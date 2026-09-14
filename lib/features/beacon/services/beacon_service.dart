import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beacon/base/utils/env.dart';
import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:nsd/nsd.dart' as nsd;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sdk_helpers/sdk_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

const String _kServiceType = '_beacon._tcp';

enum BeaconStatus { stopped, starting, running, error }

// Wire protocol (both directions keep the same framing):
//
//   SENDER → RECEIVER
//   [4 B, big-endian uint32]  filename length
//   [N bytes]                 filename (UTF-8)
//   [8 B, big-endian uint64]  file size in bytes
//   [file size bytes]         file data
//
//   RECEIVER → SENDER  (after file is flushed to disk)
//   [1 B]  0x01 = OK

@singleton
class BeaconService with LoggerMixin {
  ServerSocket? _server;
  nsd.Discovery? _discovery;
  nsd.Registration? _registration;
  String? _localServiceName;

  int _idCounter = 0;
  String _nextId() => '${DateTime.now().millisecondsSinceEpoch}_${_idCounter++}';

  final _mediaStore = MediaStore();
  static const _filesChannel = MethodChannel('com.beacon/files');
  bool _mediaStoreReady = false;

  Future<void> _ensureMediaStore() async {
    if (_mediaStoreReady) return;
    MediaStore.appFolder = Env.folderName;
    await MediaStore.ensureInitialized();
    _mediaStoreReady = true;
  }

  final _devicesController = StreamController<List<BeaconDevice>>.broadcast();
  final _transferController = StreamController<FileTransfer>.broadcast();
  final _statusController = StreamController<BeaconStatus>.broadcast();
  final List<BeaconDevice> _devices = [];
  BeaconStatus _status = BeaconStatus.stopped;

  Stream<List<BeaconDevice>> get devicesStream => _devicesController.stream;
  Stream<FileTransfer> get transferStream => _transferController.stream;
  Stream<BeaconStatus> get statusStream => _statusController.stream;
  List<BeaconDevice> get devices => List.unmodifiable(_devices);
  BeaconStatus get status => _status;

  int get port => _server?.port ?? 0;

  // Serialises start/stop so overlapping callers (e.g. onInit racing with the
  // initial AppLifecycleState.resumed) can't produce two registrations.
  Future<void>? _pending;

  void _setStatus(BeaconStatus next) {
    if (_status == next) return;
    _status = next;
    _statusController.add(next);
  }

  Future<void> start(String deviceName) async {
    // Wait for any in-flight start/stop to settle first.
    await _pending;
    // Idempotent: already running (or mid-start that just finished) → no-op.
    if (_status == BeaconStatus.running || _status == BeaconStatus.starting) return;

    final completer = Completer<void>();
    _pending = completer.future;
    try {
      _setStatus(BeaconStatus.starting);

      final sanitized = deviceName.replaceAll(RegExp(r'\s+'), '-');
      final requested = sanitized.substring(0, sanitized.length.clamp(0, 63));

      _server = await ServerSocket.bind(InternetAddress.anyIPv4, 0);
      _server!.listen((socket) {
        _handleIncoming(socket).catchError((Object error, StackTrace st) {
          e('Uncaught incoming error', error: error, stackTrace: st);
        });
      });

      _registration = await nsd.register(nsd.Service(name: requested, type: _kServiceType, port: _server!.port));
      // iOS / mDNS may change the advertised name (collision suffix, escapes).
      // Use what was actually registered so self-filtering works.
      _localServiceName = _registration!.service.name ?? requested;

      // Cache our own interface addresses so we can recognise self even if
      // mDNS hands back the advertisement under a different name variant.
      await _refreshLocalAddresses();

      // IpLookupType.any returns both v4 and v6, we prefer v4 when selecting.
      _discovery = await nsd.startDiscovery(_kServiceType, ipLookupType: nsd.IpLookupType.any);
      _discovery!.addServiceListener(_onServiceChanged);

      _setStatus(BeaconStatus.running);
    } catch (_) {
      _setStatus(BeaconStatus.error);
      // Clean up any half-initialised resources so a retry can succeed.
      await _teardown();
      rethrow;
    } finally {
      completer.complete();
      if (identical(_pending, completer.future)) _pending = null;
    }
  }

  final Set<String> _localAddresses = {};

