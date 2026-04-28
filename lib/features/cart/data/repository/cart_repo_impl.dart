import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/features/cart/data/models/cart_item_model.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/cart_item_entity.dart';
import '../../domain/repository/cart_repo.dart';
import '../dataSources/local/cart_local_data_source.dart';
import '../dataSources/remote/cart_remote_data_source.dart';

class CartRepoImpl implements CartRepo {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final CheckInternetConnection networkInfo;

  CartRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  // ── Get Cart Items ────────────────────────────────
  @override
  Future<Either<Failure, List<CartItemEntity>>> getCartItems() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItems = await remoteDataSource.getCartItems();
        await localDataSource.clearCart();
        for (var item in remoteItems) {
          await localDataSource.addCartItem(item);
        }
        return Right(remoteItems);
      } on NetworkException catch (e) {
        return Left(
          NetworkFailure(message: e.message, statusCode: e.statusCode),
        );
      }
    } else {
      try {
        final localItems = await localDataSource.getCartItems();
        return Right(localItems);
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
  }

  // ── Add Cart Item ─────────────────────────────────
  @override
  Future<Either<Failure, void>> addCartItem({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  }) async {
    try {
      final item = CartItemModel(
        productId: productId,
        productName: productName,
        productImage: productImage,
        price: price,
        quantity: quantity,
      );

      // Save locally first
      await localDataSource.addCartItem(item);

      // Sync with remote if connected
      if (await networkInfo.isConnected) {
        await remoteDataSource.addCartItem(productId, quantity);
      }

      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  // ── Remove Cart Item ──────────────────────────────
  @override
  Future<Either<Failure, void>> removeCartItem(String productId) async {
    try {
      // Remove locally first
      await localDataSource.removeCartItem(productId);

      // Sync with remote if connected
      if (await networkInfo.isConnected) {
        await remoteDataSource.removeCartItem(productId);
      }

      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  // ── Update Cart Item Quantity ─────────────────────
  @override
  Future<Either<Failure, void>> updateCartItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    try {
      // Update locally first
      await localDataSource.updateCartItemQuantity(productId, quantity);

      // Sync with remote if connected
      if (await networkInfo.isConnected) {
        await remoteDataSource.updateCartItemQuantity(productId, quantity);
      }

      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  // ── Clear Cart ────────────────────────────────────
  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      // Clear locally first
      await localDataSource.clearCart();

      // Sync with remote if connected
      if (await networkInfo.isConnected) {
        await remoteDataSource.clearCart();
      }

      return const Right(null);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
