import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/l10n.dart';
import 'src/core/bloc/locale/locale_bloc.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_bloc/theme_bloc.dart';

// IPHONE 14-15 SIZE
const Size designSize = Size(393, 852);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GoRouter _router = GetIt.I.get<GoRouter>();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,

      splitScreenMode: true,
      useInheritedMediaQuery: true,

      // fontSizeResolver: (fontSize, instance) {
      //   final display = View.of(context).display;
      //   final screenSize = display.size / display.devicePixelRatio;
      //   final scaleWidth = screenSize.width / designSize.width;
      //   return fontSize * scaleWidth;

      // },

      enableScaleWH: () => false,
      enableScaleText: () => false,
      minTextAdapt: true,
      builder: (context, child) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => BlocBuilder<LocaleBloc, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppTheme().lightTheme,
              darkTheme: AppTheme().darkTheme,
              themeMode: themeState.mode,
              routerConfig: _router,
              supportedLocales: S.delegate.supportedLocales,
              locale: localeState.locale,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
