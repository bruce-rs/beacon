import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:beacon/features/home/presentation/widgets/device_avatar.dart';
import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  const DeviceCard({super.key, required this.device, required this.isSelected, required this.onTap});

  static const double width = 172;
  static const double height = 112;

  final BeaconDevice device;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Selection is a filled card rather than a thin border: on a list of grey
    // cards an outline alone is easy to miss.
    final background = isSelected ? context.colors.primaryContainer : context.colors.surfaceContainer;
    final border = isSelected ? context.colors.primaryFixed : context.colors.outlineVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: width,
        height: height,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                DeviceAvatar(device: device),
                const Spacer(),
                if (isSelected) Icon(Icons.check_rounded, size: 18, color: context.colors.primaryFixedDim),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(device.name, style: context.texts.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  isSelected ? context.tr.device_selected : context.tr.device_tap_to_select,
                  style: isSelected
                      ? context.texts.bodySmall?.copyWith(color: context.colors.primaryFixedDim)
                      : context.texts.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
