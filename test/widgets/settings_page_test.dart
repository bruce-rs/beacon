import 'package:beacon/base/enums/app_locales.dart';
import 'package:beacon/base/presentation/controllers/app_controller.dart';
import 'package:beacon/features/settings/presentation/controllers/settings_controller.dart';
import 'package:beacon/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/test_setup.dart';

void main() {
  setUpAll(() async {
    await initTestStorage();
    PackageInfo.setMockInitialValues(
      appName: 'Beacon',
      packageName: 'pub.brs.flbeacon',
      version: '1.0.3',
      buildNumber: '111',
      buildSignature: '',
    );
  });

  setUp(() {
    registerAppController();
    registerHomeController();
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

      expect(find.text('APPEARANCE'), findsOneWidget);
    });

    testWidgets('renders Language section', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      expect(find.text('LANGUAGE'), findsOneWidget);
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

    testWidgets('after changing theme, the language check is still the only one', (tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();

      await tester.tap(find.text('Light'));
      await tester.pumpAndSettle();

      // The theme picker is a segmented row, so only the language list checks.
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
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

      // Only AppLocale.enUS: the theme picker shows selection by fill instead.
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });

  // ── about ───────────────────────────────────────────────────────────────────

  group('about', () {
    // The section sits at the bottom of the list, past the default 800x600
    // test viewport, so it has to be scrolled into view first.
    Future<void> openSettingsAtAbout(WidgetTester tester) async {
      await tester.pumpWidget(testApp(const SettingsPage()));
      await tester.pump();
      await tester.scrollUntilVisible(find.text('App description and version'), 200);
      await tester.pumpAndSettle();
    }

    testWidgets('renders the About section', (tester) async {
      await openSettingsAtAbout(tester);

      // Privacy and About share one card, so the row title stands alone.
      expect(find.text('About'), findsOneWidget);
      expect(find.text('App description and version'), findsOneWidget);
    });

    testWidgets('tapping it opens a dialog with description and version', (tester) async {
      await openSettingsAtAbout(tester);

      await tester.tap(find.text('App description and version'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('sends files straight between your own devices'), findsOneWidget);
      expect(find.text('Version 1.0.3 (111)'), findsOneWidget);
    });

    testWidgets('close dismisses the dialog', (tester) async {
      await openSettingsAtAbout(tester);

      await tester.tap(find.text('App description and version'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
