// DART KONUSU: Classes & objects — enhanced enum, const constructor,
// `String.fromEnvironment` ile derleme zamanı sabiti. Metadata —
// `@immutable`.

/// Derleme zamanı yapılandırması.
library;

import 'package:meta/meta.dart';

/// Veri kaynağı.
enum Backend {
  /// Bellek içi depolar; Firebase gerekmez.
  demo,

  /// Firebase Auth + Firestore.
  firebase,
}

/// `flutter run --dart-define=BACKEND=firebase` ile seçilir.
@immutable
final class AppConfig {
  const AppConfig({required this.backend});

  /// Ortam değişkeninden okunur; varsayılan demo modudur.
  factory AppConfig.fromEnvironment() => const AppConfig(
    backend: String.fromEnvironment('BACKEND') == 'firebase'
        ? Backend.firebase
        : Backend.demo,
  );

  final Backend backend;

  bool get isDemo => backend == Backend.demo;
}
