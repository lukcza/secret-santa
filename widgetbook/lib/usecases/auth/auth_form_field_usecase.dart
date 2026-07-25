import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_form_field.dart';
import 'package:widgetbook/widgetbook.dart';

final authFormFieldComponent = WidgetbookComponent(
  name: 'AuthFormField',
  useCases: [
    WidgetbookUseCase(
      name: '① Email Field',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthFormField(
            controller: TextEditingController(),
            labelText: 'Email Address',
            hintText: 'santa@northpole.com',
            isEmailField: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: '② Password Field',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthFormField(
            controller: TextEditingController(),
            labelText: 'Password',
            hintText: '********',
            isPasswordField: true,
            prefixIcon: const Icon(Icons.lock),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: '③ Repeat Password Field',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthFormField(
            controller: TextEditingController(),
            labelText: 'Confirm Password',
            hintText: '********',
            isRepeatPasswordField: true,
            prefixIcon: const Icon(Icons.safety_check),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: '④ Interactive Knobs',
      builder: (context) {
        final label = context.knobs.string(
          label: 'Label',
          initialValue: 'Nickname',
        );
        final hint = context.knobs.string(
          label: 'Hint',
          initialValue: 'Enter nickname',
        );

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: AuthFormField(
              controller: TextEditingController(),
              labelText: label,
              hintText: hint,
              prefixIcon: const Icon(Icons.person),
            ),
          ),
        );
      },
    ),
  ],
);
