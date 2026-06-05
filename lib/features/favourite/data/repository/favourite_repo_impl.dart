import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/core/local_db/hive_constants.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/favourite/data/dataSources/remote/favourite_remote_data_source.dart';
import 'package:graduation_project/features/favourite/domain/repository/favourite_repo.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entity/favourite_entity.dart';

class FavouriteRepoImpl implements FavouriteRepo {
  final FavouriteRemoteDataSource remoteDataSource;

  FavouriteRepoImpl({
    required this.remoteDataSource,
    required CheckInternetConnectionImpl networkInfo,
  });

  // ── Get Hive Box ──────────────────────────────────
  Box get _box => Hive.box(HiveConstants.favoritesBox);

  // ── Get Favourites ────────────────────────────────
  @override
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites() async {
    try {
      final items = _box.values.toList();
      final favourites = items.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
        return FavouriteEntity(
          id: map['id'] ?? '',
          name: map['name'] ?? '',
          image: map['image'] ?? '',
          price: (map['price'] as num? ?? 0).toDouble(),
        );
      }).toList();
      return Right(favourites);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  // ── Add Favourite ─────────────────────────────────
  @override
  Future<Either<Failure, void>> addFavourite(FavouriteEntity item) async {
    try {
      final box = Hive.box(HiveConstants.favoritesBox);
      await box.put(item.id, {
        'id': item.id,
        'name': item.name,
        'image': item.image,
        'price': item.price,
      });
      print('✅ Saved to Hive: ${item.name}');
      return const Right(null);
    } catch (e) {
      print('❌ Hive error: $e');
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  // ── Remove Favourite ──────────────────────────────
  @override
  Future<Either<Failure, void>> removeFavourite(String productId) async {
    try {
      await _box.delete(productId);
      print('✅ Removed from favourites: $productId');
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
