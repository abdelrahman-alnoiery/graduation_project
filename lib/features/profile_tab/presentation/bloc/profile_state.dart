import 'package:graduation_project/features/profile_tab/domain/entity/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileSuccessState extends ProfileState {
  final ProfileEntity user;
  const ProfileSuccessState(this.user);
}

class ProfileErrorState extends ProfileState {
  final String message;
  const ProfileErrorState(this.message);
}

class LogoutSuccessState extends ProfileState {
  const LogoutSuccessState();
}
