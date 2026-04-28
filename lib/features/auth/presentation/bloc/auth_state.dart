import '../../../../core/exceptions/failuers.dart';
import '../../domin/entity/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

// ── Initial ───────────────────────────────────────
class AuthInitialState extends AuthState {
  const AuthInitialState();
}

// ── Loading ───────────────────────────────────────
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

// ── Sign In ───────────────────────────────────────
class SignInSuccessState extends AuthState {
  final UserEntity user;
  const SignInSuccessState(this.user);
}

class SignInErrorState extends AuthState {
  final Failure failure;
  const SignInErrorState(this.failure);
}

// ── Sign Up ───────────────────────────────────────
class SignUpSuccessState extends AuthState {
  final UserEntity user;
  const SignUpSuccessState(this.user);
}

class SignUpErrorState extends AuthState {
  final Failure failure;
  const SignUpErrorState(this.failure);
}

// ── Send OTP ──────────────────────────────────────
class SendOtpSuccessState extends AuthState {
  const SendOtpSuccessState();
}

class SendOtpErrorState extends AuthState {
  final Failure failure;
  const SendOtpErrorState(this.failure);
}

// ── Verify OTP ────────────────────────────────────
class VerifyOtpSuccessState extends AuthState {
  const VerifyOtpSuccessState();
}

class VerifyOtpErrorState extends AuthState {
  final Failure failure;
  const VerifyOtpErrorState(this.failure);
}

// ── Forgot Password ───────────────────────────────
class ForgotPasswordSuccessState extends AuthState {
  const ForgotPasswordSuccessState();
}

class ForgotPasswordErrorState extends AuthState {
  final Failure failure;
  const ForgotPasswordErrorState(this.failure);
}

// ── Reset Password ────────────────────────────────
class ResetPasswordSuccessState extends AuthState {
  const ResetPasswordSuccessState();
}

class ResetPasswordErrorState extends AuthState {
  final Failure failure;
  const ResetPasswordErrorState(this.failure);
}

// ── Sign Out ──────────────────────────────────────
class SignOutSuccessState extends AuthState {
  const SignOutSuccessState();
}

class SignOutErrorState extends AuthState {
  final Failure failure;
  const SignOutErrorState(this.failure);
}

// ── Toggle Password Visibility ────────────────────
class TogglePasswordVisibilityState extends AuthState {
  final bool isPasswordVisible;
  const TogglePasswordVisibilityState(this.isPasswordVisible);
}
