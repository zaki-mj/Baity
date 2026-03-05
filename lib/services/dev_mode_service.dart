import 'package:shared_preferences/shared_preferences.dart';

class DevModeService {
  static const String _keyDevMode = 'dev_mode_enabled';

  Future<void> enableDevMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDevMode, true);
  }

  Future<bool> isDevModeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDevMode) ?? false;
  }

  Future<void> disableDevMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDevMode);
  }
}
