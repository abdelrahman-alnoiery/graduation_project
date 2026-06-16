import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';

import '../entity/add_product_entity.dart';

abstract class AddProductRepo {
  Future<Either<Failure, AddProductEntity>> addProduct({
    required String name,
    required String description,
    required String category,
    required double price,
    required int stock,
    required List<File> images,
  });
}
