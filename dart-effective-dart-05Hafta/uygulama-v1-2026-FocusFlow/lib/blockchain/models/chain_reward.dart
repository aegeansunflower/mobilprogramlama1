import '../achievements/achievement_engine.dart';
import '../core/focus_chain_network.dart';
import 'chain_block.dart';
import 'chain_transaction.dart';

/// Bir zincir yazma işleminin sonucu.
class ChainReward {
  /// İşlem, üretilen blok ve varsa yeni rozetlerle sonucu oluşturur.
  const ChainReward({
    required this.transaction,
    this.block,
    this.achievements = const <AchievementId>[],
  });

  /// Zincire yazılan asıl işlem.
  final ChainTransaction transaction;

  /// İşlemi onaylayan blok; işlem bekliyorsa `null`.
  final ChainBlock? block;

  /// Bu işlemle birlikte basılan yeni rozetler.
  final List<AchievementId> achievements;

  /// İşlem bir bloğa alındı mı?
  bool get isConfirmed => block != null;

  /// Bloğun madenciye verdiği coinbase ödülü.
  int get blockReward {
    final currentBlock = block;
    if (currentBlock == null) {
      return 0;
    }
    return currentBlock.transactions
        .where(
          (transaction) =>
              transaction.type == ChainTransactionType.miningReward,
        )
        .fold<int>(0, (total, transaction) => total + transaction.amount);
  }

  /// Yeni rozetlerin toplam FOCUS ödülü.
  int get achievementReward {
    return achievements.fold<int>(
      0,
      (total, achievement) => total + achievement.reward,
    );
  }

  /// Rozetler ayrı bir blokta basıldıysa o bloğun coinbase ödülü.
  int get achievementBlockReward =>
      achievements.isEmpty ? 0 : FocusChainNetwork.blockReward;

  /// İşlem, blok ve rozet ödüllerinin toplamı.
  int get totalReward =>
      transaction.amount +
      blockReward +
      achievementReward +
      achievementBlockReward;
}
