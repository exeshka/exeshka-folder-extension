import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'package:talker/talker.dart';

import 'package:talker_dio_logger/talker_dio_logger_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger_settings.dart';

import '../bloc/locale/locale_bloc.dart';
import '../repository/api_service/api_service.dart';
import '../repository/locale_repository.dart';
import '../router/app_router.dart';
import '../theme/repository/theme_repository.dart';
import '../theme/theme_bloc/theme_bloc.dart';

GetIt sl = GetIt.I;

enum AppMode { prod, dev }

class DependensyInject {
  Future<void> injectWithMode({required AppMode mode}) async {
    switch (mode) {
      case AppMode.prod:
        inject(apiUrl: dotenv.env['PROD_API'] ?? '');

        break;

      case AppMode.dev:
        inject(apiUrl: dotenv.env['DEV_API'] ?? '');
        break;
      default:
    }
  }

  void inject({required String apiUrl}) {
    sl.registerSingleton(Talker());

    sl.registerSingleton(appRouter);

    sl.registerSingleton(Dio());

    sl.registerSingleton(LocaleRepository());

    sl.registerSingleton(ApiService(sl.get(), baseUrl: apiUrl));

    sl.registerSingleton(ThemeRepository());

    sl.registerSingleton(ThemeBloc(sl.get()));
    sl.registerSingleton(LocaleBloc(sl.get()));

    initLoggers();

    sl.get<Talker>().info('Di completed 100%');
  }

  void initLoggers() {
    sl.get<Dio>().interceptors.add(
          TalkerDioLogger(
            settings: const TalkerDioLoggerSettings(
              printRequestHeaders: true,
              printResponseHeaders: true,
              printResponseMessage: true,
            ),
          ),
        );
  }
}
