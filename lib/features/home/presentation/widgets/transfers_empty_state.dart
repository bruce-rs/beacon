import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// Fills the transfers area before anything has been sent or received, so the
/// lower half of the first run reads as "nothing here yet" rather than broken.
class TransfersEmptyState extends StatelessWidget {
  const TransfersEmptyState({super.key});

  // Centred when there is room, scrollable when there isn't — the area shrinks
  // with the keyboard, in landscape, and on short screens.
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        // minWidth too: a scroll view passes loose width constraints, so the
        // column would otherwise shrink to its widest child and sit off-centre.
        constraints: BoxConstraints(minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: context.colors.surfaceContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(Icons.folder_outlined, size: 24, color: context.colors.outline),
            ),
            const SizedBox(height: 14),
            Text(context.tr.no_transfers_title, style: context.texts.bodyLarge),
            const SizedBox(height: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 260),
              child: Text(context.tr.no_transfers_hint, style: context.texts.bodySmall, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}
