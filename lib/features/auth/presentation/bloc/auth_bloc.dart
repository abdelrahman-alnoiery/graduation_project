import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/cache/shared_pref.dart';
import '../../../../core/utils/constants_manager.dart';
import '../../domin/usecases/login_usecase.dart';
import '../../domin/usecases/signUp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;

  bool isPasswordVisible = false;

  AuthBloc({required this.loginUseCase, required this.signUpUseCase})
    : super(const AuthInitialState()) {
    // ── Sign In ─────────────────────────────────────
    on<SignInEvent>(_onSignIn);

    // ── Sign Up ─────────────────────────────────────
    on<SignUpEvent>(_onSignUp);

    // ── Send OTP ────────────────────────────────────
    on<SendOtpEvent>(_onSendOtp);

    // ── Verify OTP ──────────────────────────────────
    on<VerifyOtpEvent>(_onVerifyOtp);

    // ── Forgot Password ─────────────────────────────
    on<ForgotPasswordEvent>(_onForgotPassword);

    // ── Reset Password ──────────────────────────────
    on<ResetPasswordEvent>(_onResetPassword);

    // ── Sign Out ────────────────────────────────────
    on<SignOutEvent>(_onSignOut);

    // ── Toggle Password Visibility ───────────────────
    on<TogglePasswordVisibilityEvent>(_onTogglePasswordVisibility);
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(SignInErrorState(failure)),
      (user) {
        SharedPref.setString(AppConstants.userToken, user.token??"");
            emit(SignInSuccessState(user));}
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoadingState());
    final result = await signUpUseCase(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      phone: event.phone,
    );
    result.fold(
      (failure) => emit(SignUpErrorState(failure)),
      (user) => emit(SignUpSuccessState(user)),
    );
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    // ⚠️ هيتكمل لما الـ Backend يبعت الـ API
    emit(const SendOtpSuccessState());
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    // ⚠️ هيتكمل لما الـ Backend يبعت الـ API
    emit(const VerifyOtpSuccessState());
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    // ⚠️ هيتكمل لما الـ Backend يبعت الـ API
    emit(const ForgotPasswordSuccessState());
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    // ⚠️ هيتكمل لما الـ Backend يبعت الـ API
    emit(const ResetPasswordSuccessState());
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    // ⚠️ هيتكمل لما الـ Backend يبعت الـ API
    emit(const SignOutSuccessState());
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibilityEvent event,
    Emitter<AuthState> emit,
  ) {
    isPasswordVisible = !isPasswordVisible;
    emit(TogglePasswordVisibilityState(isPasswordVisible));
  }
}
