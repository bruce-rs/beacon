import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:flutter/material.dart';

/// A selectable row within a group of mutually exclusive choices, such as the
/// theme or language pickers. [isFirst] and [isLast] round the matching corners
/// so the tile follows the card's shape.
class OptionTile extends OptionCardTile {
  const OptionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.vertical(
      top: isFirst ? const Radius.circular(kCardRadius) : Radius.zero,
      bottom: isLast ? const Radius.circular(kCardRadius) : Radius.zero,
    ),
    child: Padding(
      padding: kTilePadding,
      child: Row(
        children: [
          Icon(icon, size: kTileIconSize, color: context.colors.onSurfaceVariant),
          const SizedBox(width: kTileIconGap),
          Expanded(child: Text(label, style: context.texts.bodyMedium)),
          if (isSelected) Icon(Icons.check_rounded, size: kTileIconSize, color: context.colors.onPrimary),
        ],
      ),
    ),
  );
}
