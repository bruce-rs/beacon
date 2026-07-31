import 'package:beacon/features/beacon/data/models/file_transfer.dart';
import 'package:beacon/features/beacon/services/beacon_service.dart';
import 'package:beacon/features/home/presentation/controllers/home_controller.dart';
import 'package:beacon/features/home/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import '../helpers/test_setup.dart';

void main() {
  late FakeBeaconService beacon;

  setUpAll(() async {
    await initTestStorage();
  });

  setUp(() {
    beacon = FakeBeaconService();
    GetIt.I.registerSingleton<BeaconService>(beacon);
    GetIt.I.registerLazySingleton<HomeController>(() => HomeController(GetIt.I<BeaconService>()));
  });

  tearDown(() async {
    await beacon.closeStreams();
    GetIt.I.reset();
  });

  // ── device discovery section ────────────────────────────────────────────────

  group('device section', () {
    testWidgets('shows searching text when no devices found', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      expect(find.text('Nearby Devices'), findsOneWidget);
      expect(find.text('Searching for devices on your network…'), findsOneWidget);
    });

    testWidgets('shows device card when a device is discovered', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitDevices([makeDevice(name: 'iPhone 16')]);
      await tester.pump();

      expect(find.text('iPhone 16'), findsOneWidget);
      expect(find.text('Searching for devices on your network…'), findsNothing);
    });

    testWidgets('shows multiple device cards', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitDevices([makeDevice(id: 'a', name: 'MacBook'), makeDevice(id: 'b', name: 'iPad')]);
      await tester.pump();

      expect(find.text('MacBook'), findsOneWidget);
      expect(find.text('iPad'), findsOneWidget);
    });

    testWidgets('returns to searching text when all devices lost', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitDevices([makeDevice(name: 'Mac')]);
      await tester.pump();
      expect(find.text('Mac'), findsOneWidget);

      beacon.emitDevices([]);
      await tester.pump();
      expect(find.text('Searching for devices on your network…'), findsOneWidget);
    });
  });

  // ── drop zone ──────────────────────────────────────────────────────────────

  group('drop zone', () {
    testWidgets('shows inactive label when no device selected', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      expect(find.text('Select a device above to send files'), findsOneWidget);
    });

    testWidgets('changes label after selecting a device', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitDevices([makeDevice(name: 'MacBook')]);
      await tester.pump();

      await tester.tap(find.text('MacBook'));
      await tester.pump();

      expect(find.text('Select a device above to send files'), findsNothing);
    });

    testWidgets('restores inactive label when device deselected', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitDevices([makeDevice(name: 'MacBook')]);
      await tester.pump();

      // Select
      await tester.tap(find.text('MacBook'));
      await tester.pump();
      // Deselect (tap same)
      await tester.tap(find.text('MacBook'));
      await tester.pump();

      expect(find.text('Select a device above to send files'), findsOneWidget);
    });
  });

  // ── transfers section ──────────────────────────────────────────────────────

  group('transfers section', () {
    testWidgets('does not show transfers header when list is empty', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      expect(find.text('Transfers'), findsNothing);
    });

    testWidgets('shows transfers header when a transfer arrives', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitTransfer(makeTransfer());
      await tester.pump();

      expect(find.text('Transfers'), findsOneWidget);
    });

    testWidgets('shows transfer filename', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitTransfer(
        FileTransfer(
          id: 'tx-1',
          filename: 'report.pdf',
          fileSize: 2048,
          direction: TransferDirection.send,
          deviceName: 'iPhone',
        ),
      );
      await tester.pump();

      expect(find.text('report.pdf'), findsOneWidget);
    });

    testWidgets('shows multiple transfers', (tester) async {
      await tester.pumpWidget(testApp(const HomePage()));
      await tester.pump();

      beacon.emitTransfer(makeTransfer(id: 'tx-1'));
      await tester.pump();
      beacon.emitTransfer(makeTransfer(id: 'tx-2'));
      await tester.pump();

      final ctrl = GetIt.I<HomeController>();
      expect(ctrl.transfers.length, 2);
    });
  });
}
