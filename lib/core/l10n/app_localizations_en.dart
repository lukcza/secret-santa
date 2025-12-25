// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginTitle => 'Ho ho ho!\nWho are you?';

  @override
  String get emailLabel => 'Email Address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signInButton => 'Sign In';

  @override
  String get registerLink => 'Don\'t have an account? Sign Up';

  @override
  String get errorEmptyEmail => 'Please enter your email';

  @override
  String get errorShortPassword => 'Password must be at least 6 characters';

  @override
  String get welcomeImageText => 'Merry Christmas!';
}
