import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
extension ContextExtension on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}