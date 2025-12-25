import 'package:flutter/material.dart';
import 'package:secret_santa/core/router/go_router_regresh_stream.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/login_page.dart';
import 'package:secret_santa/features/auth/presentation/pages/register_page.dart';

class AppRouter {
  final AuthBloc authBloc;
  AppRouter({required this.authBloc});
  late final GoRouter router = GoRouter(
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    initialLocation: "/login",

    redirect: (BuildContext contextm, GoRouterState state) {
      final bool isLoggingIn = state.matchedLocation == "/login";
      final bool isAuthenticated =
          authBloc.state.status == AuthStatus.authenticated;
      if (!isAuthenticated) {
        if (!isLoggingIn && state.matchedLocation != "/register") {
          return "/login";
        }
        return null;
      }
      if (isAuthenticated) {
        if (isLoggingIn) {
          return "/";
        }
      }
      return null;
    },

    routes: [
      GoRoute(path: "/login", builder: (context, state) => LoginPage()),
      GoRoute(path: "/register", builder: (context, state) => RegisterPage()),
      GoRoute(
        path: "/",
        builder:
            (context, state) =>
                const Scaffold(body: Center(child: Text("Home Page"))),
      ),
    ],
  );
}
