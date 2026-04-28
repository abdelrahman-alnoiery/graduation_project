import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/home/data/models/brand_model.dart';
import 'package:graduation_project/features/home/data/models/product_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  // ── Get Products ──────────────────────────────────
  @override
  Future<List<ProductModel>> getProducts() async {
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

  // ── Get Best Price Products ───────────────────────
  @override
  Future<List<ProductModel>> getBestPriceProducts() async {
    try {
      final response = await ApiManager.get(EndPoints.bestPrice);
      return (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Get Brands ────────────────────────────────────
  @override
  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await ApiManager.get(EndPoints.brands);
      return (response.data['brands'] as List)
          .map((brand) => BrandModel.fromJson(brand))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Get Trends ────────────────────────────────────
  @override
  Future<List<ProductModel>> getTrends() async {
    try {
      final response = await ApiManager.get(EndPoints.trends);
      return (response.data['products'] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Search Products ───────────────────────────────
  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await ApiManager.get(
        "${EndPoints.products}?search=$query",
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
}
