// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'SCÜ Yoklama';

  @override
  String get schoolName => 'Şarkışla Uygulamalı Bilimler Yüksekokulu';

  @override
  String get tagline => 'Değiştirilemez, doğrulanabilir yoklama';

  @override
  String get universityName => 'Sivas Cumhuriyet Üniversitesi';

  @override
  String get welcomeTitle => 'Hoş geldiniz';

  @override
  String get welcomeSubtitle => 'Devam etmek için giriş türünüzü seçin.';

  @override
  String get brandStatementLead => 'Yoklama artık';

  @override
  String get brandStatementEmphasis => 'değiştirilemez';

  @override
  String get brandStatementTail => 'bir kayıt.';

  @override
  String get brandCaption =>
      'Her yoklama, öğretim görevlisinin imzasıyla blok zincirine yazılır; sonradan kimse sessizce değiştiremez.';

  @override
  String get brandFootnote => 'PROOF OF AUTHORITY · ED25519 · MERKLE KANITI';

  @override
  String get instructorLoginTitle => 'Öğretim görevlisi girişi';

  @override
  String get studentLoginTitle => 'Öğrenci girişi';

  @override
  String get instructorLoginSubtitle =>
      'Kurumsal e-posta adresiniz ve şifrenizle giriş yapın.';

  @override
  String get studentLoginSubtitle =>
      'Okul numaranız ve şifrenizle giriş yapın.';

  @override
  String get backToRoles => 'Giriş türünü değiştir';

  @override
  String get statBlocks => 'Blok';

  @override
  String get statBlocksCaption => 'imzalı blok';

  @override
  String get statRecords => 'Kayıt';

  @override
  String get statRecordsCaption => 'zincirdeki yoklama kaydı';

  @override
  String get statCourses => 'Ders';

  @override
  String get statCoursesCaption => 'kayıtlı ders';

  @override
  String get roleSelectTitle => 'Nasıl giriş yapmak istersiniz?';

  @override
  String get roleInstructor => 'Öğretim Görevlisi';

  @override
  String get roleStudent => 'Öğrenci';

  @override
  String get roleInstructorHint =>
      'Oturum başlatın, QR gösterin, blokları imzalayın';

  @override
  String get roleStudentHint => 'QR tarayın, yoklamanızı zincirde doğrulayın';

  @override
  String get emailLabel => 'Kurumsal e-posta';

  @override
  String get studentNumberLabel => 'Okul numarası';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get emailInvalid => 'Geçerli bir e-posta adresi girin.';

  @override
  String get studentNumberInvalid => 'Okul numarası 9–12 haneli olmalıdır.';

  @override
  String get passwordTooShort => 'Şifre en az 6 karakter olmalıdır.';

  @override
  String get showPassword => 'Şifreyi göster';

  @override
  String get hidePassword => 'Şifreyi gizle';

  @override
  String get biometricTitle => 'Kimliğinizi doğrulayın';

  @override
  String get biometricBody =>
      'Şifreniz doğrulandı. Devam etmek için parmak izi ya da yüz tanıma kullanın.';

  @override
  String get biometricReason => 'SCÜ Yoklama\'ya güvenli giriş';

  @override
  String get biometricAction => 'Biyometrik doğrula';

  @override
  String demoModeBanner(String password) {
    return 'Demo modu: tüm hesapların şifresi $password';
  }

  @override
  String get demoAccounts => 'Demo hesapları';

  @override
  String greeting(String name) {
    return 'Merhaba, $name';
  }

  @override
  String get departmentsTitle => 'Bölüm seçin';

  @override
  String get coursesTitle => 'Dersler';

  @override
  String get noCourses => 'Bu bölümde verdiğiniz ders bulunmuyor.';

  @override
  String studentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğrenci',
      zero: 'Öğrenci yok',
    );
    return '$_temp0';
  }

  @override
  String get startSession => 'Yoklama başlat';

  @override
  String get continueSession => 'Açık oturuma dön';

  @override
  String get requireLocation => 'Kampüs konum doğrulaması';

  @override
  String get requireLocationHint =>
      'Öğrenciler yalnızca yerleşke sınırları içinden yoklama verebilir';

  @override
  String get liveSession => 'Canlı yoklama';

  @override
  String qrRefreshIn(int seconds) {
    return '$seconds sn içinde yenilenecek';
  }

  @override
  String get qrSemantics =>
      'Yoklama QR kodu. Öğrenciler bu kodu tarayarak yoklama verir.';

  @override
  String get participants => 'Katılımcılar';

  @override
  String participantsProgress(int arrived, int total) {
    return '$arrived / $total';
  }

  @override
  String get noParticipantsYet =>
      'Henüz katılım yok. Öğrencilerden QR kodu taramalarını isteyin.';

  @override
  String get endSession => 'Oturumu bitir ve zincire yaz';

  @override
  String get endSessionConfirmTitle => 'Oturum bitirilsin mi?';

  @override
  String get endSessionConfirmBody =>
      'Katılımlar ve gelmeyenler imzalı bir bloğa dönüştürülecek. Bu işlem geri alınamaz.';

  @override
  String endSessionDone(int index) {
    return 'Blok #$index zincire eklendi';
  }

  @override
  String get simulateStudent => 'Demo: öğrenci katılımı ekle';

  @override
  String get allStudentsArrived => 'Tüm öğrenciler katıldı.';

  @override
  String get history => 'Geçmiş yoklamalar';

  @override
  String get noHistory => 'Bu ders için henüz yoklama alınmadı.';

  @override
  String get openSession => 'Açık oturum';

  @override
  String sessionBlock(int index) {
    return 'Blok #$index';
  }

  @override
  String get studentStats => 'Öğrenci bazlı devam';

  @override
  String get attendanceRate => 'Devam oranı';

  @override
  String get statusPresent => 'Katıldı';

  @override
  String statusLate(int minutes) {
    return 'Geç ($minutes dk)';
  }

  @override
  String get statusAbsent => 'Devamsız';

  @override
  String get statusExcused => 'Mazeretli';

  @override
  String get chainTitle => 'Blok zinciri';

  @override
  String get chainValid => 'Zincir doğrulandı';

  @override
  String chainValidDetail(int count, String hash) {
    return '$count blok · son hash $hash';
  }

  @override
  String chainBroken(int index) {
    return 'Zincir bozuk: blok #$index';
  }

  @override
  String get chainChecking => 'Zincir doğrulanıyor…';

  @override
  String get validateAgain => 'Yeniden doğrula';

  @override
  String get simulateTamper => 'Demo: bir kaydı kurcala';

  @override
  String get tamperExplain =>
      'Bu düğme veritabanındaki bir yoklama kaydını doğrudan değiştirir. Doğrulama, zincirin tam olarak hangi blokta bozulduğunu gösterir.';

  @override
  String get tamperNeedsBlock =>
      'Kurcalamak için önce en az bir yoklama bloğu oluşturun.';

  @override
  String get genesisBlock => 'Genesis bloğu';

  @override
  String transactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count işlem',
      zero: 'İşlem yok',
    );
    return '$_temp0';
  }

  @override
  String signedBy(String authority) {
    return 'İmzalayan: $authority';
  }

  @override
  String get blockHash => 'Blok hash\'i';

  @override
  String get previousHash => 'Önceki hash';

  @override
  String get merkleRoot => 'Merkle kökü';

  @override
  String get consensusName => 'Konsensüs: Proof of Authority (Ed25519)';

  @override
  String get correct => 'Düzelt';

  @override
  String get correctionTitle => 'Düzeltme bloğu ekle';

  @override
  String get correctionReason => 'Gerekçe';

  @override
  String get correctionHint =>
      'Zincir değiştirilemez. Düzeltme, eski kaydı işaret eden yeni bir blok olarak eklenir.';

  @override
  String get corrected => 'Düzeltildi';

  @override
  String get correctionSaved => 'Düzeltme bloğu zincire eklendi';

  @override
  String get reports => 'Raporlar';

  @override
  String get exportPdf => 'PDF paylaş';

  @override
  String get exportCsv => 'CSV paylaş';

  @override
  String get loadingModule => 'Modül yükleniyor…';

  @override
  String get weeklyTrend => 'Oturum bazında katılım';

  @override
  String get myCourses => 'Derslerim';

  @override
  String get scanQr => 'QR tara';

  @override
  String absenceWarning(String course, int remaining) {
    return '$course: yalnızca $remaining devamsızlık hakkınız kaldı';
  }

  @override
  String absenceOver(String course) {
    return '$course: devamsızlık sınırını aştınız';
  }

  @override
  String remainingAbsences(int count) {
    return 'Kalan hak: $count';
  }

  @override
  String get deviceBound => 'Bu cihaza bağlı';

  @override
  String get receiptTitle => 'Yoklamanız alındı';

  @override
  String get transactionHash => 'İşlem hash\'i';

  @override
  String get blockPending =>
      'Oturum kapanınca kaydınız imzalı bir bloğa yazılacak.';

  @override
  String get verified => 'Doğrulandı ✓';

  @override
  String verifiedDetail(int index) {
    return 'Blok #$index · Merkle kanıtı geçerli';
  }

  @override
  String get notVerified => 'Zincirde doğrulanamadı';

  @override
  String get pendingVerification => 'Blok bekleniyor';

  @override
  String get scannerHint => 'QR kodunu çerçeveye hizalayın';

  @override
  String get cameraPermissionDenied =>
      'Kamera izni verilmedi. Ayarlar → SCÜ Yoklama → Kamera seçeneğini açın.';

  @override
  String get cameraUnavailable =>
      'Kamera açılamadı. QR metnini yapıştırabilir ya da demo düğmesini kullanabilirsiniz.';

  @override
  String get cameraWebHint =>
      'Web sürümünde kamera kullanılmaz. Aşağıdaki demo düğmesini kullanın.';

  @override
  String get pasteQr => 'QR metnini yapıştır';

  @override
  String get submit => 'Gönder';

  @override
  String get demoQr => 'Demo: açık oturumun QR\'ını üret';

  @override
  String get noOpenSession => 'Şu anda açık bir yoklama oturumu yok.';

  @override
  String get checkingIn => 'Yoklama gönderiliyor…';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get confirm => 'Onayla';

  @override
  String get close => 'Kapat';

  @override
  String get back => 'Geri';

  @override
  String get genericError => 'Bir hata oluştu';

  @override
  String get themeToggle => 'Temayı değiştir';

  @override
  String get copied => 'Panoya kopyalandı';
}
