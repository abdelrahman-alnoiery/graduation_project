import 'dart:io';

import '../models/car_try_on_model.dart';

abstract class CarTryOnRemoteDatasource {
  Future<CarTryOnModel> tryOnCar({
    required String productId,
    required File carImage,
    required String productImageUrl,
    required String productName,
  });
}
