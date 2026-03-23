// Package imports:
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:flutter_boilerplate/domain/event/event_service.dart';
import 'package:flutter_boilerplate/domain/database/local_database.dart';
import 'package:flutter_boilerplate/utils/crashlytics_log_output.dart';

final getIt = GetIt.instance;

Logger buildLogger() {
  return Logger(
      filter: null,
      printer: PrettyPrinter(),
      output: MultiOutput([
        ConsoleOutput(),
        CrashlyticsLogOutput(minLogLevel: Level.error),
      ]));
}

void setupDependencies() {
  if (getIt.isRegistered<Logger>()) return;

  getIt.registerSingleton<Logger>(buildLogger());

  getIt.registerSingleton<LocalDatabase>(LocalDatabase());

  getIt.registerSingleton<EventService>(
    EventService(logger: getIt<Logger>()),
  );
}
