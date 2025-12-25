import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_field.dart';

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
  Future<void> _onPressed(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.passwordsDoNotMatchError)),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthSignUpRequested(nickname: name, email: email, password: password),
    );
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
                AuthField(
                  controller: nameController,
                  labelText: context.loc.nameLabel,
                  hintText: "Kris Kirngle",
                  prefixIcon: const Icon(Icons.person),
                ),
                AuthField(
                  controller: emailController,
                  labelText: context.loc.emailLabel,
                  hintText: "santa@northpole.com",
                  isEmailField: true,
                  prefixIcon: const Icon(Icons.email),
                ),
                AuthField(
                  controller: passwordController,
                  labelText: context.loc.passwordLabel,
                  hintText: "********",
                  isPasswordField: true,
                  prefixIcon: const Icon(Icons.lock),
                ),
                AuthField(
                  controller: confirmPasswordController,
                  labelText: context.loc.confirmPasswordLabel,
                  hintText: "********",
                  isReapetPasswordField: true,
                  prefixIcon: const Icon(Icons.safety_check),
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
