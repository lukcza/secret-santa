import 'package:flutter/material.dart';
import 'package:secret_santa/core/enums/group_status.dart';
import 'package:secret_santa/core/enums/user_status.dart';
import 'package:secret_santa/features/groups/domain/entities/group_entity.dart';
import 'package:secret_santa/features/groups/presentation/pages/details/details_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

final detailsGroupPageComponent = WidgetbookComponent(
  name: 'DetailsGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return DetailsGroupPage(
          group: GroupEntity(
            id: 'group_123',
            title: context.knobs.string(
              label: 'Group Title',
              initialValue: 'Design Team Santa',
            ),
            authorUID: 'admin_uid',
            participants: const {
              'admin_uid': UserStatus.creator,
              'jane_uid': UserStatus.confirmed,
              'robert_uid': UserStatus.pending,
            },
            participantsUIDs: const ['admin_uid', 'jane_uid', 'robert_uid'],
            budgetLimit: context.knobs.double
                .input(
                  label: 'Budget Limit',
                  initialValue: 50.0,
                )
                .toInt(),
            currency: context.knobs.string(
              label: 'Currency',
              initialValue: 'PLN',
            ),
            eventDate: DateTime(DateTime.now().year, 12, 20),
            createdAt: DateTime.now(),
            inviteCode: 'XMAS2026',
            state: GroupStatus.draft,
          ),
        );
      },
    ),
  ],
);
