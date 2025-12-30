import 'package:flutter/material.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/core/utils/validators.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_form_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          AuthFormField(
            controller: widget.nameController,
            labelText: context.loc.nameLabel,
            hintText: "Kris Kringle",
            prefixIcon: const Icon(Icons.person),
            validator:
                (value) => Validators.validateName(
                  value,
                  emptyMessage: context.loc.nameRequired,
                  tooShortMessage: context.loc.nameTooShort,
                ),
          ),
          AuthFormField(
            controller: widget.emailController,
            labelText: context.loc.emailLabel,
            hintText: "santa@northpole.com",
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
            labelText: context.loc.passwordLabel,
            hintText: "********",
            isPasswordField: true,
            prefixIcon: const Icon(Icons.lock),
            validator:
                (value) => Validators.validatePassword(
                  value,
                  emptyMessage: context.loc.passwordRequired,
                  tooShortMessage: context.loc.passwordTooShort,
                ),
          ),
          AuthFormField(
            controller: widget.confirmPasswordController,
            labelText: context.loc.confirmPasswordLabel,
            hintText: "********",
            isRepeatPasswordField: true,
            prefixIcon: const Icon(Icons.safety_check),
            originalPasswordController: widget.passwordController,
            validator:
                (value) => Validators.validateConfirmPassword(
                  value,
                  widget.passwordController.text,
                  emptyMessage: context.loc.confirmPasswordRequired,
                  mismatchMessage: context.loc.passwordsDoNotMatchError,
                ),
          ),
        ],
      ),
    );
  }
}
