class ProductEntity {
  final String id;
  final String name;
  final String image;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;
  final String categoryId;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.categoryId,
    this.isFavorite = false,
  });

  double get discountPercentage =>
      ((oldPrice - price) / oldPrice * 100).roundToDouble();
}
