import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/products_screen/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'products_remote_data_source.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  // ── Get Products By Category ──────────────────────
  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final response = await ApiManager.get(
        "${EndPoints.products}?category_id=$categoryId",
      );
      return (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Get All Products ──────────────────────────────
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await ApiManager.get(EndPoints.products);
      return (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
