import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:secret_santa/core/router/app_router.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_current_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/login_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/register_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/sign_out_user.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/home/data/datasources/group_remote_data_source.dart';
import 'package:secret_santa/features/home/data/datasources/group_remote_data_source_impl.dart';
import 'package:secret_santa/features/home/data/repositories/group_repository.dart';
import 'package:secret_santa/features/home/data/repositories/group_repositrory_impl.dart';
import 'package:secret_santa/features/home/domain/usecases/create_group.dart';
import 'package:secret_santa/features/home/domain/usecases/generate_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_by_id.dart';
import 'package:secret_santa/features/home/domain/usecases/get_group_code.dart';
import 'package:secret_santa/features/home/domain/usecases/get_user_groups.dart';
import 'package:secret_santa/features/home/domain/usecases/get_user_groups_stream.dart';
import 'package:secret_santa/features/home/domain/usecases/join_group.dart';
import 'package:secret_santa/features/home/domain/usecases/leave_group.dart';
import 'package:secret_santa/features/home/domain/usecases/update_group.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();
  if (sl.isRegistered<AuthBloc>()) {
    return;
  }
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<GroupRemoteDataSource>(() => GroupRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(remoteDataSource: sl(), firebaseAuth: sl()));
  //Auth usecases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOutUser(sl()));
  //Home usecases
  sl.registerLazySingleton(() => GetUserGroupsStream(sl()));
  sl.registerLazySingleton(() => GetUserGroups(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => JoinGroup(sl()));
  sl.registerLazySingleton(() => LeaveGroup(sl()));
  sl.registerLazySingleton(() => GetGroupCode(sl()));
  sl.registerLazySingleton(() => GetGroupById(sl()));
  sl.registerLazySingleton(() => UpdateGroup(sl()));
  sl.registerLazySingleton(() => GenerateGroupCode(sl()));
  //Blocs
  //Auth Bloc
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      signOutUser: sl(),
      getCurrentUser: sl(),
    ),
  );
  //Home Bloc
  sl.registerFactory(() => HomeBloc(repository: sl()));

  sl.registerLazySingleton(() => AppRouter(authBloc: sl()));
}
