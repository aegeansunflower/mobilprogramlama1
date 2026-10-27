import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'SCÜ Yoklama'**
  String get appTitle;

  /// No description provided for @schoolName.
  ///
  /// In tr, this message translates to:
  /// **'Şarkışla Uygulamalı Bilimler Yüksekokulu'**
  String get schoolName;

  /// No description provided for @tagline.
  ///
  /// In tr, this message translates to:
  /// **'Değiştirilemez, doğrulanabilir yoklama'**
  String get tagline;

  /// No description provided for @universityName.
  ///
  /// In tr, this message translates to:
  /// **'Sivas Cumhuriyet Üniversitesi'**
  String get universityName;

  /// No description provided for @welcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hoş geldiniz'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için giriş türünüzü seçin.'**
  String get welcomeSubtitle;

  /// No description provided for @brandStatementLead.
  ///
  /// In tr, this message translates to:
  /// **'Yoklama artık'**
  String get brandStatementLead;

  /// No description provided for @brandStatementEmphasis.
  ///
  /// In tr, this message translates to:
  /// **'değiştirilemez'**
  String get brandStatementEmphasis;

  /// No description provided for @brandStatementTail.
  ///
  /// In tr, this message translates to:
  /// **'bir kayıt.'**
  String get brandStatementTail;

  /// No description provided for @brandCaption.
  ///
  /// In tr, this message translates to:
  /// **'Her yoklama, öğretim görevlisinin imzasıyla blok zincirine yazılır; sonradan kimse sessizce değiştiremez.'**
  String get brandCaption;

  /// No description provided for @brandFootnote.
  ///
  /// In tr, this message translates to:
  /// **'PROOF OF AUTHORITY · ED25519 · MERKLE KANITI'**
  String get brandFootnote;

  /// No description provided for @instructorLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğretim görevlisi girişi'**
  String get instructorLoginTitle;

  /// No description provided for @studentLoginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci girişi'**
  String get studentLoginTitle;

  /// No description provided for @instructorLoginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal e-posta adresiniz ve şifrenizle giriş yapın.'**
  String get instructorLoginSubtitle;

  /// No description provided for @studentLoginSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Okul numaranız ve şifrenizle giriş yapın.'**
  String get studentLoginSubtitle;

  /// No description provided for @backToRoles.
  ///
  /// In tr, this message translates to:
  /// **'Giriş türünü değiştir'**
  String get backToRoles;

  /// No description provided for @statBlocks.
  ///
  /// In tr, this message translates to:
  /// **'Blok'**
  String get statBlocks;

  /// No description provided for @statBlocksCaption.
  ///
  /// In tr, this message translates to:
  /// **'imzalı blok'**
  String get statBlocksCaption;

  /// No description provided for @statRecords.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt'**
  String get statRecords;

  /// No description provided for @statRecordsCaption.
  ///
  /// In tr, this message translates to:
  /// **'zincirdeki yoklama kaydı'**
  String get statRecordsCaption;

  /// No description provided for @statCourses.
  ///
  /// In tr, this message translates to:
  /// **'Ders'**
  String get statCourses;

  /// No description provided for @statCoursesCaption.
  ///
  /// In tr, this message translates to:
  /// **'kayıtlı ders'**
  String get statCoursesCaption;

  /// No description provided for @roleSelectTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl giriş yapmak istersiniz?'**
  String get roleSelectTitle;

  /// No description provided for @roleInstructor.
  ///
  /// In tr, this message translates to:
  /// **'Öğretim Görevlisi'**
  String get roleInstructor;

  /// No description provided for @roleStudent.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci'**
  String get roleStudent;

  /// No description provided for @roleInstructorHint.
  ///
  /// In tr, this message translates to:
  /// **'Oturum başlatın, QR gösterin, blokları imzalayın'**
  String get roleInstructorHint;

  /// No description provided for @roleStudentHint.
  ///
  /// In tr, this message translates to:
  /// **'QR tarayın, yoklamanızı zincirde doğrulayın'**
  String get roleStudentHint;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kurumsal e-posta'**
  String get emailLabel;

  /// No description provided for @studentNumberLabel.
  ///
  /// In tr, this message translates to:
  /// **'Okul numarası'**
  String get studentNumberLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @signIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get signOut;

  /// No description provided for @emailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta adresi girin.'**
  String get emailInvalid;

  /// No description provided for @studentNumberInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Okul numarası 9–12 haneli olmalıdır.'**
  String get studentNumberInvalid;

  /// No description provided for @passwordTooShort.
  ///
  /// In tr, this message translates to:
  /// **'Şifre en az 6 karakter olmalıdır.'**
  String get passwordTooShort;

  /// No description provided for @showPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get hidePassword;

  /// No description provided for @biometricTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kimliğinizi doğrulayın'**
  String get biometricTitle;

  /// No description provided for @biometricBody.
  ///
  /// In tr, this message translates to:
  /// **'Şifreniz doğrulandı. Devam etmek için parmak izi ya da yüz tanıma kullanın.'**
  String get biometricBody;

  /// No description provided for @biometricReason.
  ///
  /// In tr, this message translates to:
  /// **'SCÜ Yoklama\'ya güvenli giriş'**
  String get biometricReason;

  /// No description provided for @biometricAction.
  ///
  /// In tr, this message translates to:
  /// **'Biyometrik doğrula'**
  String get biometricAction;

  /// No description provided for @demoModeBanner.
  ///
  /// In tr, this message translates to:
  /// **'Demo modu: tüm hesapların şifresi {password}'**
  String demoModeBanner(String password);

  /// No description provided for @demoAccounts.
  ///
  /// In tr, this message translates to:
  /// **'Demo hesapları'**
  String get demoAccounts;

  /// No description provided for @greeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name}'**
  String greeting(String name);

  /// No description provided for @departmentsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bölüm seçin'**
  String get departmentsTitle;

  /// No description provided for @coursesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dersler'**
  String get coursesTitle;

  /// No description provided for @noCourses.
  ///
  /// In tr, this message translates to:
  /// **'Bu bölümde verdiğiniz ders bulunmuyor.'**
  String get noCourses;

  /// No description provided for @studentsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{Öğrenci yok} other{{count} öğrenci}}'**
  String studentsCount(int count);

  /// No description provided for @startSession.
  ///
  /// In tr, this message translates to:
  /// **'Yoklama başlat'**
  String get startSession;

  /// No description provided for @continueSession.
  ///
  /// In tr, this message translates to:
  /// **'Açık oturuma dön'**
  String get continueSession;

  /// No description provided for @requireLocation.
  ///
  /// In tr, this message translates to:
  /// **'Kampüs konum doğrulaması'**
  String get requireLocation;

  /// No description provided for @requireLocationHint.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenciler yalnızca yerleşke sınırları içinden yoklama verebilir'**
  String get requireLocationHint;

  /// No description provided for @liveSession.
  ///
  /// In tr, this message translates to:
  /// **'Canlı yoklama'**
  String get liveSession;

  /// No description provided for @qrRefreshIn.
  ///
  /// In tr, this message translates to:
  /// **'{seconds} sn içinde yenilenecek'**
  String qrRefreshIn(int seconds);

  /// No description provided for @qrSemantics.
  ///
  /// In tr, this message translates to:
  /// **'Yoklama QR kodu. Öğrenciler bu kodu tarayarak yoklama verir.'**
  String get qrSemantics;

  /// No description provided for @participants.
  ///
  /// In tr, this message translates to:
  /// **'Katılımcılar'**
  String get participants;

  /// No description provided for @participantsProgress.
  ///
  /// In tr, this message translates to:
  /// **'{arrived} / {total}'**
  String participantsProgress(int arrived, int total);

  /// No description provided for @noParticipantsYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz katılım yok. Öğrencilerden QR kodu taramalarını isteyin.'**
  String get noParticipantsYet;

  /// No description provided for @endSession.
  ///
  /// In tr, this message translates to:
  /// **'Oturumu bitir ve zincire yaz'**
  String get endSession;

  /// No description provided for @endSessionConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Oturum bitirilsin mi?'**
  String get endSessionConfirmTitle;

  /// No description provided for @endSessionConfirmBody.
  ///
  /// In tr, this message translates to:
  /// **'Katılımlar ve gelmeyenler imzalı bir bloğa dönüştürülecek. Bu işlem geri alınamaz.'**
  String get endSessionConfirmBody;

  /// No description provided for @endSessionDone.
  ///
  /// In tr, this message translates to:
  /// **'Blok #{index} zincire eklendi'**
  String endSessionDone(int index);

  /// No description provided for @simulateStudent.
  ///
  /// In tr, this message translates to:
  /// **'Demo: öğrenci katılımı ekle'**
  String get simulateStudent;

  /// No description provided for @allStudentsArrived.
  ///
  /// In tr, this message translates to:
  /// **'Tüm öğrenciler katıldı.'**
  String get allStudentsArrived;

  /// No description provided for @history.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş yoklamalar'**
  String get history;

  /// No description provided for @noHistory.
  ///
  /// In tr, this message translates to:
  /// **'Bu ders için henüz yoklama alınmadı.'**
  String get noHistory;

  /// No description provided for @openSession.
  ///
  /// In tr, this message translates to:
  /// **'Açık oturum'**
  String get openSession;

  /// No description provided for @sessionBlock.
  ///
  /// In tr, this message translates to:
  /// **'Blok #{index}'**
  String sessionBlock(int index);

  /// No description provided for @studentStats.
  ///
  /// In tr, this message translates to:
  /// **'Öğrenci bazlı devam'**
  String get studentStats;

  /// No description provided for @attendanceRate.
  ///
  /// In tr, this message translates to:
  /// **'Devam oranı'**
  String get attendanceRate;

  /// No description provided for @statusPresent.
  ///
  /// In tr, this message translates to:
  /// **'Katıldı'**
  String get statusPresent;

  /// No description provided for @statusLate.
  ///
  /// In tr, this message translates to:
  /// **'Geç ({minutes} dk)'**
  String statusLate(int minutes);

  /// No description provided for @statusAbsent.
  ///
  /// In tr, this message translates to:
  /// **'Devamsız'**
  String get statusAbsent;

  /// No description provided for @statusExcused.
  ///
  /// In tr, this message translates to:
  /// **'Mazeretli'**
  String get statusExcused;

  /// No description provided for @chainTitle.
  ///
  /// In tr, this message translates to:
  /// **'Blok zinciri'**
  String get chainTitle;

  /// No description provided for @chainValid.
  ///
  /// In tr, this message translates to:
  /// **'Zincir doğrulandı'**
  String get chainValid;

  /// No description provided for @chainValidDetail.
  ///
  /// In tr, this message translates to:
  /// **'{count} blok · son hash {hash}'**
  String chainValidDetail(int count, String hash);

  /// No description provided for @chainBroken.
  ///
  /// In tr, this message translates to:
  /// **'Zincir bozuk: blok #{index}'**
  String chainBroken(int index);

  /// No description provided for @chainChecking.
  ///
  /// In tr, this message translates to:
  /// **'Zincir doğrulanıyor…'**
  String get chainChecking;

  /// No description provided for @validateAgain.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden doğrula'**
  String get validateAgain;

  /// No description provided for @simulateTamper.
  ///
  /// In tr, this message translates to:
  /// **'Demo: bir kaydı kurcala'**
  String get simulateTamper;

  /// No description provided for @tamperExplain.
  ///
  /// In tr, this message translates to:
  /// **'Bu düğme veritabanındaki bir yoklama kaydını doğrudan değiştirir. Doğrulama, zincirin tam olarak hangi blokta bozulduğunu gösterir.'**
  String get tamperExplain;

  /// No description provided for @tamperNeedsBlock.
  ///
  /// In tr, this message translates to:
  /// **'Kurcalamak için önce en az bir yoklama bloğu oluşturun.'**
  String get tamperNeedsBlock;

  /// No description provided for @genesisBlock.
  ///
  /// In tr, this message translates to:
  /// **'Genesis bloğu'**
  String get genesisBlock;

  /// No description provided for @transactionsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =0{İşlem yok} other{{count} işlem}}'**
  String transactionsCount(int count);

  /// No description provided for @signedBy.
  ///
  /// In tr, this message translates to:
  /// **'İmzalayan: {authority}'**
  String signedBy(String authority);

  /// No description provided for @blockHash.
  ///
  /// In tr, this message translates to:
  /// **'Blok hash\'i'**
  String get blockHash;

  /// No description provided for @previousHash.
  ///
  /// In tr, this message translates to:
  /// **'Önceki hash'**
  String get previousHash;

  /// No description provided for @merkleRoot.
  ///
  /// In tr, this message translates to:
  /// **'Merkle kökü'**
  String get merkleRoot;

  /// No description provided for @consensusName.
  ///
  /// In tr, this message translates to:
  /// **'Konsensüs: Proof of Authority (Ed25519)'**
  String get consensusName;

  /// No description provided for @correct.
  ///
  /// In tr, this message translates to:
  /// **'Düzelt'**
  String get correct;

  /// No description provided for @correctionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Düzeltme bloğu ekle'**
  String get correctionTitle;

  /// No description provided for @correctionReason.
  ///
  /// In tr, this message translates to:
  /// **'Gerekçe'**
  String get correctionReason;

  /// No description provided for @correctionHint.
  ///
  /// In tr, this message translates to:
  /// **'Zincir değiştirilemez. Düzeltme, eski kaydı işaret eden yeni bir blok olarak eklenir.'**
  String get correctionHint;

  /// No description provided for @corrected.
  ///
  /// In tr, this message translates to:
  /// **'Düzeltildi'**
  String get corrected;

  /// No description provided for @correctionSaved.
  ///
  /// In tr, this message translates to:
  /// **'Düzeltme bloğu zincire eklendi'**
  String get correctionSaved;

  /// No description provided for @reports.
  ///
  /// In tr, this message translates to:
  /// **'Raporlar'**
  String get reports;

  /// No description provided for @exportPdf.
  ///
  /// In tr, this message translates to:
  /// **'PDF paylaş'**
  String get exportPdf;

  /// No description provided for @exportCsv.
  ///
  /// In tr, this message translates to:
  /// **'CSV paylaş'**
  String get exportCsv;

  /// No description provided for @loadingModule.
  ///
  /// In tr, this message translates to:
  /// **'Modül yükleniyor…'**
  String get loadingModule;

  /// No description provided for @weeklyTrend.
  ///
  /// In tr, this message translates to:
  /// **'Oturum bazında katılım'**
  String get weeklyTrend;

  /// No description provided for @myCourses.
  ///
  /// In tr, this message translates to:
  /// **'Derslerim'**
  String get myCourses;

  /// No description provided for @scanQr.
  ///
  /// In tr, this message translates to:
  /// **'QR tara'**
  String get scanQr;

  /// No description provided for @absenceWarning.
  ///
  /// In tr, this message translates to:
  /// **'{course}: yalnızca {remaining} devamsızlık hakkınız kaldı'**
  String absenceWarning(String course, int remaining);

  /// No description provided for @absenceOver.
  ///
  /// In tr, this message translates to:
  /// **'{course}: devamsızlık sınırını aştınız'**
  String absenceOver(String course);

  /// No description provided for @remainingAbsences.
  ///
  /// In tr, this message translates to:
  /// **'Kalan hak: {count}'**
  String remainingAbsences(int count);

  /// No description provided for @deviceBound.
  ///
  /// In tr, this message translates to:
  /// **'Bu cihaza bağlı'**
  String get deviceBound;

  /// No description provided for @receiptTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yoklamanız alındı'**
  String get receiptTitle;

  /// No description provided for @transactionHash.
  ///
  /// In tr, this message translates to:
  /// **'İşlem hash\'i'**
  String get transactionHash;

  /// No description provided for @blockPending.
  ///
  /// In tr, this message translates to:
  /// **'Oturum kapanınca kaydınız imzalı bir bloğa yazılacak.'**
  String get blockPending;

  /// No description provided for @verified.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulandı ✓'**
  String get verified;

  /// No description provided for @verifiedDetail.
  ///
  /// In tr, this message translates to:
  /// **'Blok #{index} · Merkle kanıtı geçerli'**
  String verifiedDetail(int index);

  /// No description provided for @notVerified.
  ///
  /// In tr, this message translates to:
  /// **'Zincirde doğrulanamadı'**
  String get notVerified;

  /// No description provided for @pendingVerification.
  ///
  /// In tr, this message translates to:
  /// **'Blok bekleniyor'**
  String get pendingVerification;

  /// No description provided for @scannerHint.
  ///
  /// In tr, this message translates to:
  /// **'QR kodunu çerçeveye hizalayın'**
  String get scannerHint;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Kamera izni verilmedi. Ayarlar → SCÜ Yoklama → Kamera seçeneğini açın.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Kamera açılamadı. QR metnini yapıştırabilir ya da demo düğmesini kullanabilirsiniz.'**
  String get cameraUnavailable;

  /// No description provided for @cameraWebHint.
  ///
  /// In tr, this message translates to:
  /// **'Web sürümünde kamera kullanılmaz. Aşağıdaki demo düğmesini kullanın.'**
  String get cameraWebHint;

  /// No description provided for @pasteQr.
  ///
  /// In tr, this message translates to:
  /// **'QR metnini yapıştır'**
  String get pasteQr;

  /// No description provided for @submit.
  ///
  /// In tr, this message translates to:
  /// **'Gönder'**
  String get submit;

  /// No description provided for @demoQr.
  ///
  /// In tr, this message translates to:
  /// **'Demo: açık oturumun QR\'ını üret'**
  String get demoQr;

  /// No description provided for @noOpenSession.
  ///
  /// In tr, this message translates to:
  /// **'Şu anda açık bir yoklama oturumu yok.'**
  String get noOpenSession;

  /// No description provided for @checkingIn.
  ///
  /// In tr, this message translates to:
  /// **'Yoklama gönderiliyor…'**
  String get checkingIn;

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In tr, this message translates to:
  /// **'Onayla'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @back.
  ///
  /// In tr, this message translates to:
  /// **'Geri'**
  String get back;

  /// No description provided for @genericError.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu'**
  String get genericError;

  /// No description provided for @themeToggle.
  ///
  /// In tr, this message translates to:
  /// **'Temayı değiştir'**
  String get themeToggle;

  /// No description provided for @copied.
  ///
  /// In tr, this message translates to:
  /// **'Panoya kopyalandı'**
  String get copied;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
