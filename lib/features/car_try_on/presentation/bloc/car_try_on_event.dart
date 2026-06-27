import 'dart:io';

abstract class CarTryOnEvent {
  const CarTryOnEvent();
}

class TryOnCarEvent extends CarTryOnEvent {
  final String productId;
  final File carImage;
  final String? productImageUrl; // ✅

  const TryOnCarEvent({
    required this.productId,
    required this.carImage,
    this.productImageUrl,
  });
}

class ResetCarTryOnEvent extends CarTryOnEvent {
  const ResetCarTryOnEvent();
}
