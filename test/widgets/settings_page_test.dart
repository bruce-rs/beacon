import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/features/settings/presentation/controllers/settings_controller.dart';
import 'package:beacon/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../helpers/test_setup.dart';

void main() {
  setUpAll(() async {
    await initTestStorage();
  });

  setUp(() {
    registerAppController();
    GetIt.I.registerLazySingleton<SettingsController>(() => SettingsController());
  });

  tearDown(() {
    GetIt.I.reset();
  });

  // ── section labels ──────────────────────────────────────────────────────────

  group('section labels', () {
    testWidgets('renders Appearance section', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      expect(find.text('Appearance'), findsOneWidget);
    });

    testWidgets('renders Language section', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      expect(find.text('Language'), findsOneWidget);
    });
  });

  // ── theme options ───────────────────────────────────────────────────────────

  group('theme options', () {
    testWidgets('renders all three theme options', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      expect(find.text('System default'), findsOneWidget);
      expect(find.text('Light'), findsOneWidget);
      expect(find.text('Dark'), findsOneWidget);
    });

    testWidgets('System default is checked on first launch', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      final appCtrl = GetIt.I<AppController>();
      expect(appCtrl.appTheme, ThemeMode.system);
    });

    testWidgets('tapping Light updates controller theme', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      expect(GetIt.I<AppController>().appTheme, ThemeMode.light);
    });

    testWidgets('tapping Dark updates controller theme', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(GetIt.I<AppController>().appTheme, ThemeMode.dark);
    });

    testWidgets('after changing theme, check icon count remains 2', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      // One check for theme (Light), one check for language (English default)
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
    });
  });

  // ── language options ────────────────────────────────────────────────────────

  group('language options', () {
    testWidgets('renders English and Spanish options', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      expect(find.textContaining('English'), findsOneWidget);
      expect(find.textContaining('Spanish'), findsOneWidget);
    });

    testWidgets('English is selected on first launch', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      expect(GetIt.I<AppController>().appLocale, AppLocale.enUS);
    });

    testWidgets('tapping Spanish updates controller locale', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      await tester.tap(find.textContaining('Spanish'));
      await tester.pumpAndSettle();

      expect(GetIt.I<AppController>().appLocale, AppLocale.esES);
    });

    testWidgets('tapping English after Spanish switches back', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      await tester.tap(find.textContaining('Spanish'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('English'));
      await tester.pumpAndSettle();

      expect(GetIt.I<AppController>().appLocale, AppLocale.enUS);
    });
  });

  // ── initial check icon count ────────────────────────────────────────────────

  group('check icons', () {
    testWidgets('exactly 2 check icons on initial render', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      // One for ThemeMode.system, one for AppLocale.enUS
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
    });
  });
}
