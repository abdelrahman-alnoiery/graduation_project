import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }

  // ── Save ──────────────────────────────────────────

  static Future<void> saveString({
    required String key,
    required String value,
  }) async {
    await _sharedPreferences?.setString(key, value);
  }

  static Future<void> saveBool({
    required String key,
    required bool value,
  }) async {
    await _sharedPreferences?.setBool(key, value);
  }

  static Future<void> saveInt({required String key, required int value}) async {
    await _sharedPreferences?.setInt(key, value);
  }

  // ── Get ───────────────────────────────────────────

  static String? getString(String key) {
    return _sharedPreferences?.getString(key);
  }

  static bool? getBool(String key) {
    return _sharedPreferences?.getBool(key);
  }

  static int? getInt(String key) {
    return _sharedPreferences?.getInt(key);
  }

  // ── Delete ────────────────────────────────────────

  static Future<void> remove(String key) async {
    await _sharedPreferences?.remove(key);
  }

  static Future<void> clearAll() async {
    await _sharedPreferences?.clear();
  }
}
