import '../../../home/domain/entity/product_entity.dart';

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
    // ── Parse image ────────────────────────────────
    String firstImage = '';
    try {
      // ✅ colorimage array
      final colorimage = json['colorimage'] as List?;
      if (colorimage != null && colorimage.isNotEmpty) {
        final images = colorimage[0]['images'] as List?;
        if (images != null && images.isNotEmpty) {
          firstImage = images[0].toString();
        }
      }
      // ✅ image field مباشرة
      if (firstImage.isEmpty && json['image'] != null) {
        firstImage = json['image'].toString();
      }
      // ✅ images array مباشرة
      if (firstImage.isEmpty && json['images'] != null) {
        final imgs = json['images'] as List?;
        if (imgs != null && imgs.isNotEmpty) {
          firstImage = imgs[0].toString();
        }
      }
    } catch (_) {}

    // ── Parse category ─────────────────────────────
    String categoryId = '';
    try {
      categoryId = json['category']?.toString() ?? '';
      // ✅ لو category object مش string
      if (categoryId.isEmpty && json['category'] is Map) {
        categoryId = (json['category'] as Map)['name']?.toString() ?? '';
      }
    } catch (_) {}

    print(
      'Parsing: ${json['name']} | category raw: "${json['category']}" | parsed: "$categoryId"',
    );

    return ProductModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: firstImage,
      price: (json['price'] as num? ?? 0).toDouble(),
      oldPrice: (json['oldPrice'] as num? ?? json['price'] as num? ?? 0)
          .toDouble(),
      rating: (json['averageRating'] as num? ?? 0).toDouble(),
      reviewCount: (json['reviewCount'] as num? ?? 0).toInt(),
      categoryId: categoryId,
      isFavorite: false,
    );
  }
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
}
