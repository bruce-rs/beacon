import 'package:beacon/base/extensions/context_ext.dart';
import 'package:flutter/material.dart';

/// Shown in place of the device list while no peer has been discovered.
///
/// The rings read as "listening" without a spinner, which on this screen would
/// compete with the per-transfer progress bars below.
class ScanningPlaceholder extends StatelessWidget {
  const ScanningPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = context.colors.primaryFixed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 168,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _Ring(size: 168, color: accent.withValues(alpha: 0.10)),
                _Ring(size: 122, color: accent.withValues(alpha: 0.18)),
                _Ring(size: 80, color: accent.withValues(alpha: 0.32)),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(18)),
                  child: Icon(Icons.sensors_rounded, size: 26, color: context.colors.onPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(context.tr.looking_for_devices, style: context.texts.titleMedium),
          const SizedBox(height: 6),
          Text(context.tr.searching_devices, style: context.texts.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color)),
  );
}
