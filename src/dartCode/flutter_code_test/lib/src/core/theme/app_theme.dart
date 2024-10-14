import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'app_theme.tailor.dart';

// Убирает много бойлер-плейд кода который нужно прописывать в ручную
// Все что остается добавь цвет и запустить комманду
// Читайте README.md

@TailorMixin()
class CustomTheme extends ThemeExtension<CustomTheme>
    with _$CustomThemeTailorMixin {
  final Color? scaffoldColor;

  CustomTheme({
    this.scaffoldColor,
  });
}

// Базовая тема
// Если не хватает цветов то используйте CustomTheme

// final ThemeData darkTheme = ThemeData(brightness: Brightness.dark, extensions: []);

class AppTheme {
  final ThemeData darkTheme =
      ThemeData(brightness: Brightness.dark, extensions: []);
  final ThemeData lightTheme = ThemeData.light();
}
