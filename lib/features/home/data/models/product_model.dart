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
    String firstImage = '';

    // ✅ محاولة 1: colorimage array
    final colorImages = json['colorimage'] as List? ?? [];
    if (colorImages.isNotEmpty) {
      final images = colorImages.first['images'] as List? ?? [];
      if (images.isNotEmpty) {
        firstImage = images.first?.toString() ?? '';
      }
    }

    // ✅ محاولة 2: image field مباشرة
    if (firstImage.isEmpty) {
      firstImage = json['image']?.toString() ?? '';
    }

    // ✅ إضافة الـ base URL لو الصورة relative path
    if (firstImage.isNotEmpty && !firstImage.startsWith('http')) {
      firstImage = 'https://cargo-project-phi.vercel.app/$firstImage';
    }

    // ✅ لو مفيش صورة خد placeholder
    if (firstImage.isEmpty) {
      firstImage = 'https://via.placeholder.com/200x200.png?text=CarGo';
    }

    print('Product: ${json['name']} - Image: $firstImage');

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
