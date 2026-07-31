// ignore_for_file: non_constant_identifier_names

import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/base/presentation/pages/app_layout_page.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:beacon/features/home/presentation/pages/home_page.dart';
import 'package:beacon/features/settings/presentation/controllers/settings_controller.dart';
import 'package:beacon/features/settings/presentation/pages/settings_page.dart';

final AppLayoutRouteBindings = PageBindings<AppController>(
  initial: true,
  page: AppLayoutRoute.page,
  path: AppLayoutPage.routePath,
  keepAlive: true,
);

final HomeRouteBindings = PageBindings<HomeController>(
  initial: true,
  page: HomeRoute.page,
  path: HomePage.routePath,
  keepAlive: true,
);

final SettingsRouteBindings = PageBindings<SettingsController>(page: SettingsRoute.page, path: SettingsPage.routePath);
