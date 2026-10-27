// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'correction_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CorrectionRecord _$CorrectionRecordFromJson(Map<String, dynamic> json) =>
    CorrectionRecord(
      correctsRecordHash: json['corrects'] as String,
      sessionId: json['sessionId'] as String,
      courseId: json['courseId'] as String,
      studentId: json['studentId'] as String,
      newStatus: const StatusConverter().fromJson(
        json['newStatus'] as Map<String, Object?>,
      ),
      reason: json['reason'] as String,
      correctedBy: json['correctedBy'] as String,
      timestamp: const EpochMillisConverter().fromJson(
        (json['timestamp'] as num).toInt(),
      ),
    );

Map<String, dynamic> _$CorrectionRecordToJson(CorrectionRecord instance) =>
    <String, dynamic>{
      'corrects': instance.correctsRecordHash,
      'sessionId': instance.sessionId,
      'courseId': instance.courseId,
      'studentId': instance.studentId,
      'newStatus': const StatusConverter().toJson(instance.newStatus),
      'reason': instance.reason,
      'correctedBy': instance.correctedBy,
      'timestamp': const EpochMillisConverter().toJson(instance.timestamp),
    };
