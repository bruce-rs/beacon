import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../helpers/test_setup.dart';

void main() {
  late SettingsController ctrl;

  setUpAll(() async {
    await initTestStorage();
  });

  setUp(() {
    registerAppController();
    ctrl = SettingsController();
    ctrl.onInit();
    ctrl.isInitialized = true;
  });

  tearDown(() {
    ctrl.onClose();
    GetIt.I.reset();
  });

  // ── initial state ───────────────────────────────────────────────────────────

  group('initial state', () {
    test('theme defaults to system from storage', () {
      expect(ctrl.app.appTheme, ThemeMode.system);
    });

    test('locale defaults to enUS from storage', () {
      expect(ctrl.app.appLocale, AppLocale.enUS);
    });
  });

  // ── setTheme ────────────────────────────────────────────────────────────────

  group('setTheme', () {
    test('updates AppController.appTheme', () async {
      await ctrl.setTheme(ThemeMode.dark);
      expect(ctrl.app.appTheme, ThemeMode.dark);
    });

    test('persists theme to storage', () async {
      await ctrl.setTheme(ThemeMode.light);
      expect(AppStorage.to.theme, ThemeMode.light);
    });

    test('switching theme multiple times keeps the last value', () async {
      await ctrl.setTheme(ThemeMode.dark);
      await ctrl.setTheme(ThemeMode.light);
      await ctrl.setTheme(ThemeMode.system);
      expect(ctrl.app.appTheme, ThemeMode.system);
      expect(AppStorage.to.theme, ThemeMode.system);
    });

    test('all ThemeMode values are accepted', () async {
      for (final mode in ThemeMode.values) {
        await ctrl.setTheme(mode);
        expect(ctrl.app.appTheme, mode);
      }
    });
  });

  // ── setLocale ───────────────────────────────────────────────────────────────

  group('setLocale', () {
    test('updates AppController.appLocale', () async {
      await ctrl.setLocale(AppLocale.esES);
      expect(ctrl.app.appLocale, AppLocale.esES);
    });

    test('persists locale to storage', () async {
      await ctrl.setLocale(AppLocale.esES);
      expect(AppStorage.to.locale, AppLocale.esES);
    });

    test('can switch back to enUS', () async {
      await ctrl.setLocale(AppLocale.esES);
      await ctrl.setLocale(AppLocale.enUS);
      expect(ctrl.app.appLocale, AppLocale.enUS);
    });

    test('all AppLocale values are accepted', () async {
      for (final locale in AppLocale.values) {
        await ctrl.setLocale(locale);
        expect(ctrl.app.appLocale, locale);
      }
    });
  });
}
