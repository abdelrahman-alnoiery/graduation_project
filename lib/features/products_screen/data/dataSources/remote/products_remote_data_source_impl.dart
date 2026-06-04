import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'products_remote_data_source.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  // ── Cache Keys (نفس الـ Home cache) ──────────────
  static const String _homeCacheKey = 'cached_trending_products';

  // ── Get From Home Cache ───────────────────────────
  List<ProductModel> _getFromHomeCache() {
    try {
      final cached = SharedPref.getString(_homeCacheKey);
      if (cached == null || cached.isEmpty) return [];
      final List data = jsonDecode(cached);
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } catch (e) {
      return [];
    }
  }

  // ── Fetch From API ────────────────────────────────
  Future<List<ProductModel>> _fetchFromApi({int limit = 50}) async {
    int retries = 0;
    while (retries < 2) {
      try {
        final response = await ApiManager.get(
          "${EndPoints.trendingRecommend}?limit=$limit",
        );
        final List data = response.data['data'] ?? [];
        return data.map((p) => ProductModel.fromJson(p)).toList();
      } on DioException catch (e) {
        retries++;
        print('Products API Error (retry $retries): ${e.response?.statusCode}');
        if (retries == 2) break;
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        break;
      }
    }
    return [];
  }

  // ── Get All Products ──────────────────────────────
  @override
  Future<List<ProductModel>> getAllProducts() async {
    // ✅ أول حاجة: جرب الـ Home cache
    final cached = _getFromHomeCache();
    if (cached.isNotEmpty) {
      print('✅ Products from Home cache: ${cached.length}');
      return cached;
    }

    // ✅ لو مفيش cache، جرب الـ API
    final products = await _fetchFromApi(limit: 50);
    if (products.isNotEmpty) return products;

    // ✅ آخر fallback: ارجع list فاضية بدل error
    return [];
  }

  // ── Get Products By Category ──────────────────────
  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final all = await getAllProducts();
    // ✅ لو مفيش category filter، ارجع كل المنتجات
    if (categoryId.isEmpty) return all;
    final filtered = all
        .where(
          (p) =>
              p.categoryId.toLowerCase() == categoryId.toLowerCase() ||
              p.name.toLowerCase().contains(categoryId.toLowerCase()),
        )
        .toList();
    // ✅ لو مفيش منتجات في الـ category، ارجع كل المنتجات
    return filtered.isNotEmpty ? filtered : all;
  }
}
