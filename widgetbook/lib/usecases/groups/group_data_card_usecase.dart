import 'package:flutter/material.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_data_card.dart';
import 'package:widgetbook/widgetbook.dart';

final groupDataCardComponent = WidgetbookComponent(
  name: 'GroupDataCard',
  useCases: [
    WidgetbookUseCase(
      name: 'Interactive (Knobs)',
      builder: (context) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GroupDataCard(
                groupName: context.knobs.string(
                  label: 'Group Name',
                  initialValue: 'North Pole Party',
                ),
                budget: context.knobs.int.slider(
                  label: 'Budget',
                  initialValue: 25,
                  min: 0,
                  max: 500,
                ),
                date: context.knobs.dateTime(
                  label: 'Date',
                  initialValue: DateTime(DateTime.now().year, 12, 24),
                  start: DateTime(DateTime.now().year - 1),
                  end: DateTime(DateTime.now().year + 5),
                ),
                membersCount: context.knobs.int.slider(
                  label: 'Members Count',
                  initialValue: 5,
                  min: 1,
                  max: 50,
                ),
                currencySign: context.knobs.string(
                  label: 'Currency Sign',
                  initialValue: '\$',
                ),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'Design Spec (North Pole Party)',
      builder: (context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GroupDataCard(
              groupName: 'North Pole Party',
              budget: 25,
              date: DateTime(DateTime.now().year, 12, 24),
              membersCount: 5,
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Single Member (1 Elf)',
      builder: (context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GroupDataCard(
              groupName: 'Secret Santa Team',
              budget: 50,
              date: DateTime(DateTime.now().year, 12, 25),
              membersCount: 1,
            ),
          ),
        ),
      ),
    ),
  ],
);
