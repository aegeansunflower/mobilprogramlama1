import '../../core/utils/date_time_utils.dart';
import '../../features/statistics/statistics_calculator.dart';
import '../../models/focus_session.dart';
import '../../models/study_task.dart';
import '../models/chain_transaction.dart';
import '../models/focus_chain.dart';

/// FocusChain üzerinde NFT olarak basılabilen başarı rozetleri.
enum AchievementId {
  /// İlk odak oturumu.
  firstFocus(
    title: 'İlk Odak',
    description: 'İlk odak oturumunu tamamla.',
    reward: 5,
    iconName: 'spa',
  ),

  /// Beş odak oturumu.
  fiveSessions(
    title: 'Odak Serisi',
    description: '5 odak oturumu tamamla.',
    reward: 10,
    iconName: 'local_fire_department',
  ),

  /// On saatlik toplam odak.
  tenHours(
    title: 'Derin Çalışma',
    description: 'Toplam 10 saat odaklan.',
    reward: 25,
    iconName: 'workspace_premium',
  ),

  /// Yedi günlük seri.
  sevenDayStreak(
    title: 'Haftalık Disiplin',
    description: '7 gün üst üste odaklan.',
    reward: 20,
    iconName: 'calendar_month',
  ),

  /// İlk tamamlanan görev.
  firstTask(
    title: 'İlk Görev',
    description: 'İlk görevini tamamla.',
    reward: 3,
    iconName: 'task_alt',
  ),

  /// On tamamlanan görev.
  tenTasks(
    title: 'Görev Avcısı',
    description: '10 görev tamamla.',
    reward: 15,
    iconName: 'checklist',
  ),

  /// Beş blok üretimi.
  blockBuilder(
    title: 'Blok Ustası',
    description: '5 blok üret.',
    reward: 10,
    iconName: 'view_in_ar',
  ),

  /// Tek oturumda elli dakika.
  deepWork(
    title: 'Akış Hali',
    description: 'Tek oturumda 50 dakika odaklan.',
    reward: 15,
    iconName: 'auto_awesome',
  );

  const AchievementId({
    required this.title,
    required this.description,
    required this.reward,
    required this.iconName,
  });

  /// Rozetin kullanıcıya gösterilen adı.
  final String title;

  /// Rozet koşulunun açıklaması.
  final String description;

  /// Rozet basıldığında verilen FOCUS ödülü.
  final int reward;

  /// UI katmanında ikona eşlenen sembolik ad.
  final String iconName;

  /// Zincir üzerindeki NFT kimliği.
  String get tokenId => 'FFNFT-${(index + 1).toString().padLeft(3, '0')}';
}

/// Zincirde basılmış bir başarı rozeti.
class MintedAchievement {
  /// Rozet ve onu basan işlemle oluşturur.
  const MintedAchievement({
    required this.achievement,
    required this.transaction,
  });

  /// Rozet tanımı.
  final AchievementId achievement;

  /// Rozeti zincire yazan işlem.
  final ChainTransaction transaction;

  /// Rozetin basılma zamanı.
  DateTime get mintedAt => transaction.dateTime;
}

/// Oturum, görev ve zincir verilerinden hak edilen rozetleri hesaplar.
abstract final class AchievementEngine {
  /// Henüz basılmamış ve koşulu sağlanan rozetleri döndürür.
  static List<AchievementId> eligible({
    required Iterable<FocusSession> sessions,
    required Iterable<StudyTask> tasks,
    required FocusChain chain,
    DateTime? now,
  }) {
    final focusSessions = StatisticsCalculator.completedFocusSessions(sessions);
    final totalFocusSeconds = StatisticsCalculator.totalFocusSeconds(sessions);
    final completedTasks = tasks.where((task) => task.isCompleted).length;
    final minted = chain.mintedAchievementIds;
    final reference = now ?? DateTime.now();

    final longestSessionSeconds = focusSessions.fold<int>(
      0,
      (longest, session) => session.actualDurationSeconds > longest
          ? session.actualDurationSeconds
          : longest,
    );
    final streak = focusDayStreak(focusSessions, now: reference);
    final minedBlocks = chain.blocks.length - 1;

    final eligible = <AchievementId>[];
    void check(AchievementId id, bool condition) {
      if (condition && !minted.contains(id.name)) {
        eligible.add(id);
      }
    }

    check(AchievementId.firstFocus, focusSessions.isNotEmpty);
    check(AchievementId.fiveSessions, focusSessions.length >= 5);
    check(AchievementId.tenHours, totalFocusSeconds >= 10 * 60 * 60);
    check(AchievementId.sevenDayStreak, streak >= 7);
    check(AchievementId.firstTask, completedTasks >= 1);
    check(AchievementId.tenTasks, completedTasks >= 10);
    check(AchievementId.blockBuilder, minedBlocks >= 5);
    check(AchievementId.deepWork, longestSessionSeconds >= 50 * 60);

    return List<AchievementId>.unmodifiable(eligible);
  }

  /// Zincirdeki rozet işlemlerinden basılmış rozetleri üretir.
  static List<MintedAchievement> mintedFrom(FocusChain chain) {
    final minted = <MintedAchievement>[];
    for (final transaction in chain.confirmedTransactions) {
      if (transaction.type != ChainTransactionType.achievementReward) {
        continue;
      }
      final achievementId = transaction.metadata['achievementId'];
      if (achievementId is! String) {
        continue;
      }
      final achievement = _byName(achievementId);
      if (achievement == null) {
        continue;
      }
      minted.add(
        MintedAchievement(achievement: achievement, transaction: transaction),
      );
    }
    return List<MintedAchievement>.unmodifiable(minted);
  }

  /// Tamamlanmış odak oturumlarından güncel seriyi hesaplar.
  static int focusDayStreak(Iterable<FocusSession> sessions, {DateTime? now}) {
    final days = sessions
        .map((session) => dateOnly(session.effectiveDate))
        .toSet();
    if (days.isEmpty) {
      return 0;
    }

    var cursor = dateOnly(now ?? DateTime.now());
    if (!days.contains(cursor)) {
      cursor = cursor.subtract(const Duration(days: 1));
    }

    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  static AchievementId? _byName(String name) {
    for (final achievement in AchievementId.values) {
      if (achievement.name == name) {
        return achievement;
      }
    }
    return null;
  }
}
