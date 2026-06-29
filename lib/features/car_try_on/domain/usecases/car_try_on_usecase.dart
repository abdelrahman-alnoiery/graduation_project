import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/failuers.dart';

import '../entity/car_try_on_entity.dart';
import '../repository/car_try_on_repo.dart';

class CarTryOnUseCase {
  final CarTryOnRepo repo;
  CarTryOnUseCase(this.repo);

  Future<Either<Failure, CarTryOnEntity>> call({
    required String productId,
    required File carImage,
    required String
    productImageUrl, // 🔥 تم تعديلها لتكون مطلوبًا (required) وغير قابلة للـ null
    required String
    productName, // 🔥 تم تعديلها لتكون مطلوبًا (required) وغير قابلة للـ null
  }) async {
    // ✅ تمرير كافة البيانات كاملة ومؤمنة إلى الـ Repository
    return await repo.tryOnCar(
      productId: productId,
      carImage: carImage,
      productImageUrl: productImageUrl,
      productName:
          productName, // 🔥 تم تمرير الاسم بنجاح لمنع الـ null في السيرفر
    );
  }
}
