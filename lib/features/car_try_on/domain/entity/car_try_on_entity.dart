class CarTryOnEntity {
  final bool success;
  final String resultImageUrl;
  final List<int>? resultImageBytes; // ✅

  const CarTryOnEntity({
    required this.success,
    required this.resultImageUrl,
    this.resultImageBytes,
  });
}
