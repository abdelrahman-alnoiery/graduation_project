import '../../domin/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.token,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // ✅ الـ Backend بيرجع { user, token } أو { status, user }
    final user = json['user'] ?? json;
    final token = json['token'];

    final username = user['username']?.toString() ?? '';
    final parts = username.split(' ');

    return UserModel(
      id: user['_id']?.toString() ?? '',
      firstName: parts.isNotEmpty ? parts.first : '',
      lastName: parts.length > 1 ? parts.last : '',
      email: user['email']?.toString() ?? '',
      phone: user['phone']?.toString() ?? '',
      token: token?.toString(),
      role: user['role']?.toString() ?? 'seller',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': '$firstName $lastName'.trim(),
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}
