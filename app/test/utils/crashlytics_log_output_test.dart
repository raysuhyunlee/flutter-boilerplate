import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_boilerplate/utils/crashlytics_log_output.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

void main() {
  late CrashlyticsLogOutput sut;
  late MockFirebaseCrashlytics mockCrashlytics;

  setUp(() {
    mockCrashlytics = MockFirebaseCrashlytics();
    when(() => mockCrashlytics.recordError(any(), any(), fatal: true))
        .thenAnswer((_) async {});
  });

  group('output', () {
    test('should_record_error_when_level_meets_threshold', () {
      sut = CrashlyticsLogOutput(
        minLogLevel: Level.error,
        crashlytics: mockCrashlytics,
      );
      final event = OutputEvent(
        LogEvent(Level.error, 'Something went wrong'),
        ['Something went wrong'],
      );

      sut.output(event);

      verify(
        () => mockCrashlytics.recordError(
          'Something went wrong',
          null,
          fatal: true,
        ),
      ).called(1);
    });

    test('should_record_error_when_level_exceeds_threshold', () {
      sut = CrashlyticsLogOutput(
        minLogLevel: Level.warning,
        crashlytics: mockCrashlytics,
      );
      final event = OutputEvent(
        LogEvent(Level.error, 'Critical failure'),
        ['Critical failure'],
      );

      sut.output(event);

      verify(
        () => mockCrashlytics.recordError(
          'Critical failure',
          null,
          fatal: true,
        ),
      ).called(1);
    });

    test('should_not_record_error_when_level_below_threshold', () {
      sut = CrashlyticsLogOutput(
        minLogLevel: Level.error,
        crashlytics: mockCrashlytics,
      );
      final event = OutputEvent(
        LogEvent(Level.warning, 'Just a warning'),
        ['Just a warning'],
      );

      sut.output(event);

      verifyNever(
        () => mockCrashlytics.recordError(any(), any(), fatal: true),
      );
    });
  });
}
