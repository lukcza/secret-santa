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
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_hub_page.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/my_group_wishlist_page.dart';
import 'package:secret_santa/features/wishlist/domain/entities/wishlist_item_entity.dart';
import 'package:widgetbook/widgetbook.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fake data
// ─────────────────────────────────────────────────────────────────────────────

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

const _adminUser = UserEntity(
  uid: 'admin_uid',
  email: 'admin@example.com',
  nickname: 'Mikołaj Admin',
  avatarBgColorValue: 0xFFB71C1C,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

final _fakeParticipants = [_adminUser, _annaUser, _piotrUser, _juliaUser];

GroupEntity _recruitingGroup({String title = 'Design Team Santa 🎅', int budget = 150}) =>
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

GroupEntity _drawnGroup({String title = 'Design Team Santa 🎅', int budget = 150}) =>
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

final _fakeWishlistItems = [
  const WishlistItemEntity(
    id: 'item_1',
    title: 'Ceramic Travel Mug',
    price: 89.99,
    note: 'Blue glaze preferred',
    imageUrl: null,
    isHighPriority: true,
  ),
  const WishlistItemEntity(
    id: 'item_2',
    title: 'Sci-Fi Novel Collection',
    price: 45.00,
    link: 'https://example.com/book',
    note: null,
    imageUrl: null,
    isHighPriority: false,
  ),
  const WishlistItemEntity(
    id: 'item_3',
    title: 'Wool Knitting Yarn',
    price: 29.99,
    note: 'Any shade of red',
    imageUrl: null,
    isHighPriority: false,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Fake repos & blocs
// ─────────────────────────────────────────────────────────────────────────────

class _FakeAuthRepository implements AuthRepository {
  final String currentUid;
  _FakeAuthRepository({this.currentUid = 'user_anna'});

  UserEntity get _user => UserEntity(
    uid: currentUid,
    email: '$currentUid@example.com',
    nickname: currentUid == 'user_anna' ? 'Anna Kowalska' : 'Piotr Nowak',
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

AuthBloc _buildFakeAuthBloc({String uid = 'user_anna'}) {
  final repo = _FakeAuthRepository(currentUid: uid);
  final nick = uid == 'user_anna' ? 'Anna Kowalska' : 'Piotr Nowak';
  final user = UserEntity(uid: uid, email: '$uid@example.com', nickname: nick);
  return AuthBloc(
    loginUser: LoginUser(repo),
    registerUser: RegisterUser(repo),
    signOutUser: SignOutUser(repo),
    getCurrentUser: GetCurrentUser(repo),
  )..emit(AuthState(status: AuthStatus.authenticated, user: user));
}

/// Fake BLoC z wishlistą — inicjuje stan bez Firestore
class _FakeGroupBlocWithWishlist extends Bloc<GroupEvent, GroupState>
    implements GroupBloc {
  _FakeGroupBlocWithWishlist(
    GroupEntity group, {
    List<UserEntity>? participants,
    List<WishlistItemEntity>? wishlist,
  }) : super(
         GroupState(
           status: group.matches.isNotEmpty ? GroupStatus.drawn : GroupStatus.draft,
           group: group,
           inviteCode: group.inviteCode,
           participants: participants ?? _fakeParticipants,
           matches: group.matches,
           myGroupWishlist: wishlist ?? [],
           wishlistLoading: false,
         ),
       ) {
    on<GetGroupParticipantsEvent>((event, emit) {
      emit(state.copyWith(participants: state.participants));
    });
    on<LoadGroupWishlistEvent>((event, emit) {
      // już załadowane w initialState
      emit(state.copyWith(wishlistLoading: false));
    });
    on<AddWishlistItemEvent>((event, emit) {
      final updated = List<WishlistItemEntity>.from(state.myGroupWishlist)
        ..add(event.item);
      emit(state.copyWith(myGroupWishlist: updated));
    });
    on<RemoveWishlistItemEvent>((event, emit) {
      final updated = state.myGroupWishlist
          .where((i) => i.id != event.itemId)
          .toList();
      emit(state.copyWith(myGroupWishlist: updated));
    });
    on<UpdateGroupEvent>((event, emit) {
      emit(state.copyWith(group: event.group));
    });
    on<GenerateInviteCodeEvent>((event, emit) {
      emit(state.copyWith(inviteCode: 'FAKE42'));
    });
  }
}

Widget _wrapHub(
  Widget page, {
  required String authUid,
  required GroupEntity group,
  List<WishlistItemEntity>? wishlist,
}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc(uid: authUid)),
      BlocProvider<GroupBloc>(
        create: (_) => _FakeGroupBlocWithWishlist(group, wishlist: wishlist),
      ),
    ],
    child: Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => page),
    ),
  );
}

