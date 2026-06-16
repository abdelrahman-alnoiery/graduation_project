import 'dart:convert';

import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'products_remote_data_source.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  static const String _homeCacheKey = 'cached_trending_products';
  static const String _sellerCacheKey = 'cached_seller_products';

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

  // ── Fetch Seller Products ─────────────────────────
  Future<List<ProductModel>> _fetchSellerProducts() async {
    try {
      final response = await ApiManager.get(EndPoints.sellerProducts);

      List data = [];
      if (response.data is List) {
        data = response.data as List;
      } else if (response.data is Map) {
        data =
            (response.data['data'] ?? response.data['products'] ?? []) as List;
      }

      final products = data.map((p) => ProductModel.fromJson(p)).toList();
      print('✅ Seller products: ${products.length}');

      // ✅ Save to seller cache
      await SharedPref.saveString(_sellerCacheKey, jsonEncode(data));

      return products;
    } catch (e) {
      print('❌ Seller products error: $e');

      // ✅ Fallback: seller cache
      try {
        final cached = SharedPref.getString(_sellerCacheKey);
        if (cached != null && cached.isNotEmpty) {
          final List data = jsonDecode(cached);
          return data.map((p) => ProductModel.fromJson(p)).toList();
        }
      } catch (_) {}

      return [];
    }
  }

  // ── Get All Products ──────────────────────────────
  @override
  @override
  Future<List<ProductModel>> getAllProducts() async {
    // ✅ أول حاجة: جرب تجيب من الـ home cache
    final cached = _getFromHomeCache();

    // ✅ لو مفيش cache — جيب من الـ API مباشرة
    if (cached.isEmpty) {
      try {
        print('🔄 Cache empty — fetching from API...');
        final response = await ApiManager.get(
          '${EndPoints.contentRecommend}?itemName=car',
        );

        List data = [];
        if (response.data is Map) {
          data = (response.data['data'] ?? []) as List;
        } else if (response.data is List) {
          data = response.data as List;
        }

        final products = data.map((p) => ProductModel.fromJson(p)).toList();

        // ✅ احفظ في الـ cache
        if (products.isNotEmpty) {
          await SharedPref.saveString(_homeCacheKey, jsonEncode(data));
          print('✅ Fetched and cached: ${products.length}');
        }

        return products;
      } catch (e) {
        print('❌ API fetch error: $e');
        return [];
      }
    }

    // ✅ جيب الـ seller products
    final sellerProducts = await _fetchSellerProducts();

    // ✅ دمج
    final Map<String, ProductModel> all = {};
    for (var p in [...cached, ...sellerProducts]) {
      all[p.id] = p;
    }

    final allProducts = all.values.toList();

    for (var p in allProducts) {
      print('Product: ${p.name} | Category: "${p.categoryId}"');
    }

    print('✅ Total products: ${allProducts.length}');
    return allProducts;
  }

  // ── Get Products By Category ──────────────────────
  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final allProducts = await getAllProducts();
    if (categoryId.isEmpty) return allProducts;

    final filtered = allProducts
        .where((p) => p.categoryId.toLowerCase() == categoryId.toLowerCase())
        .toList();

    print('✅ Category "$categoryId": ${filtered.length} products');
    return filtered.isNotEmpty ? filtered : allProducts;
  }
}
