import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// Full-width action used by sheets and dialogs.
///
/// One component so every sheet's primary action and every Close button look
/// the same: accent fill for the action you want taken, a raised neutral fill
/// for everything else.
class SheetActionButton extends StatelessWidget {
  const SheetActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isPrimary = false,
    this.showChevron = false,
  });

  final String label;
  final VoidCallback onTap;

  /// Shown in a tile at the start of the row; the label centres without one.
  final IconData? icon;
  final bool isPrimary;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final background = isPrimary ? context.colors.primaryFixed : context.colors.surfaceContainerHigh;
    final foreground = isPrimary ? context.colors.onPrimary : context.colors.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (icon case final data?) ...[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? context.colors.onPrimary.withValues(alpha: 0.18)
                        : context.colors.surfaceContainer,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(data, size: 18, color: foreground),
                ),
                const SizedBox(width: 13),
                Expanded(child: Text(label, style: context.texts.bodyLarge?.copyWith(color: foreground))),
              ] else
                Text(label, style: context.texts.bodyLarge?.copyWith(color: foreground)),
              if (showChevron) Icon(Icons.chevron_right_rounded, size: 20, color: foreground),
            ],
          ),
        ),
      ),
    );
  }
}
