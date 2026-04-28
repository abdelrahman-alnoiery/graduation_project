import '../../domain/entity/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.phone,
    super.image,
    super.language,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      language: json['language'] ?? 'English',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'image': image,
      'language': language,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? image,
    String? language,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      language: language ?? this.language,
    );
  }
}
