part of 'locale_bloc.dart';

sealed class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentLocale extends LocaleEvent {}

class DeleteCurrentLocale extends LocaleEvent {}

class SwitchLocale extends LocaleEvent {
  final String localeCode;

  SwitchLocale({required this.localeCode});

  @override
  List<Object> get props => [localeCode];
}
