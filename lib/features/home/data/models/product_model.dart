import '../../domain/entity/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.price,
    required super.oldPrice,
    required super.rating,
    required super.reviewCount,
    required super.categoryId,
    super.isFavorite,
  });

  // ── From Json ─────────────────────────────────────
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['old_price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      categoryId: json['category_id']?.toString() ?? '',
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  // ── To Json ───────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'old_price': oldPrice,
      'rating': rating,
      'review_count': reviewCount,
      'category_id': categoryId,
      'is_favorite': isFavorite,
    };
  }

  // ── Copy With ─────────────────────────────────────
  ProductModel copyWith({
    String? id,
    String? name,
    String? image,
    double? price,
    double? oldPrice,
    double? rating,
    int? reviewCount,
    String? categoryId,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      categoryId: categoryId ?? this.categoryId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
