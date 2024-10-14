import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_code_test/src/core/theme/repository/theme_repository.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._repository) : super(ThemeState(mode: ThemeMode.system)) {
    on<GetCurrentThemeMode>((event, emit) async {
      ThemeMode mode = await _repository.getCurrentThemeMode();

      emit(ThemeState(mode: mode));
    });

    on<SwitchThemeMode>((event, emit) async {
      emit(ThemeState(mode: event.mode));
      await _repository.saveThemeMode(mode: event.mode);
    });
  }

  final ThemeRepository _repository;
}
