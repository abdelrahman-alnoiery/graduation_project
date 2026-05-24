class CartItemEntity {
  final String id;
  final String name;
  final String image;
  final double price;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get totalPrice => price * quantity;
}
