import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/home/data/models/brand_model.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import '../../../../../core/cache/shared_pref.dart';
import '../../../../../core/utils/constants_manager.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // ── Helper: Fetch Trending ────────────────────────
  // ── Helper: Fetch with Fallback ───────────────────
  Future<List<ProductModel>> _fetchTrending({int limit = 20}) async {
    try {
      // ✅ أول محاولة: Trending Recommendations
      final response = await ApiManager.get(
        "${EndPoints.trendingRecommend}?limit=$limit",
      );
      print('Trending Response: ${response.statusCode}');
      final List data = response.data['data'] ?? [];
      return data.map((p) => ProductModel.fromJson(p)).toList();
    } on DioException catch (e) {
      print(
        'Trending failed (${e.response?.statusCode}), trying user recommend...',
      );

      // ✅ Fallback: User Recommendations
      try {
        final userId = SharedPref.getString(AppConstants.userId) ?? '';
        final response2 = await ApiManager.get(
          "${EndPoints.userRecommend}?userId=$userId",
        );
        final List data = response2.data['data'] ?? [];
        return data.map((p) => ProductModel.fromJson(p)).toList();
      } catch (e2) {
        print('User recommend also failed: $e2');
        // ✅ آخر fallback: ارجع list فاضية
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // ── Get Products ──────────────────────────────────
  @override
  Future<List<ProductModel>> getProducts() async {
    return await _fetchTrending(limit: 20);
  }

  // ── Get Best Price ────────────────────────────────
  @override
  Future<List<ProductModel>> getBestPriceProducts() async {
    final products = await _fetchTrending(limit: 10);
    // ✅ رتب تصاعدي حسب السعر
    products.sort((a, b) => a.price.compareTo(b.price));
    return products;
  }

  // ── Get Brands (Static) ───────────────────────────
  @override
  Future<List<BrandModel>> getBrands() async {
    // ✅ الـ Backend مش عنده brands endpoint
    return [
      BrandModel(id: '1', name: 'Toyota', image: ''),
      BrandModel(id: '2', name: 'BMW', image: ''),
      BrandModel(id: '3', name: 'Mercedes', image: ''),
      BrandModel(id: '4', name: 'Hyundai', image: ''),
      BrandModel(id: '5', name: 'KIA', image: ''),
      BrandModel(id: '6', name: 'Nissan', image: ''),
    ];
  }

  // ── Get Trends ────────────────────────────────────
  @override
  Future<List<ProductModel>> getTrends() async {
    return await _fetchTrending(limit: 5);
  }

  // ── Search Products ───────────────────────────────
  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    int retries = 0;
    while (retries < 3) {
      try {
        final response = await ApiManager.get(
          "${EndPoints.contentRecommend}?itemName=$query",
        );
        print('Search Response: ${response.statusCode}');
        final List data = response.data['data'] ?? [];
        return data.map((p) => ProductModel.fromJson(p)).toList();
      } on DioException catch (e) {
        retries++;
        print('Search Error (retry $retries): ${e.message}');
        if (retries == 3) throw NetworkException.fromDioError(e);
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        throw NetworkException(message: e.toString());
      }
    }
    throw NetworkException(message: "Failed after retries");
  }
}
