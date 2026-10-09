import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status, this.showLabel = false, this.asPill = false});

  final BeaconStatus status;
  final bool showLabel;

  /// Wraps the dot and label in a tinted pill, for use in the app bar.
  final bool asPill;

  Color _color(BuildContext context) => switch (status) {
    BeaconStatus.running => context.colorsExt.success ?? context.colors.primaryFixed,
    BeaconStatus.starting => context.colorsExt.warning ?? context.colors.primaryFixed,
    BeaconStatus.error => context.colors.error,
    BeaconStatus.stopped => context.colors.onSurfaceVariant,
  };

  String _label(BuildContext context) => switch (status) {
    BeaconStatus.running => context.tr.status_running,
    BeaconStatus.starting => context.tr.status_starting,
    BeaconStatus.error => context.tr.status_error,
    BeaconStatus.stopped => context.tr.status_stopped,
  };

  @override
  Widget build(BuildContext context) {
    final color = _color(context);

    final dot = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: status == BeaconStatus.running
            ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1)]
            : null,
      ),
    );

    if (!showLabel) return dot;

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        asPill ? SizedBox.square(dimension: 7, child: dot) : dot,
        const SizedBox(width: 8),
        Text(
          _label(context),
          style: asPill ? context.texts.labelMedium?.copyWith(color: color) : context.texts.bodyMedium,
        ),
      ],
    );

    if (!asPill) return row;

    return Container(
      padding: const EdgeInsets.fromLTRB(9, 6, 12, 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: row,
    );
  }
}
