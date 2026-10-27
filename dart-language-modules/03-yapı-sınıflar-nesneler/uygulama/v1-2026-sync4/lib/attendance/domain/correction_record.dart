// DART KONUSU: Metadata — `@OnChainRecord`, `@JsonSerializable`,
// `@JsonKey`. Libraries & imports — `part`. Classes & objects — const /
// factory constructor, getter. Class modifiers — `final class`.

/// Düzeltme kaydı: geçmiş bir yoklama kaydını *değiştirmeden* geçersiz
/// kılar.
library;

import 'package:json_annotation/json_annotation.dart';
import 'package:sarkisla_yoklama/attendance/domain/attendance_status.dart';
import 'package:sarkisla_yoklama/attendance/domain/json_converters.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart' show Record;
import 'package:sarkisla_yoklama/core/core.dart';

part 'correction_record.g.dart';

/// Zincir değiştirilemez olduğu için yanlış girilmiş bir yoklama
/// silinmez. Onun yerine eski kaydın hash'ine işaret eden yeni bir düzeltme
/// kaydı eklenir. İstatistikler en son düzeltmeyi esas alır; asıl kayıt ve
/// düzeltmenin kendisi denetim için zincirde kalır.
@OnChainRecord(type: CorrectionRecord.kind)
@JsonSerializable()
@StatusConverter()
@EpochMillisConverter()
final class CorrectionRecord extends Record with Timestamped {
  const CorrectionRecord({
    required this.correctsRecordHash,
    required this.sessionId,
    required this.courseId,
    required this.studentId,
    required this.newStatus,
    required this.reason,
    required this.correctedBy,
    required this.timestamp,
  });

  factory CorrectionRecord.fromJson(Map<String, Object?> json) =>
      _$CorrectionRecordFromJson(json);

  static const String kind = 'correction';

  /// Düzeltilen kaydın işlem hash'i (hex).
  @JsonKey(name: 'corrects')
  final String correctsRecordHash;
  final String sessionId;
  final String courseId;
  final String studentId;
  final AttendanceStatus newStatus;

  /// Düzeltme gerekçesi (zorunlu; denetim izi).
  final String reason;

  /// Düzeltmeyi yapan öğretim görevlisi.
  final String correctedBy;

  @override
  final DateTime timestamp;

  /// Düzeltilen kaydın hash'i.
  Hash get corrects => Hash.fromHex(correctsRecordHash);

  @override
  String get recordType => kind;

  @override
  String get recordId =>
      'fix:$sessionId:$studentId:${timestamp.millisecondsSinceEpoch}';

  @override
  Map<String, Object?> toJson() => _$CorrectionRecordToJson(this);

  @override
  String toString() => 'CorrectionRecord($studentId @ $sessionId → $newStatus)';
}
