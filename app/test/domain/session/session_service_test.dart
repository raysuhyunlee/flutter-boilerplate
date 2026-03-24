import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_boilerplate/domain/session/session_service.dart';

void main() {
  late SessionService sut;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sut = SessionService();
  });

  group('isFirstLaunch', () {
    test('should_return_true_when_no_data_exists', () async {
      final result = await sut.isFirstLaunch();

      expect(result, isTrue);
    });

    test('should_return_false_when_already_marked_as_launched', () async {
      await sut.markAlreadyLaunched();

      final result = await sut.isFirstLaunch();

      expect(result, isFalse);
    });
  });

  group('markAlreadyLaunched', () {
    test('should_persist_launched_flag', () async {
      await sut.markAlreadyLaunched();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('first_launch'), isFalse);
    });
  });

  group('saveInstallDateIfNeeded', () {
    test('should_save_install_date_when_not_set', () async {
      await sut.saveInstallDateIfNeeded();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('install_date'), isNotNull);
    });

    test('should_not_overwrite_existing_install_date', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('install_date', '2025-01-01T00:00:00.000');

      await sut.saveInstallDateIfNeeded();

      expect(prefs.getString('install_date'), '2025-01-01T00:00:00.000');
    });
  });

  group('getInstallDate', () {
    test('should_return_null_when_no_install_date_saved', () async {
      final result = await sut.getInstallDate();

      expect(result, isNull);
    });

    test('should_return_saved_install_date', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('install_date', '2025-06-15T10:30:00.000');

      final result = await sut.getInstallDate();

      expect(result, DateTime(2025, 6, 15, 10, 30));
    });
  });

  group('getCount', () {
    test('should_return_zero_when_no_sessions_recorded', () async {
      final result = await sut.getCount();

      expect(result, 0);
    });

    test('should_return_stored_count', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('session_count', 5);

      final result = await sut.getCount();

      expect(result, 5);
    });
  });

  group('setCount', () {
    test('should_persist_given_count', () async {
      await sut.setCount(42);

      final result = await sut.getCount();

      expect(result, 42);
    });
  });

  group('recordColdStart', () {
    test('should_increment_session_count_by_one', () async {
      await sut.recordColdStart();

      final count = await sut.getCount();

      expect(count, 1);
    });

    test('should_increment_count_on_each_cold_start', () async {
      await sut.recordColdStart();
      await sut.recordColdStart();
      await sut.recordColdStart();

      final count = await sut.getCount();

      expect(count, 3);
    });

    test('should_update_last_session_timestamp', () async {
      await sut.recordColdStart();

      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt('last_session_timestamp');

      expect(timestamp, isNotNull);
    });
  });

  group('recordResumeIfNeeded', () {
    test('should_increment_when_no_previous_session_exists', () async {
      await sut.recordResumeIfNeeded();

      final count = await sut.getCount();

      expect(count, 1);
    });

    test('should_increment_when_gap_threshold_is_zero', () async {
      sut = SessionService(sessionGapThreshold: Duration.zero);
      await sut.recordColdStart();

      await sut.recordResumeIfNeeded();

      final count = await sut.getCount();

      expect(count, 2);
    });

    test('should_not_increment_when_gap_threshold_not_reached', () async {
      sut = SessionService(
        sessionGapThreshold: const Duration(days: 365),
      );
      await sut.recordColdStart();

      await sut.recordResumeIfNeeded();

      final count = await sut.getCount();

      expect(count, 1);
    });
  });

  group('reset', () {
    test('should_clear_all_session_data', () async {
      await sut.markAlreadyLaunched();
      await sut.saveInstallDateIfNeeded();
      await sut.recordColdStart();

      await sut.reset();

      expect(await sut.isFirstLaunch(), isTrue);
      expect(await sut.getInstallDate(), isNull);
      expect(await sut.getCount(), 0);
    });
  });
}
