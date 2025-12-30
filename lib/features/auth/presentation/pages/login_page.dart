import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_divider.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_form.dart';
import 'package:secret_santa/features/auth/presentation/widgets/login_header_card.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> onPressedLoginButton(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      context.read<AuthBloc>().add(
            AuthSignInRequested(email: email, password: password),
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
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    context.loc.loginTitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                LoginForm(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  formKey: _formKey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => debugPrint("Forgot password clicked"),
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
                      onTap: () => context.push('/register'),
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
