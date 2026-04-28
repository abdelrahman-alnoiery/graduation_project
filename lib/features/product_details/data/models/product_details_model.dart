import '../../domain/entity/product_details_entity.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.images,
    required super.price,
    required super.oldPrice,
    required super.rating,
    required super.reviewCount,
    required super.colors,
    required super.sizes,
    required super.categoryId,
    super.isFavorite,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['old_price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      colors: List<String>.from(json['colors'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      categoryId: json['category_id']?.toString() ?? '',
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'images': images,
      'price': price,
      'old_price': oldPrice,
      'rating': rating,
      'review_count': reviewCount,
      'colors': colors,
      'sizes': sizes,
      'category_id': categoryId,
      'is_favorite': isFavorite,
    };
  }
}
