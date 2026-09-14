import 'package:beacon/base/extensions/context_ext.dart';
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
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      constraints: const BoxConstraints(minHeight: 600),
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

    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            isSend ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 18,
            color: isSend ? context.colors.primaryFixed : context.colorsExt.success,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        transfer.filename,
                        style: context.texts.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      transfer.formattedSize,
                      style: context.texts.bodySmall?.copyWith(color: context.colors.outlineVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (inProgress)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: transfer.progress,
                      minHeight: 3,
                      backgroundColor: context.colors.outline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation(context.colors.primaryFixed),
                    ),
                  )
                else
                  Row(
                    children: [
                      Text(
                        transfer.deviceName,
                        style: context.texts.bodySmall?.copyWith(color: context.colors.outlineVariant),
                      ),
                      const Spacer(),
                      _StatusIcon(status: transfer.status),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!_canReveal) return content;
    return InkWell(onTap: () => _showActions(context), child: content);
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
      TransferStatus.cancelled => Icon(Icons.cancel_outlined, size: 16, color: context.colors.outlineVariant),
      TransferStatus.pending || TransferStatus.inProgress => const SizedBox.shrink(),
    };
  }
}
