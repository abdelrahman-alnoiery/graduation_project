class OrderItemEntity {
  final String productId;
  final String productName;
  final String productImage;
  final int quantity;
  final double price;

  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.quantity,
    required this.price,
  });
}

class OrderEntity {
  final String id;
  final List<OrderItemEntity> items;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });
}
