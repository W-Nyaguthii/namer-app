import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _nameKey = 'user_name';

  // Get user name from preferences
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'User';
  }

  // Save user name to preferences
  static Future<bool> setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_nameKey, name);
  }
}
