import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Text("Welcome Back!\n Santa! 🎅")],
                    ),
                  ),
                ),
                Text(
                  "Ho ho ho Who are you?",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                AuthField(
                  labelText: "Email Address",
                  hintText: "santa@northpole.com",
                  controller: _emailController,
                  isEmailField: true,
                  prefixIcon: const Icon(Icons.email),
                ),
                AuthField(
                  controller: _passwordController,
                  isPasswordField: true,
                  prefixIcon: const Icon(Icons.lock),
                  labelText: "Password",
                  hintText: "Enter your password",
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => print("Forgot Password clicked"),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.tertiary,
                          ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
