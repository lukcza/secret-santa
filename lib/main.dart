import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()..add(const AuthCheckSession()),
        ),
      ],
      child: MaterialApp(
        title: 'Secret Santa',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const Scaffold(
          body: Center(
            child: Text('Welcome to Secret Santa!'),
          ),
        ))    ,
      );
  }
}