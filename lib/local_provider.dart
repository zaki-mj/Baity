import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('ar');
  final String _key = "appLanguage";

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void setLocale(Locale locale) {
    if (!['en', 'ar', 'fr'].contains(locale.languageCode)) return;
    _locale = locale;
    _saveLocale(locale.languageCode);
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('ar');
    _saveLocale('ar');
    notifyListeners();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString(_key) ?? 'ar';
    _locale = Locale(langCode);
    notifyListeners();
  }

  Future<void> _saveLocale(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, langCode);
  }
}
