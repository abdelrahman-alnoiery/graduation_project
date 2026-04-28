import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> saveUserId(String userId);
  Future<void> saveIsLoggedIn(bool isLoggedIn);
  Future<void> saveIsOnboardingDone(bool isOnboardingDone);
  String? getToken();
  String? getUserId();
  bool? getIsLoggedIn();
  bool? getIsOnboardingDone();
  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // ── Save ──────────────────────────────────────────

  @override
  Future<void> saveToken(String token) async {
    try {
      await SharedPref.saveString(key: AppConstants.userToken, value: token);
    } catch (e) {
      throw CacheException(message: "Failed to save token");
    }
  }

  @override
  Future<void> saveUserId(String userId) async {
    try {
      await SharedPref.saveString(key: AppConstants.userId, value: userId);
    } catch (e) {
      throw CacheException(message: "Failed to save user id");
    }
  }

  @override
  Future<void> saveIsLoggedIn(bool isLoggedIn) async {
    try {
      await SharedPref.saveBool(
        key: AppConstants.isLoggedIn,
        value: isLoggedIn,
      );
    } catch (e) {
      throw CacheException(message: "Failed to save login state");
    }
  }

  @override
  Future<void> saveIsOnboardingDone(bool isOnboardingDone) async {
    try {
      await SharedPref.saveBool(
        key: AppConstants.isOnboardingDone,
        value: isOnboardingDone,
      );
    } catch (e) {
      throw CacheException(message: "Failed to save onboarding state");
    }
  }

  // ── Get ───────────────────────────────────────────

  @override
  String? getToken() {
    try {
      return SharedPref.getString(AppConstants.userToken);
    } catch (e) {
      throw CacheException(message: "Failed to get token");
    }
  }

  @override
  String? getUserId() {
    try {
      return SharedPref.getString(AppConstants.userId);
    } catch (e) {
      throw CacheException(message: "Failed to get user id");
    }
  }

  @override
  bool? getIsLoggedIn() {
    try {
      return SharedPref.getBool(AppConstants.isLoggedIn);
    } catch (e) {
      throw CacheException(message: "Failed to get login state");
    }
  }

  @override
  bool? getIsOnboardingDone() {
    try {
      return SharedPref.getBool(AppConstants.isOnboardingDone);
    } catch (e) {
      throw CacheException(message: "Failed to get onboarding state");
    }
  }

  // ── Delete ────────────────────────────────────────

  @override
  Future<void> clearUserData() async {
    try {
      await SharedPref.remove(AppConstants.userToken);
      await SharedPref.remove(AppConstants.userId);
      await SharedPref.remove(AppConstants.isLoggedIn);
    } catch (e) {
      throw CacheException(message: "Failed to clear user data");
    }
  }
}
