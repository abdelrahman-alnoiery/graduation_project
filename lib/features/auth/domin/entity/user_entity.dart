class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? token;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.token,
  });

  String get fullName => '$firstName $lastName';
}
