import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_field.dart';

final authFieldComponent = WidgetbookComponent(
  name: 'AuthField',
  useCases: [
    WidgetbookUseCase(
      name: 'Email',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthField(
            controller: TextEditingController(),
            labelText: 'Email',
            hintText: 'santa@northpole.com',
            isEmailField: true,
            prefixIcon: const Icon(Icons.email),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Password',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthField(
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
      name: 'Repeat Password',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthField(
            controller: TextEditingController(),
            labelText: 'Confirm Password',
            hintText: '********',
            isReapetPasswordField: true,
            prefixIcon: const Icon(Icons.lock_outline),
          ),
        ),
      ),
    ),
    WidgetbookUseCase(
      name: 'Username',
      builder: (context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: AuthField(
            controller: TextEditingController(),
            labelText: 'Username',
            hintText: 'Enter your nickname',
            prefixIcon: const Icon(Icons.person),
          ),
        ),
      ),
    ),
  ],
);
