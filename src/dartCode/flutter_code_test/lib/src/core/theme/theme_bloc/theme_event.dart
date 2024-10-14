part of 'theme_bloc.dart';

sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

final class GetCurrentThemeMode extends ThemeEvent {}

final class SwitchThemeMode extends ThemeEvent {
  final ThemeMode mode;

  const SwitchThemeMode({required this.mode});
  @override
  List<Object> get props => [mode];
}
