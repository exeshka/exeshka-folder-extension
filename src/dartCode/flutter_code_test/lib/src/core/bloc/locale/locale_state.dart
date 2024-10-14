part of 'locale_bloc.dart';

final class LocaleState extends Equatable {
  final Locale? locale;
  const LocaleState(this.locale);

  @override
  List<Object> get props => locale != null ? [locale!] : [];
}
