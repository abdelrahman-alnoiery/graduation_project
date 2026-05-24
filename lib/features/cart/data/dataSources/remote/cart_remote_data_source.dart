import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../../../../../core/api/api_manger.dart';
import '../../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addCartItem(String productId, int quantity);
  Future<void> removeCartItem(String productId);
  Future<void> updateCartItemQuantity(String productId, int quantity);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  @override
  Future<List<CartItemModel>> getCartItems() async {
    return []; // ✅ Local only
  }

  // ── Add Cart Item ─────────────────────────────────
  @override
  Future<void> addCartItem(String productId, int quantity) async {
    try {
      await ApiManager.post(
        EndPoints.cart,
        body: {"product_id": productId, "quantity": quantity},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Remove Cart Item ──────────────────────────────
  @override
  Future<void> removeCartItem(String productId) async {
    try {
      await ApiManager.delete("${EndPoints.cart}/$productId");
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Update Cart Item Quantity ─────────────────────
  @override
  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    try {
      await ApiManager.put(
        "${EndPoints.cart}/$productId",
        body: {"quantity": quantity},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Clear Cart ────────────────────────────────────
  @override
  Future<void> clearCart() async {
    try {
      await ApiManager.delete(EndPoints.cart);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
