import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_current_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/register_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/sign_out_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:secret_santa/features/auth/domain/usecases/login_user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUser loginUser,
    required RegisterUser registerUser,
    required SignOutUser signOutUser,
    required GetCurrentUser getCurrentUser,
  }) : super(AuthState()) {
    on<AuthSignInRequested>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await loginUser(
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (user) {
          emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        },
      );
    });
    on<AuthSignUpRequested>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await registerUser(
        nickname: event.nickname,
        email: event.email,
        password: event.password,
      );
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.error,
                errorMessage: failure.message,
              ),
            );
          },
          (user) {
            emit(state.copyWith(status: AuthStatus.registered, user: user));
          },
        );
      });
    on<AuthSignOutRequested>((event, emit) async {
      emit(state.copyWith(status: AuthStatus.loading));
      final result = await signOutUser();
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: AuthStatus.error,
              errorMessage: failure.toString(),
            ),
          );
        },
        (_) {
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: null));
        },
      );
    });
    on<AuthCheckSession>((event, emit) async {
      final currentUserResult = await getCurrentUser();
      currentUserResult.fold(
        (failure) {
          emit(state.copyWith(status: AuthStatus.unauthenticated, user: null, errorMessage: null));
        },
        (user) {
          emit(state.copyWith(status: AuthStatus.authenticated, user: user));
        },
      );
    });
  }
}
