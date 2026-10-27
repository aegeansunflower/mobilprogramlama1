// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) =>
    AttendanceRecord(
      sessionId: json['sessionId'] as String,
      courseId: json['courseId'] as String,
      studentId: json['studentId'] as String,
      studentNumber: json['studentNumber'] as String,
      status: const StatusConverter().fromJson(
        json['status'] as Map<String, Object?>,
      ),
      timestamp: const EpochMillisConverter().fromJson(
        (json['timestamp'] as num).toInt(),
      ),
      deviceId: json['deviceId'] as String?,
    );

Map<String, dynamic> _$AttendanceRecordToJson(AttendanceRecord instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'courseId': instance.courseId,
      'studentId': instance.studentId,
      'studentNumber': instance.studentNumber,
      'status': const StatusConverter().toJson(instance.status),
      'timestamp': const EpochMillisConverter().toJson(instance.timestamp),
      'deviceId': instance.deviceId,
    };
