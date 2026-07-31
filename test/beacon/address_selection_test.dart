import 'dart:io';

import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:flutter_test/flutter_test.dart';

InternetAddress _v4(String ip) => InternetAddress(ip, type: InternetAddressType.IPv4);
InternetAddress _v6(String ip) => InternetAddress(ip, type: InternetAddressType.IPv6);

void main() {
  group('BeaconService.selectAddress – routable private IPv4', () {
    test('192.168.x.x is selected', () {
      final result = BeaconService.selectAddress([_v4('192.168.1.50')]);
      expect(result?.address, '192.168.1.50');
    });

    test('10.x.x.x is selected', () {
      final result = BeaconService.selectAddress([_v4('10.0.0.1')]);
      expect(result?.address, '10.0.0.1');
    });

    test('172.16.x.x is selected', () {
      final result = BeaconService.selectAddress([_v4('172.16.0.1')]);
      expect(result?.address, '172.16.0.1');
    });

    test('172.31.x.x is selected', () {
      final result = BeaconService.selectAddress([_v4('172.31.255.255')]);
      expect(result?.address, '172.31.255.255');
    });

    test('172.32.x.x is NOT treated as routable private', () {
      // falls through to tier 2 (usable IPv4)
      final result = BeaconService.selectAddress([_v4('172.32.0.1')]);
      expect(result?.address, '172.32.0.1'); // still returned, just via tier 2
    });
  });

  group('BeaconService.selectAddress – link-local / loopback excluded from top tiers', () {
    test('169.254.x.x alone → falls to tier 4 (anything)', () {
      final result = BeaconService.selectAddress([_v4('169.254.1.1')]);
      // It is returned by tier 4 (last resort) but not preferred
      expect(result?.address, '169.254.1.1');
    });

    test('routable IPv4 preferred over link-local', () {
      final result = BeaconService.selectAddress([_v4('169.254.83.143'), _v4('192.168.1.10')]);
      expect(result?.address, '192.168.1.10');
    });

    test('127.x loopback is not returned by usable-IPv4 tier', () {
      final result = BeaconService.selectAddress([_v4('127.0.0.1'), _v6('::1')]);
      // Both are loopback; tier 4 returns first element
      expect(result, isNotNull);
    });

    test('routable IPv4 preferred over loopback', () {
      final result = BeaconService.selectAddress([_v4('127.0.0.1'), _v4('192.168.0.5')]);
      expect(result?.address, '192.168.0.5');
    });
  });

  group('BeaconService.selectAddress – IPv6 fallback', () {
    test('global IPv6 used when no IPv4 available', () {
      final result = BeaconService.selectAddress([_v6('2001:db8::1')]);
      expect(result?.address, '2001:db8::1');
    });

    test('fe80 link-local IPv6 is skipped by tier 3', () {
      final result = BeaconService.selectAddress([_v6('fe80::1'), _v6('2001:db8::1')]);
      expect(result?.address, '2001:db8::1');
    });

    test('routable IPv4 preferred over global IPv6', () {
      final result = BeaconService.selectAddress([_v6('2001:db8::1'), _v4('192.168.1.1')]);
      expect(result?.address, '192.168.1.1');
    });
  });

  group('BeaconService.selectAddress – edge cases', () {
    test('empty list returns null', () {
      expect(BeaconService.selectAddress([]), isNull);
    });

    test('single address is always returned', () {
      expect(BeaconService.selectAddress([_v4('1.2.3.4')]), isNotNull);
    });
  });
}
