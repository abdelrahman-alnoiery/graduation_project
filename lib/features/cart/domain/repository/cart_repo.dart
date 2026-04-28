import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/cart_item_entity.dart';

abstract class CartRepo {
  Future<Either<Failure, List<CartItemEntity>>> getCartItems();
  Future<Either<Failure, void>> addCartItem({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  });
  Future<Either<Failure, void>> removeCartItem(String productId);
  Future<Either<Failure, void>> updateCartItemQuantity({
    required String productId,
    required int quantity,
  });
  Future<Either<Failure, void>> clearCart();
}
