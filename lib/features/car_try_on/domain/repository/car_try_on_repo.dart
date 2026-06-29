import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/car_try_on_entity.dart';

abstract class CarTryOnRepo {
  // ✅ تم تعديل الاسم ليتوافق مع الاستدعاءات
  Future<Either<Failure, CarTryOnEntity>> tryOnCar({
    required String productId,
    required File carImage,
    required String productImageUrl,
    required String productName,
  });
}
