abstract class CartEvent {
  const CartEvent();
}

class GetCartItemsEvent extends CartEvent {
  const GetCartItemsEvent();
}

class AddCartItemEvent extends CartEvent {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  const AddCartItemEvent({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });
}

class RemoveCartItemEvent extends CartEvent {
  final String productId;

  const RemoveCartItemEvent(this.productId);
}

class UpdateCartItemEvent extends CartEvent {
  final String productId;
  final int quantity;

  const UpdateCartItemEvent({required this.productId, required this.quantity});
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
