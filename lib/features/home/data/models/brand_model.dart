import '../../domain/entity/brand_entity.dart';

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.id,
    required super.name,
    required super.image,
  });

  // ── From Json ─────────────────────────────────────
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // ── To Json ───────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
