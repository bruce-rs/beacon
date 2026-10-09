import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/features/beacon/data/models/beacon_device.dart';
import 'package:flutter/material.dart';

/// A coloured tile standing in for a discovered device.
///
/// The tint is derived from [BeaconDevice.id], which comes from the peer's
/// advertised TXT record and survives relaunches — so a device keeps the same
/// color every time it appears, which is what makes the list scannable.
class DeviceAvatar extends StatelessWidget {
  const DeviceAvatar({super.key, required this.device, this.size = 38});

  final BeaconDevice device;
  final double size;

  Color _tint(BuildContext context) {
    final palette = <Color>[
      context.colors.primaryFixed,
      context.colorsExt.deviceTeal ?? context.colors.primaryFixed,
      context.colorsExt.deviceViolet ?? context.colors.primaryFixed,
      context.colorsExt.success ?? context.colors.primaryFixed,
    ];
    // Sum of code units: stable, and good enough to spread a handful of devices.
    final hash = device.id.codeUnits.fold<int>(7, (acc, unit) => (acc * 31 + unit) & 0x7fffffff);
    return palette[hash % palette.length];
  }

  /// Guessed from the advertised name — peers don't report their platform yet.
  IconData get _icon {
    final name = device.name.toLowerCase();
    if (RegExp(r'ipad|tablet|\btab\b').hasMatch(name)) return Icons.tablet_mac_rounded;
    if (RegExp(r'iphone|pixel|moto|galaxy|android|phone|xiaomi|redmi').hasMatch(name)) {
      return Icons.smartphone_rounded;
    }
    if (RegExp(r'mac|book|imac|pc|desktop|windows|linux|ubuntu').hasMatch(name)) {
      return Icons.laptop_mac_rounded;
    }
    return Icons.devices_other_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final tint = _tint(context);
    // Dark tints (dark theme) take white ink; the light theme's deeper tints
    // keep it too, so only a genuinely pale tint flips to dark ink.
    final ink = tint.computeLuminance() > 0.55 ? const Color(0xFF10151A) : Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(size * 0.34)),
      child: Icon(_icon, size: size * 0.5, color: ink),
    );
  }
}
