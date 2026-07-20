import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/router/go_router_regresh_stream.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/login_page.dart';
import 'package:secret_santa/features/auth/presentation/pages/register_page.dart';
import 'package:secret_santa/features/auth/presentation/pages/splash_page.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/create_group_page.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/set_date_group_page.dart';
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
      final bool isInitial =
          status == AuthStatus.initial || status == AuthStatus.loading;

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
        builder:
            (context, state) => BlocProvider.value(
              value: di.sl<HomeBloc>(),
              child: const HomePage(),
            ),
      ),
      GoRoute(
        path: "/create_group",
        builder:
            (context, state) => BlocProvider.value(
              value: di.sl<GroupBloc>(),
              child: const SetDateGroupPage(),
            ),
      ),
      GoRoute(
        path: "/group/:groupId",
        builder: (context, state) {
          final groupId = state.pathParameters['groupId']!;
          return BlocProvider(
            create:
                (_) => di.sl<GroupBloc>()..add(GetGroupEvent(groupId: groupId)),
            child: const DetailsGroupPage(), // bez group – ładuje ze stanu
          );
        },
      ),
      GoRoute(
        path: "/invite/:inviteCode",
        builder: (context, state) {
          final inviteCode = state.pathParameters['inviteCode']!;
          return BlocProvider(
            create:
                (_) =>
                    di.sl<GroupBloc>()
                      ..add(JoinGroupByCodeEvent(inviteCode: inviteCode)),
            child: const JoinGroupPage(),
          );
        },
      ),
    ],
  );
}
