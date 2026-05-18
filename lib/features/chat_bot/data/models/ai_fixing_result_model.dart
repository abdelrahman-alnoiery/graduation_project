class DetectionModel {
  final List<double> bbox;
  final double confidence;
  final String className;
  final double estimatedCost;
  final String severity;

  const DetectionModel({
    required this.bbox,
    required this.confidence,
    required this.className,
    required this.estimatedCost,
    required this.severity,
  });

  factory DetectionModel.fromJson(Map<String, dynamic> json) {
    return DetectionModel(
      bbox: List<double>.from(
        (json['bbox'] ?? []).map((e) => (e as num).toDouble()),
      ),
      confidence: (json['confidence'] as num? ?? 0).toDouble(),
      className: json['class_ar'] ?? '', // ✅ التعديل هنا
      estimatedCost: (json['estimated_cost_egp'] as num? ?? 0)
          .toDouble(), // ✅ والتكلفة هنا
      severity: json['severity'] ?? '',
    );
  }
}

class AiFixingResultModel {
  final List<DetectionModel> detections;
  final String imageBase64;
  final int totalScratches;
  final double totalEstimatedCost;
  final bool success;
  final bool isCarImage;

  const AiFixingResultModel({
    required this.detections,
    required this.imageBase64,
    required this.totalScratches,
    required this.totalEstimatedCost,
    required this.success,
    required this.isCarImage,
  });

  factory AiFixingResultModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final detections = (data['detections'] as List? ?? [])
        .map((d) => DetectionModel.fromJson(d))
        .toList();

    // ✅ لو مفيش detections يبقى مش صورة عربية
    final isCarImage = detections.isNotEmpty;

    final totalCost = detections.fold(0.0, (sum, d) => sum + d.estimatedCost);

    return AiFixingResultModel(
      success: json['success'] ?? false,
      imageBase64: data['annotated_image_base64'] ?? '',
      detections: detections,
      totalScratches: detections.length,
      totalEstimatedCost: totalCost,
      isCarImage: isCarImage, // ✅ أضفنا field جديد
    );
  }
}
