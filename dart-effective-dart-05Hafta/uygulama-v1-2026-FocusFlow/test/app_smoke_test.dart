import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_flow/app.dart';
import 'package:focus_flow/blockchain/repositories/focus_chain_repository.dart';
import 'package:focus_flow/blockchain/repositories/wallet_repository.dart';
import 'package:focus_flow/blockchain/state/focus_chain_service.dart';
import 'package:focus_flow/data/focus_session_repository.dart';
import 'package:focus_flow/data/local_storage_service.dart';
import 'package:focus_flow/data/settings_repository.dart';
import 'package:focus_flow/data/task_repository.dart';
import 'package:focus_flow/features/settings/settings_screen.dart';
import 'package:focus_flow/state/app_controller.dart';
import 'package:focus_flow/widgets/app_bottom_navigation.dart';

Future<AppController> _pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues(<String, Object>{});
  final preferences = await SharedPreferences.getInstance();
  final storage = LocalStorageService(preferences);
  final controller = AppController(
    taskRepository: TaskRepository(storage),
    sessionRepository: FocusSessionRepository(storage),
    settingsRepository: SettingsRepository(storage),
    chainService: FocusChainService(
      chainRepository: FocusChainRepository(storage),
      walletRepository: WalletRepository(storage),
    ),
  );

  await tester.pumpWidget(FocusFlowApp(controller: controller));
  await tester.pumpAndSettle();
  return controller;
}

Finder _navLabel(String label) {
  return find.descendant(
    of: find.byType(AppBottomNavigation),
    matching: find.text(label),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('beş sekme dar ekranda taşmadan gezilebilir', (tester) async {
    await _pumpApp(tester);

    for (final label in <String>['Odak', 'Görevler', 'Kanıt', 'Cüzdan']) {
      await tester.tap(_navLabel(label));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }

    await tester.tap(_navLabel('Ana Sayfa'));
    await tester.pumpAndSettle();
    expect(find.text('Bugün neler yapacaksın?'), findsOneWidget);
  });

  testWidgets('cüzdandan ödül mağazası açılır', (tester) async {
    await _pumpApp(tester);

    await tester.tap(_navLabel('Cüzdan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ödül Mağazası'));
    await tester.pumpAndSettle();

    expect(find.text('Kahve Molası'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ayarlar ve istatistik sayfaları açılır', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Ayarlar'), findsOneWidget);
    final settingsScrollable = find.descendant(
      of: find.byType(SettingsScreen),
      matching: find.byType(Scrollable, skipOffstage: false),
    );
    await tester.scrollUntilVisible(
      find.text('FocusFlow Proof'),
      300,
      scrollable: settingsScrollable.first,
    );
    expect(find.text('FocusFlow Proof'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.insights_rounded));
    await tester.pumpAndSettle();
    expect(find.text('İstatistikler'), findsOneWidget);
    expect(find.text('FOCUS bakiyesi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
