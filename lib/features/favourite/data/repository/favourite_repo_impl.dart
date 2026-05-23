import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/favourite/data/models/favourite_model.dart';
import 'package:graduation_project/features/favourite/domain/repository/favourite_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/favourite_entity.dart';
import '../dataSources/remote/favourite_remote_data_source.dart';

class FavouriteRepoImpl implements FavouriteRepo {
  final FavouriteRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  FavouriteRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // ── Get Favourites ────────────────────────────────
  @override
  Future<Either<Failure, List<FavouriteEntity>>> getFavourites() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final favourites = await remoteDataSource.getFavourites();
      return Right(favourites);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Add Favourite ─────────────────────────────────
  @override
  Future<Either<Failure, void>> addFavourite(String productId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.addFavourite(productId as FavouriteModel);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Remove Favourite ──────────────────────────────
  @override
  Future<Either<Failure, void>> removeFavourite(String productId) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      await remoteDataSource.removeFavourite(productId);
      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
