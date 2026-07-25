import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/login_page.dart';
import 'package:widgetbook/widgetbook.dart';

const _fakeUser = UserEntity(
  uid: 'user_santa_1',
  email: 'santa@northpole.com',
  nickname: 'Santa Claus',
);

class _FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  _FakeAuthBloc(AuthState initialState) : super(initialState) {
    on<AuthSignInRequested>((event, emit) {});
    on<AuthSignUpRequested>((event, emit) {});
    on<AuthSignOutRequested>((event, emit) {});
    on<AuthCheckSession>((event, emit) {});
  }
}

Widget _wrapLoginPage(AuthState state) {
  return BlocProvider<AuthBloc>(
    create: (_) => _FakeAuthBloc(state),
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    ),
  );
}

final loginPageComponent = WidgetbookComponent(
  name: 'LoginPage',
  useCases: [
    // ① Initial / Unauthenticated
    WidgetbookUseCase(
      name: '① Initial / Unauthenticated',
      builder: (context) {
        return _wrapLoginPage(
          AuthState(status: AuthStatus.unauthenticated),
        );
      },
    ),

    // ② Loading State
    WidgetbookUseCase(
      name: '② Loading State',
      builder: (context) {
        return _wrapLoginPage(
          AuthState(status: AuthStatus.loading),
        );
      },
    ),

    // ③ Authenticated Success State
    WidgetbookUseCase(
      name: '③ Authenticated Success',
      builder: (context) {
        return _wrapLoginPage(
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
          initialValue: 'Invalid email or password.',
        );
        return _wrapLoginPage(
          AuthState(
            status: AuthStatus.error,
            errorMessage: errorMsg,
          ),
        );
      },
    ),
  ],
);
