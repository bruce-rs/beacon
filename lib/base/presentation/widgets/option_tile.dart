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
    this.icon,
    this.badge,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
  });

  final String label;

  /// One of [icon] or [badge] is shown at the start of the row.
  final IconData? icon;
  final String? badge;
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
          if (badge != null)
            _Badge(text: badge!, isSelected: isSelected)
          else if (icon != null)
            Icon(icon, size: kTileIconSize, color: context.colors.onSurfaceVariant),
          const SizedBox(width: kTileIconGap),
          Expanded(child: Text(label, style: context.texts.bodyMedium)),
          if (isSelected) Icon(Icons.check_rounded, size: kTileIconSize, color: context.colors.primaryFixed),
        ],
      ),
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.isSelected});

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => Container(
    width: 34,
    height: 34,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: isSelected ? context.colors.primaryContainer : context.colors.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(11),
    ),
    child: Text(
      text,
      style: context.texts.labelMedium?.copyWith(
        color: isSelected ? context.colors.primaryFixedDim : context.colors.onSurfaceVariant,
      ),
    ),
  );
}
