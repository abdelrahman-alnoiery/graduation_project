import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/categories/domain/repository/categories_repo.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/category_entity.dart';
import '../dataSources/remote/categories_remote_data_source.dart';

class CategoriesRepoImpl implements CategoriesRepo {
  final CategoriesRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  CategoriesRepoImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
