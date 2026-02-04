import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class EventService {
  final Logger logger;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  EventService({required this.logger});

  Future<void> publish(String eventType, {Map<String, Object>? parameters}) async {
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
