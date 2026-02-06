import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFFDAB49D),
  scaffoldBackgroundColor: Color(0xFFFFF8F1),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFDAB49D),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    primary: Color(0xFFDAB49D),
    secondary: Color(0xFFB2BEB5),
    background: Color(0xFFFFF8F1),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color(0xFF8E735B),
  scaffoldBackgroundColor: Color(0xFF2E2E2E),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF8E735B),
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF8E735B),
    secondary: Color(0xFFDAB49D),
    background: Color(0xFF1E1E1E),
    onPrimary: Colors.white,
    onSecondary: Colors.white70,
  ),
);
