import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// A row that can live inside an [OptionCard].
///
/// Typing the card's children keeps the grouped rows visually consistent:
/// only tiles built for the card fit in it. See [OptionTile], [NavigationTile]
/// and [InfoTile].
abstract class OptionCardTile extends StatelessWidget {
  const OptionCardTile({super.key});
}

/// Groups related [OptionCardTile]s into one rounded, elevated-free card.
class OptionCard extends StatelessWidget {
  const OptionCard({super.key, required this.children});

  final List<OptionCardTile> children;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kCardRadius)),
    color: context.colors.surfaceContainer,
    elevation: 0,
    child: Column(children: children),
  );
}

/// Shared geometry so every tile lines up inside the card.
const double kCardRadius = 16;
const EdgeInsets kTilePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
const double kTileIconSize = 20;
const double kTileIconGap = 14;
