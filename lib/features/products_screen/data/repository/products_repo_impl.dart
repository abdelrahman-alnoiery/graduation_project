import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/products_screen/domain/repository/products_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../../home/domain/entity/product_entity.dart';
import '../dataSources/remote/products_remote_data_source.dart';

class ProductsRepoImpl implements ProductsRepo {
  final ProductsRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  ProductsRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByCategory(
    String categoryId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final products = await remoteDataSource.getProductsByCategory(categoryId);
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAllProducts() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final products = await remoteDataSource.getAllProducts();
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
