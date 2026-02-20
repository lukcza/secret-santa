import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/enums/group_state.dart';
import 'package:secret_santa/core/router/go_router_regresh_stream.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/login_page.dart';
import 'package:secret_santa/features/auth/presentation/pages/register_page.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_bloc.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:secret_santa/features/home/presentation/pages/home_page.dart';

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
      final bool isRegistered =
          authBloc.state.status == AuthStatus.registered;
      if(isRegistered) {
        return "/login";
      }
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
               const HomePage(),
      )
    ],
  );
}
