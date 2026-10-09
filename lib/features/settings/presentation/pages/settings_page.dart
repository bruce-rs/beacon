import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/enums/theme_mode_ext.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:beacon/base/presentation/widgets/info_tile.dart';
import 'package:beacon/base/presentation/widgets/navigation_tile.dart';
import 'package:beacon/base/presentation/widgets/option_card.dart';
import 'package:beacon/base/presentation/widgets/option_tile.dart';
import 'package:beacon/base/utils/app_bottom_sheet.dart';
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
                label: context.tr.app_name,
                trailing: StatusIndicator(status: HomeController.to.status.value, showLabel: true),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr.appearance),
          const SizedBox(height: 8),
          OptionCard(
            children: [
              ...ThemeMode.values.map(
                (mode) => OptionTile(
                  label: mode.labelIcon(context).$1,
                  icon: mode.labelIcon(context).$2,
                  isFirst: mode == ThemeMode.values.first,
                  isLast: mode == ThemeMode.values.last,
                  isSelected: controller.app.appTheme == mode,
                  onTap: () => controller.setTheme(mode),
                ),
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
                  icon: Icons.language_outlined,
                  isFirst: locale == AppLocale.values.first,
                  isLast: locale == AppLocale.values.last,
                  isSelected: controller.app.appLocale == locale,
                  onTap: () => controller.setLocale(locale),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr.privacy_policy),
          const SizedBox(height: 8),
          OptionCard(
            children: [
              NavigationTile(
                icon: Icons.privacy_tip_outlined,
                title: context.tr.privacy_policy,
                subtitle: context.tr.privacy_policy_subtitle,
                onTap: () => _showPrivacyPolicy(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr.about),
          const SizedBox(height: 8),
          OptionCard(
            children: [
              NavigationTile(
                icon: Icons.info_outline_rounded,
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

  Future<void> _showAbout(BuildContext context) async {
    final info = await PackageInfo.fromPlatform();
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 10),
              child: Icon(Icons.info_outline_rounded, color: dialogContext.colors.onSurfaceVariant),
            ),
            Text(dialogContext.tr.app_name),
          ],
        ),
        content: Text(dialogContext.tr.about_description),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Text(
            dialogContext.tr.about_version('${info.version} (${info.buildNumber})'),
            style: dialogContext.texts.bodySmall?.copyWith(color: dialogContext.colors.onSurfaceVariant),
          ),
          // Navigator, not the router: the dialog lives in the root overlay,
          // which sits above AutoRouter, so `maybePop` finds no router there.
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(dialogContext.tr.about_close),
          ),
        ],
      ),
    );
  }

  Future<void> _showPrivacyPolicy(BuildContext context) async =>
      showAdaptiveBottomSheet<void>(context: context, builder: (sheetContext) => const _PrivacyPolicySheet());
}

class _PrivacyPolicySheet extends StatelessWidget {
  const _PrivacyPolicySheet();

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: context.colors.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Icon(Icons.privacy_tip_outlined, size: 22, color: context.colors.onSurface),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.tr.privacy_policy,
                  style: context.texts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
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
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.tr.privacy_policy_close),
            ),
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
    padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.texts.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(body, style: context.texts.bodyMedium),
      ],
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
