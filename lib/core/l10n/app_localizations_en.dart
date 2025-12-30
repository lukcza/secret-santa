// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Ho ho ho! Who are you?';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'login';

  @override
  String get registerLinkText => 'Don\'t have an account? ';

  @override
  String get registerLink => 'Register';

  @override
  String get errorEmptyEmail => 'Please enter your email';

  @override
  String get errorShortPassword => 'Password must be at least 6 characters';

  @override
  String get welcomeImageText => 'Merry Christmas!';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get login => 'Login';

  @override
  String get continueWith => 'Or continue with';

  @override
  String get unknownError => 'An unknown error occurred.';

  @override
  String get cardTitle => 'Welcome Back!';

  @override
  String get cardSubtitle => 'Christmas is coming, let\'s get you logged in.';

  @override
  String get loginSuccess => 'Successfully logged in!';

  @override
  String get registerAppBarTitle => 'Register';

  @override
  String get registerTitle => 'Become a Secret Santa';

  @override
  String get registerSubTitle =>
      'Join the fun and start exchanging gifts today!';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get termsAndConditionsLabel => 'I agree to the ';

  @override
  String get termsAndConditionsLink => 'Terms and Conditions';

  @override
  String get registerButton => 'Sign Up';

  @override
  String get registerSuccess => 'Registration successful! Please log in.';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match.';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameTooShort => 'Name must be at least 2 characters';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';
}
