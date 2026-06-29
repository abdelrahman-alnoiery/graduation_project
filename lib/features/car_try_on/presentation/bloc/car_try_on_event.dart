import 'dart:io';

abstract class CarTryOnEvent {
  const CarTryOnEvent();
}

class TryOnCarEvent extends CarTryOnEvent {
  final String productId;
  final String productName;
  final String productImageUrl;
  final File carImage;

  const TryOnCarEvent({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.carImage,
  });
}

class ResetCarTryOnEvent extends CarTryOnEvent {
  const ResetCarTryOnEvent();
}
