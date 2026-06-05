import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ── String ────────────────────────────────────────
  static Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // في shared_pref.dart
  static String? getString(String key) {
    return _prefs?.getString(key); // ✅ بيرجع String? مش Object?
  }

  // ── Bool ──────────────────────────────────────────
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // ── Int ───────────────────────────────────────────
  static Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // ── Remove ────────────────────────────────────────
  static Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  // ── Clear All ─────────────────────────────────────
  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  static Future<void> saveBool({
    required String key,
    required bool value,
  }) async {}
}