UserEntity _getUser(String uid) {
  switch (uid) {
    case 'user_anna':
      return _annaUser;
    case 'user_piotr':
      return _piotrUser;
    case 'user_julia':
      return _juliaUser;
    default:
      return _adminUser;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WidgetbookComponent – DetailsGroupHubPage
// ─────────────────────────────────────────────────────────────────────────────

final detailsGroupHubPageComponent = WidgetbookComponent(
  name: 'DetailsGroupHubPage',
  useCases: [
    // ① Brak losowania — karta "Mój Los" zablokowana
    WidgetbookUseCase(
      name: '① User – Przed losowaniem (brak par)',
      builder: (context) {
        final title = context.knobs.string(
          label: 'Tytuł grupy',
          initialValue: 'Design Team Santa 🎅',
        );
        final budget = context.knobs.int.input(
          label: 'Budżet (PLN)',
          initialValue: 150,
        );
        final group = _recruitingGroup(title: title, budget: budget);
        return _wrapHub(
          DetailsGroupHubPage(
            group: group,
            currentUid: 'user_anna',
            currentUser: _annaUser,
          ),
          authUid: 'user_anna',
          group: group,
        );
      },
    ),

    // ② Po losowaniu — karta "Mój Los" aktywna
    WidgetbookUseCase(
      name: '② User – Po losowaniu (pary znane)',
      builder: (context) {
        final title = context.knobs.string(
          label: 'Tytuł grupy',
          initialValue: 'Design Team Santa 🎅',
        );
        final uid = context.knobs.list<String>(
          label: 'Zalogowany użytkownik',
          options: ['user_anna', 'user_piotr', 'user_julia'],
          labelBuilder: (v) => v == 'user_anna'
              ? 'Anna Kowalska'
              : v == 'user_piotr'
                  ? 'Piotr Nowak'
                  : 'Julia Wiśniewska',
        );
        final group = _drawnGroup(title: title);
        final user = _getUser(uid);
        return _wrapHub(
          DetailsGroupHubPage(
            group: group,
            currentUid: uid,
            currentUser: user,
          ),
          authUid: uid,
          group: group,
        );
      },
    ),

    // ③ Mało uczestników — 2 osoby
    WidgetbookUseCase(
      name: '③ User – Mała grupa (2 uczestników)',
      builder: (context) {
        final group = GroupEntity(
          id: 'group_small',
          title: 'Rodzina 🎄',
          authorUID: 'admin_uid',
          participants: const {
            'admin_uid': UserStatus.creator,
            'user_anna': UserStatus.confirmed,
          },
          participantsUIDs: const ['admin_uid', 'user_anna'],
          budgetLimit: 200,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'FAM26',
          state: GroupStatus.draft,
        );
        return _wrapHub(
          DetailsGroupHubPage(
            group: group,
            currentUid: 'user_anna',
            currentUser: _annaUser,
          ),
          authUid: 'user_anna',
          group: group,
        );
      },
    ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// WidgetbookComponent – MyGroupWishlistPage
// ─────────────────────────────────────────────────────────────────────────────

final myGroupWishlistPageComponent = WidgetbookComponent(
  name: 'MyGroupWishlistPage',
  useCases: [
    // ① Pusta lista życzeń
    WidgetbookUseCase(
      name: '① Lista pusta (empty state)',
      builder: (context) {
        final group = _recruitingGroup();
        return _wrapHub(
          MyGroupWishlistPage(group: group, currentUser: _annaUser),
          authUid: 'user_anna',
          group: group,
          wishlist: [],
        );
      },
    ),

    // ② Lista z życzeniami (3 produkty)
    WidgetbookUseCase(
      name: '② Lista z życzeniami (3 produkty)',
      builder: (context) {
        final currency = context.knobs.list<String>(
          label: 'Waluta',
          options: ['PLN', 'USD', 'EUR'],
        );
        final showHighPriority = context.knobs.boolean(
          label: 'Pokaż High Priority',
          initialValue: true,
        );
        final group = GroupEntity(
          id: 'group_123',
          title: 'Design Team Santa 🎅',
          authorUID: 'admin_uid',
          participants: const {'admin_uid': UserStatus.creator, 'user_anna': UserStatus.confirmed},
          participantsUIDs: const ['admin_uid', 'user_anna'],
          budgetLimit: 150,
          currency: currency,
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'XMAS26',
          state: GroupStatus.draft,
        );
        final wishlist = [
          WishlistItemEntity(
            id: 'item_1',
            title: 'Ceramic Travel Mug',
            price: 89.99,
            note: 'Blue glaze preferred',
            isHighPriority: showHighPriority,
          ),
          const WishlistItemEntity(
            id: 'item_2',
            title: 'Sci-Fi Novel Collection',
            price: 45.00,
            link: 'https://example.com/book',
            isHighPriority: false,
          ),
          const WishlistItemEntity(
            id: 'item_3',
            title: 'Wool Knitting Yarn',
            price: 29.99,
            note: 'Any shade of red',
            isHighPriority: false,
          ),
        ];
        return _wrapHub(
          MyGroupWishlistPage(group: group, currentUser: _annaUser),
          authUid: 'user_anna',
          group: group,
          wishlist: wishlist,
        );
      },
    ),

    // ③ Ładowanie (loading state)
    WidgetbookUseCase(
      name: '③ Ładowanie (loading state)',
      builder: (context) {
        final group = _recruitingGroup();
        // Tworzymy BLoC który utknął w stanie ładowania
        final fakeBloc = _FakeGroupBlocWithWishlist(group, wishlist: []);
        // Emitujemy stan z wishlistLoading: true
        fakeBloc.emit(fakeBloc.state.copyWith(wishlistLoading: true));
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (_) => _buildFakeAuthBloc()),
            BlocProvider<GroupBloc>(create: (_) => fakeBloc),
          ],
          child: Navigator(
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => MyGroupWishlistPage(group: group, currentUser: _annaUser),
            ),
          ),
        );
      },
    ),

    // ④ Długie tytuły / edge case
    WidgetbookUseCase(
      name: '④ Życzenia z długimi tytułami (edge case)',
      builder: (context) {
        final group = _recruitingGroup();
        final wishlist = [
          const WishlistItemEntity(
            id: 'item_long_1',
            title: 'Professional Grade Ceramic Pour-Over Coffee Set with Bamboo Stand',
            price: 299.99,
            note: 'The matte black version, size L, I also accept the limited winter edition 2026 if available',
            isHighPriority: true,
          ),
          const WishlistItemEntity(
            id: 'item_long_2',
            title: 'Smart Fitness Tracker Watch',
            price: null,
            link: 'https://very-long-url-example.com/product/details/page/123456789',
            note: null,
            isHighPriority: false,
          ),
        ];
        return _wrapHub(
          MyGroupWishlistPage(group: group, currentUser: _annaUser),
          authUid: 'user_anna',
          group: group,
          wishlist: wishlist,
        );
      },
    ),
  ],
);
