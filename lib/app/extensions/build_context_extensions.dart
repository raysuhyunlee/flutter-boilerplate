// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_boilerplate/l10n/app_localizations.dart';

/// Convenience extensions on [BuildContext] for accessing localization.
extension BuildContextExtensions on BuildContext {
  /// Shortcut for `AppLocalizations.of(this)`.
  ///
  /// Usage: `context.l10n.appTitle`
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
