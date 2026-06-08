import 'package:flutter/material.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/widgets/participant_tile.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Shared mock data ───────────────────────────────────────────────────────────

final _mockGroup = GroupEntity(
  id: 'group_123',
  title: 'Design Team Santa 🎅',
  authorUID: 'admin_uid',
  participants: const {
    'admin_uid': UserStatus.creator,
    'user_anna': UserStatus.confirmed,
    'user_piotr': UserStatus.invited,
  },
  participantsUIDs: const ['admin_uid', 'user_anna', 'user_piotr'],
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
];

// ── Use-cases ──────────────────────────────────────────────────────────────────

final participantTileComponent = WidgetbookComponent(
  name: 'ParticipantTile',
  useCases: [
    // 1. Interactive knobs
    WidgetbookUseCase(
      name: 'Interactive (Knobs)',
      builder: (context) {
        final status = context.knobs.list<UserStatus>(
          label: 'Status',
          options: UserStatus.values,
          labelBuilder: (s) => s.name,
          initialOption: UserStatus.confirmed,
        );
        final isAuthor = context.knobs.boolean(
          label: 'Is Author / Creator',
          initialValue: false,
        );
        final isExpanded = context.knobs.boolean(
          label: 'Expanded (settings visible)',
          initialValue: false,
        );

        const participant = UserEntity(
          uid: 'user_anna',
          email: 'anna@example.com',
          nickname: 'Anna Kowalska',
          avatarBgColorValue: 0xFF2E7D32,
          avatarForegroundColorValue: 0xFFFFFFFF,
        );

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ParticipantTile(
              uid: participant.uid,
              status: status,
              isAuthor: isAuthor,
              group: _mockGroup,
              animation: AlwaysStoppedAnimation(isExpanded ? 1.0 : 0.08),
              isExpanded: isExpanded,
              onTap: () {},
              users: _allUsers,
              participant: participant,
            ),
          ),
        );
      },
    ),

    // 2. Creator tile
    WidgetbookUseCase(
      name: 'Creator (Admin)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ParticipantTile(
            uid: 'admin_uid',
            status: UserStatus.creator,
            isAuthor: true,
            group: _mockGroup,
            animation: const AlwaysStoppedAnimation(0.08),
            isExpanded: false,
            onTap: () {},
            users: _allUsers,
            participant: const UserEntity(
              uid: 'admin_uid',
              email: 'admin@example.com',
              nickname: 'Mikołaj Admin',
              avatarBgColorValue: 0xFFD32F2F,
              avatarForegroundColorValue: 0xFFFFFFFF,
            ),
          ),
        ),
      ),
    ),

    // 3. Confirmed member expanded
    WidgetbookUseCase(
      name: 'Confirmed member (expanded)',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ParticipantTile(
            uid: 'user_anna',
            status: UserStatus.confirmed,
            isAuthor: false,
            group: _mockGroup,
            animation: const AlwaysStoppedAnimation(1.0),
            isExpanded: true,
            onTap: () {},
            users: _allUsers,
            participant: const UserEntity(
              uid: 'user_anna',
              email: 'anna@example.com',
              nickname: 'Anna Kowalska',
              avatarBgColorValue: 0xFF2E7D32,
            ),
          ),
        ),
      ),
    ),

    // 4. Pending / declined states
    WidgetbookUseCase(
      name: 'Pending member',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ParticipantTile(
            uid: 'user_piotr',
            status: UserStatus.pending,
            isAuthor: false,
            group: _mockGroup,
            animation: const AlwaysStoppedAnimation(0.08),
            isExpanded: false,
            onTap: () {},
            users: _allUsers,
            participant: const UserEntity(
              uid: 'user_piotr',
              email: 'piotr@example.com',
              nickname: 'Piotr Nowak',
              avatarBgColorValue: 0xFF1565C0,
            ),
          ),
        ),
      ),
    ),

    WidgetbookUseCase(
      name: 'Declined member',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ParticipantTile(
            uid: 'user_kasia',
            status: UserStatus.declined,
            isAuthor: false,
            group: _mockGroup,
            animation: const AlwaysStoppedAnimation(0.08),
            isExpanded: false,
            onTap: () {},
            users: _allUsers,
            participant: const UserEntity(
              uid: 'user_kasia',
              email: 'kasia@example.com',
              nickname: 'Kasia Wójcik',
              avatarBgColorValue: 0xFF6A1B9A,
            ),
          ),
        ),
      ),
    ),

    // 5. Full list of all statuses
    WidgetbookUseCase(
      name: 'All statuses (list)',
      builder: (context) => Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final entry in [
              (UserStatus.creator, 'Admin (Creator)', 'admin_uid', 0xFFD32F2F, true),
              (UserStatus.confirmed, 'Anna Kowalska', 'user_anna', 0xFF2E7D32, false),
              (UserStatus.invited, 'Piotr Nowak', 'user_piotr', 0xFF1565C0, false),
              (UserStatus.pending, 'Julia Wiśniewska', 'user_julia', 0xFF6A1B9A, false),
              (UserStatus.declined, 'Marek Lis', 'user_marek', 0xFF00838F, false),
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ParticipantTile(
                  uid: entry.$3,
                  status: entry.$1,
                  isAuthor: entry.$5,
                  group: _mockGroup,
                  animation: const AlwaysStoppedAnimation(0.08),
                  isExpanded: false,
                  onTap: () {},
                  users: _allUsers,
                  participant: UserEntity(
                    uid: entry.$3,
                    email: '${entry.$3}@example.com',
                    nickname: entry.$2,
                    avatarBgColorValue: entry.$4,
                    avatarForegroundColorValue: 0xFFFFFFFF,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  ],
);
