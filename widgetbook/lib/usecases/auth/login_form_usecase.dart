import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_form.dart';
import 'package:widgetbook/widgetbook.dart';

final loginFormComponent = WidgetbookComponent(
  name: 'LoginForm',
  useCases: [
    WidgetbookUseCase(
      name: '① Default Login Form',
      builder: (context) {
        final emailController = TextEditingController();
        final passwordController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LoginForm(
              emailController: emailController,
              passwordController: passwordController,
              formKey: formKey,
            ),
          ),
        );
      },
    ),
  ],
);
