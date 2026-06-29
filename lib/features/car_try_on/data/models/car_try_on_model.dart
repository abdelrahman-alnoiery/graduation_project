import '../../domain/entity/car_try_on_entity.dart';

class CarTryOnModel extends CarTryOnEntity {
  final List<int>? resultImageBytes; // ✅ الصورة كـ bytes

  const CarTryOnModel({
    required super.success,
    required super.resultImageUrl,
    this.resultImageBytes,
  });
}
