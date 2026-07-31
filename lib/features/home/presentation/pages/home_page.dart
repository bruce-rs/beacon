import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:beacon/features/home/presentation/widgets/device_card.dart';
import 'package:beacon/features/home/presentation/widgets/drop_zone_widget.dart';
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
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.tr.app_name),
      titleTextStyle: context.texts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Obx(() => Center(child: StatusIndicator(status: controller.status.value))),
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => context.navigateToPath(SettingsPage.routePath),
        ),
      ],
    ),
    body: Obx(
      () => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Devices ────────────────────────────────────────────────
            Row(
              children: [
                Text(
                  context.tr.nearby_devices,
                  style: context.texts.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                if (controller.devices.isEmpty)
                  SizedBox(
                    width: 11,
                    height: 11,
                    child: CircularProgressIndicator(strokeWidth: 1.8, color: context.colors.outlineVariant),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (controller.devices.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  context.tr.searching_devices,
                  style: context.texts.bodySmall?.copyWith(color: context.colors.outlineVariant),
                ),
              )
            else
              SizedBox(
                height: 96,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.devices.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
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

            const SizedBox(height: 20),

            // ── Drop zone ──────────────────────────────────────────────
            DropZoneWidget(
              isActive: controller.selectedDevice.value != null,
              selectedDeviceName: controller.selectedDevice.value?.name,
              onDropped: controller.sendFiles,
              onTap: controller.pickAndSendFiles,
            ),

            const SizedBox(height: 20),

            // ── Transfers ──────────────────────────────────────────────
            if (controller.transfers.isNotEmpty) ...[
              Text(context.tr.transfers, style: context.texts.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Expanded(
                child: ListView.separated(
                  itemCount: controller.transfers.length,
                  separatorBuilder: (_, _) => Divider(height: 1, color: context.colors.outline.withValues(alpha: 0.5)),
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
