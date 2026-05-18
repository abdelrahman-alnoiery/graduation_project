import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';

import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // ── Save Token ────────────────────────────────────
  @override
  Future<void> saveToken(String token) async {
    await SharedPref.setString(AppConstants.userToken, token);
    print('✅ Token saved: $token');
  }

  // ── Get Token ─────────────────────────────────────
  @override
  String? getToken() {
    final token = SharedPref.getString(AppConstants.userToken);
    print('✅ Token retrieved: $token');
    return token;
  }

  // ── Delete Token ──────────────────────────────────
  @override
  Future<void> deleteToken() async {
    await SharedPref.remove(AppConstants.userToken);
    print('✅ Token deleted');
  }

  // ── Save Is Logged In ─────────────────────────────
  @override
  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    await SharedPref.setBool(AppConstants.isLoggedIn, isLoggedIn);
    print('✅ IsLoggedIn saved: $isLoggedIn');
  }

  // ── Get Is Logged In ──────────────────────────────
  @override
  bool getIsLoggedIn() {
    return SharedPref.getBool(AppConstants.isLoggedIn) ?? false;
  }

  // ── Save User Id ──────────────────────────────────
  @override
  Future<void> saveUserId(String userId) async {
    await SharedPref.setString(AppConstants.userId, userId);
    print('✅ UserId saved: $userId');
  }

  // ── Get User Id ───────────────────────────────────
  @override
  String? getUserId() {
    return SharedPref.getString(AppConstants.userId);
  }

  // ── Clear All ─────────────────────────────────────
  @override
  Future<void> clearAll() async {
    await SharedPref.remove(AppConstants.userToken);
    await SharedPref.remove(AppConstants.isLoggedIn);
    await SharedPref.remove(AppConstants.userId);
    print('✅ All auth data cleared');
  }

  @override
  Future<void> clearUserData() {
    // TODO: implement clearUserData
    throw UnimplementedError();
  }
}
