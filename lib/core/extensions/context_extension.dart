import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../l10n/app_localizations_en.dart';

extension ContextExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this) ?? AppLocalizationsEn();
}