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
import 'package:focus_flow/state/app_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uygulama ana gezinme ile açılır', (tester) async {
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

    expect(find.text('FocusFlow'), findsOneWidget);
    expect(find.text('PROOF'), findsOneWidget);
    expect(find.text('Ana Sayfa'), findsOneWidget);
    expect(find.text('Odak'), findsWidgets);
    expect(find.text('Görevler'), findsWidgets);
    expect(find.text('Kanıt'), findsWidgets);
    expect(find.text('Cüzdan'), findsWidgets);
    expect(find.text('Bugün neler yapacaksın?'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    expect(find.byIcon(Icons.insights_rounded), findsOneWidget);

    await tester.tap(find.text('Kanıt'));
    await tester.pumpAndSettle();

    expect(find.text('Kanıt Defteri'), findsOneWidget);
  });
}
