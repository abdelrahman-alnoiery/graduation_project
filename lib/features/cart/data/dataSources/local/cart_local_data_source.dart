import 'package:graduation_project/features/cart/data/models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addCartItem({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  });
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItem({
    required String productId,
    required int quantity,
  });
  Future<void> clearCart();
}
