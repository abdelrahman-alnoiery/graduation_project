import 'package:dio/dio.dart';
import 'package:graduation_project/core/api/end_points.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';
import 'package:graduation_project/features/profile_tab/data/models/profile_model.dart';

import '../../../../../core/api/api_manger.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    try {
      final userId = SharedPref.getString(AppConstants.userId) ?? '';
      final userName = SharedPref.getString(AppConstants.userName) ?? '';
      final userEmail = SharedPref.getString(AppConstants.userEmail) ?? '';

      print('Profile from local: $userId - $userName - $userEmail');

      // ✅ ارجع البيانات من الـ SharedPreferences
      if (userId.isNotEmpty) {
        final parts = userName.split(' ');
        return ProfileModel(
          id: userId,
          firstName: parts.isNotEmpty ? parts.first : 'User',
          lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
          email: userEmail,
          phone: '',
          role: 'seller',
        );
      }

      throw NetworkException(message: "User not logged in");
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<ProfileModel> updateProfile({String? username, String? email}) async {
    try {
      final userId = SharedPref.getString(AppConstants.userId) ?? '';
      final body = <String, dynamic>{};
      if (username != null) body['username'] = username;
      if (email != null) body['email'] = email;

      // ✅ PUT /api/user/{id} — Update logged user
      final response = await ApiManager.put(
        "${EndPoints.updateMe}/$userId",
        body: body,
      );
      print('Update Profile Response: ${response.data}');

      // ✅ حفظ البيانات الجديدة محلياً
      if (username != null) {
        await SharedPref.setString(AppConstants.userName, username);
      }
      if (email != null) {
        await SharedPref.setString(AppConstants.userEmail, email);
      }

      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      throw NetworkException.fromDioError(e);
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await SharedPref.remove(AppConstants.userToken);
    await SharedPref.remove(AppConstants.isLoggedIn);
    await SharedPref.remove(AppConstants.userId);
    await SharedPref.remove(AppConstants.userName);
    print('✅ Logged out');
  }
}
