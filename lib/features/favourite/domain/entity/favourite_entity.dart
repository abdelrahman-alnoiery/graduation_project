class FavouriteEntity {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final double oldPrice;
  final double rating;
  final int reviewCount;

  const FavouriteEntity({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviewCount,
  });
}
