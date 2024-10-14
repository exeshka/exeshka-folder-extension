import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_code_test/src/core/repository/locale_repository.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc(this._localeRepository) : super(LocaleState(null)) {
    on<GetCurrentLocale>((event, emit) async {
      Locale? locale = await _localeRepository.loadSavedLocale();

      emit(LocaleState(locale));
    });

    on<SwitchLocale>((event, emit) async {
      emit(LocaleState(Locale(event.localeCode)));

      await _localeRepository.changeLocale(event.localeCode);
    });

    on<DeleteCurrentLocale>((event, emit) async {
      await _localeRepository.resetToSystemLocale();

      emit(LocaleState(null));
    });
  }
  final LocaleRepository _localeRepository;
}
