import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:secret_santa/core/router/app_router.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_current_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/login_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/register_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/sign_out_user.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();
  if (sl.isRegistered<AuthBloc>()) {
    return;
  }
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOutUser(sl()));

  sl.registerLazySingleton(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      signOutUser: sl(),
      getCurrentUser: sl(),
    ),
  );

  sl.registerLazySingleton(() => AppRouter(authBloc: sl()));
}
