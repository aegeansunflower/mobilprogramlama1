// DART KONUSU: Libraries & imports — barrel dosya (`export`) ve `hide` ile
// dışa aktarımı daraltma.

/// Çekirdek katman: sonuç tipi, hatalar, annotation'lar, kripto yardımcıları,
/// mixin'ler, extension'lar ve platform soyutlamaları.
///
/// Diğer katmanlar yalnızca `import 'package:sarkisla_yoklama/core/core.dart';`
/// yazar; iç dosya yerleşimi değişse de bu import değişmez.
library;

export 'annotations/on_chain_record.dart';
export 'annotations/role_restricted.dart';
export 'constants/department.dart';
export 'constants/role.dart';
// `_sorted` zaten private; burada yalnızca iki genel fonksiyon dışa açılır.
export 'crypto/canonical_json.dart' show canonicalBytes, canonicalJson;
export 'crypto/hash.dart';
export 'crypto/hashable.dart';
export 'errors/failure.dart';
// Saatlerle ilgili ham `int` extension'ı katman dışına sızdırılmaz.
export 'extensions/date_time_x.dart' hide EpochMillisX;
export 'extensions/string_x.dart';
export 'mixins/event_emitter.dart';
export 'mixins/timestamped.dart';
export 'platform/clock.dart';
export 'platform/key_value_store.dart';
export 'result/result.dart';
