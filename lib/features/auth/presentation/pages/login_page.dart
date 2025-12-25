import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_field.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_divider.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_header_card.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An unknown error occurred'),
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LoginHeaderCard(),
                Container(
                  margin: const EdgeInsets.only(top:10,),
                  child: Text(
                    "Ho ho ho Who are you?",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                    ),
                  ),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => debugPrint("Forgot Password clicked"),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => debugPrint("Login clicked"),
                    child: Text("Login"),
                  ),
                ),
                LoginDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset(
                        'assets/images/google_icon.png',
                        height: 50,
                        width: 50,
                      ),
                      iconSize: 1,
                      onPressed: () => debugPrint("Google login clicked"),
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Image.asset(
                        'assets/images/facebook_icon.png',
                        height: 50,
                        width: 50,
                        color: Color.fromARGB(255, 59, 89, 152),
                      ),
                      iconSize: 1,
                      onPressed: () => debugPrint("Facebook login clicked"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => debugPrint("Navigate to Register Page"),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
