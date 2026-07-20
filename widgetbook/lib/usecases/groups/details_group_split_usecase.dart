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
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_admin.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_user.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/reveal_recipient_page.dart';
import 'package:widgetbook/widgetbook.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fake data
// ─────────────────────────────────────────────────────────────────────────────

const _adminUser = UserEntity(
  uid: 'admin_uid',
  email: 'admin@example.com',
  nickname: 'Mikołaj Admin',
  avatarBgColorValue: 0xFFB71C1C,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _annaUser = UserEntity(
  uid: 'user_anna',
  email: 'anna@example.com',
  nickname: 'Anna Kowalska',
  avatarBgColorValue: 0xFF1565C0,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _piotrUser = UserEntity(
  uid: 'user_piotr',
  email: 'piotr@example.com',
  nickname: 'Piotr Nowak',
  avatarBgColorValue: 0xFF2E7D32,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _juliaUser = UserEntity(
  uid: 'user_julia',
  email: 'julia@example.com',
  nickname: 'Julia Wiśniewska',
  avatarBgColorValue: 0xFF6A1B9A,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

final _fakeParticipants = [_adminUser, _annaUser, _piotrUser, _juliaUser];

/// Pary po losowaniu: admin → anna, anna → piotr, piotr → julia, julia → admin
final _fakeMatches = {
  'admin_uid': 'user_anna',
  'user_anna': 'user_piotr',
  'user_piotr': 'user_julia',
  'user_julia': 'admin_uid',
};

GroupEntity _recruitingGroup({String title = 'Design Team Santa 🎅', int budget = 100}) =>
    GroupEntity(
      id: 'group_123',
      title: title,
      authorUID: 'admin_uid',
      participants: const {
        'admin_uid': UserStatus.creator,
        'user_anna': UserStatus.confirmed,
        'user_piotr': UserStatus.invited,
        'user_julia': UserStatus.pending,
      },
      participantsUIDs: const ['admin_uid', 'user_anna', 'user_piotr', 'user_julia'],
      budgetLimit: budget,
      currency: 'PLN',
      eventDate: DateTime(2026, 12, 24),
      createdAt: DateTime.now(),
      inviteCode: 'XMAS26',
      state: GroupStatus.draft,
    );

GroupEntity _drawnGroup({String title = 'Design Team Santa 🎅', int budget = 100}) =>
    GroupEntity(
      id: 'group_123',
      title: title,
      authorUID: 'admin_uid',
      participants: const {
        'admin_uid': UserStatus.creator,
        'user_anna': UserStatus.confirmed,
        'user_piotr': UserStatus.confirmed,
        'user_julia': UserStatus.confirmed,
      },
      participantsUIDs: const ['admin_uid', 'user_anna', 'user_piotr', 'user_julia'],
      budgetLimit: budget,
      currency: 'PLN',
      eventDate: DateTime(2026, 12, 24),
      createdAt: DateTime.now(),
      inviteCode: 'XMAS26',
      state: GroupStatus.drawn,
      matches: {
        'admin_uid': 'user_anna',
        'user_anna': 'user_piotr',
        'user_piotr': 'user_julia',
        'user_julia': 'admin_uid',
      },
    );

// ─────────────────────────────────────────────────────────────────────────────
// Fake repos & blocs
// ─────────────────────────────────────────────────────────────────────────────

class _FakeAuthRepository implements AuthRepository {
  final String currentUid;
  _FakeAuthRepository({this.currentUid = 'admin_uid'});

  UserEntity get _user => UserEntity(
    uid: currentUid,
    email: '$currentUid@example.com',
    nickname: currentUid == 'admin_uid' ? 'Mikołaj Admin' : 'Anna Kowalska',
  );

  @override
  Future<Either<Failure, UserEntity>> signIn({required String email, required String password}) async =>
      Right(_user);
  @override
  Future<Either<Failure, void>> signOut() async => const Right(null);
  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async => Right(_user);
  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String nickname,
    required String email,
    required String password,
  }) async => Right(_user);
  @override
  Stream<UserEntity?> get getCurrentUserStream => Stream.value(_user);
  @override
  Future<Either<Failure, UserEntity>> getUserByEmail({required String email}) =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, UserEntity>> getUserByUid({required String uid}) =>
      throw UnimplementedError();
}

AuthBloc _buildFakeAuthBloc({String uid = 'admin_uid'}) {
  final repo = _FakeAuthRepository(currentUid: uid);
  final user = UserEntity(
    uid: uid,
    email: '$uid@example.com',
    nickname: uid == 'admin_uid' ? 'Mikołaj Admin' : 'Anna Kowalska',
  );
  return AuthBloc(
    loginUser: LoginUser(repo),
    registerUser: RegisterUser(repo),
    signOutUser: SignOutUser(repo),
    getCurrentUser: GetCurrentUser(repo),
  )..emit(AuthState(status: AuthStatus.authenticated, user: user));
}

class _FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  _FakeGroupBloc(GroupEntity group, [List<UserEntity>? participants])
    : super(
        GroupState(
          status: group.matches.isNotEmpty ? GroupStatus.drawn : GroupStatus.draft,
          group: group,
          inviteCode: group.inviteCode,
          participants: participants ?? _fakeParticipants,
          matches: group.matches,
        ),
      ) {
    on<GetGroupParticipantsEvent>((event, emit) {
      // Already in initialState – emit to trigger listener
      emit(state.copyWith(participants: state.participants));
    });
    on<GenerateInviteCodeEvent>((event, emit) {
      emit(state.copyWith(inviteCode: 'FAKE42'));
    });
    on<UpdateGroupEvent>((event, emit) {
      emit(state.copyWith(group: event.group));
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper builder
// ─────────────────────────────────────────────────────────────────────────────

Widget _wrapPage(Widget page, {required String authUid, required GroupEntity group}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc(uid: authUid)),
      BlocProvider<GroupBloc>(create: (_) => _FakeGroupBloc(group)),
    ],
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => page),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// WidgetbookComponent – DetailsGroupAdmin
// ─────────────────────────────────────────────────────────────────────────────

final detailsGroupAdminComponent = WidgetbookComponent(
  name: 'DetailsGroupAdmin',
  useCases: [
    // ① Recruiting – admin widzi InviteCard + lista uczestników + "Start Drawing"
    WidgetbookUseCase(
      name: '① Admin – Recruiting (before draw)',
      builder: (context) {
        final group = _recruitingGroup(
          title: context.knobs.string(
            label: 'Group Title',
            initialValue: 'Design Team Santa 🎅',
          ),
          budget: context.knobs.int.input(label: 'Budget (PLN)', initialValue: 100),
        );
        return _wrapPage(
          DetailsGroupAdmin(group: group),
          authUid: 'admin_uid',
          group: group,
        );
      },
    ),

    // ② Drawn – admin widzi listę wylosowanych par (MatchTile, read-only)
    WidgetbookUseCase(
      name: '② Admin – Drawn (pairs revealed)',
      builder: (context) {
        final group = _drawnGroup(
          title: context.knobs.string(
            label: 'Group Title',
            initialValue: 'Design Team Santa 🎅',
          ),
          budget: context.knobs.int.input(label: 'Budget (PLN)', initialValue: 100),
        );
        return _wrapPage(
          DetailsGroupAdmin(group: group),
          authUid: 'admin_uid',
          group: group,
        );
      },
    ),

    // ③ Admin – pusta lista uczestników
    WidgetbookUseCase(
      name: '③ Admin – Empty group (no participants)',
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
            BlocProvider<GroupBloc>(
              create: (_) => _FakeGroupBloc(emptyGroup, const []),
            ),
          ],
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => DetailsGroupAdmin(group: emptyGroup),
            ),
          ),
        );
      },
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// WidgetbookComponent – DetailsGroupUser
// ─────────────────────────────────────────────────────────────────────────────

final detailsGroupUserComponent = WidgetbookComponent(
  name: 'DetailsGroupUser',
  useCases: [
    // ① Waiting room – uczestnik czeka na losowanie
    WidgetbookUseCase(
      name: '① User – Waiting Room (no matches yet)',
      builder: (context) {
        final group = _recruitingGroup(
          title: context.knobs.string(
            label: 'Group Title',
            initialValue: 'Design Team Santa 🎅',
          ),
          budget: context.knobs.int.input(label: 'Budget (PLN)', initialValue: 100),
        );
        return _wrapPage(
          DetailsGroupUser(group: group, currentUid: 'user_anna'),
          authUid: 'user_anna',
          group: group,
        );
      },
    ),

    // ② Po losowaniu – uczestnik widzi wylosowaną osobę
    WidgetbookUseCase(
      name: '② User – Match Revealed (recipient card)',
      builder: (context) {
        final group = _drawnGroup(
          title: context.knobs.string(
            label: 'Group Title',
            initialValue: 'Design Team Santa 🎅',
          ),
          budget: context.knobs.int.input(label: 'Budget (PLN)', initialValue: 100),
        );
        // user_anna → piotr (zgodnie z _fakeMatches)
        return _wrapPage(
          DetailsGroupUser(group: group, currentUid: 'user_anna'),
          authUid: 'user_anna',
          group: group,
        );
      },
    ),

    // ③ Po losowaniu – widok julia (jej odbiorcą jest admin)
    WidgetbookUseCase(
      name: '③ User – Match Revealed (julia → admin)',
      builder: (context) {
        final group = _drawnGroup();
        return _wrapPage(
          DetailsGroupUser(group: group, currentUid: 'user_julia'),
          authUid: 'user_julia',
          group: group,
        );
      },
    ),

    // ④ Użytkownik nie ma przypisanego matcha (edge case)
    WidgetbookUseCase(
      name: '④ User – No match assigned (edge case)',
      builder: (context) {
        // Drawn group ale currentUid nie jest w matches
        final groupWithoutUser = GroupEntity(
          id: 'group_edge',
          title: 'Edge Case Group',
          authorUID: 'admin_uid',
          participants: const {
            'admin_uid': UserStatus.creator,
            'user_anna': UserStatus.confirmed,
          },
          participantsUIDs: const ['admin_uid', 'user_anna'],
          budgetLimit: 80,
          currency: 'USD',
          eventDate: DateTime(2026, 12, 31),
          createdAt: DateTime.now(),
          inviteCode: 'EDGE01',
          state: GroupStatus.drawn,
          matches: {'admin_uid': 'user_anna', 'user_anna': 'admin_uid'},
        );
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => _buildFakeAuthBloc(uid: 'user_piotr'),
            ),
            BlocProvider<GroupBloc>(
              create: (_) => _FakeGroupBloc(groupWithoutUser, [_adminUser, _annaUser]),
            ),
          ],
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => DetailsGroupUser(
                group: groupWithoutUser,
                currentUid: 'user_piotr',
              ),
            ),
          ),
        );
      },
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// WidgetbookComponent – RevealRecipientPage
// ─────────────────────────────────────────────────────────────────────────────

final revealRecipientComponent = WidgetbookComponent(
  name: 'RevealRecipientPage',
  useCases: [
    WidgetbookUseCase(
      name: '① Default (Ho Ho Ho!)',
      builder: (context) {
        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const RevealRecipientPage(
              recipient: _annaUser,
              groupId: 'group_123',
            ),
          ),
        );
      },
    ),
  ],
);
