import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/home/domain/repository/home_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/brand_entity.dart';
import '../../domain/entity/product_entity.dart';
import '../dataSources/remote/home_remote_data_source.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  HomeRepoImpl({required this.remoteDataSource, required this.networkInfo});

  // ── Get Products ──────────────────────────────────
  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final products = await remoteDataSource.getProducts();
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Get Best Price Products ───────────────────────
  @override
  Future<Either<Failure, List<ProductEntity>>> getBestPriceProducts() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final products = await remoteDataSource.getBestPriceProducts();
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Get Brands ────────────────────────────────────
  @override
  Future<Either<Failure, List<BrandEntity>>> getBrands() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final brands = await remoteDataSource.getBrands();
      return Right(brands);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Get Trends ────────────────────────────────────
  @override
  Future<Either<Failure, List<ProductEntity>>> getTrends() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final trends = await remoteDataSource.getTrends();
      return Right(trends);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  // ── Search Products ───────────────────────────────
  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(
    String query,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
