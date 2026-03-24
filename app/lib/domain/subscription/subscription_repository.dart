// Package imports:
import 'package:logger/logger.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// Project imports:
import 'package:flutter_boilerplate/domain/session/session_service.dart';
import 'package:flutter_boilerplate/resources/app_config.dart';

/// Manages RevenueCat subscription state, purchases, and paywall trigger logic.
///
/// Call [initialize] once at app startup (e.g., in `main.dart` background init).
/// Use [evaluatePaywallTrigger] to decide when/how to show the paywall.
class SubscriptionRepository {
  final Logger _logger;
  final SessionService _sessionService;
  bool _initialized = false;
  final List<void Function(CustomerInfo)> _pendingListeners = [];

  SubscriptionRepository({
    required Logger logger,
    required SessionService sessionService,
  })  : _logger = logger,
        _sessionService = sessionService;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (AppConfig.revenueCatApiKey.isEmpty) {
      _logger.w('RevenueCat API key not configured — skipping initialization');
      return;
    }
    try {
      await Purchases.setLogLevel(LogLevel.debug);
      final configuration =
          PurchasesConfiguration(AppConfig.revenueCatApiKey);
      await Purchases.configure(configuration);
      _initialized = true;
      for (final listener in _pendingListeners) {
        Purchases.addCustomerInfoUpdateListener(listener);
      }
      _pendingListeners.clear();
    } catch (e, st) {
      _logger.e('RevenueCat initialization failed', error: e, stackTrace: st);
    }
  }

  Future<bool> isProUser() async {
    if (!_initialized) return false;
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo
              .entitlements.all[AppConfig.revenueCatEntitlementId]?.isActive ??
          false;
    } catch (e, st) {
      _logger.e('Failed to check entitlement', error: e, stackTrace: st);
      return false;
    }
  }

  Future<CustomerInfo?> getCustomerInfo() async {
    if (!_initialized) return null;
    return Purchases.getCustomerInfo();
  }

  Future<CustomerInfo?> restorePurchases() async {
    if (!_initialized) return null;
    return Purchases.restorePurchases();
  }

  void addCustomerInfoListener(void Function(CustomerInfo) listener) {
    if (!_initialized) {
      _pendingListeners.add(listener);
      return;
    }
    Purchases.addCustomerInfoUpdateListener(listener);
  }

  Future<Offerings?> getOfferings() async {
    if (!_initialized) return null;
    return Purchases.getOfferings();
  }

  Future<CustomerInfo?> purchasePackage(Package package) async {
    if (!_initialized) return null;
    return Purchases.purchasePackage(package);
  }

  /// Evaluates whether to show a paywall based on session count and pro status.
  ///
  /// Returns [PaywallTrigger.none] if the user is pro or RevenueCat is not
  /// initialized. Otherwise returns dismissible (< [forcedAfterSessions]) or
  /// forced (>= [forcedAfterSessions]).
  Future<PaywallTrigger> evaluatePaywallTrigger({
    int forcedAfterSessions = 10,
  }) async {
    if (!_initialized) return PaywallTrigger.none;
    final isPro = await isProUser();
    if (isPro) return PaywallTrigger.none;
    final sessionCount = await _sessionService.getCount();
    if (sessionCount >= forcedAfterSessions) {
      return PaywallTrigger.forcedPaywall;
    }
    return PaywallTrigger.dismissiblePaywall;
  }
}

enum PaywallTrigger {
  none,
  dismissiblePaywall,
  forcedPaywall,
}
