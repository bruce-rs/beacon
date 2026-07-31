import 'package:beacon/base/constants/constants.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:beacon/base/presentation/pages/unknown_page.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:beacon/base/theme/app_theme.dart';
import 'package:beacon/base/utils/flavors.dart';
import 'package:beacon/gen/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppPage extends BasePage<AppController> {
  const AppPage({super.key});

  @override
  Widget build(BuildContext context) => Obx(
    () => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppFlavor.title,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: controller.appTheme,
      locale: controller.appLocale.asLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => ColoredBox(
        color: context.colors.surface,
        child: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMediumScreenMaxWidth),
              child: Builder(builder: (context) => child ?? const UnknownPage()),
            ),
          ),
        ),
      ),
      routerConfig: AppRouter.to.config(navigatorObservers: () => [BindingsObserver()]),
    ),
  );
}
