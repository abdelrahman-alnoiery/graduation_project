import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/favourite/data/models/favourite_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'favourite_remote_data_source.dart';

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  // ── Get Favourites ────────────────────────────────
  @override
  Future<List<FavouriteModel>> getFavourites() async {
    try {
      final response = await ApiManager.get(EndPoints.favorites);
      return (response.data['favourites'] as List)
          .map((item) => FavouriteModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Add Favourite ─────────────────────────────────
  @override
  Future<void> addFavourite(String productId) async {
    try {
      await ApiManager.post(
        EndPoints.favorites,
        body: {"product_id": productId},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Remove Favourite ──────────────────────────────
  @override
  Future<void> removeFavourite(String productId) async {
    try {
      await ApiManager.delete("${EndPoints.favorites}/$productId");
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
