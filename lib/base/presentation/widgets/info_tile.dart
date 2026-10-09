import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:flutter/material.dart';

/// A read-only row: leading icon, label and an optional trailing widget such as
/// a status indicator.
class InfoTile extends OptionCardTile {
  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.iconTint,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;

  /// Colours the icon and the tile behind it; plain when null.
  final Color? iconTint;

  @override
  Widget build(BuildContext context) => Padding(
    padding: kTilePadding,
    child: Row(
      children: [
        if (iconTint case final tint?)
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: tint.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: kTileIconSize, color: tint),
          )
        else
          Icon(icon, size: kTileIconSize, color: context.colors.onSurfaceVariant),
        const SizedBox(width: kTileIconGap),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: context.texts.bodyMedium),
              if (subtitle case final text?) ...[
                const SizedBox(height: 2),
                Text(text, style: context.texts.bodySmall),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    ),
  );
}
