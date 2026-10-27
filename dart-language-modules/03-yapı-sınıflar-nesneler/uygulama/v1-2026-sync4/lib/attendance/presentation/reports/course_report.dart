// DART KONUSU: Classes & objects — factory constructor (`CourseReport.build`),
// records, getter'lar, extension kullanımı. Libraries & imports — `as pw`
// öneki (pdf paketinin `Text`, `Table` gibi adları Flutter'ınkilerle
// çakışır), `show`. Class modifiers — `final class`. Metadata — `@immutable`.

/// Ders raporu: öğrenci bazlı devam, oturum bazlı dağılım, CSV ve PDF.
library;

import 'dart:typed_data' show ByteData, Uint8List;

import 'package:csv/csv.dart' show Csv;
import 'package:meta/meta.dart';
import 'package:pdf/pdf.dart' show PdfColor, PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart' as pw;
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart' show Record;
import 'package:sarkisla_yoklama/core/core.dart';

/// Bir oturumdaki durum dağılımı.
typedef SessionTally = ({
  AttendanceSession session,
  int present,
  int late,
  int absent,
  int excused,
});

/// Ders raporu (zincirdeki düzeltilmiş kayıtlardan üretilir).
@immutable
final class CourseReport {
  const CourseReport._({
    required this.course,
    required this.rows,
    required this.sessions,
    required this.generatedAt,
  });

  /// Zincir kayıtlarından rapor üretir.
  factory CourseReport.build({
    required Course course,
    required List<Student> roster,
    required List<AttendanceSession> sessions,
    required Iterable<Record> ledger,
    required DateTime now,
  }) {
    final effective = ledger.effectiveFor(course.id);
    final closed = sessions.where((s) => !s.isOpen).toList()
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    return CourseReport._(
      course: course,
      generatedAt: now,
      rows: [
        for (final s
            in roster.toList()
              ..sort((a, b) => a.studentNumber.compareTo(b.studentNumber)))
          (student: s, summary: ledger.summaryFor(course, s.uid)),
      ],
      sessions: [
        for (final session in closed)
          _tally(session, effective.where((e) => e.sessionId == session.id)),
      ],
    );
  }

  static SessionTally _tally(
    AttendanceSession session,
    Iterable<EffectiveAttendance> entries,
  ) {
    var present = 0;
    var late = 0;
    var absent = 0;
    var excused = 0;
    for (final e in entries) {
      switch (e.status) {
        case Present():
          present++;
        case Late():
          late++;
        case Absent():
          absent++;
        case Excused():
          excused++;
      }
    }
    return (
      session: session,
      present: present,
      late: late,
      absent: absent,
      excused: excused,
    );
  }

  final Course course;
  final List<({Student student, AttendanceSummary summary})> rows;
  final List<SessionTally> sessions;
  final DateTime generatedAt;

  static const List<String> _header = [
    'Okul No',
    'Ad Soyad',
    'Katıldı',
    'Geç',
    'Devamsız',
    'Mazeretli',
    'Devam %',
    'Durum',
  ];

  List<List<String>> get _table => [
    for (final (:student, :summary) in rows)
      [
        student.studentNumber,
        student.displayName,
        '${summary.present}',
        '${summary.late}',
        '${summary.absent}',
        '${summary.excused}',
        (summary.rate * 100).toStringAsFixed(0),
        if (summary.isOverLimit)
          'Devamsızlıktan kaldı'
        else if (summary.isNearLimit)
          'Sınırda'
        else
          'Uygun',
      ],
  ];

  /// Excel'in Türkçe ayarlarıyla uyumlu (`;` ayraçlı) CSV.
  String toCsv() => '﻿${Csv(fieldDelimiter: ';').encode([_header, ..._table])}';

  /// Gömülü Fira Sans yazı tipiyle PDF. Helvetica Türkçe karakterleri
  /// içermediği için yazı tipi baytları dışarıdan verilir.
  Future<Uint8List> toPdf({
    required ByteData regularFont,
    required ByteData boldFont,
  }) async {
    final theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(regularFont),
      bold: pw.Font.ttf(boldFont),
    );
    const accent = PdfColor.fromInt(0xFF6366F1);
    final doc =
        pw.Document(
          title: '${course.code} Yoklama Raporu',
          author: 'Şarkışla UBYO',
        )..addPage(
          pw.MultiPage(
            theme: theme,
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            header: (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Şarkışla Uygulamalı Bilimler Yüksekokulu',
                  style: const pw.TextStyle(color: PdfColors.grey700),
                ),
                pw.Text(
                  '${course.code} · ${course.name}',
                  style: const pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                    color: accent,
                  ),
                ),
                pw.Text(
                  '${course.department.label} · ${sessions.length} oturum · '
                  'Rapor: ${generatedAt.trDateTime}',
                  style: const pw.TextStyle(color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 12),
              ],
            ),
            footer: (context) => pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Kayıtlar Proof of Authority zincirinde doğrulanabilir · '
                '${context.pageNumber}/${context.pagesCount}',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
              ),
            ),
            build: (_) => [
              pw.TableHelper.fromTextArray(
                headers: _header,
                data: _table,
                headerStyle: const pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                headerDecoration: const pw.BoxDecoration(color: accent),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellAlignment: pw.Alignment.centerLeft,
                oddRowDecoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Oturum bazında dağılım',
                style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 6),
              pw.TableHelper.fromTextArray(
                headers: const [
                  'Tarih',
                  'Blok',
                  'Katıldı',
                  'Geç',
                  'Devamsız',
                  'Mazeretli',
                ],
                data: [
                  for (final t in sessions)
                    [
                      t.session.startedAt.trDateTime,
                      '#${t.session.blockIndex}',
                      '${t.present}',
                      '${t.late}',
                      '${t.absent}',
                      '${t.excused}',
                    ],
                ],
                cellStyle: const pw.TextStyle(fontSize: 9),
              ),
            ],
          ),
        );
    return await doc.save();
  }
}
