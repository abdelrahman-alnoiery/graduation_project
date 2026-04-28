import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.logoutUseCase,
  }) : super(const ProfileInitialState()) {
    on<GetProfileEvent>(_onGetProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  // ── Get Profile ───────────────────────────────────
  Future<void> _onGetProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoadingState());
    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(ProfileErrorState(failure)),
      (profile) => emit(GetProfileSuccessState(profile)),
    );
  }

  // ── Update Profile ────────────────────────────────
  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoadingState());
    final result = await updateProfileUseCase(
      firstName: event.firstName,
      lastName: event.lastName,
      phone: event.phone,
      language: event.language,
    );
    result.fold(
      (failure) => emit(ProfileErrorState(failure)),
      (profile) => emit(UpdateProfileSuccessState(profile)),
    );
  }

  // ── Logout ────────────────────────────────────────
  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileLoadingState());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(ProfileErrorState(failure)),
      (_) => emit(const LogoutSuccessState()),
    );
  }
}
