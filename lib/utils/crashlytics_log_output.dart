// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class CrashlyticsLogOutput extends LogOutput {
  final Level minLogLevel;
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

  CrashlyticsLogOutput({required this.minLogLevel});

  @override
  void output(OutputEvent event) {
    if (event.level.value >= minLogLevel.value) {
      final errorMessage = event.origin.message;
      crashlytics.recordError(errorMessage, null, fatal: true);
    }
  }
}
