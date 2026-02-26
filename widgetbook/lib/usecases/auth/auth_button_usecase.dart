import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';

final authButtonComponent = WidgetbookComponent(
  name: 'AuthButton',
  useCases: [
    WidgetbookUseCase(
      name: 'Login',
      builder: (context) => Scaffold(
        body: Center(
          child: AuthButton(
            onPressed: () {},
            buttonText: 'Login',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Register',
      builder: (context) => Scaffold(
        body: Center(
          child: AuthButton(
            onPressed: () {},
            buttonText: 'Sign Up',
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Loading State',
      builder: (context) => Scaffold(
        body: Center(
          child: AuthButton(
            onPressed: () {},
            buttonText: 'Processing...',
          ),
        ),
      ),
    ),
  ],
);
