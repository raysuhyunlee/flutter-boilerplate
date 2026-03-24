// Dart imports:
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get_it/get_it.dart';

// Project imports:
import 'package:flutter_boilerplate/app/app.dart';
import 'package:flutter_boilerplate/app/dependencies.dart';
import 'package:flutter_boilerplate/domain/subscription/subscription_repository.dart';
import 'package:flutter_boilerplate/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {}
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  setupDependencies();
  _initializeInBackground();
  runApp(const App());
}

/// Non-blocking initialisation of services that don't need to be ready
/// before the first frame (e.g. RevenueCat).
void _initializeInBackground() {
  final subscriptionRepo = GetIt.instance<SubscriptionRepository>();
  subscriptionRepo.initialize();
}
