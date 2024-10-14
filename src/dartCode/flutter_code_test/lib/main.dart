import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

import 'app.dart';
import 'src/core/bloc/locale/locale_bloc.dart';
import 'src/core/di/di.dart';
import 'src/core/theme/theme_bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = TalkerBlocObserver();
  await dotenv.load(fileName: ".env");

  await DependensyInject().injectWithMode(mode: AppMode.dev);

  log(dotenv.env['PROD_API'] ?? '');

  await ScreenUtil.ensureScreenSize();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      lazy: false,
      create: (context) => GetIt.I.get<ThemeBloc>()..add(GetCurrentThemeMode()),
    ),
    BlocProvider(
      lazy: false,
      create: (context) => GetIt.I.get<LocaleBloc>()..add(GetCurrentLocale()),
    ),
  ], child: const App()));
}
