import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../helpers/test_setup.dart';

// Suppresses showError crashes (AppRouter.to.appContext is null in unit tests).
class _FakeHomeController extends HomeController {
  _FakeHomeController(super.beacon);

  final errors = <String>[];

  @override
  void showError(String message, {BuildContext? context}) => errors.add(message);
}

void main() {
  late FakeBeaconService beacon;
  late _FakeHomeController ctrl;

  setUpAll(() async {
    await initTestStorage();
  });

  setUp(() async {
    beacon = FakeBeaconService();
    ctrl = _FakeHomeController(beacon);
    ctrl.onInit();
    ctrl.isInitialized = true;
  });

  tearDown(() async {
    ctrl.onClose();
    await beacon.closeStreams();
    GetIt.I.reset();
  });

  // ── selectDevice ────────────────────────────────────────────────────────────

  group('selectDevice', () {
    test('selects a device', () {
      final d = makeDevice();
      ctrl.selectDevice(d);
      expect(ctrl.selectedDevice.value, d);
    });

    test('deselects when tapping the same device again', () {
      final d = makeDevice();
      ctrl.selectDevice(d);
      ctrl.selectDevice(d);
      expect(ctrl.selectedDevice.value, isNull);
    });

    test('switches to a different device', () {
      final a = makeDevice(id: 'a', name: 'A');
      final b = makeDevice(id: 'b', name: 'B');
      ctrl.selectDevice(a);
      ctrl.selectDevice(b);
      expect(ctrl.selectedDevice.value, b);
    });
  });

  // ── transfer stream handling ────────────────────────────────────────────────

  group('transfer stream', () {
    Future<void> emit(FileTransfer t) async {
      beacon.emitTransfer(t);
      await Future<void>.microtask(() {});
    }

    test('new transfer is inserted at index 0', () async {
      await emit(makeTransfer(id: 'tx-1'));
      expect(ctrl.transfers.length, 1);
      expect(ctrl.transfers[0].id, 'tx-1');
    });

    test('newer transfer is prepended before older one', () async {
      await emit(makeTransfer(id: 'tx-1'));
      await emit(makeTransfer(id: 'tx-2'));
      expect(ctrl.transfers[0].id, 'tx-2');
      expect(ctrl.transfers[1].id, 'tx-1');
    });

    test('existing transfer is updated in-place by id', () async {
      await emit(makeTransfer(id: 'tx-1', status: TransferStatus.inProgress));
      await emit(makeTransfer(id: 'tx-1', status: TransferStatus.completed));
      expect(ctrl.transfers.length, 1);
      expect(ctrl.transfers[0].status, TransferStatus.completed);
    });

    test('update preserves list order', () async {
      await emit(makeTransfer(id: 'tx-1'));
      await emit(makeTransfer(id: 'tx-2'));
      await emit(makeTransfer(id: 'tx-1', status: TransferStatus.failed));
      // tx-2 at 0, tx-1 at 1 (order from insertion), tx-1 updated in-place
      expect(ctrl.transfers[0].id, 'tx-2');
      expect(ctrl.transfers[1].id, 'tx-1');
      expect(ctrl.transfers[1].status, TransferStatus.failed);
    });
  });

  // ── sendFiles ───────────────────────────────────────────────────────────────

  group('sendFiles', () {
    test('does not send when no device is selected', () async {
      ctrl.selectedDevice.value = null;
      await ctrl.sendFiles(['/tmp/file.txt']);
      expect(beacon.sendFileCallCount, 0);
    });

    test('shows error when no device is selected', () async {
      ctrl.selectedDevice.value = null;
      await ctrl.sendFiles(['/tmp/file.txt']);
      expect(ctrl.errors, isNotEmpty);
    });

    test('calls sendFile for each path when a device is selected', () async {
      ctrl.selectedDevice.value = makeDevice();
      await ctrl.sendFiles(['/tmp/a.txt', '/tmp/b.png']);
      expect(beacon.sendFileCallCount, 2);
    });

    test('passes the correct device and path', () async {
      final device = makeDevice(name: 'MyMac');
      ctrl.selectedDevice.value = device;
      await ctrl.sendFiles(['/tmp/doc.pdf']);
      expect(beacon.lastSendDevice, device);
      expect(beacon.lastSendPath, '/tmp/doc.pdf');
    });
  });

  // ── device stream ───────────────────────────────────────────────────────────

  group('device stream', () {
    test('devices list is updated from beacon stream', () async {
      final devices = [makeDevice(id: 'a'), makeDevice(id: 'b')];
      beacon.emitDevices(devices);
      await Future<void>.microtask(() {});
      expect(ctrl.devices.length, 2);
    });

    test('devices list is cleared when beacon emits empty list', () async {
      beacon.emitDevices([makeDevice()]);
      await Future<void>.microtask(() {});
      beacon.emitDevices([]);
      await Future<void>.microtask(() {});
      expect(ctrl.devices, isEmpty);
    });
  });
}
