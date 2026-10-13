import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/widgets/sheet_action_button.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Shows the About dialog.
///
/// Lives outside SettingsPage because the macOS menu bar opens it too, through
/// the `com.beacon/menu` channel. Named for Beacon so it doesn't collide with
/// Material's own `showAboutDialog`.
Future<void> showBeaconAboutDialog(BuildContext context) async {
  final info = await PackageInfo.fromPlatform();
  if (!context.mounted) return;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 10),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: dialogContext.colors.primaryFixed,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(Icons.sensors_rounded, size: 30, color: dialogContext.colors.onPrimary),
          ),
          const SizedBox(height: 18),
          Text(dialogContext.tr.app_name, style: dialogContext.texts.headlineSmall),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: dialogContext.colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              dialogContext.tr.about_version('${info.version} (${info.buildNumber})'),
              style: dialogContext.texts.labelMedium?.copyWith(color: dialogContext.colors.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 18),
          Text(dialogContext.tr.about_description, style: dialogContext.texts.bodySmall, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            children: [
              _AboutBadge(
                icon: Icons.shield_outlined,
                label: dialogContext.tr.about_no_tracking,
                tint: dialogContext.colorsExt.success ?? dialogContext.colors.primaryFixed,
              ),
              const SizedBox(width: 10),
              _AboutBadge(
                icon: Icons.wifi_tethering_rounded,
                label: dialogContext.tr.about_local_only,
                tint: dialogContext.colorsExt.deviceTeal ?? dialogContext.colors.primaryFixed,
              ),
              const SizedBox(width: 10),
              _AboutBadge(
                icon: Icons.favorite_outline_rounded,
                label: dialogContext.tr.about_free,
                tint: dialogContext.colorsExt.deviceViolet ?? dialogContext.colors.primaryFixed,
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Navigator, not the router: the dialog lives in the root overlay,
        // which sits above AutoRouter, so `maybePop` finds no router there.
        SizedBox(
          width: double.infinity,
          child: SheetActionButton(
            label: dialogContext.tr.about_close,
            onTap: () => Navigator.of(dialogContext).pop(),
          ),
        ),
      ],
    ),
  );
}

/// One of the three reassurances in the About dialog.
class _AboutBadge extends StatelessWidget {
  const _AboutBadge({required this.icon, required this.label, required this.tint});

  final IconData icon;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 19, color: tint),
          const SizedBox(height: 7),
          Text(label, style: context.texts.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
