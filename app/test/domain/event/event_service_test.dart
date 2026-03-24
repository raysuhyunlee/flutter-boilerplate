import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_boilerplate/domain/device/device_id_service.dart';
import 'package:flutter_boilerplate/domain/event/event_service.dart';

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockLogger extends Mock implements Logger {}

class MockDeviceIdService extends Mock implements DeviceIdService {}

void main() {
  late EventService sut;
  late MockFirebaseAnalytics mockAnalytics;
  late MockLogger mockLogger;
  late MockDeviceIdService mockDeviceIdService;

  setUp(() {
    mockAnalytics = MockFirebaseAnalytics();
    mockLogger = MockLogger();
    mockDeviceIdService = MockDeviceIdService();
    sut = EventService(
      logger: mockLogger,
      analytics: mockAnalytics,
      deviceIdService: mockDeviceIdService,
    );
  });

  group('initialize', () {
    test('should_set_analytics_user_id_with_device_id', () async {
      when(() => mockDeviceIdService.getOrCreateDeviceId())
          .thenAnswer((_) async => 'test-device-id');
      when(() => mockAnalytics.setUserId(id: any(named: 'id')))
          .thenAnswer((_) async {});

      await sut.initialize();

      verify(() => mockAnalytics.setUserId(id: 'test-device-id')).called(1);
    });

    test('should_request_device_id_from_device_id_service', () async {
      when(() => mockDeviceIdService.getOrCreateDeviceId())
          .thenAnswer((_) async => 'abc-123');
      when(() => mockAnalytics.setUserId(id: any(named: 'id')))
          .thenAnswer((_) async {});

      await sut.initialize();

      verify(() => mockDeviceIdService.getOrCreateDeviceId()).called(1);
    });
  });

  group('publish', () {
    test('should_log_event_with_name_and_timestamp', () async {
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async {});

      await sut.publish(Events.paywallShow);

      final captured = verify(
        () => mockAnalytics.logEvent(
          name: Events.paywallShow,
          parameters: captureAny(named: 'parameters'),
        ),
      ).captured.single as Map<String, Object?>;

      expect(captured, containsPair('timestamp', isA<int>()));
    });

    test('should_merge_custom_parameters_with_timestamp', () async {
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenAnswer((_) async {});

      await sut.publish(
        Events.paywallPurchase,
        parameters: {'product_id': 'premium_yearly'},
      );

      final captured = verify(
        () => mockAnalytics.logEvent(
          name: Events.paywallPurchase,
          parameters: captureAny(named: 'parameters'),
        ),
      ).captured.single as Map<String, Object?>;

      expect(captured, containsPair('timestamp', isA<int>()));
      expect(captured, containsPair('product_id', 'premium_yearly'));
    });

    test('should_log_error_when_analytics_throws', () async {
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenThrow(Exception('network error'));
      when(() => mockLogger.e(any())).thenReturn(null);

      await sut.publish(Events.shareApp);

      verify(() => mockLogger.e(any(
            that: contains('Failed to publish event'),
          ))).called(1);
    });

    test('should_not_throw_when_analytics_fails', () async {
      when(() => mockAnalytics.logEvent(
            name: any(named: 'name'),
            parameters: any(named: 'parameters'),
          )).thenThrow(Exception('crash'));
      when(() => mockLogger.e(any())).thenReturn(null);

      expect(() => sut.publish(Events.reviewApp), returnsNormally);
    });
  });
}
