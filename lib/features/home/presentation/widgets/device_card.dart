import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device, required this.isSelected, required this.onTap});

  final BeaconDevice device;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 88,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primaryFixed.withValues(alpha: 0.12) : context.colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.colors.primaryFixed : context.colors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.computer_outlined,
              size: 28,
              color: isSelected ? context.colors.primaryFixed : context.colors.onSurface,
            ),
            const SizedBox(height: 6),
            Text(
              device.name,
              style: context.texts.labelSmall,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
