// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_element, unnecessary_cast

part of 'app_theme.dart';

// **************************************************************************
// TailorAnnotationsGenerator
// **************************************************************************

mixin _$CustomThemeTailorMixin on ThemeExtension<CustomTheme> {
  Color? get scaffoldColor;

  @override
  CustomTheme copyWith({
    Color? scaffoldColor,
  }) {
    return CustomTheme(
      scaffoldColor: scaffoldColor ?? this.scaffoldColor,
    );
  }

  @override
  CustomTheme lerp(covariant ThemeExtension<CustomTheme>? other, double t) {
    if (other is! CustomTheme) return this as CustomTheme;
    return CustomTheme(
      scaffoldColor: Color.lerp(scaffoldColor, other.scaffoldColor, t),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomTheme &&
            const DeepCollectionEquality()
                .equals(scaffoldColor, other.scaffoldColor));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(scaffoldColor),
    );
  }
}

extension CustomThemeBuildContextProps on BuildContext {
  CustomTheme get customTheme => Theme.of(this).extension<CustomTheme>()!;
  Color? get scaffoldColor => customTheme.scaffoldColor;
}
