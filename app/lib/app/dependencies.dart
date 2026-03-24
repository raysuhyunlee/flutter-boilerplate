// Package imports:
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:flutter_boilerplate/domain/device/device_id_service.dart';
import 'package:flutter_boilerplate/domain/event/event_service.dart';
import 'package:flutter_boilerplate/domain/database/local_database.dart';
import 'package:flutter_boilerplate/domain/session/session_service.dart';
import 'package:flutter_boilerplate/domain/subscription/purchases_client.dart';
import 'package:flutter_boilerplate/domain/subscription/subscription_repository.dart';
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

  getIt.registerSingleton<SessionService>(SessionService());

  getIt.registerSingleton<DeviceIdService>(DeviceIdService());

  getIt.registerSingleton<EventService>(
    EventService(
      logger: getIt<Logger>(),
      deviceIdService: getIt<DeviceIdService>(),
    ),
  );

  getIt.registerSingleton<PurchasesClient>(RevenueCatPurchasesClient());

  getIt.registerSingleton<SubscriptionRepository>(
    SubscriptionRepository(
      logger: getIt<Logger>(),
      sessionService: getIt<SessionService>(),
      purchasesClient: getIt<PurchasesClient>(),
    ),
  );
}
