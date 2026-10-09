import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/utils/app_bottom_sheet.dart';
import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';

class TransferTile extends StatelessWidget {
  const TransferTile({super.key, required this.transfer});

  final FileTransfer transfer;

  bool get _canReveal =>
      transfer.direction == TransferDirection.receive &&
      transfer.status == TransferStatus.completed &&
      (transfer.savePath != null || transfer.savedUri != null);

  Future<void> _showActions(BuildContext context) async {
    await showAdaptiveBottomSheet<void>(
      context: context,
      minHeight: 600,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: Text(transfer.filename, style: sheetContext.texts.titleMedium, overflow: TextOverflow.ellipsis),
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: Text(sheetContext.tr.open_folder),
              onTap: () async {
                Navigator.of(sheetContext).pop();
                final ok = await HomeController.to.openTransferLocation(transfer);
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr.open_folder_failed)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSend = transfer.direction == TransferDirection.send;
    final inProgress = transfer.status == TransferStatus.inProgress;
    // Blue for leaving this device, green for arriving — the same pairing the
    // status dot and the check icon already use.
    final accent = isSend ? context.colors.primaryFixed : (context.colorsExt.success ?? context.colors.primaryFixed);

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSend ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              size: 18,
              color: accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(child: Text(transfer.filename, style: context.texts.bodyMedium, overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Text(
                      inProgress ? '${(transfer.progress * 100).round()}%' : transfer.formattedSize,
                      style: inProgress
                          ? context.texts.labelMedium?.copyWith(color: context.colors.primaryFixedDim)
                          : context.texts.bodySmall,
                    ),
                  ],
                ),
                if (inProgress) ...[
                  const SizedBox(height: 7),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: transfer.progress,
                      minHeight: 5,
                      backgroundColor: context.colors.outlineVariant,
                      valueColor: AlwaysStoppedAnimation(accent),
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                Text(_subtitle(context), style: context.texts.bodySmall, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (_canReveal)
            Icon(Icons.chevron_right_rounded, size: 20, color: context.colors.onSurfaceVariant)
          else
            _StatusIcon(status: transfer.status),
        ],
      ),
    );

    if (!_canReveal) return content;
    return InkWell(onTap: () => _showActions(context), child: content);
  }

  /// Where the file is going or came from, plus its size.
  String _subtitle(BuildContext context) {
    final name = transfer.deviceName;
    final isSend = transfer.direction == TransferDirection.send;
    final inProgress = transfer.status == TransferStatus.inProgress;

    final where = switch ((isSend, inProgress)) {
      (true, true) => context.tr.transfer_sending_to(name),
      (true, false) => context.tr.transfer_sent_to(name),
      (false, true) => context.tr.transfer_receiving_from(name),
      (false, false) => context.tr.transfer_received_from(name),
    };

    return inProgress ? '$where · ${transfer.formattedSize}' : where;
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final TransferStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      TransferStatus.completed => Icon(Icons.check_circle_outline, size: 16, color: context.colorsExt.success),
      TransferStatus.failed => Icon(Icons.error_outline, size: 16, color: context.colors.error),
      TransferStatus.cancelled => Icon(Icons.cancel_outlined, size: 16, color: context.colors.onSurfaceVariant),
      TransferStatus.pending || TransferStatus.inProgress => const SizedBox.shrink(),
    };
  }
}
