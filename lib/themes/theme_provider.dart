import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;
  final String _key = "isDarkTheme";

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get theme => _currentTheme;
  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  void toggleTheme() {
    _currentTheme = isDarkMode ? lightTheme : darkTheme;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    _currentTheme = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_key, isDarkMode);
  }
}
