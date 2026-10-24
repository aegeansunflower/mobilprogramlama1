import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'blockchain/repositories/focus_chain_repository.dart';
import 'blockchain/repositories/wallet_repository.dart';
import 'blockchain/state/focus_chain_service.dart';
import 'data/focus_session_repository.dart';
import 'data/local_storage_service.dart';
import 'data/settings_repository.dart';
import 'data/task_repository.dart';
import 'state/app_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
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
    runApp(FocusFlowApp(controller: controller));
  } catch (error, stackTrace) {
    debugPrint('FocusFlow Proof başlatılamadı: $error');
    debugPrintStack(stackTrace: stackTrace);
    runApp(const FocusFlowStartupErrorApp());
  }
}
