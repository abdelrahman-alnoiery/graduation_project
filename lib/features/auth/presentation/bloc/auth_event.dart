abstract class AuthEvent {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;

  const SignUpEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phone,
  });
}

class SendOtpEvent extends AuthEvent {
  final String email;

  const SendOtpEvent({required this.email});
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtpEvent({required this.email, required this.otp});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});
}

class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String otp;
  final String newPassword;

  const ResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class TogglePasswordVisibilityEvent extends AuthEvent {
  const TogglePasswordVisibilityEvent();
}
