import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';

import '../entity/car_try_on_entity.dart';

abstract class CarTryOnRepo {
  Future<Either<Failure, CarTryOnEntity>> tryOnCar({
    required String productId,
    required File carImage,
    String? productImageUrl, // ✅
  });
}
