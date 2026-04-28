import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/local_db/hive_constants.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addCartItem(CartItemModel item);
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItemQuantity(String productId, int quantity);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box<CartItemModel> _cartBox = Hive.box<CartItemModel>(
    HiveConstants.cartBox,
  );

  // ── Get Cart Items ────────────────────────────────
  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      return _cartBox.values.toList();
    } catch (e) {
      throw CacheException(message: "Failed to get cart items");
    }
  }

  // ── Add Cart Item ─────────────────────────────────
  @override
  Future<void> addCartItem(CartItemModel item) async {
    try {
      await _cartBox.put(item.productId, item);
    } catch (e) {
      throw CacheException(message: "Failed to add cart item");
    }
  }

  // ── Remove Cart Item ──────────────────────────────
  @override
  Future<void> removeCartItem(String productId) async {
    try {
      await _cartBox.delete(productId);
    } catch (e) {
      throw CacheException(message: "Failed to remove cart item");
    }
  }

  // ── Update Cart Item Quantity ─────────────────────
  @override
  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    try {
      final item = _cartBox.get(productId);
      if (item != null) {
        await _cartBox.put(
          productId,
          CartItemModel(
            productId: item.productId,
            productName: item.productName,
            productImage: item.productImage,
            price: item.price,
            quantity: quantity,
          ),
        );
      }
    } catch (e) {
      throw CacheException(message: "Failed to update cart item quantity");
    }
  }

  // ── Clear Cart ────────────────────────────────────
  @override
  Future<void> clearCart() async {
    try {
      await _cartBox.clear();
    } catch (e) {
      throw CacheException(message: "Failed to clear cart");
    }
  }
}
