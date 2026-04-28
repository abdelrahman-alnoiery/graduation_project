import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });

  Future<void> sendOtp({required String email});

  Future<void> verifyOtp({required String email, required String otp});

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<void> signOut();
}
