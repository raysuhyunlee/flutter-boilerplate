import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_boilerplate/domain/session/session_service.dart';
import 'package:flutter_boilerplate/domain/subscription/purchases_client.dart';
import 'package:flutter_boilerplate/domain/subscription/subscription_repository.dart';

class MockPurchasesClient extends Mock implements PurchasesClient {}

class MockLogger extends Mock implements Logger {}

class FakeCustomerInfo extends Fake implements CustomerInfo {
  final EntitlementInfos _entitlements;

  FakeCustomerInfo({required EntitlementInfos entitlements})
      : _entitlements = entitlements;

  @override
  EntitlementInfos get entitlements => _entitlements;
}

class FakeEntitlementInfos extends Fake implements EntitlementInfos {
  final Map<String, EntitlementInfo> _all;

  FakeEntitlementInfos({required Map<String, EntitlementInfo> all})
      : _all = all;

  @override
  Map<String, EntitlementInfo> get all => _all;
}

class FakeEntitlementInfo extends Fake implements EntitlementInfo {
  final bool _isActive;

  FakeEntitlementInfo({required bool isActive}) : _isActive = isActive;

  @override
  bool get isActive => _isActive;
}

void main() {
  late SubscriptionRepository sut;
  late MockPurchasesClient mockPurchasesClient;
  late MockLogger mockLogger;
  late SessionService sessionService;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockPurchasesClient = MockPurchasesClient();
    mockLogger = MockLogger();
    sessionService = SessionService();

    sut = SubscriptionRepository(
      logger: mockLogger,
      sessionService: sessionService,
      purchasesClient: mockPurchasesClient,
    );
  });

  group('isInitialized', () {
    test('should_return_false_when_not_initialized', () {
      expect(sut.isInitialized, isFalse);
    });
  });

  group('isProUser', () {
    test('should_return_false_when_not_initialized', () async {
      final result = await sut.isProUser();

      expect(result, isFalse);
    });
  });

  group('getCustomerInfo', () {
    test('should_return_null_when_not_initialized', () async {
      final result = await sut.getCustomerInfo();

      expect(result, isNull);
    });
  });

  group('restorePurchases', () {
    test('should_return_null_when_not_initialized', () async {
      final result = await sut.restorePurchases();

      expect(result, isNull);
    });
  });

  group('getOfferings', () {
    test('should_return_null_when_not_initialized', () async {
      final result = await sut.getOfferings();

      expect(result, isNull);
    });
  });

  group('addCustomerInfoListener', () {
    test('should_queue_listener_when_not_initialized', () {
      var called = false;

      sut.addCustomerInfoListener((_) => called = true);

      verifyNever(
        () => mockPurchasesClient.addCustomerInfoUpdateListener(any()),
      );
      expect(called, isFalse);
    });
  });

  group('evaluatePaywallTrigger', () {
    test('should_return_none_when_not_initialized', () async {
      final result = await sut.evaluatePaywallTrigger();

      expect(result, PaywallTrigger.none);
    });

    test(
      'should_return_none_when_user_is_pro',
      () async {
        _markInitialized(sut);
        _stubProUser(mockPurchasesClient, isPro: true);

        final result = await sut.evaluatePaywallTrigger();

        expect(result, PaywallTrigger.none);
      },
    );

    test(
      'should_return_dismissible_when_session_count_below_threshold',
      () async {
        _markInitialized(sut);
        _stubProUser(mockPurchasesClient, isPro: false);
        await sessionService.setCount(3);

        final result = await sut.evaluatePaywallTrigger(
          forcedAfterSessions: 10,
        );

        expect(result, PaywallTrigger.dismissiblePaywall);
      },
    );

    test(
      'should_return_forced_when_session_count_equals_threshold',
      () async {
        _markInitialized(sut);
        _stubProUser(mockPurchasesClient, isPro: false);
        await sessionService.setCount(10);

        final result = await sut.evaluatePaywallTrigger(
          forcedAfterSessions: 10,
        );

        expect(result, PaywallTrigger.forcedPaywall);
      },
    );

    test(
      'should_return_forced_when_session_count_exceeds_threshold',
      () async {
        _markInitialized(sut);
        _stubProUser(mockPurchasesClient, isPro: false);
        await sessionService.setCount(15);

        final result = await sut.evaluatePaywallTrigger(
          forcedAfterSessions: 10,
        );

        expect(result, PaywallTrigger.forcedPaywall);
      },
    );

    test(
      'should_use_custom_forced_after_sessions_value',
      () async {
        _markInitialized(sut);
        _stubProUser(mockPurchasesClient, isPro: false);
        await sessionService.setCount(5);

        final result = await sut.evaluatePaywallTrigger(
          forcedAfterSessions: 5,
        );

        expect(result, PaywallTrigger.forcedPaywall);
      },
    );
  });
}

void _markInitialized(SubscriptionRepository repo) {
  repo.initializedForTesting = true;
}

void _stubProUser(MockPurchasesClient client, {required bool isPro}) {
  final entitlementInfo = FakeEntitlementInfo(isActive: isPro);
  final entitlements = FakeEntitlementInfos(
    all: isPro ? {'pro': entitlementInfo} : {},
  );
  final customerInfo = FakeCustomerInfo(entitlements: entitlements);

  when(() => client.getCustomerInfo())
      .thenAnswer((_) async => customerInfo);
}
