class AddProductRequestModel {
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;

  const AddProductRequestModel({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'category': category,
    'price': price.toString(),
    'stock': stock.toString(),
  };
}
