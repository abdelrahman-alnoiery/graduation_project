import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';

import '../../../../../core/api/api_manger.dart';
import '../../models/user_model.dart';
import 'auth_remote_ds.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // ── Sign In ───────────────────────────────────────
  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiManager.post(
        EndPoints.signIn,
        body: {"email": email, "password": password},
      );
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Sign Up ───────────────────────────────────────
  @override
  Future<UserModel> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      print('SignUp Request: ${EndPoints.baseUrl}${EndPoints.signUp}'); // ✅
      final response = await ApiManager.post(
        EndPoints.signUp,
        body: {
          "username": "$firstName $lastName", // ✅ Backend بياخد username
          "email": email,
          "password": password,
          "role": "seller",
        },
      );
      print('SignUp Response: ${response.data}'); // ✅
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      print('SignUp DioError: ${e.message}'); // ✅
      print('SignUp DioResponse: ${e.response?.data}'); // ✅
      print('SignUp DioStatus: ${e.response?.statusCode}'); // ✅
      throw NetworkException.fromDioError(e);
    } catch (e) {
      print('SignUp Error: $e'); // ✅

      throw NetworkException(message: e.toString());
    }
  }

  // ── Send OTP ──────────────────────────────────────
  @override
  Future<void> sendOtp({required String email}) async {
    try {
      await ApiManager.post(EndPoints.otp, body: {"email": email});
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Verify OTP ────────────────────────────────────
  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      await ApiManager.post(
        EndPoints.verify,
        body: {"email": email, "otp": otp},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Forgot Password ───────────────────────────────
  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await ApiManager.post(EndPoints.forgotPassword, body: {"email": email});
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Reset Password ────────────────────────────────
  @override
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await ApiManager.post(
        EndPoints.resetPassword,
        body: {"email": email, "otp": otp, "new_password": newPassword},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Sign Out ──────────────────────────────────────
  @override
  Future<void> signOut() async {
    try {
      await ApiManager.post(EndPoints.signOut, body: {});
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
