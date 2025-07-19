import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _currencyKey = 'default_currency';
  static const String _themeModeKey = 'theme_mode';
  static const String _firstTimeUserKey = 'first_time_user';

  Future<String?> getDefaultCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey);
  }

  Future<void> setDefaultCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
  }

  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  Future<void> setThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode);
  }

  Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstTimeUserKey) ?? true;
  }

  Future<void> setFirstTimeUser(bool isFirstTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeUserKey, isFirstTime);
  }

  // Initialization logic for app load
  Future<void> initializeDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_currencyKey)) {
      await prefs.setString(_currencyKey, 'USD');
    }
    if (!prefs.containsKey(_themeModeKey)) {
      await prefs.setString(_themeModeKey, 'system');
    }
    if (!prefs.containsKey(_firstTimeUserKey)) {
      await prefs.setBool(_firstTimeUserKey, true);
    }
  }
} 