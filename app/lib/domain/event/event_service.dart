import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:flutter_boilerplate/domain/device/device_id_service.dart';

/// Analytics event names used across the app.
/// Add app-specific events as needed.
abstract final class Events {
  // Paywall
  static const paywallShow = 'paywall_show';
  static const paywallPurchase = 'paywall_purchase';
  static const paywallClose = 'paywall_close';

  // Settings
  static const notificationToggle = 'notification_toggle';
  static const shareApp = 'share_app';
  static const reviewApp = 'review_app';
}

class EventService {
  final Logger logger;
  final FirebaseAnalytics _analytics;
  final DeviceIdService _deviceIdService;

  EventService({
    required this.logger,
    required DeviceIdService deviceIdService,
    FirebaseAnalytics? analytics,
  })  : _analytics = analytics ?? FirebaseAnalytics.instance,
        _deviceIdService = deviceIdService;

  /// Sets the device ID as the Analytics user identifier.
  Future<void> initialize() async {
    final id = await _deviceIdService.getOrCreateDeviceId();
    await _analytics.setUserId(id: id);
  }

  Future<void> publish(String eventType,
      {Map<String, Object>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: eventType,
        parameters: {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          ...?parameters,
        },
      );
    } catch (e) {
      logger.e('Failed to publish event: $e');
    }
  }
}
