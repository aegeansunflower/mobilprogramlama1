import 'package:flutter/foundation.dart';

import '../../models/focus_session.dart';
import '../../models/study_task.dart';
import '../achievements/achievement_engine.dart';
import '../core/focus_chain_network.dart';
import '../core/focus_reward_calculator.dart';
import '../models/chain_block.dart';
import '../models/chain_reward.dart';
import '../models/chain_transaction.dart';
import '../models/chain_validation_result.dart';
import '../models/focus_chain.dart';
import '../models/wallet_account.dart';
import '../repositories/focus_chain_repository.dart';
import '../repositories/wallet_repository.dart';
import '../services/chain_validator.dart';
import '../services/wallet_service.dart';

/// Yerel FocusChain düğümünün cüzdan, defter ve madencilik durumunu yönetir.
///
/// UI katmanı yalnızca bu servisi dinler. Her yazma işlemi önce kalıcı depoya
/// kaydedilir; ancak başarılıysa bellekteki defter güncellenir.
class FocusChainService extends ChangeNotifier {
  /// Repository bağımlılıklarıyla servisi oluşturur.
  FocusChainService({
    required FocusChainRepository chainRepository,
    required WalletRepository walletRepository,
    int difficulty = FocusChainNetwork.defaultDifficulty,
  }) : _chainRepository = chainRepository,
       _difficulty = difficulty {
    _walletService = WalletService(walletRepository);
    _validator = ChainValidator(_walletService);
  }

  final FocusChainRepository _chainRepository;
  final int _difficulty;
  late final WalletService _walletService;
  late final ChainValidator _validator;

  FocusChain? _chain;
  WalletAccount? _wallet;
  ChainValidationResult? _lastValidation;
  ChainReward? _lastReward;
  ChainBlock? _lastMinedBlock;
  List<AchievementId> _lastAchievements = const <AchievementId>[];
  FocusChain? _chainBackup;
  bool _isInitializing = false;
  bool _isInitialized = false;
  bool _isMining = false;
  bool _isTampered = false;
  String? _error;

  /// Yerel cüzdan; başlatma tamamlanmadıysa `null`.
  WalletAccount? get wallet => _wallet;

  /// Güncel defter; başlatma tamamlanmadıysa `null`.
  ///
  /// Kurcalama demosu sırasında bu, demo amaçlı bozulmuş kopyayı döndürür.
  FocusChain? get chain => _chain;

  /// Cüzdan ve özet hesapları için sağlam defter.
  FocusChain? get _ledger => _chainBackup ?? _chain;

  /// Zincir başlatıldı ve kullanıma hazır mı?
  bool get isReady => _wallet != null && _chain != null;

  /// Başlatma sürüyor mu?
  bool get isInitializing => _isInitializing;

  /// Madencilik sürüyor mu?
  bool get isMining => _isMining;

  /// Demo bütünlük testi için defter bellekte kurcalandı mı?
  bool get isTampered => _isTampered;

  /// Son doğrulama sonucu.
  ChainValidationResult? get lastValidation => _lastValidation;

  /// Son odak/görev ödülü.
  ChainReward? get lastReward => _lastReward;

  /// Son üretilen blok.
  ChainBlock? get lastMinedBlock => _lastMinedBlock;

  /// Son işlemde basılan rozetler.
  List<AchievementId> get lastAchievements =>
      List<AchievementId>.unmodifiable(_lastAchievements);

  /// Kullanıcıya gösterilebilir son hata.
  String? get error => _error;

  /// Yerel cüzdan adresi; yoksa boş metin.
  String get walletAddress => _wallet?.address ?? '';

  /// Onaylanmış FOCUS bakiyesi.
  ///
  /// Kurcalama demosu sırasında sağlam defterdeki bakiye korunur; demo
  /// kopyasındaki bozulma cüzdan bakiyesine yansımaz.
  int get balance => _ledger?.walletBalance ?? 0;

  /// Bekleyen giden transferler düşülmüş bakiye.
  int get availableBalance => _ledger?.availableBalance ?? 0;

  /// Zincir yüksekliği; genesis dahil.
  int get chainHeight => _ledger?.height ?? 0;

  /// Bekleyen işlem sayısı.
  int get pendingTransactionCount => _ledger?.pendingTransactions.length ?? 0;

  /// Zincirde basılmış toplam FOCUS.
  int get totalMinted => _ledger?.totalMinted ?? 0;

  /// Basılmış rozetler.
  List<MintedAchievement> get mintedAchievements {
    final currentChain = _ledger;
    if (currentChain == null) {
      return const <MintedAchievement>[];
    }
    return AchievementEngine.mintedFrom(currentChain);
  }

