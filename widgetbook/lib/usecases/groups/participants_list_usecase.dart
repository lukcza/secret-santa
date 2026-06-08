import 'package:flutter/material.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/widgets/participants_list.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Shared mock data ───────────────────────────────────────────────────────────

final _fullGroup = GroupEntity(
  id: 'group_123',
  title: 'Design Team Santa 🎅',
  authorUID: 'admin_uid',
  participants: const {
    'admin_uid': UserStatus.creator,
    'user_anna': UserStatus.confirmed,
    'user_piotr': UserStatus.invited,
    'user_julia': UserStatus.pending,
    'user_marek': UserStatus.confirmed,
  },
  participantsUIDs: const ['admin_uid', 'user_anna', 'user_piotr', 'user_julia', 'user_marek'],
  budgetLimit: 100,
  currency: 'PLN',
  eventDate: DateTime(2026, 12, 24),
  createdAt: DateTime.now(),
  inviteCode: 'XMAS26',
  state: GroupStatus.draft,
);

const _allUsers = [
  UserEntity(
    uid: 'admin_uid',
    email: 'admin@example.com',
    nickname: 'Mikołaj Admin',
    avatarBgColorValue: 0xFFD32F2F,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  UserEntity(
    uid: 'user_anna',
    email: 'anna@example.com',
    nickname: 'Anna Kowalska',
    avatarBgColorValue: 0xFF2E7D32,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  UserEntity(
    uid: 'user_piotr',
    email: 'piotr@example.com',
    nickname: 'Piotr Nowak',
    avatarBgColorValue: 0xFF1565C0,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  UserEntity(
    uid: 'user_julia',
    email: 'julia@example.com',
    nickname: 'Julia Wiśniewska',
    avatarBgColorValue: 0xFF6A1B9A,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  UserEntity(
    uid: 'user_marek',
    email: 'marek@example.com',
    nickname: 'Marek Lis',
    avatarBgColorValue: 0xFF00838F,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
];

// ── Use-cases ──────────────────────────────────────────────────────────────────

final participantsListComponent = WidgetbookComponent(
  name: 'ParticipantsList',
  useCases: [
    // 1. Full group with all status types
    WidgetbookUseCase(
      name: 'Full group (5 participants)',
      builder: (context) => Scaffold(
        body: ParticipantsList(
          group: _fullGroup,
          users: _allUsers,
        ),
      ),
    ),

    // 2. Empty group
    WidgetbookUseCase(
      name: 'Empty group',
      builder: (context) => Scaffold(
        body: ParticipantsList(
          group: GroupEntity(
            id: 'empty',
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
          ),
          users: const [],
        ),
      ),
    ),

    // 3. Single creator only
    WidgetbookUseCase(
      name: 'Solo (creator only)',
      builder: (context) => Scaffold(
        body: ParticipantsList(
          group: GroupEntity(
            id: 'solo',
            title: 'Solo Group',
            authorUID: 'admin_uid',
            participants: const {'admin_uid': UserStatus.creator},
            participantsUIDs: const ['admin_uid'],
            budgetLimit: 50,
            currency: 'PLN',
            eventDate: DateTime(2026, 12, 25),
            createdAt: DateTime.now(),
            inviteCode: 'SOLO1',
            state: GroupStatus.draft,
          ),
          users: const [
            UserEntity(
              uid: 'admin_uid',
              email: 'admin@example.com',
              nickname: 'Mikołaj Admin',
              avatarBgColorValue: 0xFFD32F2F,
            ),
          ],
        ),
      ),
    ),

    // 4. Users not loaded (uid fallback display)
    WidgetbookUseCase(
      name: 'Users not fetched yet (UID fallback)',
      builder: (context) => Scaffold(
        body: ParticipantsList(
          group: _fullGroup,
          users: const [], // empty → fallback to uid as display name
        ),
      ),
    ),
  ],
);
