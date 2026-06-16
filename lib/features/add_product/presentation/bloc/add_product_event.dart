import 'dart:io';

abstract class AddProductEvent {
  const AddProductEvent();
}

class SubmitAddProductEvent extends AddProductEvent {
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final List<File> images;

  const SubmitAddProductEvent({
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.images,
  });
}

class ResetAddProductEvent extends AddProductEvent {
  const ResetAddProductEvent();
}
