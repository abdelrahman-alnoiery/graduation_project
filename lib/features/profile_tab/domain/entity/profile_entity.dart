class ProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? image;
  final String language;

  const ProfileEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.image,
    this.language = 'English',
  });

  String get fullName => '$firstName $lastName';
}
