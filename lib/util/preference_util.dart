import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  static Future<void> save<T>(String key, T? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value != null) {
      final jsonValue = json.encode(value);
      prefs.setString(key, jsonValue);
    }
  }

  static Future<T?> get<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jsonData = prefs.getString(key);
    if (jsonData != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonData);
      return fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> remove(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
