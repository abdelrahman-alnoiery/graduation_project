import 'package:graduation_project/features/favourite/data/models/favourite_model.dart';

import 'favourite_remote_data_source.dart';

class FavouriteRemoteDataSourceImpl implements FavouriteRemoteDataSource {
  // ✅ الـ Favourites شغالة محلياً فقط (Hive)
  // مفيش Backend endpoint للـ Favourites
  @override
  Future<List<FavouriteModel>> getFavourites() async {
    return [];
  }

  @override
  Future<void> addFavourite(FavouriteModel item) async {
    // Local only
  }

  @override
  Future<void> removeFavourite(String productId) async {
    // Local only
  }
}
