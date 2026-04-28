import '../../domain/entity/favourite_entity.dart';

class FavouriteModel extends FavouriteEntity {
  const FavouriteModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.price,
    required super.oldPrice,
    required super.rating,
    required super.reviewCount,
  });

  factory FavouriteModel.fromJson(Map<String, dynamic> json) {
    return FavouriteModel(
      id: json['id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['old_price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'old_price': oldPrice,
      'rating': rating,
      'review_count': reviewCount,
    };
  }
}
