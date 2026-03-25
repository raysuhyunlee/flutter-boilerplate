import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_boilerplate/app/app_reset_notifier.dart';

void main() {
  group('AppResetNotifier', () {
    test('should_notify_listeners_when_reset_is_called', () {
      final notifier = AppResetNotifier();
      var notified = false;
      notifier.addListener(() => notified = true);

      notifier.reset();

      expect(notified, isTrue);
    });
  });
}
