import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';
import 'package:secret_santa/features/auth/presentation/widgets/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _onPressed(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      context.read<AuthBloc>().add(
        AuthSignUpRequested(nickname: name, email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.loc.unknownError),
            ),
          );
        }
        if (state.status == AuthStatus.authenticated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.loc.registerSuccess)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.registerAppBarTitle)),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.loc.registerTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  context.loc.registerSubTitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                RegisterForm(
                  nameController: nameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                  formKey: _formKey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(value: false, onChanged: (value) {}),
                    Text(context.loc.termsAndConditionsLabel),
                    GestureDetector(
                      onTap: () {
                        // Handle privacy policy link tap
                      },
                      child: Text(
                        context.loc.termsAndConditionsLink,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                AuthButton(
                  onPressed: () => _onPressed(context),
                  buttonText: context.loc.registerButton,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
