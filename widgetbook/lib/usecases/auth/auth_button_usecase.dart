import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';
import 'package:widgetbook/widgetbook.dart';

final authButtonComponent = WidgetbookComponent(
  name: 'AuthButton',
  useCases: [
    WidgetbookUseCase(
      name: '① Login Button',
      builder: (context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AuthButton(
              onPressed: () {},
              buttonText: 'Login',
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: '② Register Button',
      builder: (context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: AuthButton(
              onPressed: () {},
              buttonText: 'Sign Up',
            ),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: '③ Custom Interactive Knob',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Button Text',
          initialValue: 'Continue',
        );
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AuthButton(
                onPressed: () {},
                buttonText: label,
              ),
            ),
          ),
        );
      },
    ),
  ],
);
