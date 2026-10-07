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

  // Sits above MaterialApp: there is no Theme to read yet, and a cap here would
  // apply to every route and modal.
  @override
  bool get constrainWidth => false;

  @override
  Widget buildPage(BuildContext context) => Obx(
    () => MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppFlavor.title,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: controller.appTheme,
      locale: controller.appLocale.asLocale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Pages constrain themselves through BasePage; constraining here would
      // also cap modal routes, cutting bottom sheets off mid-screen.
      builder: (context, child) => Builder(builder: (context) => child ?? const UnknownPage()),
      routerConfig: AppRouter.to.config(navigatorObservers: () => [BindingsObserver()]),
    ),
  );
}
