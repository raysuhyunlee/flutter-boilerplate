// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

/// Manages session lifecycle: first launch detection, install date tracking,
/// and session counting with a configurable gap threshold.
///
/// Usage:
///   final session = SessionService();
///   await session.recordColdStart();           // call in initState
///   await session.recordResumeIfNeeded();      // call on AppLifecycleState.resumed
///   final isFirst = await session.isFirstLaunch();
class SessionService {
  static const _firstLaunchKey = 'first_launch';
  static const _installDateKey = 'install_date';
  static const _sessionCountKey = 'session_count';
  static const _lastSessionTimestampKey = 'last_session_timestamp';

  /// Minimum elapsed time before a resume counts as a new session.
  final Duration sessionGapThreshold;

  SessionService({
    this.sessionGapThreshold = const Duration(days: 1),
  });

  // ── First launch ──

  Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_firstLaunchKey) ?? true;
    } catch (_) {
      return true;
    }
  }

  Future<void> markAlreadyLaunched() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstLaunchKey, false);
    } catch (_) {}
  }

  // ── Install date ──

  Future<void> saveInstallDateIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey(_installDateKey)) {
        await prefs.setString(
            _installDateKey, DateTime.now().toIso8601String());
      }
    } catch (_) {}
  }

  Future<DateTime?> getInstallDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateStr = prefs.getString(_installDateKey);
      return dateStr != null ? DateTime.parse(dateStr) : null;
    } catch (_) {
      return null;
    }
  }

  // ── Session count ──

  Future<int> getCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionCountKey) ?? 0;
  }

  Future<void> setCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionCountKey, count);
  }

  Future<void> _increment() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, current + 1);
    await prefs.setInt(
      _lastSessionTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Called on cold start — always counts as a new session.
  Future<void> recordColdStart() async {
    await _increment();
  }

  /// Called on resume from background — only counts if [sessionGapThreshold]
  /// has passed since the last recorded session.
  Future<void> recordResumeIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastTimestamp = prefs.getInt(_lastSessionTimestampKey);
    if (lastTimestamp == null) {
      await _increment();
      return;
    }
    final lastSession = DateTime.fromMillisecondsSinceEpoch(lastTimestamp);
    final elapsed = DateTime.now().difference(lastSession);
    if (elapsed >= sessionGapThreshold) {
      await _increment();
    }
  }

  /// Clears all session data. Useful for the dev tools "reset" action.
  Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstLaunchKey);
    await prefs.remove(_installDateKey);
    await prefs.remove(_sessionCountKey);
    await prefs.remove(_lastSessionTimestampKey);
  }
}
