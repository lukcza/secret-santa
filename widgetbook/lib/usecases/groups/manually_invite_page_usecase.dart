import 'package:flutter/material.dart';
import 'package:secret_santa/features/groups/presentation/pages/manually_invite_page.dart';
import 'package:widgetbook/widgetbook.dart';

final manuallyInvitePageComponent = WidgetbookComponent(
  name: 'ManuallyInvitePage',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const ManuallyInvitePage(),
    ),
  ],
);
