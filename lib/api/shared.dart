import 'package:shared_preferences/shared_preferences.dart';

class AppShared {
  static String sharedPreferenceUserKey = "user";
  static String sharedPreferenceTokenKey = "Token";
  static String lang = 'en';

  static int language() {
    return lang == 'en' ? 2 : 1;
  }

  static bool isRTL() {
    return language() == 1;
  }

  static String token = "";

  static Future<void> setToken(String userToken) async {
    AppShared.token = userToken;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(sharedPreferenceTokenKey, userToken);
  }

  static Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? result = prefs.getString(sharedPreferenceTokenKey);
    if (result != null) token = result;
  }
}