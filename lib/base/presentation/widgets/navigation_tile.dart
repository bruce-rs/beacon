import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:flutter/material.dart';

/// A tappable row that opens a detail view: leading icon, title, subtitle and a
/// trailing chevron.
class NavigationTile extends OptionCardTile {
  const NavigationTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconTint,
  });

  final IconData icon;

  /// Colours the icon and the tile behind it; plain when null.
  final Color? iconTint;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(kCardRadius),
    child: Padding(
      padding: kTilePadding,
      child: Row(
        children: [
          if (iconTint case final tint?)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: tint.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: kTileIconSize, color: tint),
            )
          else
            Icon(icon, size: kTileIconSize, color: context.colors.onSurfaceVariant),
          const SizedBox(width: kTileIconGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.texts.bodyMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: context.texts.bodySmall?.copyWith(color: context.colors.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: kTileIconSize, color: context.colors.onSurfaceVariant),
        ],
      ),
    ),
  );
}
