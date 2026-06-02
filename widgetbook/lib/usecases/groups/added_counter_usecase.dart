import 'package:flutter/material.dart';
import 'package:secret_santa/features/groups/presentation/widgets/added_counter.dart';
import 'package:widgetbook/widgetbook.dart';

final addedCounterComponent = WidgetbookComponent(
  name: 'AddedCounter',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        return Scaffold(
          body: Center(
            child: AddedCounter(
              addedFriends: context.knobs.int.slider(
                label: 'Added Friends',
                initialValue: 3,
                min: 0,
                max: 50,
              ),
            ),
          ),
        );
      },
    ),
  ],
);
