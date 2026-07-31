import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/presentation/controllers/base_controller.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@singleton
class AppController extends BaseController {
  AppController();

  static AppController get to => GetIt.I<AppController>();

  @override
  void onInit() {
    super.onInit();

    _appLocale.value = AppStorage.to.locale;
    _appTheme.value = AppStorage.to.theme;

    loadNativeActions();
  }

  void loadNativeActions() => switch (defaultTargetPlatform) {
    TargetPlatform.macOS => _loadMacosSettingsAction(),
    _ => null,
  };

  final Rx<AppLocale> _appLocale = AppLocale.enUS.obs;
  AppLocale get appLocale => _appLocale.value;

  Future<void> setAppLocale(AppLocale locale) async {
    _appLocale.value = locale;
    await storage.setLocale(locale);
  }

  final Rx<ThemeMode> _appTheme = Rx<ThemeMode>(ThemeMode.system);
  ThemeMode get appTheme => _appTheme.value;

  Future<void> setAppTheme(ThemeMode value) async {
    _appTheme.value = value;
    await storage.setTheme(value);
  }

  void _loadMacosSettingsAction() {
    if (defaultTargetPlatform != TargetPlatform.macOS) return;

    const MethodChannel('com.beacon/menu').setMethodCallHandler((call) async {
      if (call.method == 'openSettings') {
        AppRouter.to.navigate(const SettingsRoute());
      }
    });
  }
}
