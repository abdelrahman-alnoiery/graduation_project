abstract class ProfileEvent {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String phone;
  final String language;

  const UpdateProfileEvent({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.language,
  });
}

class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}
