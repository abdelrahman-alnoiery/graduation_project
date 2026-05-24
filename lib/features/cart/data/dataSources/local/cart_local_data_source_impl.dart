import 'package:graduation_project/core/local_db/hive_constants.dart';
import 'package:graduation_project/core/local_db/hive_helper.dart';
import 'package:graduation_project/features/cart/data/models/cart_item_model.dart';

import 'cart_local_data_source.dart';

class CartLocalDataSourceImpl implements CartLocalDataSource {
  // ── Get Box ───────────────────────────────────────
  get _box => HiveHelper.getBox<CartItemModel>(HiveConstants.cartBox);

  // ── Get Cart Items ────────────────────────────────
  @override
  Future<List<CartItemModel>> getCartItems() async {
    return _box.values.toList().cast<CartItemModel>();
  }

  // ── Add Cart Item ─────────────────────────────────
  @override
  Future<void> addCartItem({
    required String productId,
    required String productName,
    required String productImage,
    required double price,
    required int quantity,
  }) async {
    final existing = _box.get(productId) as CartItemModel?;
    if (existing != null) {
      await _box.put(
        productId,
        existing.copyWith(quantity: existing.quantity + quantity),
      );
    } else {
      await _box.put(
        productId,
        CartItemModel(
          productId: productId,
          productName: productName,
          productImage: productImage,
          price: price,
          quantity: quantity,
        ),
      );
    }
  }

  // ── Remove Cart Item ──────────────────────────────
  @override
  Future<void> removeCartItem(String productId) async {
    await _box.delete(productId);
  }

  // ── Update Cart Item ──────────────────────────────
  @override
  Future<void> updateCartItem({
    required String productId,
    required int quantity,
  }) async {
    final existing = _box.get(productId) as CartItemModel?;
    if (existing != null) {
      await _box.put(productId, existing.copyWith(quantity: quantity));
    }
  }

  // ── Clear Cart ────────────────────────────────────
  @override
  Future<void> clearCart() async {
    await HiveHelper.clearBox(HiveConstants.cartBox);
  }
}
