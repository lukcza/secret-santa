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
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Fake data ──────────────────────────────────────────────────────────────────

const _fakeUser = UserEntity(
  uid: 'admin_uid',
  email: 'admin@example.com',
  nickname: 'Mikołaj Admin',
);

final _fakeParticipants = [
  _fakeUser,
  const UserEntity(
    uid: 'user_anna',
    email: 'anna@example.com',
    nickname: 'Anna Kowalska',
  ),
  const UserEntity(
    uid: 'user_piotr',
    email: 'piotr@example.com',
    nickname: 'Piotr Nowak',
  ),
  const UserEntity(
    uid: 'user_julia',
    email: 'julia@example.com',
    nickname: 'Julia Wiśniewska',
  ),
];

GroupEntity _mockGroup({
  String title = 'Design Team Santa 🎅',
  int budget = 100,
}) => GroupEntity(
  id: 'group_123',
  title: title,
  authorUID: 'admin_uid',
  participants: const {
    'admin_uid': UserStatus.creator,
    'user_anna': UserStatus.confirmed,
    'user_piotr': UserStatus.invited,
    'user_julia': UserStatus.pending,
  },
  participantsUIDs: const [
    'admin_uid',
    'user_anna',
    'user_piotr',
    'user_julia',
  ],
  budgetLimit: budget,
  currency: 'PLN',
  eventDate: DateTime(2026, 12, 24),
  createdAt: DateTime.now(),
  inviteCode: 'XMAS26',
  state: GroupStatus.draft,
);

// ── Fake repos/blocs ───────────────────────────────────────────────────────────

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
  Future<Either<Failure, UserEntity>> getUserByEmail({required String email}) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> getUserByUid({required String uid}) {
    // TODO: implement getUserByUid
    throw UnimplementedError();
  }
}

AuthBloc _buildFakeAuthBloc() {
  final repo = _FakeAuthRepository();
  return AuthBloc(
    loginUser: LoginUser(repo),
    registerUser: RegisterUser(repo),
    signOutUser: SignOutUser(repo),
    getCurrentUser: GetCurrentUser(repo),
  )..emit(AuthState(status: AuthStatus.authenticated, user: _fakeUser));
}

class _FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  _FakeGroupBloc(GroupEntity group, [List<UserEntity>? participants])
    : super(
        GroupState(
          status: GroupStatus.draft,
          group: group,
          participants: participants ?? _fakeParticipants,
        ),
      ) {
    on<GetGroupParticipantsEvent>((event, emit) {
      // Already pre-loaded in initial state – no-op
    });
  }
}

// ── Use-cases ──────────────────────────────────────────────────────────────────

final detailsGroupPageComponent = WidgetbookComponent(
  name: 'DetailsGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default (4 participants)',
      builder: (context) {
        final group = _mockGroup(
          title: context.knobs.string(
            label: 'Group Title',
            initialValue: 'Design Team Santa 🎅',
          ),
          budget: context.knobs.int.input(
            label: 'Budget Limit (PLN)',
            initialValue: 100,
          ),
        );
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc()),
            BlocProvider<GroupBloc>(create: (_) => _FakeGroupBloc(group)),
          ],
          child: Navigator(
            onGenerateRoute:
                (_) => MaterialPageRoute(
                  builder: (_) => DetailsGroupPage(group: group),
                ),
          ),
        );
      },
    ),

    WidgetbookUseCase(
      name: 'Empty group (no participants)',
      builder: (context) {
        final emptyGroup = GroupEntity(
          id: 'empty_group',
          title: 'Empty Group',
          authorUID: 'admin_uid',
          participants: const {},
          participantsUIDs: const [],
          budgetLimit: 50,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 25),
          createdAt: DateTime.now(),
          inviteCode: 'EMPTY1',
          state: GroupStatus.draft,
        );
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc()),
            BlocProvider<GroupBloc>(create: (_) => _FakeGroupBloc(emptyGroup)),
          ],
          child: Navigator(
            onGenerateRoute:
                (_) => MaterialPageRoute(
                  builder: (_) => DetailsGroupPage(group: emptyGroup),
                ),
          ),
        );
      },
    ),

    WidgetbookUseCase(
      name: 'Large group (many participants)',
      builder: (context) {
        final bigGroup = GroupEntity(
          id: 'big_group',
          title: 'Office Christmas Party 🎄',
          authorUID: 'admin_uid',
          participants: const {
            'admin_uid': UserStatus.creator,
            'user_anna': UserStatus.confirmed,
            'user_piotr': UserStatus.invited,
            'user_julia': UserStatus.pending,
            'user_marek': UserStatus.confirmed,
            'user_kasia': UserStatus.declined,
            'user_bartek': UserStatus.confirmed,
            'user_zofia': UserStatus.invited,
          },
          participantsUIDs: const [
            'admin_uid',
            'user_anna',
            'user_piotr',
            'user_julia',
            'user_marek',
            'user_kasia',
            'user_bartek',
            'user_zofia',
          ],
          budgetLimit: 200,
          currency: 'EUR',
          eventDate: DateTime(2026, 12, 20),
          createdAt: DateTime.now(),
          inviteCode: 'OFFICE26',
          state: GroupStatus.draft,
        );
        final extraParticipants = [
          _fakeUser,
          const UserEntity(
            uid: 'user_anna',
            email: 'anna@example.com',
            nickname: 'Anna Kowalska',
          ),
          const UserEntity(
            uid: 'user_piotr',
            email: 'piotr@example.com',
            nickname: 'Piotr Nowak',
          ),
          const UserEntity(
            uid: 'user_julia',
            email: 'julia@example.com',
            nickname: 'Julia Wiśniewska',
          ),
          const UserEntity(
            uid: 'user_marek',
            email: 'marek@example.com',
            nickname: 'Marek Lis',
          ),
          const UserEntity(
            uid: 'user_kasia',
            email: 'kasia@example.com',
            nickname: 'Kasia Wójcik',
          ),
          const UserEntity(
            uid: 'user_bartek',
            email: 'bartek@example.com',
            nickname: 'Bartek Zając',
          ),
          const UserEntity(
            uid: 'user_zofia',
            email: 'zofia@example.com',
            nickname: 'Zofia Dąbrowska',
          ),
        ];
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc()),
            BlocProvider<GroupBloc>(
              create: (_) => _FakeGroupBloc(bigGroup, extraParticipants),
            ),
          ],
          child: Navigator(
            onGenerateRoute:
                (_) => MaterialPageRoute(
                  builder: (_) => DetailsGroupPage(group: bigGroup),
                ),
          ),
        );
      },
    ),
  ],
);
