// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:beacon/gen/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

// ── Fake beacon ──────────────────────────────────────────────────────────────

class FakeBeaconService extends BeaconService {
  final _devicesCtrl = StreamController<List<BeaconDevice>>.broadcast();
  final _transferCtrl = StreamController<FileTransfer>.broadcast();

  int sendFileCallCount = 0;
  BeaconDevice? lastSendDevice;
  String? lastSendPath;

  @override
  Stream<List<BeaconDevice>> get devicesStream => _devicesCtrl.stream;

  @override
  Stream<FileTransfer> get transferStream => _transferCtrl.stream;

  @override
  List<BeaconDevice> get devices => [];

  @override
  Future<void> start(String deviceName) async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> sendFile(BeaconDevice device, String filePath) async {
    sendFileCallCount++;
    lastSendDevice = device;
    lastSendPath = filePath;
  }

  void emitDevices(List<BeaconDevice> list) => _devicesCtrl.add(list);
  void emitTransfer(FileTransfer t) => _transferCtrl.add(t);

  Future<void> closeStreams() async {
    await _devicesCtrl.close();
    await _transferCtrl.close();
  }
}

// ── Storage bootstrap ─────────────────────────────────────────────────────────

Future<void> initTestStorage() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  await AppStorage.init();
}

// ── GetIt helpers ─────────────────────────────────────────────────────────────

AppController registerAppController() {
  final ac = AppController();
  ac.onInit();
  GetIt.I.registerSingleton<AppController>(ac);
  return ac;
}

// ── Widget wrapper ────────────────────────────────────────────────────────────

Widget testApp(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

// ── Test data helpers ─────────────────────────────────────────────────────────

BeaconDevice makeDevice({String id = 'dev-1', String name = 'TestDevice'}) =>
    BeaconDevice(id: id, name: name, host: '192.168.1.10', port: 5000);

FileTransfer makeTransfer({String id = 'tx-1', TransferStatus status = TransferStatus.inProgress}) => FileTransfer(
  id: id,
  filename: 'photo.jpg',
  fileSize: 1024 * 1024,
  direction: TransferDirection.send,
  deviceName: 'TestDevice',
  status: status,
);
