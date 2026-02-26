import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_divider.dart';

final loginDividerComponent = WidgetbookComponent(
  name: 'LoginDivider',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => const Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: LoginDivider(),
          ),
        ),
      ),
    ),
  ],
);
