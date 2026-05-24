import 'package:hive/hive.dart';

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
         id: productId,
         name: productName,
         image: productImage,
         price: price,
         quantity: quantity,
       );

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      productId: productId,
      productName: productName,
      productImage: productImage,
      price: price,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      productId: entity.id,
      productName: entity.name,
      productImage: entity.image,
      price: entity.price,
      quantity: entity.quantity,
    );
  }
}
