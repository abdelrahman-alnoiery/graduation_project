import '../../domin/entity/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.token,
  });

  // ── From Json ─────────────────────────────────────
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      token: json['token'],
    );
  }

  // ── To Json ───────────────────────────────────────
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'token': token,
    };
  }

  // ── Copy With ─────────────────────────────────────
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      token: token ?? this.token,
    );
  }
}
