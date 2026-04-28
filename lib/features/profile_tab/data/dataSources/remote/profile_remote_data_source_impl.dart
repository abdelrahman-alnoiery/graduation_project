import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/features/profile_tab/data/models/profile_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  // ── Get Profile ───────────────────────────────────
  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await ApiManager.get(EndPoints.profile);
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Update Profile ────────────────────────────────
  @override
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String language,
  }) async {
    try {
      final response = await ApiManager.put(
        EndPoints.profile,
        body: {
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
          "language": language,
        },
      );
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Change Password ───────────────────────────────
  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await ApiManager.post(
        EndPoints.changePassword,
        body: {"old_password": oldPassword, "new_password": newPassword},
      );
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  // ── Logout ────────────────────────────────────────
  @override
  Future<void> logout() async {
    try {
      await ApiManager.post(EndPoints.signOut, body: {});
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
