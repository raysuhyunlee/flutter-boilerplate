import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_boilerplate/domain/device/device_id_service.dart';

void main() {
  late DeviceIdService sut;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    sut = DeviceIdService();
  });

  group('getOrCreateDeviceId', () {
    test('should_generate_and_persist_id_when_none_exists', () async {
      final id = await sut.getOrCreateDeviceId();

      expect(id, isNotEmpty);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('device_id'), equals(id));
    });

    test('should_return_existing_id_when_already_persisted', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('device_id', 'existing-device-id');

      final id = await sut.getOrCreateDeviceId();

      expect(id, equals('existing-device-id'));
    });

    test('should_return_same_id_on_subsequent_calls', () async {
      final first = await sut.getOrCreateDeviceId();
      final second = await sut.getOrCreateDeviceId();

      expect(first, equals(second));
    });

    test('should_generate_uuid_v4_format', () async {
      final id = await sut.getOrCreateDeviceId();

      final uuidV4Pattern = RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      );
      expect(id, matches(uuidV4Pattern));
    });
  });
}
