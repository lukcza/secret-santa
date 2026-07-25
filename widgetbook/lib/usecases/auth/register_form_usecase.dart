import 'package:flutter/material.dart';
import 'package:secret_santa/features/auth/presentation/widgets/register_form.dart';
import 'package:widgetbook/widgetbook.dart';

final registerFormComponent = WidgetbookComponent(
  name: 'RegisterForm',
  useCases: [
    WidgetbookUseCase(
      name: '① Default Register Form',
      builder: (context) {
        final nameController = TextEditingController();
        final emailController = TextEditingController();
        final passwordController = TextEditingController();
        final confirmPasswordController = TextEditingController();
        final formKey = GlobalKey<FormState>();

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RegisterForm(
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              formKey: formKey,
            ),
          ),
        );
      },
    ),
  ],
);
