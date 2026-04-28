import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class GetProfileSuccessState extends ProfileState {
  final ProfileEntity profile;
  const GetProfileSuccessState(this.profile);
}

class UpdateProfileSuccessState extends ProfileState {
  final ProfileEntity profile;
  const UpdateProfileSuccessState(this.profile);
}

class LogoutSuccessState extends ProfileState {
  const LogoutSuccessState();
}

class ProfileErrorState extends ProfileState {
  final Failure failure;
  const ProfileErrorState(this.failure);
}
