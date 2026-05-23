import 'package:hive/hive.dart';

import '../../domain/entity/favourite_entity.dart';

@HiveType(typeId: 1)
class FavouriteModel extends FavouriteEntity {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final String productImage;

  @HiveField(3)
  final double price;

  const FavouriteModel({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
  }) : super(
         id: productId,
         name: productName,
         image: productImage,
         price: price,
       );

  factory FavouriteModel.fromEntity(FavouriteEntity entity) {
    return FavouriteModel(
      productId: entity.id,
      productName: entity.name,
      productImage: entity.image,
      price: entity.price,
    );
  }
}
