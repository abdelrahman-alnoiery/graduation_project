class CartItemEntity {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;

  const CartItemEntity({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;
}
