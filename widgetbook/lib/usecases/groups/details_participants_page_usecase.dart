import 'package:flutter/material.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/auth/domain/entities/user_entity.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_paticipants_page.dart';
import 'package:widgetbook/widgetbook.dart';

// ── Mock data ──────────────────────────────────────────────────────────────────

final _adminUser = const UserEntity(
  uid: 'admin_uid',
  email: 'admin@example.com',
  nickname: 'Mikołaj Admin',
  avatarBgColorValue: 0xFFD32F2F,
  avatarForegroundColorValue: 0xFFFFFFFF,
);

final _participants = [
  _adminUser,
  const UserEntity(
    uid: 'user_anna',
    email: 'anna@example.com',
    nickname: 'Anna Kowalska',
    avatarBgColorValue: 0xFF2E7D32,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  const UserEntity(
    uid: 'user_piotr',
    email: 'piotr@example.com',
    nickname: 'Piotr Nowak',
    avatarBgColorValue: 0xFF1565C0,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  const UserEntity(
    uid: 'user_julia',
    email: 'julia@example.com',
    nickname: 'Julia Wiśniewska',
    avatarBgColorValue: 0xFF6A1B9A,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
  const UserEntity(
    uid: 'user_marek',
    email: 'marek@example.com',
    avatarBgColorValue: 0xFF00838F,
    avatarForegroundColorValue: 0xFFFFFFFF,
  ),
];

final _mockGroup = GroupEntity(
  id: 'group_123',
  title: 'Design Team Santa 🎅',
  authorUID: 'admin_uid',
  participants: {
    'admin_uid': UserStatus.creator,
    'user_anna': UserStatus.confirmed,
    'user_piotr': UserStatus.invited,
    'user_julia': UserStatus.pending,
    'user_marek': UserStatus.confirmed,
  },
  participantsUIDs: _participants.map((u) => u.uid).toList(),
  budgetLimit: 100,
  currency: 'PLN',
  eventDate: DateTime(2026, 12, 24),
  createdAt: DateTime.now(),
  inviteCode: 'XMAS26',
  state: GroupStatus.draft,
);

// ── Use-cases ──────────────────────────────────────────────────────────────────

final detailsParticipantsPageComponent = WidgetbookComponent(
  name: 'DetailsParticipantsPage',
  useCases: [
    // 1. Regular member
    WidgetbookUseCase(
      name: 'Regular member',
      builder: (context) {
        final memberIndex = context.knobs.list<int>(
          label: 'Participant',
          options: [1, 2, 3, 4],
          labelBuilder: (i) => _participants[i].displayName,
          initialOption: 1,
        );

        return DetailsParticipantsPage(
          participant: _participants[memberIndex],
          users: _participants,
          group: _mockGroup,
          onSave: (excluded) => debugPrint('Saved exclusions: $excluded'),
          onRemove: () => debugPrint('Remove participant triggered'),
        );
      },
    ),

    // 2. Admin member (remove button disabled)
    WidgetbookUseCase(
      name: 'Admin member',
      builder: (context) {
        return DetailsParticipantsPage(
          participant: _adminUser,
          users: _participants,
          group: _mockGroup,
          onSave: (excluded) => debugPrint('Saved exclusions: $excluded'),
          onRemove: () => debugPrint('Remove triggered'),
        );
      },
    ),

    // 3. Solo participant (no others)
    WidgetbookUseCase(
      name: 'No other participants',
      builder: (context) {
        final soloGroup = GroupEntity(
          id: 'solo_group',
          title: 'Solo Group',
          authorUID: 'admin_uid',
          participants: const {'admin_uid': UserStatus.creator},
          participantsUIDs: const ['admin_uid'],
          budgetLimit: 50,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'SOLO01',
          state: GroupStatus.draft,
        );
        return DetailsParticipantsPage(
          participant: _adminUser,
          users: const [
            UserEntity(
              uid: 'admin_uid',
              email: 'admin@example.com',
              nickname: 'Mikołaj Admin',
            ),
          ],
          group: soloGroup,
          onSave: (_) {},
          onRemove: () {},
        );
      },
    ),

    // 4. All excluded
    WidgetbookUseCase(
      name: 'All participants excluded (via group excludedPairs)',
      builder: (context) {
        final groupWithExclusions = GroupEntity(
          id: 'group_123',
          title: 'Design Team Santa 🎅',
          authorUID: 'admin_uid',
          participants: {
            'admin_uid': UserStatus.creator,
            'user_anna': UserStatus.confirmed,
            'user_piotr': UserStatus.invited,
            'user_julia': UserStatus.pending,
            'user_marek': UserStatus.confirmed,
          },
          participantsUIDs: _participants.map((u) => u.uid).toList(),
          budgetLimit: 100,
          currency: 'PLN',
          eventDate: DateTime(2026, 12, 24),
          createdAt: DateTime.now(),
          inviteCode: 'XMAS26',
          state: GroupStatus.draft,
          excludedPairs: {
            'user_anna': ['admin_uid', 'user_piotr', 'user_julia', 'user_marek'],
          },
        );

        return DetailsParticipantsPage(
          participant: _participants[1], // Anna
          users: _participants,
          group: groupWithExclusions,
          onSave: (excluded) => debugPrint('Saved: $excluded'),
          onRemove: () => debugPrint('Remove'),
        );
      },
    ),
  ],
);
