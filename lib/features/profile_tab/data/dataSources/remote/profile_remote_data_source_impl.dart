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
      print('Getting profile for userId: $userId');
      final response = await ApiManager.get("${EndPoints.getMe}/$userId");
      print('Profile Response: ${response.data}');
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Profile Error: ${e.response?.data}');
      throw NetworkException.fromDioError(e);
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

      final response = await ApiManager.put(
        "${EndPoints.updateMe}/$userId",
        body: body,
      );
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
