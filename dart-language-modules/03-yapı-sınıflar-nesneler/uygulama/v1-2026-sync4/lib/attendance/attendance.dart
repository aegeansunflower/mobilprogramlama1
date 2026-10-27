// DART KONUSU: Libraries & imports — barrel dosya. `json_converters.dart`
// bilerek dışa aktarılmaz; yalnızca kayıt modellerinin içinde kullanılır.

/// Yoklama alanı: durumlar, zincir kayıtları, oturumlar, QR jetonu, hile
/// önleme kuralları, istatistik ve depolar.
library;

export 'data/demo_attendance_repository.dart';
export 'data/firestore_attendance_repository.dart';
export 'data/location_providers.dart';
export 'domain/attendance_ledger.dart';
export 'domain/attendance_record.dart';
export 'domain/attendance_repository.dart';
export 'domain/attendance_session.dart';
export 'domain/attendance_status.dart';
export 'domain/correction_record.dart';
export 'domain/course.dart';
export 'domain/geofence.dart';
export 'domain/ledger_codec.dart';
export 'domain/qr_token.dart';
export 'domain/usecases/check_in.dart';
export 'domain/usecases/correct_attendance.dart';
export 'domain/usecases/end_session.dart';
