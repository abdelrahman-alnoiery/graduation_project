import 'package:graduation_project/features/profile_tab/domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.role,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? json;
    final username = user['username']?.toString() ?? '';
    final parts = username.split(' ');

    return ProfileModel(
      id: user['_id']?.toString() ?? '',
      firstName: parts.isNotEmpty ? parts.first : '',
      lastName: parts.length > 1 ? parts.last : '',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      role: user['role']?.toString() ?? 'seller',
    );
  }
}
