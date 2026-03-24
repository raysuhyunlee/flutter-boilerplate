// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

class CrashlyticsLogOutput extends LogOutput {
  final Level minLogLevel;
  final FirebaseCrashlytics crashlytics;

  CrashlyticsLogOutput({
    required this.minLogLevel,
    FirebaseCrashlytics? crashlytics,
  }) : crashlytics = crashlytics ?? FirebaseCrashlytics.instance;

  @override
  void output(OutputEvent event) {
    if (event.level.value >= minLogLevel.value) {
      final errorMessage = event.origin.message;
      crashlytics.recordError(errorMessage, null, fatal: true);
    }
  }
}
