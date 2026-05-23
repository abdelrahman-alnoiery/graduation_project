import 'package:graduation_project/features/favourite/data/models/favourite_model.dart';

abstract class FavouriteRemoteDataSource {
  Future<List<FavouriteModel>> getFavourites();
  Future<void> addFavourite(FavouriteModel item);
  Future<void> removeFavourite(String productId);
}
