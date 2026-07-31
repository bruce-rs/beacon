import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({super.key, required this.status, this.showLabel = false});

  final BeaconStatus status;
  final bool showLabel;

  Color _color(BuildContext context) => switch (status) {
    BeaconStatus.running => Colors.green.shade500,
    BeaconStatus.starting => Colors.amber.shade600,
    BeaconStatus.error => context.colors.error,
    BeaconStatus.stopped => context.colors.outlineVariant,
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot,
        const SizedBox(width: 8),
        Text(_label(context), style: context.texts.bodyMedium),
      ],
    );
  }
}
