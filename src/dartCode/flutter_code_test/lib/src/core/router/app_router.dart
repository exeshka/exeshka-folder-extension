import 'package:go_router/go_router.dart';
import 'package:go_transitions/go_transitions.dart';

import '../../features/auth/presentation/pages/auth_screen.dart';

GoRouter appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (_, __) => const AuthScreen(),
    pageBuilder: GoTransitions.fadeUpwards.call,
  )
]);
