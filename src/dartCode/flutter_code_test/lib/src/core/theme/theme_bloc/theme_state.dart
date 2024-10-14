part of 'theme_bloc.dart';

final class ThemeState extends Equatable {
  final ThemeMode mode;

  ThemeState({required this.mode});
  @override
  List<Object> get props => [mode];
}
