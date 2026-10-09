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
    _beacon.devicesStream.listen(_onDevices);
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
    if (state == AppLifecycleState.detached) {
      // Leaving a live registration behind makes the next launch collide with
      // it and get renamed ("name (2)").
      _beacon.stop();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      _wasPaused = true;
    } else if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      _beacon.stop().whenComplete(_startBeacon);
    }
  }

  Future<void> _startBeacon() async {
    try {
      await _beacon.start(await _localName, deviceId: await _stableDeviceId);
    } catch (err) {
      showError('Beacon failed to start: $err');
    }
  }

  /// A human-readable name for this device, advertised over mDNS.
  ///
  /// Platform sources, best first:
  /// - Android: `Settings.Global.DEVICE_NAME` (the name the user set).
  /// - iOS: the user-assigned name; iOS 16+ returns a generic "iPhone" unless
  ///   the app has the user-assigned-device-name entitlement, so fall back to
  ///   the marketing model name ("iPhone 16 Pro").
  /// - macOS/Windows: the computer name.
  /// - Otherwise: the hostname.
  ///
  /// Names need not be unique; mDNS appends a suffix when two collide.
  Future<String> get _localName async {
    final info = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final android = await info.androidInfo;
        return _pick([android.name, '${android.manufacturer} ${android.model}']);
      }
      if (Platform.isIOS) {
        final ios = await info.iosInfo;
        // "iPhone"/"iPad" means iOS withheld the user-assigned name.
        final isGeneric = const {'iphone', 'ipad', 'ipod touch'}.contains(ios.name.trim().toLowerCase());
        return isGeneric ? _pick([ios.modelName, ios.name]) : _pick([ios.name, ios.modelName]);
      }
      if (Platform.isMacOS) return _pick([(await info.macOsInfo).computerName, _hostname]);
      if (Platform.isWindows) return _pick([(await info.windowsInfo).computerName, _hostname]);
    } catch (err) {
      w('Failed to read device name: $err');
    }
    return _hostname;
  }

  /// A stable per-install id, advertised so peers recognise this device across
  /// relaunches regardless of the mDNS instance name.
  Future<String?> get _stableDeviceId async {
    final info = DeviceInfoPlugin();
    try {
      if (Platform.isIOS) return (await info.iosInfo).identifierForVendor;
      if (Platform.isAndroid) return (await info.androidInfo).id;
      if (Platform.isMacOS) return (await info.macOsInfo).systemGUID;
      if (Platform.isWindows) return (await info.windowsInfo).deviceId;
      if (Platform.isLinux) return (await info.linuxInfo).machineId;
    } catch (err) {
      w('Failed to read device id: $err');
    }
    return null;
  }

  String get _hostname {
    String name = Platform.localHostname;
    if (name.endsWith('.local')) name = name.substring(0, name.length - 6);
    if (name.isEmpty || name == 'localhost') name = 'Beacon-${Platform.operatingSystem}';
    return name;
  }

  /// First non-blank candidate, or a platform-tagged fallback.
  String _pick(List<String?> candidates) {
    for (final candidate in candidates) {
      final trimmed = candidate?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return 'Beacon-${Platform.operatingSystem}';
  }

  void _onDevices(List<BeaconDevice> list) {
    devices.assignAll(list);

    // A selected device that left the network would otherwise stay highlighted
    // and be sent to. Drop the selection; the user can pick it again when it
    // comes back (possibly on a new port, hence the lookup in `_liveSelection`).
    final selected = selectedDevice.value;
    if (selected != null && !list.any((d) => d.id == selected.id)) {
      selectedDevice.value = null;
    }
  }

  /// The selected device as currently advertised, or null if it is gone.
  ///
  /// Re-announcements can change host/port, and [BeaconDevice] equality is
  /// id-based, so the stored selection can hold a stale endpoint.
  BeaconDevice? get _liveSelection {
    final selected = selectedDevice.value;
    if (selected == null) return null;
    return devices.firstWhereOrNull((d) => d.id == selected.id) ?? selected;
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
    final device = _liveSelection;
    if (device == null) {
      showError('Select a device first');
      return;
    }
    for (final path in paths) {
      await _beacon.sendFile(device, path);
    }
  }

  Future<bool> openTransferLocation(FileTransfer transfer) => _beacon.openSaveLocation(transfer);

  /// Removes the row from the list only; the file on disk is left alone.
  void removeTransfer(FileTransfer transfer) => transfers.removeWhere((t) => t.id == transfer.id);

  Future<void> pickAndSendFiles() async {
    final device = _liveSelection;
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
