// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SCU Attendance';

  @override
  String get schoolName => 'Şarkışla School of Applied Sciences';

  @override
  String get tagline => 'Immutable, verifiable attendance';

  @override
  String get universityName => 'Sivas Cumhuriyet University';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get welcomeSubtitle => 'Choose how you would like to sign in.';

  @override
  String get brandStatementLead => 'Attendance is now an';

  @override
  String get brandStatementEmphasis => 'immutable';

  @override
  String get brandStatementTail => 'record.';

  @override
  String get brandCaption =>
      'Every check-in is signed by the instructor and written to the blockchain; nobody can quietly change it later.';

  @override
  String get brandFootnote => 'PROOF OF AUTHORITY · ED25519 · MERKLE PROOF';

  @override
  String get instructorLoginTitle => 'Instructor sign-in';

  @override
  String get studentLoginTitle => 'Student sign-in';

  @override
  String get instructorLoginSubtitle =>
      'Sign in with your institutional e-mail and password.';

  @override
  String get studentLoginSubtitle =>
      'Sign in with your student number and password.';

  @override
  String get backToRoles => 'Change sign-in type';

  @override
  String get statBlocks => 'Blocks';

  @override
  String get statBlocksCaption => 'signed blocks';

  @override
  String get statRecords => 'Records';

  @override
  String get statRecordsCaption => 'attendance records on chain';

  @override
  String get statCourses => 'Courses';

  @override
  String get statCoursesCaption => 'enrolled courses';

  @override
  String get roleSelectTitle => 'How would you like to sign in?';

  @override
  String get roleInstructor => 'Instructor';

  @override
  String get roleStudent => 'Student';

  @override
  String get roleInstructorHint => 'Start sessions, show QR codes, sign blocks';

  @override
  String get roleStudentHint =>
      'Scan QR codes, verify your attendance on-chain';

  @override
  String get emailLabel => 'Institutional e-mail';

  @override
  String get studentNumberLabel => 'Student number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signOut => 'Sign out';

  @override
  String get emailInvalid => 'Enter a valid e-mail address.';

  @override
  String get studentNumberInvalid => 'Student number must have 9–12 digits.';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get biometricTitle => 'Verify your identity';

  @override
  String get biometricBody =>
      'Your password was accepted. Use fingerprint or face unlock to continue.';

  @override
  String get biometricReason => 'Secure sign-in to SCU Attendance';

  @override
  String get biometricAction => 'Verify biometrics';

  @override
  String demoModeBanner(String password) {
    return 'Demo mode: every account\'s password is $password';
  }

  @override
  String get demoAccounts => 'Demo accounts';

  @override
  String greeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get departmentsTitle => 'Choose a department';

  @override
  String get coursesTitle => 'Courses';

  @override
  String get noCourses => 'You teach no courses in this department.';

  @override
  String studentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count students',
      one: '1 student',
      zero: 'No students',
    );
    return '$_temp0';
  }

  @override
  String get startSession => 'Start attendance';

  @override
  String get continueSession => 'Return to open session';

  @override
  String get requireLocation => 'Campus location check';

  @override
  String get requireLocationHint =>
      'Students can only check in from inside the campus';

  @override
  String get liveSession => 'Live attendance';

  @override
  String qrRefreshIn(int seconds) {
    return 'Refreshes in $seconds s';
  }

  @override
  String get qrSemantics =>
      'Attendance QR code. Students scan this code to check in.';

  @override
  String get participants => 'Participants';

  @override
  String participantsProgress(int arrived, int total) {
    return '$arrived / $total';
  }

  @override
  String get noParticipantsYet =>
      'No check-ins yet. Ask students to scan the QR code.';

  @override
  String get endSession => 'End session and write to chain';

  @override
  String get endSessionConfirmTitle => 'End this session?';

  @override
  String get endSessionConfirmBody =>
      'Check-ins and absentees will be sealed into a signed block. This cannot be undone.';

  @override
  String endSessionDone(int index) {
    return 'Block #$index added to the chain';
  }

  @override
  String get simulateStudent => 'Demo: add a student check-in';

  @override
  String get allStudentsArrived => 'Every student has checked in.';

  @override
  String get history => 'Past sessions';

  @override
  String get noHistory => 'No attendance has been taken for this course yet.';

  @override
  String get openSession => 'Open session';

  @override
  String sessionBlock(int index) {
    return 'Block #$index';
  }

  @override
  String get studentStats => 'Attendance per student';

  @override
  String get attendanceRate => 'Attendance rate';

  @override
  String get statusPresent => 'Present';

  @override
  String statusLate(int minutes) {
    return 'Late ($minutes min)';
  }

  @override
  String get statusAbsent => 'Absent';

  @override
  String get statusExcused => 'Excused';

  @override
  String get chainTitle => 'Blockchain';

  @override
  String get chainValid => 'Chain verified';

  @override
  String chainValidDetail(int count, String hash) {
    return '$count blocks · head $hash';
  }

  @override
  String chainBroken(int index) {
    return 'Chain broken at block #$index';
  }

  @override
  String get chainChecking => 'Verifying chain…';

  @override
  String get validateAgain => 'Verify again';

  @override
  String get simulateTamper => 'Demo: tamper with a record';

  @override
  String get tamperExplain =>
      'This button edits an attendance record directly in the database. Verification shows exactly which block broke.';

  @override
  String get tamperNeedsBlock =>
      'Create at least one attendance block before tampering.';

  @override
  String get genesisBlock => 'Genesis block';

  @override
  String transactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count transactions',
      one: '1 transaction',
      zero: 'No transactions',
    );
    return '$_temp0';
  }

  @override
  String signedBy(String authority) {
    return 'Signed by: $authority';
  }

  @override
  String get blockHash => 'Block hash';

  @override
  String get previousHash => 'Previous hash';

  @override
  String get merkleRoot => 'Merkle root';

  @override
  String get consensusName => 'Consensus: Proof of Authority (Ed25519)';

  @override
  String get correct => 'Correct';

  @override
  String get correctionTitle => 'Add a correction block';

  @override
  String get correctionReason => 'Reason';

  @override
  String get correctionHint =>
      'The chain is immutable. The correction is appended as a new block pointing to the old record.';

  @override
  String get corrected => 'Corrected';

  @override
  String get correctionSaved => 'Correction block added to the chain';

  @override
  String get reports => 'Reports';

  @override
  String get exportPdf => 'Share PDF';

  @override
  String get exportCsv => 'Share CSV';

  @override
  String get loadingModule => 'Loading module…';

  @override
  String get weeklyTrend => 'Attendance per session';

  @override
  String get myCourses => 'My courses';

  @override
  String get scanQr => 'Scan QR';

  @override
  String absenceWarning(String course, int remaining) {
    return '$course: only $remaining absences left';
  }

  @override
  String absenceOver(String course) {
    return '$course: you exceeded the absence limit';
  }

  @override
  String remainingAbsences(int count) {
    return 'Remaining: $count';
  }

  @override
  String get deviceBound => 'Bound to this device';

  @override
  String get receiptTitle => 'You\'re checked in';

  @override
  String get transactionHash => 'Transaction hash';

  @override
  String get blockPending =>
      'Your record will be written to a signed block when the session ends.';

  @override
  String get verified => 'Verified ✓';

  @override
  String verifiedDetail(int index) {
    return 'Block #$index · Merkle proof valid';
  }

  @override
  String get notVerified => 'Could not be verified on-chain';

  @override
  String get pendingVerification => 'Waiting for block';

  @override
  String get scannerHint => 'Align the QR code inside the frame';

  @override
  String get cameraPermissionDenied =>
      'Camera permission denied. Enable it in Settings → SCÜ Yoklama → Camera.';

  @override
  String get cameraUnavailable =>
      'The camera could not be opened. Paste the QR text or use the demo button instead.';

  @override
  String get cameraWebHint =>
      'The camera is not used on the web version. Use the demo button below.';

  @override
  String get pasteQr => 'Paste QR text';

  @override
  String get submit => 'Submit';

  @override
  String get demoQr => 'Demo: generate the open session\'s QR';

  @override
  String get noOpenSession => 'There is no open attendance session right now.';

  @override
  String get checkingIn => 'Checking in…';

  @override
  String get retry => 'Try again';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get themeToggle => 'Toggle theme';

  @override
  String get copied => 'Copied to clipboard';
}
