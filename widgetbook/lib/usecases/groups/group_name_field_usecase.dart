import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/groups/presentation/widgets/group_name_field.dart';

final groupNameFieldComponent = WidgetbookComponent(
  name: 'GroupNameField',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) {
        final controller = TextEditingController();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GroupNameField(
              labelText: 'Group Name',
              hintText: 'Enter group name',
              controller: controller,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'With Long Label',
      builder: (context) {
        final controller = TextEditingController();
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GroupNameField(
              labelText: 'Enter your Secret Santa Group Name',
              hintText: 'e.g. Office Team 2025',
              controller: controller,
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: 'With Pre-filled Text',
      builder: (context) {
        final controller = TextEditingController(text: 'Family Gift Exchange');
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GroupNameField(
              labelText: 'Group Name',
              hintText: 'Enter group name',
              controller: controller,
            ),
          ),
        );
      },
    ),
  ],
);
