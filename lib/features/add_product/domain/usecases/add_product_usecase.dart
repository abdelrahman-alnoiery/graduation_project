import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';
import 'package:graduation_project/features/add_product/domain/repository/add_product_repo.dart';

import '../entity/add_product_entity.dart';

class AddProductUseCase {
  final AddProductRepo repo;
  AddProductUseCase(this.repo);

  Future<Either<Failure, AddProductEntity>> call({
    required String name,
    required String description,
    required String category,
    required double price,
    required int stock,
    required List<File> images,
  }) async {
    return await repo.addProduct(
      name: name,
      description: description,
      category: category,
      price: price,
      stock: stock,
      images: images,
    );
  }
}
