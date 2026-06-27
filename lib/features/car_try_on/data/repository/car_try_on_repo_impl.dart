import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';

import '../../domain/entity/car_try_on_entity.dart';
import '../../domain/repository/car_try_on_repo.dart';
import '../datasources/car_try_on_remote_datasource.dart';

class CarTryOnRepoImpl implements CarTryOnRepo {
  final CarTryOnRemoteDatasource remoteDataSource;
  final CheckInternetConnection networkInfo;

  CarTryOnRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, CarTryOnEntity>> tryOnCar({
    required String productId,
    required File carImage,
    String? productImageUrl,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await remoteDataSource.tryOnCar(
        productId: productId,
        carImage: carImage,
        productImageUrl: productImageUrl, // ✅
      );
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
