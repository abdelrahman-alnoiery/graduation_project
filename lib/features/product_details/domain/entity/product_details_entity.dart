class ProductDetailsEntity {
  final String id;
  final String name;
  final String description;
  final List<String> images;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;
  final List<String> colors;
  final List<String> sizes;
  final String categoryId;
  final bool isFavorite;

  const ProductDetailsEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.colors,
    required this.sizes,
    required this.categoryId,
    this.isFavorite = false,
  });
}
