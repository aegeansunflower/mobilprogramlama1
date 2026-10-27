// DART KONUSU: Metadata — özel annotation sınıfı ve `meta_meta` ile hedef
// kısıtlaması (@Target).

/// Zincire yazılan modelleri işaretleyen annotation.
library;

import 'package:meta/meta_meta.dart';

/// Bir sınıfın blockchain'e *işlem (transaction)* olarak yazıldığını belirtir.
///
/// Bu annotation iki yerde gerçekten kullanılır:
/// * `tool/check_annotations.dart` işaretli her sınıfın `Record`'dan
///   türediğini, `fromJson`/`toJson` içerdiğini ve [type] değerinin tekil
///   olduğunu denetler.
/// * [schemaVersion] kayıt JSON'una yazılır; ileride şema değişirse eski
///   bloklar doğru sürümle çözülür.
@Target({TargetKind.classType})
final class OnChainRecord {
  /// Annotation'ı oluşturur. `const` olmak zorundadır; Dart'ta metadata
  /// yalnızca derleme zamanı sabitleriyle yazılabilir.
  const OnChainRecord({required this.type, this.schemaVersion = 1});

  /// Kayıt türünün zincirdeki adı (`attendance`, `correction` …).
  final String type;

  /// Kayıt şemasının sürümü.
  final int schemaVersion;
}
