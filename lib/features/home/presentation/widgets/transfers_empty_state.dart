import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// Fills the transfers area before anything has been sent or received, so the
/// lower half of the first run reads as "nothing here yet" rather than broken.
class TransfersEmptyState extends StatelessWidget {
  const TransfersEmptyState({super.key, this.onOpenFolder});

  final VoidCallback? onOpenFolder;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: context.colors.surfaceContainer, borderRadius: BorderRadius.circular(18)),
            child: Icon(Icons.folder_outlined, size: 24, color: context.colors.outline),
          ),
          const SizedBox(height: 14),
          Text(context.tr.no_transfers_title, style: context.texts.bodyLarge),
          const SizedBox(height: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 260),
            child: Text(context.tr.no_transfers_hint, style: context.texts.bodySmall, textAlign: TextAlign.center),
          ),
          if (onOpenFolder case final open?) ...[
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: open,
              icon: const Icon(Icons.folder_open_outlined, size: 18),
              label: Text(context.tr.open_beacon_folder),
            ),
          ],
        ],
      ),
    ),
  );
}
