abstract class ProfileEvent {
  const ProfileEvent();
}

class GetProfileEvent extends ProfileEvent {
  const GetProfileEvent();
}

class UpdateProfileEvent extends ProfileEvent {
  final String? username;
  final String? email;

  const UpdateProfileEvent({this.username, this.email});
}

class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}
