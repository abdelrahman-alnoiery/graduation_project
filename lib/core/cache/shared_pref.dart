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

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  // ✅ alias عشان الـ products datasource يستخدمه
  static Future<bool> saveString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // ── Bool ──────────────────────────────────────────
  static Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static Future<void> saveBool({
    required String key,
    required bool value,
  }) async {
    await _prefs.setBool(key, value);
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

  // // ── Contains ─────────────────────────────────────
  // static bool containsKey(String key) {
  //   return _prefs.containsKeys().contains(key);
  // }
}
