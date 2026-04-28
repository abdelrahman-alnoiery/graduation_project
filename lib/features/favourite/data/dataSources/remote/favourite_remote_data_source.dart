import 'package:graduation_project/features/favourite/data/models/favourite_model.dart';

abstract class FavouriteRemoteDataSource {
  Future<List<FavouriteModel>> getFavourites();
  Future<void> addFavourite(String productId);
  Future<void> removeFavourite(String productId);
}
