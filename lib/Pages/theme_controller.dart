import 'package:flutter/material.dart';
import 'package:pizzashop/Services/Shearedprefrences.dart';


class ThemeController extends ChangeNotifier {
  final SharedPreferencesHelper _prefs = SharedPreferencesHelper();

  bool _isDark = false;
  bool get isDark => _isDark;

  ThemeController() {
    loadTheme();
  }

  void loadTheme() async {
    _isDark = await _prefs.getTheme();
    notifyListeners();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    await _prefs.saveTheme(_isDark);
    notifyListeners();
  }
}
