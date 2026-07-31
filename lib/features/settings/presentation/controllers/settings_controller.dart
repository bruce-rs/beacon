import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SettingsController extends BaseController {
  SettingsController();

  final app = AppController.to;

  @override
  void onInit() {
    super.onInit();

    app.setAppTheme(storage.theme);
  }

  Future<void> setTheme(ThemeMode mode) async => app.setAppTheme(mode);

  Future<void> setLocale(AppLocale locale) async => app.setAppLocale(locale);
}
