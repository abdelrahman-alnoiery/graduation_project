import '../../domain/entity/order_entity.dart';

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    // ── product ممكن يكون nested object أو String ──
    final product = json['product'];
    String productId = '';
    String productName = '';
    String productImage = '';
    double price = 0.0;

    if (product is Map<String, dynamic>) {
      productId = product['_id']?.toString() ?? '';
      productName = product['name']?.toString() ?? '';
      price = _parseDouble(product['price']);

      // ── image ──
      try {
        final colorimage = product['colorimage'] as List?;
        if (colorimage != null && colorimage.isNotEmpty) {
          final images = colorimage[0]['images'] as List?;
          if (images != null && images.isNotEmpty) {
            productImage = images[0].toString();
          }
        }
      } catch (_) {
        productImage = product['image']?.toString() ?? '';
      }
    } else {
      productId = product?.toString() ?? '';
    }

    return OrderItemModel(
      productId: productId,
      productName: productName,
      productImage: productImage,
      quantity: _parseInt(json['quantity']),
      price: price > 0 ? price : _parseDouble(json['price']),
    );
  }

  static double _parseDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _parseInt(dynamic v) {
    if (v == null) return 1;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 1;
  }
}

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalPrice,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // ── items ──
    final rawItems = json['items'] ?? json['products'] ?? [];
    final items = (rawItems as List)
        .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // ── total ──
    double total = OrderItemModel._parseDouble(
      json['totalPrice'] ?? json['total'] ?? json['totalAmount'],
    );
    if (total == 0 && items.isNotEmpty) {
      total = items.fold(0.0, (sum, i) => sum + (i.price * i.quantity));
    }

    // ── date ──
    DateTime createdAt = DateTime.now();
    try {
      final raw = json['createdAt'] ?? json['created_at'] ?? json['date'];
      if (raw != null) createdAt = DateTime.parse(raw.toString());
    } catch (_) {}

    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      items: items,
      totalPrice: total,
      status: json['status']?.toString() ?? 'pending',
      createdAt: createdAt,
    );
  }
}