  Future<void> _refreshLocalAddresses() async {
    _localAddresses.clear();
    try {
      final interfaces = await NetworkInterface.list(includeLoopback: true, includeLinkLocal: true);
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          _localAddresses.add(addr.address);
        }
      }
    } catch (err) {
      w('Could not list local interfaces: $err');
    }
  }

  Future<void> stop() async {
    await _pending;
    if (_status == BeaconStatus.stopped) return;

    final completer = Completer<void>();
    _pending = completer.future;
    try {
      await _teardown();
      _setStatus(BeaconStatus.stopped);
    } finally {
      completer.complete();
      if (identical(_pending, completer.future)) _pending = null;
    }
  }

  Future<void> _teardown() async {
    if (_discovery != null) {
      try {
        await nsd.stopDiscovery(_discovery!);
      } catch (_) {}
      _discovery = null;
    }
    if (_registration != null) {
      try {
        await nsd.unregister(_registration!);
      } catch (_) {}
      _registration = null;
    }
    try {
      await _server?.close();
    } catch (_) {}
    _server = null;
    _localServiceName = null;
    _localAddresses.clear();
    _devices.clear();
    _devicesController.add(const []);
  }

  // Normalize so variations from mDNS (trailing dot, case, whitespace) don't
  // produce different ids — or fool the self-filter.
  static String _normalize(String name) =>
      name.trim().toLowerCase().replaceAll(RegExp(r'\.local\.?$'), '').replaceAll(RegExp(r'\.$'), '');

  bool _isSelf(nsd.Service service) {
    final name = service.name;
    if (name != null && _localServiceName != null && _normalize(name) == _normalize(_localServiceName!)) {
      return true;
    }
    // Same port as our ServerSocket → it's us, regardless of what mDNS named it.
    if (service.port != null && service.port == _server?.port) return true;
    // Any of the advertised addresses belongs to one of our local interfaces.
    final addresses = service.addresses;
    if (addresses != null) {
      for (final a in addresses) {
        if (_localAddresses.contains(a.address)) return true;
      }
    }
    return false;
  }

  void _onServiceChanged(nsd.Service service, nsd.ServiceStatus status) {
    if (service.name == null || _isSelf(service)) return;
    final id = _normalize(service.name!);

    if (status == nsd.ServiceStatus.found) {
      final addresses = service.addresses;
      if (addresses == null || addresses.isEmpty || service.port == null) {
        w('Discovered "${service.name}" but no address/port – skipping');
        return;
      }

      final addr = _selectAddress(addresses);
      if (addr == null) {
        w('"${service.name}" has no routable address – skipping');
        return;
      }

      final device = BeaconDevice(id: id, name: service.name!, host: addr.address, port: service.port!);

      final idx = _devices.indexWhere((d) => d.id == device.id);
      if (idx >= 0) {
        if (_devices[idx] == device) return;
        _devices[idx] = device;
      } else {
        log('Found device: ${device.name} @ ${device.host}:${device.port}');
        _devices.add(device);
      }
      _devicesController.add(List.unmodifiable(_devices));
    } else if (status == nsd.ServiceStatus.lost) {
      w('Lost device: ${service.name}');
      final before = _devices.length;
      _devices.removeWhere((d) => d.id == id);
      if (_devices.length != before) {
        _devicesController.add(List.unmodifiable(_devices));
      }
    }
  }

  Future<void> _handleIncoming(Socket socket) async {
    final reader = _SocketReader(socket);
    FileTransfer? transfer;
    IOSink? fileSink;
    String? savePath;

    try {
      // ── Read header ───────────────────────────────────────────────
      final nameLenBuf = await reader.read(4);
      final nameLen = ByteData.view(Uint8List.fromList(nameLenBuf).buffer).getUint32(0, Endian.big);

      final nameBytes = await reader.read(nameLen);
      final filename = utf8.decode(nameBytes);

      final sizeBuf = await reader.read(8);
      final fileSize = ByteData.view(Uint8List.fromList(sizeBuf).buffer).getUint64(0, Endian.big);

      log(
        'Receiving "$filename" (${_fmt(fileSize)}) '
        'from ${socket.remoteAddress.address}',
      );

      if (fileSize == 0) throw StateError('Received file size is 0');

      FileTransfer t = FileTransfer(
        id: _nextId(),
        filename: filename,
        fileSize: fileSize,
        direction: TransferDirection.receive,
        deviceName: socket.remoteAddress.address,
        status: TransferStatus.inProgress,
      );
      transfer = t;
      _transferController.add(t);

      // ── Save file ─────────────────────────────────────────────────
      if (Platform.isAndroid) {
        await _ensureMediaStore();
        final tmp = await getTemporaryDirectory();
        savePath = p.join(tmp.path, filename);
      } else {
        final saveDir = await _saveDirectory();
        savePath = p.join(saveDir.path, filename);
      }
      fileSink = File(savePath).openWrite();

      int received = 0;
      DateTime lastEmit = DateTime.now();

      while (received < fileSize) {
        final remaining = fileSize - received;
        final chunk = await reader.read(remaining < 65536 ? remaining : 65536);
        fileSink.add(chunk);
        received += chunk.length;

        final now = DateTime.now();
        if (now.difference(lastEmit).inMilliseconds > 80 || received == fileSize) {
          t = t.copyWith(progress: received / fileSize);
          transfer = t;
          _transferController.add(t);
          lastEmit = now;
        }
      }

      log('All bytes received, flushing to disk…');
      await fileSink.flush();
      await fileSink.close();
      fileSink = null;

      String? savedUri;
      if (Platform.isAndroid) {
        final info = await _mediaStore.saveFile(
          tempFilePath: savePath,
          dirType: DirType.download,
          dirName: DirName.download,
        );
        log('MediaStore saved: $info');
        savedUri = info?.uri.toString();
        savePath = null; // MediaStore deletes the temp file
      }

      log('Saved "$filename" → Downloads/Beacon – sending ACK');

      // ── Send ACK to confirm successful receipt ─────────────────────
      socket.add([0x01]);
      await socket.flush();

      _transferController.add(
        t.copyWith(progress: 1.0, status: TransferStatus.completed, savePath: savePath, savedUri: savedUri),
      );
    } catch (e, st) {
      log('Receive error: $e\n$st');
      if (transfer != null) {
        _transferController.add(transfer.copyWith(status: TransferStatus.failed));
      }
      // Clean up partial file
      if (savePath != null) {
        try {
          await File(savePath).delete();
        } catch (_) {}
      }
      // No ACK → sender will detect connection close and mark failed
    } finally {
      await fileSink?.close();
      await socket.close();
      reader.dispose();
    }
  }

  Future<void> sendFile(BeaconDevice device, String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      w('sendFile: file not found – $filePath');
      return;
    }

    final fileSize = await file.length();
    final filename = p.basename(filePath);

    var transfer = FileTransfer(
      id: _nextId(),
      filename: filename,
      fileSize: fileSize,
      direction: TransferDirection.send,
      deviceName: device.name,
      status: TransferStatus.inProgress,
    );
    _transferController.add(transfer);

    Socket? socket;
    try {
      log('Connecting to ${device.name} @ ${device.host}:${device.port}');
      socket = await Socket.connect(device.host, device.port, timeout: const Duration(seconds: 10));

      // ── Register ACK listener BEFORE sending anything ─────────────
      // We must subscribe before data is in flight so we cannot miss the
      // 0x01 byte the receiver sends after flushing the file to disk.
      final ackCompleter = Completer<bool>();
      socket.listen(
        (data) {
          if (!ackCompleter.isCompleted) {
            ackCompleter.complete(data.isNotEmpty && data[0] == 0x01);
          }
        },
        onDone: () {
          if (!ackCompleter.isCompleted) ackCompleter.complete(false);
        },
        onError: (Object e) {
          if (!ackCompleter.isCompleted) ackCompleter.complete(false);
        },
      );

      // ── Send header ───────────────────────────────────────────────
      final nameBytes = utf8.encode(filename);
      final header = BytesBuilder();
      header.add((ByteData(4)..setUint32(0, nameBytes.length, Endian.big)).buffer.asUint8List());
      header.add(nameBytes);
      header.add((ByteData(8)..setUint64(0, fileSize, Endian.big)).buffer.asUint8List());
      socket.add(header.toBytes());

      // ── Stream file data ─────────────────────────────────────────
      int sent = 0;
      DateTime lastEmit = DateTime.now();

      await for (final chunk in file.openRead()) {
        socket.add(chunk);
        sent += chunk.length;

        final now = DateTime.now();
        if (now.difference(lastEmit).inMilliseconds > 80 || sent == fileSize) {
          transfer = transfer.copyWith(progress: sent / fileSize);
          _transferController.add(transfer);
          lastEmit = now;
        }
      }

      await socket.flush();

      // ── Wait for receiver ACK (up to 60 s for large files + slow disks)
      log('Waiting for ACK from ${device.name}…');
      final ackOk = await ackCompleter.future.timeout(const Duration(seconds: 60), onTimeout: () => false);

      if (!ackOk) throw Exception('Receiver did not confirm the transfer');

      log('ACK received – "$filename" delivered to ${device.name}');
      _transferController.add(transfer.copyWith(progress: 1.0, status: TransferStatus.completed));
    } catch (error, st) {
      e('Send error', error: error, stackTrace: st);
      _transferController.add(transfer.copyWith(status: TransferStatus.failed));
    } finally {
      await socket?.close();
    }
  }

  /// Picks the best address from an mDNS service's address list.
  ///
  /// Priority (highest → lowest):
  ///   1. Routable private IPv4 (10.x / 172.16–31.x / 192.168.x)
  ///   2. Any non-link-local, non-loopback IPv4
  ///   3. Non-link-local IPv6 (not fe80::)
  ///   4. Whatever is left
  ///
  /// 169.254.x.x (APIPA/link-local) and 127.x (loopback) are excluded from
  /// the first two tiers because they are not reachable across devices.
  @visibleForTesting
  static InternetAddress? selectAddress(List<InternetAddress> addresses) => _selectAddress(addresses);

  static InternetAddress? _selectAddress(List<InternetAddress> addresses) {
    bool isRoutableV4(InternetAddress a) {
      if (a.type != InternetAddressType.IPv4) return false;
      final ip = a.address;
      return (ip.startsWith('10.') || ip.startsWith('192.168.') || RegExp(r'^172\.(1[6-9]|2\d|3[01])\.').hasMatch(ip));
    }

    bool isUsableV4(InternetAddress a) {
      if (a.type != InternetAddressType.IPv4) return false;
      final ip = a.address;
      return !ip.startsWith('127.') && !ip.startsWith('169.254.');
    }

    // 1. Routable private IPv4
    final routable = addresses.where(isRoutableV4).toList();
    if (routable.isNotEmpty) return routable.first;

    // 2. Any usable IPv4
    final usable = addresses.where(isUsableV4).toList();
    if (usable.isNotEmpty) return usable.first;

    // 3. Global IPv6
    final v6 = addresses
        .where((a) => a.type == InternetAddressType.IPv6 && !a.address.startsWith('fe80') && a.address != '::1')
        .toList();
    if (v6.isNotEmpty) return v6.first;

    // 4. Anything
    return addresses.isNotEmpty ? addresses.first : null;
  }

  /// Reveals the folder where a received file was saved in the OS file browser.
  ///
  /// - iOS: opens Files.app at the app's Documents/Beacon folder (requires
  ///   `UIFileSharingEnabled` + `LSSupportsOpeningDocumentsInPlace`).
  /// - Android: opens Download/Beacon in the system Files app via a platform
  ///   channel (see MainActivity.kt), falling back to the MediaStore entry
  ///   for the received file.
  /// - Desktop: opens the save folder in the OS file manager.
  Future<bool> openSaveLocation(FileTransfer transfer) async {
    try {
      if (Platform.isIOS) {
        final dir = await _saveDirectory();
        final uri = Uri(scheme: 'shareddocuments', path: dir.path);
        return await launchUrl(uri);
      }
      if (Platform.isAndroid) {
        final opened = await _filesChannel.invokeMethod<bool>('openDownloadsFolder', {'folder': Env.folderName});
        if (opened == true) return true;
        if (transfer.savedUri == null) return false;
        return await launchUrl(Uri.parse(transfer.savedUri!), mode: LaunchMode.externalApplication);
      }
      final dir = await _saveDirectory();
      return await launchUrl(Uri.file(dir.path));
    } catch (err, st) {
      e('openSaveLocation failed', error: err, stackTrace: st);
      return false;
    }
  }

  Future<Directory> _saveDirectory() async {
    // Helper: creates <base>/Beacon/, returns null if anything fails.
    Future<Directory?> tryMake(Directory base) async {
      try {
        final sub = Directory(p.join(base.path, 'Beacon'));
        await sub.create(recursive: true);
        log('Save directory: ${sub.path}');
        return sub;
      } catch (error) {
        e('Could not use ${base.path}', error: error);
        return null;
      }
    }

    // On iOS the Downloads path is outside the app sandbox and not writable.
    // Always use the app's Documents directory on iOS.
    if (!Platform.isIOS) {
      try {
        final dl = await getDownloadsDirectory();
        if (dl != null) {
          final dir = await tryMake(dl);
          if (dir != null) return dir;
        }
      } catch (_) {}
    }

    final docs = await getApplicationDocumentsDirectory();
    return await tryMake(docs) ?? docs;
  }

  String _fmt(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Buffers bytes from a [Socket] and exposes a typed [read] method that
/// awaits until the requested number of bytes is available.
class _SocketReader {
  _SocketReader(Socket socket) {
    _sub = socket.listen(
      (data) {
        _buf.addAll(data);
        _wake();
      },
      onDone: () {
        _closed = true;
        _wake();
      },
      onError: (Object e) {
        _err = e;
        _closed = true;
        _wake();
      },
    );
  }

  late final StreamSubscription<List<int>> _sub;
  final List<int> _buf = [];
  bool _closed = false;
  Object? _err;
  Completer<void>? _pending;

  void _wake() {
    final c = _pending;
    _pending = null;
    c?.complete();
  }

  Future<List<int>> read(int count) async {
    while (_buf.length < count) {
      if (_err != null) throw _err!;
      if (_closed) throw StateError('Connection closed ($count bytes expected)');
      _pending = Completer<void>();
      await _pending!.future;
    }
    final result = _buf.sublist(0, count);
    _buf.removeRange(0, count);
    return result;
  }

  void dispose() => _sub.cancel();
}
