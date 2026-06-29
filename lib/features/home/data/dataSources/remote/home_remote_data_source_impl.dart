import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/features/home/data/models/brand_model.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  List _extractList(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) return responseData['data'] as List? ?? [];
    return [];
  }

  // ── Helper: Fetch Trending ────────────────────────
  Future<List<ProductModel>> _fetchTrending({int limit = 20}) async {
    try {
      final response = await ApiManager.get("${EndPoints.sellerProductSearch}?Name=car");
      final data = _extractList(response.data);
      final products = data.map((p) => ProductModel.fromJson(p)).toList();
      if (products.isNotEmpty) {
        print('✅ From content recommend: ${products.length}');
        return products;
      }
    } catch (e) {
      print('Content recommend failed: $e');
    }

    try {
      final response = await ApiManager.get(
        "${EndPoints.contentRecommend}?itemName=car",
      );
      final data = _extractList(response.data);
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      print('Trending failed: $e');
    }

    return [];
  }

  // ── Get Products ──────────────────────────────────
  @override
  Future<List<ProductModel>> getProducts() async {
    return await _fetchTrending(limit: 20);
  }

  // ── Get Best Price ────────────────────────────────
  @override
  Future<List<ProductModel>> getBestPriceProducts() async {
    try {
      final response = await ApiManager.get(EndPoints.products);
      final data = _extractList(response.data);
      final products = data.map((p) => ProductModel.fromJson(p)).toList();
      if (products.isNotEmpty) return products;
    } catch (e) {
      print('Best price fetch failed: $e');
    }

    try {
      final response = await ApiManager.get(EndPoints.trendingRecommend);
      final data = _extractList(response.data);
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      print('Best price fallback failed: $e');
    }

    return [];
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
      final data = _extractList(response.data);
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } on DioException catch (e) {
      print('Search Error: ${e.response?.data}');
      return [];
    } catch (e) {
      return [];
    }
  }
}
