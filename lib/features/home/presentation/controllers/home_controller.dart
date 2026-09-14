import 'dart:io';

import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
class HomeController extends BaseController with WidgetsBindingObserver {
  HomeController(this._beacon);

  final BeaconService _beacon;

  static HomeController get to => GetIt.I<HomeController>();

  final devices = RxList<BeaconDevice>([]);
  final transfers = RxList<FileTransfer>([]);
  final selectedDevice = Rx<BeaconDevice?>(null);
  final status = Rx<BeaconStatus>(BeaconStatus.stopped);

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _beacon.devicesStream.listen((list) => devices.assignAll(list));
    _beacon.transferStream.listen(_onTransfer);
    _beacon.statusStream.listen((s) => status.value = s);
    _startBeacon();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _beacon.stop();
    super.onClose();
  }

  bool _wasPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only restart after a real background → foreground transition; the
    // initial `resumed` event on launch would otherwise race with onInit.
    if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _wasPaused = true;
    } else if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      _beacon.stop().whenComplete(_startBeacon);
    }
  }

  Future<void> _startBeacon() async {
    try {
      await _beacon.start(await _localName);
    } catch (err) {
      showError('Beacon failed to start: $err');
    }
  }

  Future<String> get _localName async {
    String name = Platform.localHostname;
    if (name.endsWith('.local')) name = name.substring(0, name.length - 6);
    // iOS often returns 'localhost' or empty — fall back to a friendly label.
    if (name.isEmpty || name == 'localhost') {
      name = 'Beacon-${Platform.operatingSystem}';
    }
    // Append a stable per-device id so two devices with the same label
    // (e.g. both iOS) don't collide and get auto-renamed by mDNS.
    final id = await _platformDeviceId();
    return id != null ? '$name-$id' : name;
  }

  Future<String?> _platformDeviceId() async {
    final info = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) return _shorten((await info.iosInfo).identifierForVendor);
      if (Platform.isAndroid) return _shorten((await info.androidInfo).id);
      if (Platform.isMacOS) return _shorten((await info.macOsInfo).systemGUID);
      if (Platform.isWindows) return _shorten((await info.windowsInfo).deviceId);
      if (Platform.isLinux) return _shorten((await info.linuxInfo).machineId);
    } catch (err) {
      w('Failed to read device id: $err');
    }
    return null;
  }

  String? _shorten(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final cleaned = raw.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toLowerCase();
    if (cleaned.isEmpty) return null;
    return cleaned.substring(0, cleaned.length.clamp(0, 8));
  }

  void _onTransfer(FileTransfer t) {
    final idx = transfers.indexWhere((x) => x.id == t.id);
    if (idx >= 0) {
      transfers[idx] = t;
    } else {
      transfers.insert(0, t);
    }
  }

  void selectDevice(BeaconDevice device) {
    if (selectedDevice.value?.id == device.id) {
      selectedDevice.value = null;
    } else {
      selectedDevice.value = device;
    }
  }

  Future<void> sendFiles(List<String> paths) async {
    final device = selectedDevice.value;
    if (device == null) {
      showError('Select a device first');
      return;
    }
    for (final path in paths) {
      await _beacon.sendFile(device, path);
    }
  }

  Future<bool> openTransferLocation(FileTransfer transfer) => _beacon.openSaveLocation(transfer);

  Future<void> pickAndSendFiles() async {
    final device = selectedDevice.value;
    if (device == null) {
      showError('Select a device first');
      return;
    }

    final files = await FilePicker.pickFiles();
    if (files.isEmpty) return;

    final paths = files.map((f) => f.path).whereType<String>().toList();
    await sendFiles(paths);
  }
}
