import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/core/errors/failures.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/auth/domain/repositories/auth_repository.dart';
import 'package:secret_santa/features/auth/domain/usecases/get_current_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/login_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/register_user.dart';
import 'package:secret_santa/features/auth/domain/usecases/sign_out_user.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_bloc.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_event.dart';
import 'package:secret_santa/features/home/presentation/bloc/home_state.dart';
import 'package:secret_santa/features/home/presentation/pages/home_page.dart';
import 'package:widgetbook/widgetbook.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fake Data
// ─────────────────────────────────────────────────────────────────────────────

const _currentUser = UserEntity(
  uid: 'user_santa_1',
  email: 'santa@northpole.com',
  nickname: 'Santa Claus',
  photoUrl: null,
  groups: ['group_1', 'group_2', 'group_3'],
  wishlist: ['Wool socks', 'Coffee mug', 'Book'],
);

final _fakeGroups = [
  GroupEntity(
    id: 'group_1',
    title: 'Family Christmas 2026 🎄',
    description: 'Annual secret santa exchange for family',
    authorUID: 'user_santa_1',
    participants: const {
      'user_santa_1': UserStatus.creator,
      'user_anna': UserStatus.confirmed,
      'user_piotr': UserStatus.confirmed,
    },
    participantsUIDs: const ['user_santa_1', 'user_anna', 'user_piotr'],
    budgetLimit: 150,
    currency: 'PLN',
    eventDate: DateTime(2026, 12, 24),
    createdAt: DateTime(2026, 11, 1),
    inviteCode: 'FAM2026',
    state: GroupStatus.recruiting,
  ),
  GroupEntity(
    id: 'group_2',
    title: 'Workplace Team 🎅',
    description: 'Office gift exchange',
    authorUID: 'user_boss',
    participants: const {
      'user_boss': UserStatus.creator,
      'user_santa_1': UserStatus.confirmed,
      'user_julia': UserStatus.confirmed,
    },
    participantsUIDs: const ['user_boss', 'user_santa_1', 'user_julia'],
    budgetLimit: 100,
    currency: 'PLN',
    eventDate: DateTime(2026, 12, 20),
    createdAt: DateTime(2026, 11, 10),
    inviteCode: 'WORK26',
    state: GroupStatus.drawn,
    matches: const {
      'user_santa_1': 'user_julia',
      'user_julia': 'user_boss',
      'user_boss': 'user_santa_1',
    },
  ),
  GroupEntity(
    id: 'group_3',
    title: 'Friends Board Games Night 🎁',
    description: 'Small gifts for game night',
    authorUID: 'user_santa_1',
    participants: const {
      'user_santa_1': UserStatus.creator,
      'user_piotr': UserStatus.confirmed,
    },
    participantsUIDs: const ['user_santa_1', 'user_piotr'],
    budgetLimit: 50,
    currency: 'PLN',
    eventDate: DateTime(2026, 12, 15),
    createdAt: DateTime(2026, 10, 25),
    inviteCode: 'GAME26',
    state: GroupStatus.finished,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Fake Repos & Blocs
// ─────────────────────────────────────────────────────────────────────────────

class _FakeAuthRepository implements AuthRepository {
  final UserEntity user;
  _FakeAuthRepository({this.user = _currentUser});

  @override
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password}) async =>
      Right(user);
  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);
  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async => Right(user);
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String nickname,
    required String email,
    required String password,
  }) async => Right(user);
  @override
  Stream<UserEntity?> get getCurrentUserStream => Stream.value(user);
  @override
  Future<Either<Failure, UserEntity>> getUserByEmail({required String email}) =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, UserEntity>> getUserByUid({required String uid}) =>
      throw UnimplementedError();
}

AuthBloc _buildFakeAuthBloc({UserEntity user = _currentUser}) {
  final repo = _FakeAuthRepository(user: user);
  return AuthBloc(
    loginUser: LoginUser(repo),
    registerUser: RegisterUser(repo),
    signOutUser: SignOutUser(repo),
    getCurrentUser: GetCurrentUser(repo),
  )..emit(AuthState(status: AuthStatus.authenticated, user: user));
}

class _FakeHomeBloc extends Bloc<HomeEvent, HomeState> implements HomeBloc {
  _FakeHomeBloc(HomeState initialState) : super(initialState) {
    on<HomeGetUserGroupsEvent>((event, emit) {
      emit(state);
    });
  }
}

Widget _wrapHomePage({
  required UserEntity user,
  required HomeState homeState,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc(user: user)),
      BlocProvider<HomeBloc>(create: (_) => _FakeHomeBloc(homeState)),
    ],
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// WidgetbookComponent – HomePage
// ─────────────────────────────────────────────────────────────────────────────

final homePageComponent = WidgetbookComponent(
  name: 'HomePage',
  useCases: [
    // ① Loaded – Multiple Groups
    WidgetbookUseCase(
      name: '① Loaded – Multiple Groups',
      builder: (context) {
        final nickname = context.knobs.string(
          label: 'User Nickname',
          initialValue: 'Santa Claus',
        );
        final user = UserEntity(
          uid: _currentUser.uid,
          email: _currentUser.email,
          nickname: nickname,
          photoUrl: _currentUser.photoUrl,
          groups: _currentUser.groups,
          wishlist: _currentUser.wishlist,
        );
        return _wrapHomePage(
          user: user,
          homeState: HomeState(
            status: HomeStatus.loaded,
            groups: _fakeGroups,
          ),
        );
      },
    ),

    // ② Loaded – Single Group
    WidgetbookUseCase(
      name: '② Loaded – Single Group',
      builder: (context) {
        return _wrapHomePage(
          user: _currentUser,
          homeState: HomeState(
            status: HomeStatus.loaded,
            groups: [_fakeGroups.first],
          ),
        );
      },
    ),

    // ③ Loaded – Empty Groups List
    WidgetbookUseCase(
      name: '③ Loaded – Empty Groups List',
      builder: (context) {
        return _wrapHomePage(
          user: _currentUser,
          homeState: const HomeState(
            status: HomeStatus.loaded,
            groups: [],
          ),
        );
      },
    ),

    // ④ Loading State
    WidgetbookUseCase(
      name: '④ Loading State',
      builder: (context) {
        return _wrapHomePage(
          user: _currentUser,
          homeState: const HomeState(
            status: HomeStatus.loading,
            groups: [],
          ),
        );
      },
    ),

    // ⑤ Error State
    WidgetbookUseCase(
      name: '⑤ Error State',
      builder: (context) {
        final errorMsg = context.knobs.string(
          label: 'Error Message',
          initialValue: 'Failed to load groups. Please check your network connection.',
        );
        return _wrapHomePage(
          user: _currentUser,
          homeState: HomeState(
            status: HomeStatus.error,
            errorMessage: errorMsg,
          ),
        );
      },
    ),
  ],
);