  /// Defterde onaylanmış ödül kullanımları.
  List<ChainTransaction> get rewardRedemptions {
    final currentChain = _ledger;
    if (currentChain == null) {
      return const <ChainTransaction>[];
    }
    return List<ChainTransaction>.unmodifiable(
      currentChain.confirmedTransactions.where(
        (transaction) =>
            transaction.type == ChainTransactionType.rewardRedemption,
      ),
    );
  }

  /// Cüzdanı ve defteri yükler; ilk çalıştırmada genesis bloğu üretir.
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) {
      return;
    }
    _isInitializing = true;
    _error = null;
    notifyListeners();

    try {
      final wallet = await _walletService.loadOrCreate();
      final loaded = _chainRepository.loadChain();
      final chain = loaded != null && loaded.walletAddress == wallet.address
          ? loaded
          : FocusChain.createGenesis(
              walletAddress: wallet.address,
              difficulty: _difficulty,
            );

      if (loaded == null || loaded.walletAddress != wallet.address) {
        final saved = await _chainRepository.saveChain(chain);
        if (!saved) {
          throw StateError('Genesis bloğu kaydedilemedi.');
        }
      }

      _wallet = wallet;
      _chain = chain;
      _isInitialized = true;
      _lastValidation = await _validator.validate(chain);
    } on Object {
      _wallet = null;
      _chain = null;
      _error = 'Kanıt defteri başlatılamadı. Yerel depolamayı kontrol edin.';
      rethrow;
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Tamamlanan odak oturumunu zincire ödül işlemi olarak yazar.
  Future<ChainReward?> recordFocusReward({
    required FocusSession session,
    required Iterable<FocusSession> sessions,
    required Iterable<StudyTask> tasks,
  }) async {
    if (_blockedByTamper()) {
      return null;
    }
    _lastReward = null;
    _lastAchievements = const <AchievementId>[];
    final chain = _chain;
    final wallet = _wallet;
    if (chain == null ||
        wallet == null ||
        !session.isCompleted ||
        !session.type.isFocus ||
        chain.hasTransactionForSession(session.id)) {
      return null;
    }

    final amount = FocusRewardCalculator.forSeconds(
      session.actualDurationSeconds,
    );
    if (amount <= 0) {
      return null;
    }

    final transaction = ChainTransaction.create(
      type: ChainTransactionType.focusReward,
      fromAddress: FocusChainNetwork.systemAddress,
      toAddress: wallet.address,
      amount: amount,
      timestamp: (session.completedAt ?? DateTime.now())
          .toUtc()
          .millisecondsSinceEpoch,
      metadata: <String, Object?>{
        'sessionId': session.id,
        'durationSeconds': session.actualDurationSeconds,
        'sessionType': session.type.name,
      },
    );
    final result = await _enqueueAndMine(transaction);
    if (result == null) {
      return null;
    }
    final achievements = await evaluateAchievements(
      sessions: sessions,
      tasks: tasks,
    );
    final reward = ChainReward(
      transaction: transaction,
      block: result.block,
      achievements: achievements,
    );
    _lastReward = reward;
    return reward;
  }

  /// Tamamlanan görevi zincire ödül işlemi olarak yazar.
  Future<ChainReward?> recordTaskReward({
    required StudyTask task,
    required Iterable<FocusSession> sessions,
    required Iterable<StudyTask> tasks,
  }) async {
    if (_blockedByTamper()) {
      return null;
    }
    _lastReward = null;
    _lastAchievements = const <AchievementId>[];
    final chain = _chain;
    final wallet = _wallet;
    if (chain == null ||
        wallet == null ||
        !task.isCompleted ||
        chain.hasTransactionForTask(task.id)) {
      return null;
    }

    final transaction = ChainTransaction.create(
      type: ChainTransactionType.taskReward,
      fromAddress: FocusChainNetwork.systemAddress,
      toAddress: wallet.address,
      amount: FocusChainNetwork.taskReward,
      timestamp: (task.completedAt ?? DateTime.now())
          .toUtc()
          .millisecondsSinceEpoch,
      metadata: <String, Object?>{'taskId': task.id},
    );
    final result = await _enqueueAndMine(transaction);
    if (result == null) {
      return null;
    }
    final achievements = await evaluateAchievements(
      sessions: sessions,
      tasks: tasks,
    );
    final reward = ChainReward(
      transaction: transaction,
      block: result.block,
      achievements: achievements,
    );
    _lastReward = reward;
    return reward;
  }

  /// Hak edilen ve henüz basılmamış rozetleri zincire yazar.
  Future<List<AchievementId>> evaluateAchievements({
    required Iterable<FocusSession> sessions,
    required Iterable<StudyTask> tasks,
  }) async {
    if (_blockedByTamper()) {
      return const <AchievementId>[];
    }
    final chain = _chain;
    final wallet = _wallet;
    if (chain == null || wallet == null) {
      return const <AchievementId>[];
    }

    final eligible = AchievementEngine.eligible(
      sessions: sessions,
      tasks: tasks,
      chain: chain,
    );
    if (eligible.isEmpty) {
      _lastAchievements = const <AchievementId>[];
      return const <AchievementId>[];
    }

    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    final transactions = eligible
        .map((achievement) {
          return ChainTransaction.create(
            type: ChainTransactionType.achievementReward,
            fromAddress: FocusChainNetwork.systemAddress,
            toAddress: wallet.address,
            amount: achievement.reward,
            timestamp: timestamp,
            metadata: <String, Object?>{
              'achievementId': achievement.name,
              'tokenId': achievement.tokenId,
              'title': achievement.title,
            },
          );
        })
        .toList(growable: false);

    var nextChain = chain;
    for (final transaction in transactions) {
      nextChain = nextChain.addPendingTransaction(transaction);
    }
    if (!await _persist(nextChain)) {
      return const <AchievementId>[];
    }
    _chain = nextChain;
    notifyListeners();

    final block = await minePending();
    if (block == null) {
      return const <AchievementId>[];
    }
    _lastAchievements = List<AchievementId>.unmodifiable(eligible);
    notifyListeners();
    return _lastAchievements;
  }

  /// Bekleyen işlemleri proof-of-work ile bloklaştırır.
  Future<ChainBlock?> minePending() async {
    if (_blockedByTamper()) {
      return null;
    }
    final chain = _chain;
    final wallet = _wallet;
    if (_isMining ||
        chain == null ||
        wallet == null ||
        chain.pendingTransactions.isEmpty) {
      return null;
    }

    _isMining = true;
    _error = null;
    notifyListeners();
    try {
      final minedChain = chain.minePendingTransactions(
        minerAddress: wallet.address,
      );
      if (!await _persist(minedChain)) {
        return null;
      }
      _chain = minedChain;
      _lastMinedBlock = minedChain.latestBlock;
      _lastValidation = await _validator.validate(minedChain);
      notifyListeners();
      return minedChain.latestBlock;
    } on Object {
      _error = 'Blok üretilemedi. Bekleyen işlemler korundu.';
      return null;
    } finally {
      _isMining = false;
      notifyListeners();
    }
  }

  /// İmzalı bir FOCUS transferi oluşturur ve bloklaştırır.
  Future<ChainReward?> sendTransfer({
    required String toAddress,
    required int amount,
    String? memo,
  }) async {
    if (_blockedByTamper()) {
      return null;
    }
    final chain = _chain;
    final wallet = _wallet;
    if (chain == null || wallet == null) {
      _error = 'Cüzdan henüz hazır değil.';
      return null;
    }
    if (amount <= 0) {
      _error = 'Transfer miktarı sıfırdan büyük olmalı.';
      return null;
    }
    if (!FocusChainNetwork.isValidUserAddress(toAddress)) {
      _error = 'Alıcı adresi geçersiz.';
      return null;
    }
    if (toAddress == wallet.address) {
      _error = 'Kendi adresinize transfer yapamazsınız.';
      return null;
    }
    if (amount > chain.availableBalance) {
      _error = 'Yetersiz bakiye.';
      return null;
    }

    final metadata = <String, Object?>{};
    final trimmedMemo = memo?.trim();
    if (trimmedMemo != null && trimmedMemo.isNotEmpty) {
      metadata['memo'] = trimmedMemo;
    }
    final transaction = ChainTransaction.create(
      type: ChainTransactionType.transfer,
      fromAddress: wallet.address,
      toAddress: toAddress,
      amount: amount,
      timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
      metadata: metadata,
    );
    final signature = await _walletService.sign(
      wallet: wallet,
      payload: transaction.signingPayload,
    );
    final signedTransaction = transaction.withSignature(
      signature: signature,
      senderPublicKey: wallet.publicKey,
    );

    _error = null;
    final result = await _enqueueAndMine(signedTransaction);
    if (result != null) {
      _lastReward = null;
    }
    return result;
  }

  /// FOCUS karşılığında yerel bir ödülü kullanır ve deftere yazar.
  ///
  /// Ödül kullanımı, cüzdandan yakma adresine yapılan imzalı bir harcama
  /// olarak kaydedilir. Böylece bakiye düşer ve işlem kanıt defterinde kalır.
  Future<ChainReward?> redeemReward({
    required String rewardId,
    required String title,
    required int cost,
  }) async {
    if (_blockedByTamper()) {
      return null;
    }
    _lastReward = null;
    _lastAchievements = const <AchievementId>[];
    final chain = _chain;
    final wallet = _wallet;
    if (chain == null || wallet == null) {
      _error = 'Cüzdan henüz hazır değil.';
      return null;
    }
    final normalizedId = rewardId.trim();
    final normalizedTitle = title.trim();
    if (normalizedId.isEmpty || normalizedTitle.isEmpty || cost <= 0) {
      _error = 'Ödül bilgisi geçersiz.';
      return null;
    }
    if (cost > chain.availableBalance) {
      _error = 'Bu ödül için yeterli FOCUS yok.';
      return null;
    }

    final transaction = ChainTransaction.create(
      type: ChainTransactionType.rewardRedemption,
      fromAddress: wallet.address,
      toAddress: FocusChainNetwork.burnAddress,
      amount: cost,
      timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
      metadata: <String, Object?>{
        'rewardId': normalizedId,
        'title': normalizedTitle,
      },
    );
    final signature = await _walletService.sign(
      wallet: wallet,
      payload: transaction.signingPayload,
    );
    final signedTransaction = transaction.withSignature(
      signature: signature,
      senderPublicKey: wallet.publicKey,
    );

    _error = null;
    final result = await _enqueueAndMine(signedTransaction);
    if (result != null) {
      _lastReward = null;
    }
    return result;
  }

  /// Defteri hash, proof-of-work, imza ve bakiye açısından doğrular.
  Future<ChainValidationResult?> validateChain() async {
    final chain = _chain;
    if (chain == null) {
      return null;
    }
    final result = await _validator.validate(chain);
    _lastValidation = result;
    notifyListeners();
    return result;
  }

  /// Demo için son bloğu bellekte kurcalar; kalıcı depoya yazmaz.
  Future<bool> simulateTamper() async {
    if (_isTampered) {
      _error = 'Kurcalama demosu zaten aktif. Önce sağlam deftere dön.';
      notifyListeners();
      return false;
    }
    final chain = _chain;
    if (chain == null || chain.height < 2) {
      _error = 'Kurcalama demosu için en az bir onaylı işlem bloğu gerekir.';
      return false;
    }
    _error = null;
    _chainBackup = chain;
    final tampered = chain.createTamperedCopy();
    if (identical(tampered, chain)) {
      return false;
    }
    _chain = tampered;
    _isTampered = true;
    _lastValidation = await _validator.validate(tampered);
    notifyListeners();
    return true;
  }

  /// Kurcalama demosundan önceki sağlam deftere döner.
  Future<void> restoreAfterTamper() async {
    final backup = _chainBackup;
    if (backup == null) {
      return;
    }
    _chain = backup;
    _chainBackup = null;
    _isTampered = false;
    _error = null;
    _lastValidation = await _validator.validate(backup);
    notifyListeners();
  }

  /// Zinciri genesis bloğuna sıfırlar; cüzdan adresi korunur.
  Future<bool> resetChain() async {
    final wallet = _wallet;
    if (wallet == null) {
      return false;
    }
    final genesis = FocusChain.createGenesis(
      walletAddress: wallet.address,
      difficulty: _difficulty,
    );
    if (!await _persist(genesis)) {
      return false;
    }
    _chain = genesis;
    _chainBackup = null;
    _isTampered = false;
    _lastReward = null;
    _lastMinedBlock = null;
    _lastAchievements = const <AchievementId>[];
    _lastValidation = await _validator.validate(genesis);
    notifyListeners();
    return true;
  }

  /// Son hatayı temizler.
  void clearError() {
    if (_error == null) {
      return;
    }
    _error = null;
    notifyListeners();
  }

  Future<ChainReward?> _enqueueAndMine(ChainTransaction transaction) async {
    final chain = _chain;
    if (chain == null) {
      return null;
    }
    final nextChain = chain.addPendingTransaction(transaction);
    if (!await _persist(nextChain)) {
      return null;
    }
    _chain = nextChain;
    notifyListeners();

    final block = await minePending();
    return ChainReward(transaction: transaction, block: block);
  }

  Future<bool> _persist(FocusChain chain) async {
    final saved = await _chainRepository.saveChain(chain);
    if (!saved) {
      _error = 'Defter kaydedilemedi. İşlem tamamlanmadı.';
      notifyListeners();
    }
    return saved;
  }

  bool _blockedByTamper() {
    if (!_isTampered) {
      return false;
    }
    _error = 'Kurcalama demosu aktif. Önce sağlam deftere dön.';
    notifyListeners();
    return true;
  }
}
