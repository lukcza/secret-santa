import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/router/go_router_regresh_stream.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/login_page.dart';
import 'package:secret_santa/features/auth/presentation/pages/register_page.dart';
import 'package:secret_santa/features/auth/presentation/pages/splash_page.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_bloc.dart';
import 'package:secret_santa/features/home/presentation/pages/home_page.dart';
import 'package:secret_santa/injection_container.dart' as di;

class AppRouter {
  final AuthBloc authBloc;
  AppRouter({required this.authBloc});
  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: "/splash",

    redirect: (BuildContext contextm, GoRouterState state) {
      final status = authBloc.state.status;
      final bool isLoggingIn = state.matchedLocation == "/login";
      final bool isOnSplash = state.matchedLocation == "/splash";
      final bool isAuthenticated = status == AuthStatus.authenticated;
      final bool isRegistered = status == AuthStatus.registered;
      final bool isInitial = status == AuthStatus.initial || status == AuthStatus.loading;

      // Czekamy na wynik sprawdzenia sesji — pokazujemy splash
      if (isInitial) {
        return isOnSplash ? null : "/splash";
      }

      if (isRegistered) {
        return "/login";
      }
      if (!isAuthenticated) {
        if (!isLoggingIn && state.matchedLocation != "/register") {
          return "/login";
        }
        return null;
      }
      // Użytkownik jest zalogowany - przekieruj ze splash/login na home
      if (isAuthenticated && (isLoggingIn || isOnSplash)) {
        return "/";
      }
      return null;
    },

    routes: [
      GoRoute(path: "/splash", builder: (context, state) => const SplashPage()),
      GoRoute(path: "/login", builder: (context, state) => LoginPage()),
      GoRoute(path: "/register", builder: (context, state) => RegisterPage()),
      GoRoute(
        path: "/",
        builder: (context, state) => BlocProvider.value(
          value: di.sl<HomeBloc>(),
          child: const HomePage(),
        ),
      )
    ],
  );
}
