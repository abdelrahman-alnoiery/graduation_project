import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/features/home/data/models/brand_model.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // ── Cache Keys ────────────────────────────────────
  static const String _cacheKey = 'cached_trending_products';
  static const String _cacheTimeKey = 'cached_trending_time';
  static const int _cacheDurationMinutes = 30;

  // ── Helper: Check Cache Valid ─────────────────────
  Object _isCacheValid() {
    final timeStr = SharedPref.getString(_cacheTimeKey);
    if (timeStr == null) return false;
    final cacheTime = DateTime.tryParse(timeStr);
    if (cacheTime == null) return false;
    return DateTime.now().difference(cacheTime).inMinutes;
    _cacheDurationMinutes;
  }

  // ── Helper: Get From Cache ────────────────────────
  List<ProductModel>? _getFromCache() {
    try {
      final cached = SharedPref.getString(_cacheKey);
      if (cached == null || cached.isEmpty) return null;
      final List data = jsonDecode(cached);
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      return null;
    }
  }

  // ── Helper: Save To Cache ─────────────────────────
  Future<void> _saveToCache(List<ProductModel> products) async {
    try {
      final data = products
          .map(
            (p) => {
              '_id': p.id,
              'name': p.name,
              'image': p.image,
              'price': p.price,
              'averageRating': p.rating,
              'reviewCount': p.reviewCount,
              'category': p.categoryId,
            },
          )
          .toList();
      await SharedPref.setString(_cacheKey, jsonEncode(data));
      await SharedPref.setString(
        _cacheTimeKey,
        DateTime.now().toIso8601String(),
      );
      print('✅ Products cached: ${products.length}');
    } catch (e) {
      print('Cache save error: $e');
    }
  }

  // ── Helper: Fetch Trending ────────────────────────
  Future<List<ProductModel>> _fetchTrending({int limit = 20}) async {
    // ✅ Check cache
    bool _isCacheValid() {
      try {
        final timeStr = SharedPref.getString(_cacheTimeKey);
        if (timeStr == null || timeStr.isEmpty) return false;
        final cacheTime = DateTime.tryParse(timeStr);
        if (cacheTime == null) return false;
        final diff = DateTime.now().difference(cacheTime).inMinutes;
        return diff < _cacheDurationMinutes;
      } catch (e) {
        return false;
      }
    }

    // ✅ جرب content recommend
    try {
      final response = await ApiManager.get(
        "${EndPoints.contentRecommend}?itemName=car",
      );
      final List data = response.data['data'] ?? [];
      final products = data.map((p) => ProductModel.fromJson(p)).toList();
      if (products.isNotEmpty) {
        await _saveToCache(products);
        print('✅ From content recommend: ${products.length}');
        return products;
      }
    } catch (e) {
      print('Content recommend failed: $e');
    }

    // ✅ جرب trending
    try {
      final response = await ApiManager.get(
        "${EndPoints.trendingRecommend}?limit=$limit",
      );
      final List data = response.data['data'] ?? [];
      final products = data.map((p) => ProductModel.fromJson(p)).toList();
      if (products.isNotEmpty) {
        await _saveToCache(products);
        return products;
      }
    } catch (e) {
      print('Trending failed: $e');
    }

    // ✅ آخر fallback: الـ cache القديم
    return _getFromCache() ?? [];
  }

  // ── Get Products ──────────────────────────────────
  @override
  Future<List<ProductModel>> getProducts() async {
    return await _fetchTrending(limit: 20);
  }

  // ── Get Best Price ────────────────────────────────
  @override
  Future<List<ProductModel>> getBestPriceProducts() async {
    final products = await _fetchTrending(limit: 20);
    final sorted = List<ProductModel>.from(products)
      ..sort((a, b) => a.price.compareTo(b.price));
    return sorted.take(10).toList();
  }

  // ── Get Brands ────────────────────────────────────
  @override
  Future<List<BrandModel>> getBrands() async {
    return [
      BrandModel(id: '1', name: 'Toyota', image: ''),
      BrandModel(id: '2', name: 'BMW', image: ''),
      BrandModel(id: '3', name: 'Mercedes', image: ''),
      BrandModel(
        id: '4',
        name: 'Hyundai',
        image: 'assets/images/png/hyundai.png',
      ),
      BrandModel(id: '5', name: 'KIA', image: ''),
      BrandModel(id: '6', name: 'Nissan', image: ''),
      BrandModel(id: '8', name: 'Audi', image: ''),
      BrandModel(id: '9', name: 'Skoda', image: ''),
      BrandModel(id: '7', name: 'Ford', image: ''),
      BrandModel(id: '10', name: 'Honda', image: ''),
    ];
  }

  // ── Get Trends ────────────────────────────────────
  @override
  Future<List<ProductModel>> getTrends() async {
    final products = await _fetchTrending(limit: 20);
    return products.take(5).toList();
  }

  // ── Search Products ───────────────────────────────
  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await ApiManager.get(
        "${EndPoints.contentRecommend}?itemName=$query",
      );
      final List data = response.data['data'] ?? [];
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } on DioException catch (e) {
      print('Search Error: ${e.response?.data}');
      // ✅ Fallback: فلتر من الـ cache
      final cached = _getFromCache() ?? [];
      return cached
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
