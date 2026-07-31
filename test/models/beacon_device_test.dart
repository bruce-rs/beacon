import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const a = BeaconDevice(id: 'mac-1', name: 'MacBook', host: '192.168.1.10', port: 5000);
  const b = BeaconDevice(id: 'mac-1', name: 'Different Name', host: '10.0.0.1', port: 9999);
  const c = BeaconDevice(id: 'iphone-2', name: 'iPhone', host: '192.168.1.11', port: 5001);

  group('BeaconDevice equality', () {
    test('same id → equal regardless of other fields', () {
      expect(a, equals(b));
    });

    test('different id → not equal', () {
      expect(a, isNot(equals(c)));
    });

    test('equal to itself', () {
      expect(a, equals(a));
    });
  });

  group('BeaconDevice hashCode', () {
    test('same id → same hashCode', () {
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different id → different hashCode (highly likely)', () {
      expect(a.hashCode, isNot(equals(c.hashCode)));
    });
  });

  group('BeaconDevice fields', () {
    test('stores all fields correctly', () {
      expect(a.id, 'mac-1');
      expect(a.name, 'MacBook');
      expect(a.host, '192.168.1.10');
      expect(a.port, 5000);
    });
  });

  group('BeaconDevice in collections', () {
    test('deduplication in Set works by id', () {
      final set = {a, b, c};
      expect(set.length, 2);
    });

    test('can be found by id in list', () {
      final devices = [a, c];
      expect(devices.any((d) => d.id == 'mac-1'), isTrue);
      expect(devices.any((d) => d.id == 'unknown'), isFalse);
    });
  });
}
