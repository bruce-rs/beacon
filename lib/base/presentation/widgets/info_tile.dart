import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:flutter/material.dart';

/// A read-only row: leading icon, label and an optional trailing widget such as
/// a status indicator.
class InfoTile extends OptionCardTile {
  const InfoTile({super.key, required this.icon, required this.label, this.trailing});

  final IconData icon;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: kTilePadding,
    child: Row(
      children: [
        Icon(icon, size: kTileIconSize, color: context.colors.onSurfaceVariant),
        const SizedBox(width: kTileIconGap),
        Expanded(child: Text(label, style: context.texts.bodyMedium)),
        ?trailing,
      ],
    ),
  );
}
