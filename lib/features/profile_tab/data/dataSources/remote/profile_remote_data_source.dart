import 'package:graduation_project/features/profile_tab/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String language,
  });
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
  Future<void> logout();
}
