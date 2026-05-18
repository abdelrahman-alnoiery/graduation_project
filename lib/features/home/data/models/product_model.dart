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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // ✅ الصور جوا colorimage array
    final colorImages = json['colorimage'] as List? ?? [];
    String firstImage = '';

    if (colorImages.isNotEmpty) {
      final images = colorImages.first['images'] as List? ?? [];
      if (images.isNotEmpty) {
        firstImage = images.first?.toString() ?? '';
        // ✅ لو الصورة relative path أضفلها الـ base URL
        if (firstImage.isNotEmpty && !firstImage.startsWith('http')) {
          firstImage =
              'https://cargo-project-production.up.railway.app/$firstImage';
        }
      }
    }

    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: firstImage,
      price: (json['price'] as num? ?? 0).toDouble(),
      oldPrice: (json['price'] as num? ?? 0).toDouble(),
      rating: (json['averageRating'] as num? ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      categoryId: json['category']?.toString() ?? '',
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'averageRating': rating,
      'category': categoryId,
    };
  }
}
