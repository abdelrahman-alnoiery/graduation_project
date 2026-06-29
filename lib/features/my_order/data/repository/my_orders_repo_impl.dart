import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';

import '../../domain/entity/order_entity.dart';
import '../../domain/repository/my_orders_repo.dart';
import '../datasources/my_orders_remote_datasource.dart';

class MyOrdersRepoImpl implements MyOrdersRepo {
  final MyOrdersRemoteDatasource remoteDataSource;
  final CheckInternetConnection networkInfo;

  MyOrdersRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
    try {
      final result = await remoteDataSource.getMyOrders();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
