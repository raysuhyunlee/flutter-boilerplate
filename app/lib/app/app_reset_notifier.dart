// Flutter imports:
import 'package:flutter/foundation.dart';

/// Notifies listeners when the app should reset to its initial state
/// (e.g. returning to the onboarding screen).
class AppResetNotifier extends ChangeNotifier {
  void reset() {
    notifyListeners();
  }
}
