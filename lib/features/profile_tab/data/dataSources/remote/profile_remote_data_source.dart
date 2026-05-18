import 'package:graduation_project/features/profile_tab/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({String? username, String? email});
  Future<void> logout();
}
