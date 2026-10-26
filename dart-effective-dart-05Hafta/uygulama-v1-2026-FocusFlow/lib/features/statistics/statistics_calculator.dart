import '../../core/utils/date_time_utils.dart';
import '../../models/focus_session.dart';
import '../../models/study_task.dart';

/// Tek bir güne ait toplam odak süresi.
class DailyFocus {
  /// Gün ve o gün tamamlanan odak süresini taşır.
  const DailyFocus({required this.date, required this.seconds});

  /// Günün başlangıcı.
  final DateTime date;

  /// O gün tamamlanan odak oturumlarının toplam saniyesi.
  final int seconds;

  /// O gün en az bir odak oturumu tamamlanıp tamamlanmadığı.
  bool get hasFocus => seconds > 0;
}

/// Oturum ve görev kayıtlarından istatistik üreten saf hesaplayıcı.
///
/// UI'dan bağımsızdır; sabit örnek veri kullanmaz. Tüm sonuçlar gerçek
/// kayıtlardan ve verilen referans zamandan hesaplanır.
abstract final class StatisticsCalculator {
  /// Yalnızca tamamlanmış odak oturumlarını döndürür.
  ///
  /// Molalar ve yarım kalan oturumlar odak istatistiklerine dahil edilmez.
  static List<FocusSession> completedFocusSessions(
    Iterable<FocusSession> sessions,
  ) {
    return List<FocusSession>.unmodifiable(
      sessions.where((session) => session.isCompleted && session.type.isFocus),
    );
  }

  /// Tamamlanmış odak oturumlarının toplam süresini saniye olarak döndürür.
  static int totalFocusSeconds(Iterable<FocusSession> sessions) {
    return completedFocusSessions(
      sessions,
    ).fold<int>(0, (total, session) => total + session.actualDurationSeconds);
  }

  /// Tamamlanmış odak oturumlarının sayısını döndürür.
  static int totalCompletedFocusSessionCount(Iterable<FocusSession> sessions) {
    return completedFocusSessions(sessions).length;
  }

  /// Belirtilen güne ait odak süresini saniye olarak hesaplar.
  ///
  /// Oturumun günü [FocusSession.effectiveDate] ile belirlenir; tamamlanan
  /// oturumlarda bitiş zamanı esas alınır.
  static int focusSecondsForDay(Iterable<FocusSession> sessions, DateTime day) {
    return completedFocusSessions(sessions)
        .where((session) => isSameDay(session.effectiveDate, day))
        .fold<int>(
          0,
          (total, session) => total + session.actualDurationSeconds,
        );
  }

  /// Bugün tamamlanan odak süresini saniye olarak hesaplar.
  static int todayFocusSeconds(
    Iterable<FocusSession> sessions, {
    DateTime? now,
  }) {
    return focusSecondsForDay(sessions, now ?? DateTime.now());
  }

  /// Belirtilen günde tamamlanan odak oturumu sayısını döndürür.
  static int focusSessionCountForDay(
    Iterable<FocusSession> sessions,
    DateTime day,
  ) {
    return completedFocusSessions(
      sessions,
    ).where((session) => isSameDay(session.effectiveDate, day)).length;
  }

  /// Bugün tamamlanan odak oturumu sayısını döndürür.
  static int todayFocusSessionCount(
    Iterable<FocusSession> sessions, {
    DateTime? now,
  }) {
    return focusSessionCountForDay(sessions, now ?? DateTime.now());
  }

  /// Son yedi günün odak sürelerini eskiden yeniye doğru döndürür.
  ///
  /// Dönen listede her zaman yedi eleman bulunur; kayıt olmayan günler
  /// sıfır saniye ile temsil edilir.
  static List<DailyFocus> lastSevenDays(
    Iterable<FocusSession> sessions, {
    DateTime? now,
  }) {
    final reference = dateOnly(now ?? DateTime.now());
    final days = <DailyFocus>[];
    for (var offset = 6; offset >= 0; offset--) {
      final day = DateTime(
        reference.year,
        reference.month,
        reference.day - offset,
      );
      days.add(
        DailyFocus(date: day, seconds: focusSecondsForDay(sessions, day)),
      );
    }
    return List<DailyFocus>.unmodifiable(days);
  }

  /// Son yedi günde tamamlanan toplam odak süresini döndürür.
  static int lastSevenDaysFocusSeconds(
    Iterable<FocusSession> sessions, {
    DateTime? now,
  }) {
    return lastSevenDays(
      sessions,
      now: now,
    ).fold<int>(0, (total, day) => total + day.seconds);
  }

  /// Belirtilen günde tamamlanan görev sayısını döndürür.
  ///
  /// Tamamlanma zamanı kaydedilmemiş eski görevler güne atanamadığı için
  /// hesaba katılmaz.
  static int completedTaskCountForDay(Iterable<StudyTask> tasks, DateTime day) {
    return tasks.where((task) {
      final completedAt = task.completedAt;
      return task.isCompleted &&
          completedAt != null &&
          isSameDay(completedAt, day);
    }).length;
  }

  /// Bugün tamamlanan görev sayısını döndürür.
  static int todayCompletedTaskCount(
    Iterable<StudyTask> tasks, {
    DateTime? now,
  }) {
    return completedTaskCountForDay(tasks, now ?? DateTime.now());
  }

  /// Henüz tamamlanmamış görevlerin sayısını döndürür.
  static int pendingTaskCount(Iterable<StudyTask> tasks) {
    return tasks.where((task) => !task.isCompleted).length;
  }

  /// Tamamlanmış görevlerin toplam sayısını döndürür.
  static int totalCompletedTaskCount(Iterable<StudyTask> tasks) {
    return tasks.where((task) => task.isCompleted).length;
  }
}
