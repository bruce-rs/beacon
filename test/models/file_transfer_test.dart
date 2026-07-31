import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FileTransfer.formattedSize', () {
    FileTransfer make(int size) =>
        FileTransfer(id: '1', filename: 'f', fileSize: size, direction: TransferDirection.send, deviceName: 'dev');

    test('bytes when under 1 KB', () {
      expect(make(0).formattedSize, '0 B');
      expect(make(512).formattedSize, '512 B');
      expect(make(1023).formattedSize, '1023 B');
    });

    test('kilobytes between 1 KB and 1 MB', () {
      expect(make(1024).formattedSize, '1.0 KB');
      expect(make(1536).formattedSize, '1.5 KB');
      expect(make(1024 * 1024 - 1).formattedSize, endsWith('KB'));
    });

    test('megabytes between 1 MB and 1 GB', () {
      expect(make(1024 * 1024).formattedSize, '1.0 MB');
      expect(make(1024 * 1024 * 2).formattedSize, '2.0 MB');
      expect(make(1024 * 1024 * 1024 - 1).formattedSize, endsWith('MB'));
    });

    test('gigabytes at or above 1 GB', () {
      expect(make(1024 * 1024 * 1024).formattedSize, '1.00 GB');
      expect(make(1024 * 1024 * 1024 * 2).formattedSize, '2.00 GB');
    });
  });

  group('FileTransfer.copyWith', () {
    late FileTransfer base;

    setUp(() {
      base = FileTransfer(
        id: 'abc',
        filename: 'photo.jpg',
        fileSize: 2048,
        direction: TransferDirection.receive,
        deviceName: 'iPhone',
        progress: 0.3,
        status: TransferStatus.inProgress,
      );
    });

    test('updates progress only', () {
      final updated = base.copyWith(progress: 0.9);
      expect(updated.progress, 0.9);
      expect(updated.status, TransferStatus.inProgress);
      expect(updated.id, 'abc');
      expect(updated.filename, 'photo.jpg');
    });

    test('updates status only', () {
      final updated = base.copyWith(status: TransferStatus.completed);
      expect(updated.status, TransferStatus.completed);
      expect(updated.progress, 0.3);
    });

    test('updates both progress and status', () {
      final updated = base.copyWith(progress: 1.0, status: TransferStatus.completed);
      expect(updated.progress, 1.0);
      expect(updated.status, TransferStatus.completed);
    });

    test('preserves all identity fields', () {
      final updated = base.copyWith(progress: 0.5);
      expect(updated.id, base.id);
      expect(updated.filename, base.filename);
      expect(updated.fileSize, base.fileSize);
      expect(updated.direction, base.direction);
      expect(updated.deviceName, base.deviceName);
      expect(updated.startedAt, base.startedAt);
    });
  });

  group('FileTransfer defaults', () {
    test('initial progress is 0.0 and status is pending', () {
      final t = FileTransfer(
        id: 'x',
        filename: 'doc.pdf',
        fileSize: 100,
        direction: TransferDirection.send,
        deviceName: 'Mac',
      );
      expect(t.progress, 0.0);
      expect(t.status, TransferStatus.pending);
    });

    test('startedAt is set automatically', () {
      final before = DateTime.now();
      final t = FileTransfer(id: 'x', filename: 'f', fileSize: 1, direction: TransferDirection.send, deviceName: 'd');
      expect(t.startedAt.isAfter(before) || t.startedAt.isAtSameMomentAs(before), isTrue);
    });
  });
}
