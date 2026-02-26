import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:secret_santa/core/router/app_router.dart';
import 'package:secret_santa/core/theme/app_theme.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/core/l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'package:secret_santa/injection_container.dart' as di;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  // Dodaj event od razu po inicjalizacji
  print("main: Adding AuthCheckSession event");
  final authBloc = di.sl<AuthBloc>();
  print("main: AuthBloc instance: $authBloc");
  authBloc.add(const AuthCheckSession());
  print("main: Event added, running app");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final appRouter = di.sl<AppRouter>();
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.router,
        title: 'Secret Santa',
        localizationsDelegates: [
           AppLocalizations.delegate,
           GlobalMaterialLocalizations.delegate,
           GlobalWidgetsLocalizations.delegate,
           GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThemeMode,
        darkTheme: AppTheme.darkThemeMode,
        themeMode: ThemeMode.system,
      ),
      );
  }
}
