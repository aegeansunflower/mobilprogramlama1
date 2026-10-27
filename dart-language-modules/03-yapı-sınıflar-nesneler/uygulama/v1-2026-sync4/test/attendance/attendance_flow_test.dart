import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/app/demo_seed.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

import '../helpers/test_doubles.dart';

/// Uçtan uca yoklama akışı: oturum → QR → katılım → blok → makbuz →
/// düzeltme → istatistik.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late FixedClock clock;
  late DemoAttendanceRepository attendance;
  late LocalFirstBlockchainRepository<Record> chain;
  late ChainDatabase db;
  late Ed25519Signer signer;
  late InMemoryAuthorityDirectory directory;
  late CheckIn checkIn;
  late Course course;
  late AttendanceSession session;

  const hoca = DemoSeed.ayseHoca;
  final elif = DemoSeed.bstStudents[0];
  final burak = DemoSeed.bstStudents[1];
  final deniz = const Student(
    uid: 'ogr-kayitsiz',
    displayName: 'Kayıtsız Öğrenci',
    email: 'kayitsiz@ogrenci.sarkisla.edu.tr',
    studentNumber: '2024489999',
    department: Department.artificialIntelligence,
  ); // BST101'e kayıtlı değil

  Future<String> freshQr() async {
    final token = await QrToken.issue(
      sessionId: session.id,
      signer: signer,
      now: clock.now(),
    );
    await attendance.publishNonce(
      session.id,
      token.nonce,
      actor: Role.instructor,
    );
    return token.encode();
  }

  setUp(() async {
    clock = FixedClock(DateTime.utc(2026, 10, 7, 9));
    attendance = DemoAttendanceRepository(
      courses: DemoSeed.courses,
      students: DemoSeed.students,
    );
    signer = await Ed25519Signer.fromSeed(hoca.uid, List.filled(32, 5));
    directory = InMemoryAuthorityDirectory();
    await directory.register(hoca.uid, await signer.publicKey());
    db = ChainDatabase(NativeDatabase.memory());
    chain = LocalFirstBlockchainRepository<Record>(
      database: db,
      remote: InMemoryRemoteChainSource(),
      consensus: ProofOfAuthority(directory: directory),
      decode: ledgerDecoder,
      clock: clock,
    );
    checkIn = CheckIn(
      repository: attendance,
      validateQr: QrTokenValidator(directory: directory, clock: clock),
      clock: clock,
    );
    course = (await attendance.course('bst101'))!;
    session = (await attendance.startSession(
      course: course,
      instructor: hoca,
      at: clock.now(),
    )).valueOrNull!;
  });

  tearDown(() => db.close());

  group('QR ve hile önleme', () {
    test('geçerli QR ile yoklama alınır, işlem hash’i döner', () async {
      final r = await checkIn(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'd-elif',
      );
      final pending = r.valueOrNull!;
      expect(pending.record.status, const Present());
      expect(pending.transactionHash, pending.record.recordHash);
    });

    test('aynı öğrenci aynı oturumda ikinci kez yoklama veremez', () async {
      await checkIn(rawQr: await freshQr(), student: elif, deviceId: 'd-elif');
      final again = await checkIn(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'd-elif',
      );
      expect(again.failureOrNull?.message, contains('zaten alındı'));
    });

    test('15 sn’den eski QR reddedilir', () async {
      final qr = await freshQr();
      clock.advance(const Duration(seconds: 21));
      final r = await checkIn(rawQr: qr, student: elif, deviceId: 'd');
      expect(r.failureOrNull?.message, contains('süresi doldu'));
    });

    test('QR yenilendikten iki tur sonra eski nonce geçersizdir', () async {
      final old = await freshQr();
      await freshQr();
      await freshQr(); // yalnızca son iki nonce geçerli
      final r = await checkIn(rawQr: old, student: elif, deviceId: 'd');
      expect(r.failureOrNull?.message, contains('artık geçerli değil'));
    });

    test('imzası değiştirilmiş QR reddedilir', () async {
      final parts = (await freshQr()).split('.');
      final forged = '${parts[0]}.${parts[1]}.${'A' * parts[2].length}';
      final r = await checkIn(rawQr: forged, student: elif, deviceId: 'd');
      expect(r.failureOrNull?.message, contains('imzası geçersiz'));
    });

    test('yetkisiz anahtarla üretilmiş QR reddedilir', () async {
      final fake = await Ed25519Signer.fromSeed('sahte', List.filled(32, 1));
      final token = await QrToken.issue(
        sessionId: session.id,
        signer: fake,
        now: clock.now(),
      );
      final r = await checkIn(
        rawQr: token.encode(),
        student: elif,
        deviceId: 'd',
      );
      expect(r.failureOrNull?.message, contains('yetkili'));
    });

    test('bağlı olmayan cihazdan yoklama verilemez', () async {
      final bound = elif.copyWith(boundDeviceId: 'telefonum');
      final r = await checkIn(
        rawQr: await freshQr(),
        student: bound,
        deviceId: 'arkadasimin-telefonu',
      );
      expect(r.failureOrNull?.message, contains('bağlı cihaz'));
    });

    test('aynı cihazdan iki farklı öğrenci yoklama veremez', () async {
      await checkIn(rawQr: await freshQr(), student: elif, deviceId: 'ortak');
      final r = await checkIn(
        rawQr: await freshQr(),
        student: burak,
        deviceId: 'ortak',
      );
      expect(r.failureOrNull?.message, contains('Bu cihazdan'));
    });

    test('derse kayıtlı olmayan öğrenci reddedilir', () async {
      final r = await checkIn(
        rawQr: await freshQr(),
        student: deniz,
        deviceId: 'd',
      );
      expect(r.failureOrNull?.message, contains('kayıtlı değil'));
    });

    test('konum zorunluysa kampüs dışından yoklama verilemez', () async {
      final located = await attendance.startSession(
        course: (await attendance.course('bst205'))!,
        instructor: hoca,
        at: clock.now(),
        requireLocation: true,
      );
      session = located.valueOrNull!;
      final outside = CheckIn(
        repository: attendance,
        validateQr: QrTokenValidator(directory: directory, clock: clock),
        clock: clock,
        location: const FixedLocationProvider((
          latitude: 39.75,
          longitude: 37.02,
        )), // Sivas merkez
      );
      final r = await outside(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'd',
      );
      expect(r.failureOrNull?.message, contains('Kampüs dışındasınız'));

      final inside = CheckIn(
        repository: attendance,
        validateQr: QrTokenValidator(directory: directory, clock: clock),
        clock: clock,
        location: const FixedLocationProvider((
          latitude: 39.3542,
          longitude: 36.4093,
        )),
      );
      final ok = await inside(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'd',
      );
      expect(ok.isOk, isTrue);
    });

    test(
      '@RoleRestricted: öğrenci QR nonce yayınlayamaz, oturum kapatamaz',
      () async {
        final nonce = await attendance.publishNonce(
          session.id,
          'x',
          actor: Role.student,
        );
        expect(nonce.failureOrNull, isA<PermissionFailure>());
        final close = await attendance.closeSession(
          session.id,
          actor: Role.student,
          at: clock.now(),
          blockIndex: 1,
        );
        expect(close.failureOrNull, isA<PermissionFailure>());
      },
    );

    test('@Deprecated v1 QR anlamlı hatayla reddedilir', () async {
      final r = await checkIn(
        rawQr: 'SYQ1|${session.id}|0',
        student: elif,
        deviceId: 'd',
      );
      expect(r.failureOrNull?.message, contains('Eski QR'));
      // Kullanımdan kaldırılan API bilerek çağrılıyor: geriye uyumluluk testi.
      // ignore: deprecated_member_use_from_same_package
      expect(QrToken.decodeLegacyV1('SYQ1|x|0').valueOrNull?.signature, isNull);
    });

    test('geç gelen öğrenci "Geç" olarak işaretlenir', () async {
      clock.advance(const Duration(minutes: 25));
      final r = await checkIn(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'd',
      );
      expect(r.valueOrNull?.record.status, const Late(15));
    });
  });

  group('Oturum kapanışı ve zincir', () {
    late EndSession endSession;

    setUp(() {
      endSession = EndSession(
        attendance: attendance,
        chain: chain,
        clock: clock,
      );
    });

    test('kayıtlar bloğa yazılır, gelmeyenler Devamsız olur', () async {
      await checkIn(rawQr: await freshQr(), student: elif, deviceId: 'e');
      clock.advance(const Duration(minutes: 12));
      await checkIn(rawQr: await freshQr(), student: burak, deviceId: 'b');

      final summary = (await endSession(
        sessionId: session.id,
        instructor: hoca,
        signer: signer,
      )).valueOrNull!;

      expect(summary.block.index, 1);
      expect(summary.present, 1);
      expect(summary.late, 1);
      expect(summary.absent, course.studentIds.length - 2);
      expect(summary.block.transactions, hasLength(course.studentIds.length));
      expect(await chain.validate(), isA<ChainValid>());

      final closed = (await attendance.session(session.id))!;
      expect(closed.isOpen, isFalse);
      expect(closed.blockIndex, 1);
    });

    test('makbuz: öğrencinin işlem hash’i bloktaki kayda eşittir', () async {
      final pending = (await checkIn(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'e',
      )).valueOrNull!;
      await endSession(sessionId: session.id, instructor: hoca, signer: signer);

      final receipt = await chain.receiptFor(pending.transactionHash);
      expect(receipt, isNotNull);
      expect(receipt!.isValid, isTrue);
      expect(receipt.blockIndex, 1);
    });

    test('kapanmış oturuma yoklama verilemez ve tekrar kapatılamaz', () async {
      await endSession(sessionId: session.id, instructor: hoca, signer: signer);
      final late = await checkIn(
        rawQr: await freshQr(),
        student: elif,
        deviceId: 'e',
      );
      expect(late.failureOrNull?.message, contains('kapanmış'));
      final again = await endSession(
        sessionId: session.id,
        instructor: hoca,
        signer: signer,
      );
      expect(again.isOk, isFalse);
    });

    test('oturumu başka görevli kapatamaz', () async {
      final r = await endSession(
        sessionId: session.id,
        instructor: DemoSeed.mehmetHoca,
        signer: signer,
      );
      expect(r.failureOrNull, isA<PermissionFailure>());
    });

    test('düzeltme bloğu: eski kayıt kalır, istatistik değişir', () async {
      await checkIn(rawQr: await freshQr(), student: elif, deviceId: 'e');
      await endSession(sessionId: session.id, instructor: hoca, signer: signer);

      var records = (await chain.currentBlocks()).expand((b) => b.transactions);
      final burakBefore = records.summaryFor(course, burak.uid);
      expect(burakBefore.absent, 1);

      final target = records
          .effectiveFor(course.id)
          .firstWhere((e) => e.studentId == burak.uid);
      final fix = await CorrectAttendance(chain: chain, clock: clock)(
        target: target,
        newStatus: const Excused('Sağlık raporu'),
        reason: 'Sağlık raporu teslim edildi',
        instructor: hoca,
        signer: signer,
      );
      expect(fix.isOk, isTrue);

      final blocks = await chain.currentBlocks();
      expect(blocks, hasLength(3)); // genesis + yoklama + düzeltme
      records = blocks.expand((b) => b.transactions);
      final burakAfter = records.summaryFor(course, burak.uid);
      expect(burakAfter.absent, 0);
      expect(burakAfter.excused, 1);
      // Asıl kayıt zincirde değişmeden duruyor.
      expect(
        records.attendanceOf(session.id, burak.uid)!.status,
        const Absent(),
      );
      expect(await chain.validate(), isA<ChainValid>());
    });

    test('gerekçesiz düzeltme reddedilir', () async {
      await endSession(sessionId: session.id, instructor: hoca, signer: signer);
      final records = (await chain.currentBlocks()).expand(
        (b) => b.transactions,
      );
      final r = await CorrectAttendance(chain: chain, clock: clock)(
        target: records.effectiveFor(course.id).first,
        newStatus: const Present(),
        reason: '',
        instructor: hoca,
        signer: signer,
      );
      expect(r.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('Modeller', () {
    test('AttendanceStatus JSON ve sealed switch', () {
      const all = <AttendanceStatus>[
        Present(),
        Late(7),
        Absent(),
        Excused('Görevli'),
      ];
      for (final s in all) {
        expect(AttendanceStatus.fromJson(s.toJson()), s);
      }
      expect(all.where((s) => s.countsAsAttended), hasLength(3));
    });

    test('AttendanceRecord JSON gidiş-dönüşü hash’i korur', () {
      final r = AttendanceRecord(
        sessionId: 's',
        courseId: 'c',
        studentId: 'u',
        studentNumber: '2026101001',
        status: const Late(3),
        timestamp: DateTime.utc(2026, 10, 7, 9, 13),
        deviceId: 'd',
      );
      final back = decodeLedgerRecord(r.envelope);
      expect(back, isA<AttendanceRecord>());
      expect(back.recordHash, r.recordHash);
    });

    test('devamsızlık sınırı uyarısı', () {
      final c = DemoSeed.courses.first; // 14 oturum, %30 → 4 hak
      AttendanceSummary s(int absent) => AttendanceSummary(
        course: c,
        present: 5,
        late: 0,
        absent: absent,
        excused: 0,
      );
      expect(c.maxAbsences, 4);
      expect(s(2).isNearLimit, isFalse);
      expect(s(3).isNearLimit, isTrue);
      expect(s(5).isOverLimit, isTrue);
      expect(s(0).rate, 1);
    });

    test('GeofencePolicy uzaklık', () {
      const g = GeofencePolicy.sarkislaCampus;
      expect(g.contains((latitude: g.latitude, longitude: g.longitude)), true);
      expect(
        g.distanceTo((latitude: 39.75, longitude: 37.02)),
        greaterThan(60000),
      );
    });
  });
}
