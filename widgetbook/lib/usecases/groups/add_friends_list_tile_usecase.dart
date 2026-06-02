import 'package:flutter/material.dart';
import 'package:secret_santa/features/groups/presentation/widgets/add_friends_list_tile.dart';
import 'package:widgetbook/widgetbook.dart';

final addFriendsListTileComponent = WidgetbookComponent(
  name: 'AddFriendsListTile',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AddFriendsListTile(
                title: context.knobs.string(
                  label: 'Title',
                  initialValue: 'Add Friends Manually',
                ),
                subtitle: context.knobs.string(
                  label: 'Subtitle',
                  initialValue: 'Input email, copy link or invite code',
                ),
                icon: Icons.person_add_alt_1_rounded,
                iconColor: Theme.of(context).colorScheme.primary,
                onTap: () {},
              ),
            ),
          ),
        );
      },
    ),
  ],
);
