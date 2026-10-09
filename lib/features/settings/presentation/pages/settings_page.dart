import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/enums/theme_mode_ext.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:beacon/base/presentation/widgets/info_tile.dart';
import 'package:beacon/base/presentation/widgets/navigation_tile.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:beacon/base/presentation/widgets/option_tile.dart';
import 'package:beacon/base/presentation/widgets/segmented_option_tile.dart';
import 'package:beacon/base/presentation/widgets/sheet_action_button.dart';
import 'package:beacon/base/utils/app_bottom_sheet.dart';
import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:beacon/features/home/presentation/widgets/status_indicator.dart';
import 'package:beacon/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

@RoutePage()
class SettingsPage extends BasePage<SettingsController> {
  const SettingsPage({super.key});

  static const String routePath = 'settings';

  @override
  Widget buildPage(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.tr.settings),
      titleTextStyle: context.texts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    ),
    body: Obx(
      () => ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _SectionLabel(context.tr.status),
          const SizedBox(height: 8),
          OptionCard(
            children: [
              InfoTile(
                icon: Icons.wifi_tethering_rounded,
                iconTint: _statusTint(context, HomeController.to.status.value),
                label: _statusTitle(context, HomeController.to.status.value),
                subtitle: _statusSubtitle(context, HomeController.to.status.value, HomeController.to.localName.value),
                trailing: StatusIndicator(status: HomeController.to.status.value),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr.appearance),
          const SizedBox(height: 8),
          OptionCard(
            children: [
              SegmentedOptionTile(
                options: [
                  for (final mode in ThemeMode.values)
                    SegmentedOption(
                      label: mode.labelIcon(context).$1,
                      icon: mode.labelIcon(context).$2,
                      isSelected: controller.app.appTheme == mode,
                      onTap: () => controller.setTheme(mode),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr.language),
          const SizedBox(height: 8),
          OptionCard(
            children: [
              ...AppLocale.values.map(
                (locale) => OptionTile(
                  label: locale.displayLabel(context),
                  badge: locale.langCode.toUpperCase(),
                  isFirst: locale == AppLocale.values.first,
                  isLast: locale == AppLocale.values.last,
                  isSelected: controller.app.appLocale == locale,
                  onTap: () => controller.setLocale(locale),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          OptionCard(
            children: [
              NavigationTile(
                icon: Icons.privacy_tip_outlined,
                iconTint: context.colorsExt.deviceTeal,
                title: context.tr.privacy_policy,
                subtitle: context.tr.privacy_policy_subtitle,
                onTap: () => _showPrivacyPolicy(context),
              ),
              NavigationTile(
                icon: Icons.info_outline_rounded,
                iconTint: context.colors.primaryFixed,
                title: context.tr.about,
                subtitle: context.tr.about_subtitle,
                onTap: () => _showAbout(context),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  String _statusTitle(BuildContext context, BeaconStatus status) => switch (status) {
    BeaconStatus.running => context.tr.status_title_running,
    BeaconStatus.starting => context.tr.status_title_starting,
    BeaconStatus.stopped => context.tr.status_title_stopped,
    BeaconStatus.error => context.tr.status_title_error,
  };

  /// The advertised name once running; otherwise why peers can't see us.
  String _statusSubtitle(BuildContext context, BeaconStatus status, String? name) =>
      status == BeaconStatus.running && name != null
      ? context.tr.status_visible_as(name)
      : context.tr.status_not_visible;

  Color _statusTint(BuildContext context, BeaconStatus status) => switch (status) {
    BeaconStatus.running => context.colorsExt.success ?? context.colors.primaryFixed,
    BeaconStatus.starting => context.colors.primaryFixed,
    BeaconStatus.stopped => context.colors.onSurfaceVariant,
    BeaconStatus.error => context.colors.error,
  };

  Future<void> _showAbout(BuildContext context) async {
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

  Future<void> _showPrivacyPolicy(BuildContext context) async => showAdaptiveBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => const _PrivacyPolicySheet(),
  );
}

class _PrivacyPolicySheet extends StatelessWidget {
  const _PrivacyPolicySheet();

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: (context.colorsExt.deviceTeal ?? context.colors.primaryFixed).withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  Icons.privacy_tip_outlined,
                  size: 24,
                  color: context.colorsExt.deviceTeal ?? context.colors.primaryFixed,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(context.tr.privacy_policy, style: context.texts.titleLarge),
                    const SizedBox(height: 4),
                    Text(context.tr.privacy_policy_subtitle, style: context.texts.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.tr.privacy_policy_intro, style: context.texts.bodyMedium),
                  const SizedBox(height: 20),
                  _PolicyItem(
                    title: context.tr.privacy_policy_file_sharing_title,
                    body: context.tr.privacy_policy_file_sharing_body,
                  ),
                  _PolicyItem(
                    title: context.tr.privacy_policy_liability_title,
                    body: context.tr.privacy_policy_liability_body,
                  ),
                  _PolicyItem(title: context.tr.privacy_policy_free_title, body: context.tr.privacy_policy_free_body),
                  _PolicyItem(
                    title: context.tr.privacy_policy_no_tracking_title,
                    body: context.tr.privacy_policy_no_tracking_body,
                  ),
                  _PolicyItem(
                    title: context.tr.privacy_policy_no_storage_title,
                    body: context.tr.privacy_policy_no_storage_body,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SheetActionButton(
            label: context.tr.privacy_policy_close,
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}

/// A tappable row that opens a detail view: leading icon, title, subtitle and a
/// trailing chevron. Used for the Privacy Policy and About entries.
class _PolicyItem extends StatelessWidget {
  const _PolicyItem({required this.title, required this.body, this.isLast = false});

  final String title;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.texts.bodyLarge),
          const SizedBox(height: 4),
          Text(body, style: context.texts.bodySmall),
        ],
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text.toUpperCase(),
    style: context.texts.labelSmall?.copyWith(
      color: context.colors.onSurfaceVariant,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.8,
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
