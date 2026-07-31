import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/extensions/context_ext.dart';
import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:beacon/base/presentation/pages/app_layout_page.dart';
import 'package:beacon/base/presentation/pages/unknown_page.dart';
import 'package:beacon/base/router/app_bindings_declarations.dart';
import 'package:beacon/features/home/presentation/pages/home_page.dart';
import 'package:beacon/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:sdk_helpers/sdk_helpers.dart';

part 'app_bindings.dart';
part 'app_router.gr.dart';

final _appRouter = AppRouter();

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter();

  static AppRouter get to => _appRouter;

  BuildContext get appContext => to.navigatorKey.currentContext!;

  static void safePop<T extends Object?>([T? result, BuildContext? context]) {
    (context ?? to.appContext).safePop(result);
  }

  static Future<bool> safeMaybePop<T extends Object?>([T? result, BuildContext? context]) async {
    return await (context ?? to.appContext).safeMaybePop(result);
  }

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [
    AppLayoutRouteBindings.route(children: [HomeRouteBindings.route(), SettingsRouteBindings.route()]),
    AutoRoute(page: UnknownRoute.page, path: UnknownPage.routePath),
  ];
}
