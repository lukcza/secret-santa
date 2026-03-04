import 'package:flutter/material.dart';
import 'package:secret_santa/features/groups/presentation/pages/create_group_page.dart';
import 'package:widgetbook/widgetbook.dart';

final createGroupPageComponent = WidgetbookComponent(
  name: 'CreateGroupPage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => CreateGroupPage(),
    ),
  ],
);