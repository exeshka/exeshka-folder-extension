import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_test/src/core/theme/theme_bloc/theme_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/bloc/locale/locale_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final supportedLocales = S.delegate.supportedLocales;
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(onPressed: () {
            BlocProvider.of<ThemeBloc>(context)
                .add(SwitchThemeMode(mode: ThemeMode.system));
          }),
          FloatingActionButton(onPressed: () {
            BlocProvider.of<ThemeBloc>(context)
                .add(SwitchThemeMode(mode: ThemeMode.dark));
          }),
          FloatingActionButton(onPressed: () {
            BlocProvider.of<ThemeBloc>(context)
                .add(SwitchThemeMode(mode: ThemeMode.light));
          }),
        ],
      ),
      appBar: AppBar(),
      body: ListView(
        children: [
          ...supportedLocales.map((locale) {
            return ListTile(
              selected: locale.languageCode ==
                  Localizations.localeOf(context).languageCode,
              title: Text(locale.languageCode),
              onTap: () {
                context
                    .read<LocaleBloc>()
                    .add(SwitchLocale(localeCode: locale.languageCode));
              },
            );
          }),
          TextButton(
              onPressed: () {
                context.read<LocaleBloc>().add(DeleteCurrentLocale());
              },
              child: Text("удалить локаль"))
        ],
      ),
    );
  }
}
