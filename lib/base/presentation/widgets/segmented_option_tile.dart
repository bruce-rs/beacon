import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:flutter/material.dart';

/// One choice in a [SegmentedOptionTile].
class SegmentedOption {
  const SegmentedOption({required this.label, required this.icon, required this.isSelected, required this.onTap});

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
}

/// A row of side-by-side choices, for small mutually exclusive sets where
/// seeing every option at once beats a list of rows — the theme picker.
class SegmentedOptionTile extends OptionCardTile {
  const SegmentedOptionTile({super.key, required this.options});

  final List<SegmentedOption> options;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(6),
    child: Row(
      children: [
        for (final option in options) ...[
          Expanded(child: _Segment(option: option)),
          if (option != options.last) const SizedBox(width: 6),
        ],
      ],
    ),
  );
}

class _Segment extends StatelessWidget {
  const _Segment({required this.option});

  final SegmentedOption option;

  @override
  Widget build(BuildContext context) {
    final selected = option.isSelected;
    final foreground = selected ? context.colors.onPrimary : context.colors.onSurfaceVariant;

    return Material(
      color: selected ? context.colors.primaryFixed : Colors.transparent,
      borderRadius: BorderRadius.circular(kCardRadius - 2),
      child: InkWell(
        onTap: option.onTap,
        borderRadius: BorderRadius.circular(kCardRadius - 2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(option.icon, size: kTileIconSize, color: foreground),
              const SizedBox(height: 7),
              Text(
                option.label,
                style: context.texts.labelMedium?.copyWith(color: foreground),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
