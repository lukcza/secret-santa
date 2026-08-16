import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_found_modal.dart';
import 'package:secret_santa/core/enums/group_status.dart';

// ── Fake data ──────────────────────────────────────────────────────────────────
final _fakeGroup = GroupEntity(
  id: 'group1',
  title: 'Santa\'s Workshop',
  description: 'Annual secret santa exchange for our team!',
  authorUID: 'admin1',
  participants: const {}, // Minimal for this view
  participantsUIDs: const ['user1', 'user2', 'user3', 'user4', 'user5'],
  budgetLimit: 150,
  currency: 'PLN',
  eventDate: DateTime(2026, 12, 24),
  createdAt: DateTime.now(),
  inviteCode: 'SANTA2026',
  state: GroupStatus.recruiting,
);

// ── Use-cases ──────────────────────────────────────────────────────────────────
final groupFoundModalComponent = WidgetbookComponent(
  name: 'GroupFoundModal',
  useCases: [
    WidgetbookUseCase(
      name: '① Default',
      builder: (context) {
        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => GroupFoundModal(
              group: _fakeGroup,
              onJoinPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Join pressed!')),
                );
              },
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '② Loading state',
      builder: (context) {
        return Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => GroupFoundModal(
              group: _fakeGroup,
              isLoading: true,
              onJoinPressed: () {},
            ),
          ),
        );
      },
    ),
  ],
);
