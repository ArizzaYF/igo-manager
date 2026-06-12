import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._();

  static LocalStorage? _instance;
  static SharedPreferences? _prefs;

  static LocalStorage get instance {
    if (_instance == null) {
      throw StateError('LocalStorage not initialized. Call getInstance() first.');
    }
    return _instance!;
  }

  static Future<LocalStorage> getInstance() async {
    if (_instance == null) {
      _prefs = await SharedPreferences.getInstance();
      _instance = LocalStorage._();
    }
    return _instance!;
  }

  Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }

  Future<void> saveBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  // Session
  static const String _sessionKey = 'user_session';
  static const String _onboardingKey = 'onboarding_completed';

  Future<void> saveUserSession(Map<String, dynamic> sessionData) async {
    final json = jsonEncode(sessionData);
    await saveString(_sessionKey, json);
  }

  Map<String, dynamic>? getUserSession() {
    final json = getString(_sessionKey);
    if (json == null) return null;
    return jsonDecode(json) as Map<String, dynamic>;
  }

  Future<void> clearSession() async {
    await remove(_sessionKey);
  }

  Future<void> setOnboardingCompleted(bool value) async {
    await saveBool(_onboardingKey, value);
  }

  bool? isOnboardingCompleted() {
    return getBool(_onboardingKey);
  }
}
