abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> deleteToken();
  Future<void> saveIsLoggedIn(bool isLoggedIn);
  bool getIsLoggedIn();
  Future<void> saveUserId(String userId);
  String? getUserId();
  Future<void> clearAll();

  Future<void> clearUserData() async {}
}
