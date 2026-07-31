import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/enums/theme_mode_ext.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:beacon/base/utils/app_bottom_sheet.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:beacon/features/home/presentation/widgets/status_indicator.dart';
import 'package:beacon/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

@RoutePage()
class SettingsPage extends BasePage<SettingsController> {
  const SettingsPage({super.key});

  static const String routePath = 'settings';

  @override
  Widget build(BuildContext context) => Scaffold(
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
          _OptionCard(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(Icons.wifi_tethering_rounded, size: 20, color: context.colors.onSurfaceVariant),
                    const SizedBox(width: 14),
                    Expanded(child: Text(context.tr.app_name, style: context.texts.bodyMedium)),
                    StatusIndicator(status: HomeController.to.status.value, showLabel: true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionLabel(context.tr.appearance),
          const SizedBox(height: 8),
          _OptionCard(
            children: [
              ...ThemeMode.values.map(
                (mode) => _OptionTile(
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
          _OptionCard(
            children: [
              ...AppLocale.values.map(
                (locale) => _OptionTile(
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
          _OptionCard(children: [_PrivacyPolicyTile(onTap: () => _showPrivacyPolicy(context))]),
        ],
      ),
    ),
  );

  Future<void> _showPrivacyPolicy(BuildContext context) async => showAdaptiveBottomSheet<void>(
    context: context,
    builder: (sheetContext) => const _PrivacyPolicySheet(),
  );
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
                  _PolicyItem(
                    title: context.tr.privacy_policy_free_title,
                    body: context.tr.privacy_policy_free_body,
                  ),
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

class _PrivacyPolicyTile extends StatelessWidget {
  const _PrivacyPolicyTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(Icons.privacy_tip_outlined, size: 20, color: context.colors.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr.privacy_policy, style: context.texts.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  context.tr.privacy_policy_subtitle,
                  style: context.texts.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, size: 20, color: context.colors.onSurfaceVariant),
        ],
      ),
    ),
  );
}

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
    text,
    style: context.texts.labelMedium?.copyWith(
      color: context.colors.onPrimary,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.8,
    ),
  );
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: context.colors.surfaceContainer,
    elevation: 0,
    child: Column(children: children),
  );
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.icon,
    required this.isFirst,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isFirst;
  final bool isLast;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.vertical(
      top: isFirst ? const Radius.circular(16) : Radius.zero,
      bottom: isLast ? const Radius.circular(16) : Radius.zero,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colors.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: context.texts.bodyMedium)),
          if (isSelected) Icon(Icons.check_rounded, size: 20, color: context.colors.onPrimary),
        ],
      ),
    ),
  );
}
