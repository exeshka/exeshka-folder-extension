import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class ThemeRepository {
  static const String _themeModeKey = 'theme_mode';

  Future<void> saveThemeMode({required ThemeMode mode}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setInt(_themeModeKey, mode.index);
    } catch (e) {}
  }

  Future<ThemeMode> getCurrentThemeMode() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final int? modeInt = prefs.getInt(_themeModeKey);

      if (modeInt != null) {
        return ThemeMode.values[modeInt];
      } else {
        return ThemeMode.system;
      }
    } catch (e, st) {
      GetIt.I.get<Talker>().error(e, st);

      return ThemeMode.system;
    }
  }
}
