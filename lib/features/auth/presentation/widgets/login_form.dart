import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/utils/validators.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_form_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AuthFormField(
            labelText: context.loc.emailLabel,
            hintText: "santa@northpole.com",
            controller: widget.emailController,
            isEmailField: true,
            prefixIcon: const Icon(Icons.email),
            validator:
                (value) => Validators.validateEmail(
                  value,
                  emptyMessage: context.loc.emailRequired,
                  invalidMessage: context.loc.emailInvalid,
                ),
          ),
          AuthFormField(
            controller: widget.passwordController,
            isPasswordField: true,
            prefixIcon: const Icon(Icons.lock),
            labelText: context.loc.passwordLabel,
            hintText: "********",
            validator:
                (value) => Validators.validatePassword(
                  value,
                  emptyMessage: context.loc.passwordRequired,
                  tooShortMessage: context.loc.passwordTooShort,
                ),
          ),
        ],
      ),
    );
  }
}
