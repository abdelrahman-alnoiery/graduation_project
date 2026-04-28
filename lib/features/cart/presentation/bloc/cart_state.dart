import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/cart_item_entity.dart';

abstract class CartState {
  const CartState();
}

// ── Initial ───────────────────────────────────────
class CartInitialState extends CartState {
  const CartInitialState();
}

// ── Loading ───────────────────────────────────────
class CartLoadingState extends CartState {
  const CartLoadingState();
}

// ── Get Cart Items ────────────────────────────────
class GetCartItemsSuccessState extends CartState {
  final List<CartItemEntity> cartItems;
  final double totalPrice;

  const GetCartItemsSuccessState({
    required this.cartItems,
    required this.totalPrice,
  });
}

class GetCartItemsErrorState extends CartState {
  final Failure failure;
  const GetCartItemsErrorState(this.failure);
}

// ── Add Cart Item ─────────────────────────────────
class AddCartItemSuccessState extends CartState {
  const AddCartItemSuccessState();
}

class AddCartItemErrorState extends CartState {
  final Failure failure;
  const AddCartItemErrorState(this.failure);
}

// ── Remove Cart Item ──────────────────────────────
class RemoveCartItemSuccessState extends CartState {
  const RemoveCartItemSuccessState();
}

class RemoveCartItemErrorState extends CartState {
  final Failure failure;
  const RemoveCartItemErrorState(this.failure);
}

// ── Update Cart Item ──────────────────────────────
class UpdateCartItemSuccessState extends CartState {
  const UpdateCartItemSuccessState();
}

class UpdateCartItemErrorState extends CartState {
  final Failure failure;
  const UpdateCartItemErrorState(this.failure);
}

// ── Clear Cart ────────────────────────────────────
class ClearCartSuccessState extends CartState {
  const ClearCartSuccessState();
}

class ClearCartErrorState extends CartState {
  final Failure failure;
  const ClearCartErrorState(this.failure);
}

// ── Empty Cart ────────────────────────────────────
class CartEmptyState extends CartState {
  const CartEmptyState();
}
