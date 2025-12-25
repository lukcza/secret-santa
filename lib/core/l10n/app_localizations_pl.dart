// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get loginTitle => 'Ho ho ho!\nKim jesteś?';

  @override
  String get emailLabel => 'Adres Email';

  @override
  String get passwordLabel => 'Hasło';

  @override
  String get signInButton => 'Zaloguj się';

  @override
  String get registerLink => 'Nie masz konta? Zarejestruj się';

  @override
  String get errorEmptyEmail => 'Proszę podać email';

  @override
  String get errorShortPassword => 'Hasło musi mieć min. 6 znaków';

  @override
  String get welcomeImageText => 'Wesołych Świąt!';
}
