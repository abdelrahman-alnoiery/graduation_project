class AddProductResponseModel {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;

  const AddProductResponseModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
  });

  factory AddProductResponseModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    try {
      final colorimage = json['colorimage'] as List?;
      if (colorimage != null && colorimage.isNotEmpty) {
        final images = colorimage[0]['images'] as List?;
        if (images != null && images.isNotEmpty) {
          imageUrl = images[0].toString();
        }
      }
    } catch (_) {}

    return AddProductResponseModel(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      imageUrl: imageUrl,
    );
  }
}
