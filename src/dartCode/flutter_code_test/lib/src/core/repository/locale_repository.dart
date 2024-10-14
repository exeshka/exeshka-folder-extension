import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class LocaleRepository {
  static const String _localeCodeKey = 'language_code';

  Future<Locale?> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeCodeKey);
    if (languageCode != null) {
      return Locale(languageCode);
    }
    return null;
  }

  Future<void> changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeCodeKey, languageCode);
  }

  Future<void> resetToSystemLocale() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localeCodeKey);
  }
}
