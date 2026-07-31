enum TransferDirection { send, receive }

enum TransferStatus { pending, inProgress, completed, failed, cancelled }

class FileTransfer {
  FileTransfer({
    required this.id,
    required this.filename,
    required this.fileSize,
    required this.direction,
    required this.deviceName,
    this.progress = 0.0,
    this.status = TransferStatus.pending,
    this.savePath,
    this.savedUri,
    DateTime? startedAt,
  }) : startedAt = startedAt ?? DateTime.now();

  final String id;
  final String filename;
  final int fileSize;
  final TransferDirection direction;
  final String deviceName;
  final DateTime startedAt;
  double progress;
  TransferStatus status;

  /// Absolute filesystem path of the saved file (iOS/macOS/Linux/Windows receives,
  /// and sender-side source files). Null on Android where files go through MediaStore.
  final String? savePath;

  /// MediaStore content:// URI for received files on Android.
  final String? savedUri;

  FileTransfer copyWith({double? progress, TransferStatus? status, String? savePath, String? savedUri}) {
    return FileTransfer(
      id: id,
      filename: filename,
      fileSize: fileSize,
      direction: direction,
      deviceName: deviceName,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      savePath: savePath ?? this.savePath,
      savedUri: savedUri ?? this.savedUri,
      startedAt: startedAt,
    );
  }

  String get formattedSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
