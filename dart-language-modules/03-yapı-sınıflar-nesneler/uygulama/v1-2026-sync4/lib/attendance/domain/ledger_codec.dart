// DART KONUSU: Classes & objects — switch ifadesiyle tür seçimi, top-level
// fonksiyonun `RecordDecoder<Record>` typedef'ine uyması. Libraries & imports
// — `show`.

/// Zincirdeki kayıt zarflarını somut türlere çözer.
library;

import 'package:sarkisla_yoklama/attendance/domain/attendance_record.dart';
import 'package:sarkisla_yoklama/attendance/domain/correction_record.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart'
    show Record, RecordDecoder;

/// Yoklama zincirinin kayıt çözücüsü.
///
/// Yeni bir `@OnChainRecord` türü eklendiğinde buraya da eklenmelidir
/// (`tool/check_annotations.dart` bunu denetler).
Record decodeLedgerRecord(Map<String, Object?> envelope) {
  final data = Map<String, Object?>.from(envelope['data']! as Map);
  return switch (envelope['type']) {
    AttendanceRecord.kind => AttendanceRecord.fromJson(data),
    CorrectionRecord.kind => CorrectionRecord.fromJson(data),
    final other => throw FormatException('Bilinmeyen kayıt türü', other),
  };
}

/// `BlockchainRepository<Record>` kurulumunda verilen çözücü.
const RecordDecoder<Record> ledgerDecoder = decodeLedgerRecord;
