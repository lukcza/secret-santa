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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                clipBehavior: Clip.antiAlias,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Image(
                      image: AssetImage('assets/images/cardBGLoginPage.png'),
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Text(
                        "Welcome Back!\n Santa! 🎅",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: ()=>debugPrint("Login clicked"),
                  child: Text("Login"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Or continue with",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
                  ],
                ),
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/images/google_icon.png'),
                    iconSize: 50,
                    onPressed: () => debugPrint("Google login clicked"),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Image.asset('assets/images/facebook_icon.png'),
                    iconSize: 50,
                    onPressed: () => debugPrint("Facebook login clicked"),
                  ),
                ],
              ),*/
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
    );
  }
}
