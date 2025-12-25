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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final appRouter = di.sl<AppRouter>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(const AuthCheckSession()),
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