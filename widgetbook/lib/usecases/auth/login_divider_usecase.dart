import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_divider.dart';
import 'package:widgetbook/widgetbook.dart';

final loginDividerComponent = WidgetbookComponent(
  name: 'LoginDivider',
  useCases: [
    WidgetbookUseCase(
      name: '① Default Login Divider',
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
