import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secret_santa/core/extensions/context_extension.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_event.dart';
import 'package:secret_santa/features/auth/presentation/bloc/auth_state.dart';
import 'package:secret_santa/features/auth/presentation/widgets/auth_button.dart';
import 'package:secret_santa/features/auth/presentation/widgets/avatar_color_picker.dart';
import 'package:secret_santa/features/auth/presentation/widgets/profile_avatar_picker.dart';
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

  int _currentStep = 0;
  final PageController _pageController = PageController();
  Uint8List? _avatarImageBytes;
  Color _selectedAvatarColor = AvatarColorPicker.presetColors[0];
  bool _acceptedTerms = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _currentStep = 1;
      });
      _pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    setState(() {
      _currentStep = 0;
    });
    _pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitRegistration() {
    if (context.read<AuthBloc>().state.status == AuthStatus.loading) return;
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    context.read<AuthBloc>().add(
          AuthSignUpRequested(
            nickname: name,
            email: email,
            password: password,
            avatarImageBytes: _avatarImageBytes,
            avatarBgColorValue: _selectedAvatarColor.value,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) => bloc.state.status == AuthStatus.loading,
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? context.loc.unknownError),
            ),
          );
        }
        if (state.status == AuthStatus.authenticated ||
            state.status == AuthStatus.registered) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.registerSuccess)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.registerAppBarTitle),
          leading: _currentStep == 1
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: isLoading ? null : _previousStep,
                )
              : null,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Step indicator banner
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_currentStep + 1) / 2,
                          minHeight: 6,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      context.loc.stepCount(_currentStep + 1, 2),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Step 1: Account Information Form
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Text(
                            context.loc.registerTitle,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            context.loc.registerSubTitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          RegisterForm(
                            nameController: nameController,
                            emailController: emailController,
                            passwordController: passwordController,
                            confirmPasswordController:
                                confirmPasswordController,
                            formKey: _formKey,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: _acceptedTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _acceptedTerms = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Wrap(
                                  children: [
                                    Text(context.loc.termsAndConditionsLabel),
                                    GestureDetector(
                                      onTap: () {
                                        // Handle terms link
                                      },
                                      child: Text(
                                        context.loc.termsAndConditionsLink,
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AuthButton(
                            onPressed: _nextStep,
                            buttonText: context.loc.registerNextStep,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),

                    // Step 2: Profile Avatar Setup
                    SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            context.loc.registerStep2Title,
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              context.loc.registerStep2Subtitle,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 28),

                          // Profile Avatar Picker (Circle with Initials/Photo + Plus badge)
                          ProfileAvatarPicker(
                            imageBytes: _avatarImageBytes,
                            nickname: nameController.text.trim().isNotEmpty
                                ? nameController.text.trim()
                                : 'Santa',
                            backgroundColor: _selectedAvatarColor,
                            onImageSelected: (bytes) {
                              setState(() {
                                _avatarImageBytes = bytes;
                              });
                            },
                          ),

                          const SizedBox(height: 28),

                          // Avatar background color palette (only visible when using initials)
                          if (_avatarImageBytes == null) ...[
                            AvatarColorPicker(
                              selectedColor: _selectedAvatarColor,
                              onColorSelected: (color) {
                                setState(() {
                                  _selectedAvatarColor = color;
                                });
                              },
                            ),
                            const SizedBox(height: 28),
                          ],

                          // Action Buttons: Complete Registration & Back
                          AuthButton(
                            onPressed: _submitRegistration,
                            buttonText: context.loc.registerButton,
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: isLoading ? null : _previousStep,
                            child: Text(
                              context.loc.registerBackStep,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
