import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'products_remote_data_source.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  // ── Helper ────────────────────────────────────────
  Future<List<ProductModel>> _fetchTrending({int limit = 50}) async {
    int retries = 0;
    while (retries < 3) {
      try {
        final response = await ApiManager.get(
          "${EndPoints.trendingRecommend}?limit=$limit",
        );
        final List data = response.data['data'] ?? [];
        return data.map((p) => ProductModel.fromJson(p)).toList();
      } on DioException catch (e) {
        retries++;
        if (retries == 3) throw NetworkException.fromDioError(e);
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        throw NetworkException(message: e.toString());
      }
    }
    throw NetworkException(message: "Failed after retries");
  }

  // ── Get All Products ──────────────────────────────
  @override
  Future<List<ProductModel>> getAllProducts() async {
    return await _fetchTrending(limit: 50);
  }

  // ── Get Products By Category ──────────────────────
  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    final products = await _fetchTrending(limit: 50);
    return products.where((p) => p.categoryId == categoryId).toList();
  }
}
