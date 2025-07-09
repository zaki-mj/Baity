import 'package:flutter/material.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = lightTheme;

  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;
  ThemeData get theme => _currentTheme;

  void toggleTheme() {
    _currentTheme = isDarkMode ? lightTheme : darkTheme;
    notifyListeners();
  }
}