import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static String userIdKey = "USERIDKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  static String userImageKey = "USERIMAGEKEY";
  static String isLoginKey = "ISLOGGEDIN";
   static const String themeKey = "IS_DARK_THEME";

 // Save theme: true = dark, false = light
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeKey, isDark);
  }

  // Get theme, default = false (light)
  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeKey) ?? false;
  }

// User Login Status
Future<bool> saveUserLoginStatus(bool isLoggedIn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool(isLoginKey, isLoggedIn);
}
// Get Login Status
Future<bool> getUserLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(isLoginKey) ?? false;
}
////Why ?? false?

//////If user opens app first time, no value exists → default false////


  // For Store Data of User Locally

  Future<bool> saveUserId(String getUserId) async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.setString(userIdKey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.setString(userNameKey, getUserName);
  }

  Future<bool> saveUserEmail(String getUserEmail) async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.setString(userEmailKey, getUserEmail);
  }

  Future<bool> saveUserImage(String getUserImage) async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.setString(userImageKey, getUserImage);
  }

  // Now to Get these data

  Future<String?> getUserId() async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.getString(userIdKey);
  }


   Future<String?> getUserName() async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.getString(userNameKey);
  }


   Future<String?> getUserEmail() async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.getString(userEmailKey);
  }


   Future<String?> getUserImage() async {
    SharedPreferences Prefs = await SharedPreferences.getInstance();
    return Prefs.getString(userImageKey);
  }

 Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
