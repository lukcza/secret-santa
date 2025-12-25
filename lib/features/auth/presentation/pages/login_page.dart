import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_field.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_divider.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_header_card.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> onPressedLoginButton(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    context.read<AuthBloc>().add(
          AuthSignInRequested(email: email, password: password),
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc.loginSuccess),
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
                    context.loc.loginTitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                AuthField(
                  labelText: context.loc.emailLabel,
                  hintText: "santa@northpole.com",
                  controller: _emailController,
                  isEmailField: true,
                  prefixIcon: const Icon(Icons.email),
                ),
                AuthField(
                  controller: _passwordController,
                  isPasswordField: true,
                  prefixIcon: const Icon(Icons.lock),
                  labelText: context.loc.passwordLabel,
                  hintText: "********",
                  suffixIcon: const Icon(Icons.visibility_off),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => debugPrint("Forgot Password clicked"),
                      child: Text(
                        context.loc.forgotPassword,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if(state.status == AuthStatus.loading){
                      return const CircularProgressIndicator();
                    }

                    return AuthButton(onPressed: () => onPressedLoginButton(context), buttonText: context.loc.loginButton);
                  }
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
                      context.loc.registerLinkText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => debugPrint("Navigate to Register Page"),
                      child: Text(
                        context.loc.registerLink,
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
