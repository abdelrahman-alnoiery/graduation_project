import '../../domain/entity/car_try_on_entity.dart';

class CarTryOnModel extends CarTryOnEntity {
  const CarTryOnModel({required super.success, required super.resultImageUrl});

  factory CarTryOnModel.fromJson(Map<String, dynamic> json) {
    return CarTryOnModel(
      success: json['success'] == true,
      resultImageUrl: json['result_image']?.toString() ?? '',
    );
  }
}
