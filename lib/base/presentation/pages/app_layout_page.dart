import 'package:auto_route/auto_route.dart';
import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/base/presentation/pages/base_page.dart';
import 'package:flutter/material.dart';

@RoutePage()
class AppLayoutPage extends BasePage<AppController> {
  const AppLayoutPage({super.key});

  static const String routePath = '/';

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
