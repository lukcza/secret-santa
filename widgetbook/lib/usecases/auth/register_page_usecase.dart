import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/register_page.dart';
import 'package:widgetbook/widgetbook.dart';

const _fakeUser = UserEntity(
  uid: 'user_new_1',
  email: 'elf@northpole.com',
  nickname: 'Buddy Elf',
);

class _FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  _FakeAuthBloc(AuthState initialState) : super(initialState) {
    on<AuthSignInRequested>((event, emit) {});
    on<AuthSignUpRequested>((event, emit) {});
    on<AuthSignOutRequested>((event, emit) {});
    on<AuthCheckSession>((event, emit) {});
  }
}

Widget _wrapRegisterPage(AuthState state) {
  return BlocProvider<AuthBloc>(
    create: (_) => _FakeAuthBloc(state),
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const RegisterPage(),
      ),
    ),
  );
}

final registerPageComponent = WidgetbookComponent(
  name: 'RegisterPage',
  useCases: [
    // ① Initial State
    WidgetbookUseCase(
      name: '① Initial State',
      builder: (context) {
        return _wrapRegisterPage(
          AuthState(status: AuthStatus.initial),
        );
      },
    ),

    // ② Loading State
    WidgetbookUseCase(
      name: '② Loading State',
      builder: (context) {
        return _wrapRegisterPage(
          AuthState(status: AuthStatus.loading),
        );
      },
    ),

    // ③ Registered Success
    WidgetbookUseCase(
      name: '③ Registered Success',
      builder: (context) {
        return _wrapRegisterPage(
          AuthState(
            status: AuthStatus.authenticated,
            user: _fakeUser,
          ),
        );
      },
    ),

    // ④ Error State
    WidgetbookUseCase(
      name: '④ Error State',
      builder: (context) {
        final errorMsg = context.knobs.string(
          label: 'Error Message',
          initialValue: 'Account already exists with this email.',
        );
        return _wrapRegisterPage(
          AuthState(
            status: AuthStatus.error,
            errorMessage: errorMsg,
          ),
        );
      },
    ),
  ],
);
