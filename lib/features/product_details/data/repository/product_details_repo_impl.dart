import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/product_details/domain/repository/product_details_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/product_details_entity.dart';
import '../dataSources/remote/product_details_remote_data_source.dart';

class ProductDetailsRepoImpl implements ProductDetailsRepo {
  final ProductDetailsRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  ProductDetailsRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(
    String productId,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final product = await remoteDataSource.getProductDetails(productId);
      return Right(product);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
