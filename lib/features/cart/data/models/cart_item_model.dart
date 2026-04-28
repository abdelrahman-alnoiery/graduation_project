import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entity/cart_item_entity.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends CartItemEntity {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String productImage;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int quantity;

  const CartItemModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
  }) : super(
         productId: productId,
         productName: productName,
         productImage: productImage,
         price: price,
         quantity: quantity,
       );

  // ── From Json ─────────────────────────────────────
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  // ── To Json ───────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
    };
  }

  // ── Copy With ─────────────────────────────────────
  CartItemModel copyWith({
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
