// DART KONUSU: Libraries & imports — uygulama giriş noktası; `show` ile
// seçici importlar. Metadata — kütüphane dokümantasyonu.

/// Şarkışla Yoklama — blockchain tabanlı dijital yoklama.
///
/// Çalıştırma:
/// * Demo (Firebase gerekmez): `flutter run`
/// * Firebase: `flutter run --dart-define=BACKEND=firebase`
library;

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:intl/date_symbol_data_local.dart' show initializeDateFormatting;
import 'package:sarkisla_yoklama/app/app.dart';
import 'package:sarkisla_yoklama/app/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr');
  if (!AppConfig.fromEnvironment().isDemo) {
    // `flutterfire configure` ile üretilen google-services.json /
    // GoogleService-Info.plist dosyalarını kullanır.
    await Firebase.initializeApp();
  }
  runApp(const ProviderScope(child: SarkislaApp()));
}
