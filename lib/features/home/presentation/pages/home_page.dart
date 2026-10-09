import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:beacon/features/home/presentation/widgets/device_card.dart';
import 'package:beacon/features/home/presentation/widgets/drop_zone_widget.dart';
import 'package:beacon/features/home/presentation/widgets/scanning_placeholder.dart';
import 'package:beacon/features/home/presentation/widgets/status_indicator.dart';
import 'package:beacon/features/home/presentation/widgets/transfer_tile.dart';
import 'package:beacon/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@RoutePage()
class HomePage extends BasePage<HomeController> {
  const HomePage({super.key});

  static const String routePath = 'home';

  @override
  Widget buildPage(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.tr.app_name),
      titleTextStyle: context.texts.headlineSmall,
      actions: [
        Obx(() => StatusIndicator(status: controller.status.value, showLabel: true, asPill: true)),
        const SizedBox(width: 8),
        _AppBarIconButton(
          icon: Icons.settings_outlined,
          tooltip: context.tr.settings,
          onPressed: () => context.navigateToPath(SettingsPage.routePath),
        ),
        const SizedBox(width: 4),
      ],
    ),
    body: Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Devices ────────────────────────────────────────────────
            _SectionLabel(context.tr.nearby_devices),
            const SizedBox(height: 12),
            if (controller.devices.isEmpty)
              const ScanningPlaceholder()
            else
              SizedBox(
                height: DeviceCard.height,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.devices.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final device = controller.devices[i];
                    return DeviceCard(
                      device: device,
                      isSelected: controller.selectedDevice.value?.id == device.id,
                      onTap: () => controller.selectDevice(device),
                    );
                  },
                ),
              ),

            const SizedBox(height: 22),

            // ── Drop zone ──────────────────────────────────────────────
            DropZoneWidget(
              isActive: controller.selectedDevice.value != null,
              selectedDeviceName: controller.selectedDevice.value?.name,
              onDropped: controller.sendFiles,
              onTap: controller.pickAndSendFiles,
            ),

            const SizedBox(height: 24),

            // ── Transfers ──────────────────────────────────────────────
            if (controller.transfers.isNotEmpty) ...[
              _SectionLabel(context.tr.transfers),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.transfers.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.outlineVariant),
                  itemBuilder: (_, i) => TransferTile(transfer: controller.transfers[i]),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// An app-bar action on a rounded tile, matching the status pill beside it.
class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: context.colors.surfaceContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox.square(
          dimension: 38,
          child: Icon(icon, size: 20, color: context.colors.onSurfaceVariant),
        ),
      ),
    ),
  );
}

/// Small caps caption above each group.
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(text.toUpperCase(), style: context.texts.labelSmall);
}
