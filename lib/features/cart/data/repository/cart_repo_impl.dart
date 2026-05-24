import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/cart/data/dataSources/local/cart_local_data_source.dart';
import 'package:graduation_project/features/cart/data/dataSources/remote/cart_remote_data_source.dart';
import 'package:graduation_project/features/cart/domain/repository/cart_repo.dart';

import '../../domain/entity/cart_item_entity.dart';

class CartRepoImpl implements CartRepo {
  final CartLocalDataSource localDataSource;

  CartRepoImpl({
    required this.localDataSource,
    required CartRemoteDataSourceImpl remoteDataSource,
    required CheckInternetConnectionImpl networkInfo,
  });

  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    try {
      final items = await localDataSource.getCartItems();
      return Right(items);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addCartItem({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  }) async {
    try {
      await localDataSource.addCartItem(
        productId: productId,
        productName: productName,
        productImage: productImage,
        price: price,
        quantity: quantity,
      );
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeCartItem(String productId) async {
    try {
      await localDataSource.removeCartItem(productId);
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem({
    required String productId,
    required int quantity,
  }) async {
    try {
      await localDataSource.updateCartItem(
        productId: productId,
        quantity: quantity,
      );
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(message: e.toString()));
    }
  }
}
