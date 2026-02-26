import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/home/presentation/widgets/add_group_placeholder.dart';

final addGroupPlaceholderComponent = WidgetbookComponent(
  name: 'AddGroupPlaceholder',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: AddGroupPlaceholder(),
        ),
      ),
    ),
  ],
);
