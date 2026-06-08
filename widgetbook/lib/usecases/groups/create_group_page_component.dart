import 'package:fpdart/fpdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_current_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/login_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/register_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/sign_out_user.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/create/create_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

const _fakeUser = UserEntity(
  uid: 'fake_uid_123',
  email: 'santa@example.com',
  nickname: 'Santa Claus',
);

// Fake repository — returns a pre-set user for getCurrentUser,
// stubs out everything else. Lets us use the real AuthBloc.
class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async => const Right(_fakeUser);

  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async =>
      const Right(_fakeUser);

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String nickname,
    required String email,
    required String password,
  }) async => const Right(_fakeUser);

  @override
  Stream<UserEntity?> get getCurrentUserStream => Stream.value(_fakeUser);

  @override
  Future<Either<Failure, UserEntity>> getUserByEmail({required String email}) async =>
      const Right(_fakeUser);

  @override
  Future<Either<Failure, UserEntity>> getUserByUid({required String uid}) async =>
      const Right(_fakeUser);
}

AuthBloc _buildFakeAuthBloc() {
  final repo = _FakeAuthRepository();
  return AuthBloc(
    loginUser: LoginUser(repo),
    registerUser: RegisterUser(repo),
    signOutUser: SignOutUser(repo),
    getCurrentUser: GetCurrentUser(repo),
  )..emit(
      AuthState(
        status: AuthStatus.authenticated,
        user: _fakeUser,
      ),
    );
}

// Fake GroupBloc — handles events needed by CreateGroupPage / ManuallyInvitePage.
class _FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  _FakeGroupBloc() : super(GroupState(status: GroupStatus.draft)) {
    on<GenerateInviteCodeEvent>((event, emit) {
      emit(state.copyWith(inviteCode: 'FAKE42'));
    });
    on<CreateGroupEvent>((event, emit) {});
  }
}

// Fake GroupBloc - handles events needed by CreateGroupPage / ManuallyInvitePage.
class FakeCreateGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  FakeCreateGroupBloc() : super(GroupState(status: GroupStatus.draft)) {
    on<GenerateInviteCodeEvent>((event, emit) {
      emit(state.copyWith(inviteCode: 'FAKE42'));
    });
    on<CreateGroupEvent>((event, emit) {});
  }
}

final createGroupPageComponent = WidgetbookComponent(
  name: 'CreateGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc()),
          BlocProvider<GroupBloc>(create: (_) => FakeCreateGroupBloc()),
        ],
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => CreateGroupPage(selectedDate: DateTime.now()),
          ),
        ),
      ),
    ),
  ],
);
