import '../../domain/entity/cart_item_entity.dart';

abstract class CartState {
  const CartState();
}

class CartInitialState extends CartState {
  const CartInitialState();
}

class CartLoadingState extends CartState {
  const CartLoadingState();
}

class GetCartItemsSuccessState extends CartState {
  final List<CartItemEntity> cartItems;
  const GetCartItemsSuccessState(this.cartItems);
}

class CartEmptyState extends CartState {
  const CartEmptyState();
}

class GetCartItemsErrorState extends CartState {
  final String message;
  const GetCartItemsErrorState(this.message);
}
