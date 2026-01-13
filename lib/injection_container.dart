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
import 'package:secret_santa/features/home/domain/usecases/create_group.dart';
import 'package:secret_santa/features/home/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_by_id.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_user_groups.dart';
import 'package:secret_santa/features/home/domain/usecases/join_group.dart';
import 'package:secret_santa/features/home/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/home/domain/usecases/update_group.dart';

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
  //sl.registerFactory(()=> HomeBloc(getUserGroups: sl()));

  sl.registerLazySingleton(() => GetUserGroups(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => JoinGroup(sl()));
  sl.registerLazySingleton(() => LeaveGroup(sl()));
  sl.registerLazySingleton(() => GetGroupCode(sl()));
  sl.registerLazySingleton(() => GetGroupById(sl()));
  sl.registerLazySingleton(() => UpdateGroup(sl()));
  sl.registerLazySingleton(() => GenerateGroupCode(sl()));

  sl.registerLazySingleton(() => AppRouter(authBloc: sl()));
}
