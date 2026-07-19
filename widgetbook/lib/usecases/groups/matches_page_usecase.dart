import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_bloc.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_event.dart';
import 'package:secret_santa/features/groups/presentation/bloc/group_state.dart';
import 'package:secret_santa/features/groups/presentation/pages/matches/matches_page.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Shared mock data ───────────────────────────────────────────────────────────

const _alice = UserEntity(
  uid: 'user_alice',
  email: 'alice@example.com',
  nickname: 'Alice Kowalska',
  avatarBgColorValue: 0xFFD32F2F,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _bob = UserEntity(
  uid: 'user_bob',
  email: 'bob@example.com',
  nickname: 'Bob Nowak',
  avatarBgColorValue: 0xFF1565C0,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _carol = UserEntity(
  uid: 'user_carol',
  email: 'carol@example.com',
  nickname: 'Carol Wójcik',
  avatarBgColorValue: 0xFF2E7D32,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _dave = UserEntity(
  uid: 'user_dave',
  email: 'dave@example.com',
  nickname: 'Dave Malinowski',
  avatarBgColorValue: 0xFF6A1B9A,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _ewa = UserEntity(
  uid: 'user_ewa',
  email: 'ewa@example.com',
  nickname: 'Ewa Zielińska',
  avatarBgColorValue: 0xFF00838F,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

const _fakeParticipants = [_alice, _bob, _carol, _dave, _ewa];

GroupEntity _buildGroup({
  Map<String, String> matches = const {},
  GroupStatus state = GroupStatus.active,
  Map<String, List<String>> excludedPairs = const {},
}) =>
    GroupEntity(
      id: 'group_wb',
      title: 'Christmas Team 🎄',
      authorUID: 'user_alice',
      participants: const {
        'user_alice': UserStatus.creator,
        'user_bob': UserStatus.confirmed,
        'user_carol': UserStatus.confirmed,
        'user_dave': UserStatus.confirmed,
        'user_ewa': UserStatus.confirmed,
      },
      participantsUIDs: const [
        'user_alice',
        'user_bob',
        'user_carol',
        'user_dave',
        'user_ewa',
      ],
      budgetLimit: 150,
      currency: 'PLN',
      eventDate: DateTime(2026, 12, 24),
      createdAt: DateTime.now(),
      inviteCode: 'XMAS26',
      state: state,
      matches: matches,
      excludedPairs: excludedPairs,
    );

// ── Helpers ────────────────────────────────────────────────────────────────────

const _staticFakeMatches = {
  'user_alice': 'user_bob',
  'user_bob': 'user_carol',
  'user_carol': 'user_dave',
  'user_dave': 'user_ewa',
  'user_ewa': 'user_alice',
};

Map<String, String> _drawMatches(
  List<String> uids,
  Map<String, List<String>> excluded,
) {
  if (uids.length < 3) return {};
  for (int attempt = 0; attempt < 100; attempt++) {
    final shuffled = List<String>.from(uids)..shuffle(math.Random());
    final draft = <String, String>{};
    bool valid = true;
    for (int i = 0; i < uids.length; i++) {
      final giver = uids[i];
      final recipient = shuffled[i];
      if (giver == recipient ||
          (excluded[giver]?.contains(recipient) ?? false)) {
        valid = false;
        break;
      }
      draft[giver] = recipient;
    }
    if (valid && draft.length == uids.length) return draft;
  }
  return {}; // niemożliwe – zwróć puste (błąd)
}

// ── Fake GroupBloc – statyczne pary (UI preview) ───────────────────────────────
// Matches są w initial state – brak oczekiwania na event.

class _FakeGroupBloc extends Bloc<GroupEvent, GroupState> implements GroupBloc {
  _FakeGroupBloc({
    required GroupEntity group,
    List<UserEntity> participants = _fakeParticipants,
    Map<String, String> preloadedMatches = _staticFakeMatches,
    GroupStatus status = GroupStatus.active,
  }) : super(
          GroupState(
            status: status,
            group: group,
            participants: participants,
            matches: preloadedMatches,
          ),
        ) {
    on<DrawPairsLocalEvent>((event, emit) {
      emit(state.copyWith(matches: _staticFakeMatches));
    });

    on<ConfirmDrawEvent>((event, emit) {
      emit(state.copyWith(
        status: GroupStatus.drawn,
        group: event.group.copyWith(matches: event.matches),
        matches: event.matches,
      ));
    });

    on<GetGroupParticipantsEvent>((event, emit) {
      emit(state.copyWith(participants: participants));
    });

    on<UpdateGroupEvent>((event, emit) {
      emit(state.copyWith(group: event.group));
    });
  }
}

// ── Real-draw GroupBloc – rzeczywisty algorytm losowania (z/bez wykluczeń) ─────
// Matches są obliczane od razu w initial state – brak oczekiwania na event.

class _RealDrawGroupBloc extends Bloc<GroupEvent, GroupState>
    implements GroupBloc {
  static GroupState _buildInitialState({
    required GroupEntity group,
    required List<UserEntity> participants,
    required GroupStatus status,
  }) {
    final uids = group.participantsUIDs;
    final excluded = group.excludedPairs;
    final matches = _drawMatches(uids, excluded);
    if (matches.isEmpty && uids.length >= 3) {
      // Niemożliwe wykluczenia
      return GroupState(
        status: GroupStatus.error,
        group: group,
        participants: participants,
        errorMessage: 'Nie udało się wylosować par – spróbuj ponownie',
      );
    }
    return GroupState(
      status: status,
      group: group,
      participants: participants,
      matches: matches,
    );
  }

  _RealDrawGroupBloc({
    required GroupEntity group,
    List<UserEntity> participants = _fakeParticipants,
    GroupStatus status = GroupStatus.active,
  }) : super(
          _buildInitialState(
            group: group,
            participants: participants,
            status: status,
          ),
        ) {
    on<DrawPairsLocalEvent>((event, emit) {
      final matches = _drawMatches(
        event.participantUids,
        event.excludedPairs,
      );
      if (matches.isEmpty && event.participantUids.length >= 3) {
        emit(state.copyWith(
          status: GroupStatus.error,
          errorMessage: 'Nie udało się wylosować par – spróbuj ponownie',
        ));
        return;
      }
      if (event.participantUids.length < 3) {
        emit(state.copyWith(
          status: GroupStatus.error,
          errorMessage: 'Za mało uczestników (minimum 3)',
        ));
        return;
      }
      emit(state.copyWith(matches: matches));
    });

    on<ConfirmDrawEvent>((event, emit) {
      emit(state.copyWith(
        status: GroupStatus.drawn,
        group: event.group.copyWith(matches: event.matches),
        matches: event.matches,
      ));
    });

    on<GetGroupParticipantsEvent>((event, emit) {
      emit(state.copyWith(participants: participants));
    });

    on<UpdateGroupEvent>((event, emit) {
      emit(state.copyWith(group: event.group));
    });
  }
}

// ── Use-cases ──────────────────────────────────────────────────────────────────

final matchesPageComponent = WidgetbookComponent(
  name: 'MatchesPage',
  useCases: [
    // 1. Freshly opened – draws immediately on mount
    WidgetbookUseCase(
      name: 'Fresh draw (5 participants)',
      builder: (context) {
        final group = _buildGroup();
        final bloc = _FakeGroupBloc(group: group);
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: group,
            participants: _fakeParticipants,
          ),
        );
      },
    ),

    // 2. Pre-confirmed state (already saved to DB)
    WidgetbookUseCase(
      name: 'Already confirmed',
      builder: (context) {
        const preMatches = {
          'user_alice': 'user_bob',
          'user_bob': 'user_carol',
          'user_carol': 'user_dave',
          'user_dave': 'user_ewa',
          'user_ewa': 'user_alice',
        };
        final group = _buildGroup(
          matches: preMatches,
          state: GroupStatus.drawn,
        );
        final bloc = _FakeGroupBloc(
          group: group,
          preloadedMatches: preMatches,
          status: GroupStatus.drawn,
        );
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: group,
            participants: _fakeParticipants,
          ),
        );
      },
    ),

    // 3. Scrollable – many participants (8 pairs)
    WidgetbookUseCase(
      name: 'Many participants (8 pairs)',
      builder: (context) {
        const extraUsers = [
          UserEntity(uid: 'u1', email: 'u1@x.com', nickname: 'Zuzanna K', avatarBgColorValue: 0xFFBF360C),
          UserEntity(uid: 'u2', email: 'u2@x.com', nickname: 'Michał S', avatarBgColorValue: 0xFF283593),
          UserEntity(uid: 'u3', email: 'u3@x.com', nickname: 'Natalia P', avatarBgColorValue: 0xFF00695C),
        ];
        const allUsers = [..._fakeParticipants, ...extraUsers];

        final bigGroup = GroupEntity(
          id: 'big_group',
          title: 'Big Santa Party 🎅',
          authorUID: 'user_alice',
          participants: const {
            'user_alice': UserStatus.creator,
            'user_bob': UserStatus.confirmed,
            'user_carol': UserStatus.confirmed,
            'user_dave': UserStatus.confirmed,
            'user_ewa': UserStatus.confirmed,
            'u1': UserStatus.confirmed,
            'u2': UserStatus.confirmed,
            'u3': UserStatus.confirmed,
          },
          participantsUIDs: const [
            'user_alice', 'user_bob', 'user_carol', 'user_dave',
            'user_ewa', 'u1', 'u2', 'u3',
          ],
          budgetLimit: 200,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'BIG26',
          state: GroupStatus.active,
        );

        final bloc = _FakeGroupBloc(group: bigGroup, participants: allUsers);
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: bigGroup,
            participants: allUsers,
          ),
        );
      },
    ),

    // ── EXCLUSIONS – rzeczywiste losowanie z wykluczeniami ─────────────────────

    // 4. REAL DRAW – wykluczenia par małżeńskich (Alice↔Bob, Carol↔Dave)
    //    Każde odświeżenie strony daje inny wynik!
    WidgetbookUseCase(
      name: 'REAL: wykluczenia – małżeństwa (Alice↔Bob, Carol↔Dave)',
      builder: (context) {
        const excluded = {
          'user_alice': ['user_bob'],
          'user_bob': ['user_alice'],
          'user_carol': ['user_dave'],
          'user_dave': ['user_carol'],
        };
        final group = _buildGroup(excludedPairs: excluded);
        final bloc = _RealDrawGroupBloc(group: group);
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: group,
            participants: _fakeParticipants,
          ),
        );
      },
    ),

    // 5. REAL DRAW – wykluczenie jednostronne (Alice nie losuje Ewy)
    WidgetbookUseCase(
      name: 'REAL: wykluczenie jednostronne (Alice nie losuje Ewy)',
      builder: (context) {
        const excluded = {
          'user_alice': ['user_ewa'],
        };
        final group = _buildGroup(excludedPairs: excluded);
        final bloc = _RealDrawGroupBloc(group: group);
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: group,
            participants: _fakeParticipants,
          ),
        );
      },
    ),

    // 6. REAL DRAW – Alice wyklucza prawie wszystkich (tylko Carol możliwa)
    //    Trudny przypadek – algorytm musi trafić na Carol dla Alice.
    WidgetbookUseCase(
      name: 'REAL: skrajne wykluczenia (Alice tylko → Carol)',
      builder: (context) {
        const excluded = {
          'user_alice': ['user_bob', 'user_dave', 'user_ewa'],
        };
        final group = _buildGroup(excludedPairs: excluded);
        final bloc = _RealDrawGroupBloc(group: group);
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: group,
            participants: _fakeParticipants,
          ),
        );
      },
    ),

    // 7. REAL DRAW – niemożliwe wykluczenia → błąd algorytmu
    //    3 osoby, każda wyklucza pozostałe dwie → brak rozwiązania.
    WidgetbookUseCase(
      name: 'REAL: niemożliwe losowanie → stan błędu',
      builder: (context) {
        const threeUsers = [_alice, _bob, _carol];
        const excluded = {
          'user_alice': ['user_bob', 'user_carol'],
          'user_bob': ['user_alice', 'user_carol'],
          'user_carol': ['user_alice', 'user_bob'],
        };
        final impossibleGroup = GroupEntity(
          id: 'impossible_group',
          title: 'Impossible Draw ❌',
          authorUID: 'user_alice',
          participants: const {
            'user_alice': UserStatus.creator,
            'user_bob': UserStatus.confirmed,
            'user_carol': UserStatus.confirmed,
          },
          participantsUIDs: const ['user_alice', 'user_bob', 'user_carol'],
          budgetLimit: 50,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'IMPOS',
          state: GroupStatus.active,
          excludedPairs: excluded,
        );
        final bloc = _RealDrawGroupBloc(
          group: impossibleGroup,
          participants: threeUsers,
        );
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: impossibleGroup,
            participants: threeUsers,
          ),
        );
      },
    ),

    // 8. REAL DRAW – wykluczenia w dużej grupie (8 osób, 3 pary wykluczone)
    WidgetbookUseCase(
      name: 'REAL: wykluczenia w dużej grupie (8 os.)',
      builder: (context) {
        const extraUsers = [
          UserEntity(uid: 'u1', email: 'u1@x.com', nickname: 'Zuzanna K', avatarBgColorValue: 0xFFBF360C),
          UserEntity(uid: 'u2', email: 'u2@x.com', nickname: 'Michał S', avatarBgColorValue: 0xFF283593),
          UserEntity(uid: 'u3', email: 'u3@x.com', nickname: 'Natalia P', avatarBgColorValue: 0xFF00695C),
        ];
        const allUsers = [..._fakeParticipants, ...extraUsers];

        // 3 pary wykluczone: Alice↔Bob, Carol↔Dave, Ewa↔u1
        const excluded = {
          'user_alice': ['user_bob'],
          'user_bob': ['user_alice'],
          'user_carol': ['user_dave'],
          'user_dave': ['user_carol'],
          'user_ewa': ['u1'],
          'u1': ['user_ewa'],
        };

        final bigGroupExcluded = GroupEntity(
          id: 'big_group_excluded',
          title: 'Big Santa – z wykluczeniami 🎅',
          authorUID: 'user_alice',
          participants: const {
            'user_alice': UserStatus.creator,
            'user_bob': UserStatus.confirmed,
            'user_carol': UserStatus.confirmed,
            'user_dave': UserStatus.confirmed,
            'user_ewa': UserStatus.confirmed,
            'u1': UserStatus.confirmed,
            'u2': UserStatus.confirmed,
            'u3': UserStatus.confirmed,
          },
          participantsUIDs: const [
            'user_alice', 'user_bob', 'user_carol', 'user_dave',
            'user_ewa', 'u1', 'u2', 'u3',
          ],
          budgetLimit: 200,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'BIG26EX',
          state: GroupStatus.active,
          excludedPairs: excluded,
        );

        final bloc = _RealDrawGroupBloc(
          group: bigGroupExcluded,
          participants: allUsers,
        );
        return BlocProvider<GroupBloc>.value(
          value: bloc,
          child: MatchesPage(
            group: bigGroupExcluded,
            participants: allUsers,
          ),
        );
      },
    ),
  ],
);
