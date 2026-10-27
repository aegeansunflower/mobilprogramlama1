import 'dart:math';

import 'package:flutter/foundation.dart';

import '../blockchain/achievements/achievement_engine.dart';
import '../blockchain/models/chain_block.dart';
import '../blockchain/models/chain_reward.dart';
import '../blockchain/models/chain_transaction.dart';
import '../blockchain/models/chain_validation_result.dart';
import '../blockchain/models/focus_chain.dart';
import '../blockchain/models/wallet_account.dart';
import '../blockchain/state/focus_chain_service.dart';
import '../data/focus_session_repository.dart';
import '../data/settings_repository.dart';
import '../data/task_repository.dart';
import '../features/statistics/statistics_calculator.dart';
import '../models/app_settings.dart';
import '../models/focus_session.dart';
import '../models/reward_offer.dart';
import '../models/study_task.dart';

/// Uygulamanın görev, oturum ve ayar durumunu yöneten merkezi denetleyici.
///
/// UI yalnızca bu sınıfı dinler; kalıcı depolamaya doğrudan erişmez.
/// Her yazma işlemi önce depoya kaydedilir, başarılıysa bellekteki durum
/// güncellenir. Böylece kullanıcıya yanlış bir başarı mesajı gösterilmez.
class AppController extends ChangeNotifier {
  /// Repository bağımlılıklarıyla denetleyiciyi oluşturur.
  AppController({
    required TaskRepository taskRepository,
    required FocusSessionRepository sessionRepository,
    required SettingsRepository settingsRepository,
    required FocusChainService chainService,
  }) : _taskRepository = taskRepository,
       _sessionRepository = sessionRepository,
       _settingsRepository = settingsRepository,
       _chainService = chainService {
    _chainService.addListener(_handleChainChanged);
  }

  final TaskRepository _taskRepository;
  final FocusSessionRepository _sessionRepository;
  final SettingsRepository _settingsRepository;
  final FocusChainService _chainService;
  final Random _random = Random();

  List<StudyTask> _tasks = const <StudyTask>[];
  List<FocusSession> _sessions = const <FocusSession>[];
  AppSettings _settings = const AppSettings();
  bool _isLoading = true;
  bool _isInitializing = false;
  bool _isInitialized = false;
  String? _loadError;
  String? _lastError;
  String? _chainError;

  /// Kayıtlı verilerin yüklenip yüklenmediği.
  bool get isLoading => _isLoading;

  /// Başlangıç yüklemesi sırasında oluşan hata; yoksa `null`.
  String? get loadError => _loadError;

  /// Son başarısız işlemin kullanıcıya gösterilebilir hatası.
  String? get lastError => _lastError;

  /// Kayıtlı görevlerin değiştirilemez kopyası.
  List<StudyTask> get tasks => List<StudyTask>.unmodifiable(_tasks);

  /// Kayıtlı oturumların değiştirilemez kopyası.
  List<FocusSession> get sessions => List<FocusSession>.unmodifiable(_sessions);

  /// Geçerli kullanıcı ayarları.
  AppSettings get settings => _settings;

  /// Zincir başlatılamadıysa kullanıcıya gösterilecek hata.
  String? get chainError => _chainError;

  /// Yerel FocusChain defteri; hazır değilse `null`.
  FocusChain? get chain => _chainService.chain;

  /// Yerel cüzdan; hazır değilse `null`.
  WalletAccount? get wallet => _chainService.wallet;

  /// Yerel cüzdan adresi.
  String get walletAddress => _chainService.walletAddress;

  /// Onaylanmış FOCUS bakiyesi.
  int get focusBalance => _chainService.balance;

  /// Bekleyen giden transferler düşülmüş bakiye.
  int get availableFocusBalance => _chainService.availableBalance;

  /// Zincir yüksekliği; genesis dahil.
  int get chainHeight => _chainService.chainHeight;

  /// Bekleyen zincir işlemi sayısı.
  int get pendingChainTransactionCount => _chainService.pendingTransactionCount;

  /// Zincirde basılmış toplam FOCUS miktarı.
  int get totalMintedFocus => _chainService.totalMinted;

  /// Zincir servisi kullanıma hazır mı?
  bool get isChainReady => _chainService.isReady;

  /// Madencilik sürüyor mu?
  bool get isMining => _chainService.isMining;

  /// Demo kurcalama modu etkin mi?
  bool get isChainTampered => _chainService.isTampered;

  /// Son zincir doğrulama sonucu.
  ChainValidationResult? get lastChainValidation =>
      _chainService.lastValidation;

  /// Son odak veya görev ödülü.
  ChainReward? get lastChainReward => _chainService.lastReward;

  /// Son üretilen blok.
  ChainBlock? get lastMinedBlock => _chainService.lastMinedBlock;

  /// Son işlemde basılan rozetler.
  List<AchievementId> get lastAchievements => _chainService.lastAchievements;

  /// Zincirde basılmış rozetler.
  List<MintedAchievement> get mintedAchievements =>
      _chainService.mintedAchievements;

  /// Defterde onaylanmış ödül kullanımları.
  List<ChainTransaction> get rewardRedemptions =>
      _chainService.rewardRedemptions;

  /// Bir görev için zincirde ödül işlemi var mı?
  bool hasRewardForTask(String taskId) =>
      _chainService.chain?.hasTransactionForTask(taskId) ?? false;

  /// Bir oturum için zincirde ödül işlemi var mı?
  bool hasRewardForSession(String sessionId) =>
      _chainService.chain?.hasTransactionForSession(sessionId) ?? false;

  /// Başlangıç verilerini depodan yükler.
  ///
  /// Aynı anda birden fazla çağrı gelirse yalnızca biri çalışır. Hata
  /// durumunda [loadError] doldurulur ve kullanıcıya tekrar deneme imkânı
  /// bırakılır.
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) {
      return;
    }
    _isInitializing = true;
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      _tasks = List<StudyTask>.unmodifiable(_taskRepository.loadTasks());
      _sessions = List<FocusSession>.unmodifiable(
        _sessionRepository.loadSessions(),
      );
      _settings = _settingsRepository.loadSettings();
      try {
        await _chainService.initialize();
        _chainError = null;
      } on Object {
        _chainError =
            _chainService.error ??
            'Kanıt defteri başlatılamadı. Yerel depolamayı kontrol edin.';
      }
      _isInitialized = true;
    } on Object {
      _loadError = 'Kayıtlı veriler yüklenemedi. Lütfen tekrar deneyin.';
    } finally {
      _isInitializing = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tamamlanmamış görevleri son tarihe, sonra oluşturulma zamanına göre sıralar.
  List<StudyTask> get pendingTasks {
    final pending = _tasks.where((task) => !task.isCompleted).toList();
    pending.sort(_comparePendingTasks);
    return List<StudyTask>.unmodifiable(pending);
  }

  /// Tamamlanmış görevleri en son tamamlanandan geriye doğru sıralar.
  List<StudyTask> get completedTasks {
    final completed = _tasks.where((task) => task.isCompleted).toList();
    completed.sort(_compareCompletedTasks);
    return List<StudyTask>.unmodifiable(completed);
  }

  /// Görev ekranı için tüm görevleri bekleyenler önde olacak şekilde sıralar.
  List<StudyTask> get sortedTasks {
    final sorted = List<StudyTask>.of(_tasks);
    sorted.sort((first, second) {
      if (first.isCompleted != second.isCompleted) {
        return first.isCompleted ? 1 : -1;
      }
      return first.isCompleted
          ? _compareCompletedTasks(first, second)
          : _comparePendingTasks(first, second);
    });
    return List<StudyTask>.unmodifiable(sorted);
  }

  /// Ana sayfada gösterilecek en fazla üç bekleyen görev.
  List<StudyTask> get upcomingTasks =>
      pendingTasks.take(3).toList(growable: false);

  /// Bekleyen görev sayısı.
  int get pendingTaskCount => StatisticsCalculator.pendingTaskCount(_tasks);

  /// Tamamlanmış görev sayısı.
  int get completedTaskCount =>
      StatisticsCalculator.totalCompletedTaskCount(_tasks);

  /// Toplam görev sayısı.
  int get totalTaskCount => _tasks.length;

  /// Bugün tamamlanan görev sayısı.
  int get todayCompletedTaskCount =>
      StatisticsCalculator.todayCompletedTaskCount(_tasks);

  /// Bugün tamamlanan odak süresi (saniye).
  int get todayFocusSeconds =>
      StatisticsCalculator.todayFocusSeconds(_sessions);

  /// Bugün tamamlanan odak oturumu sayısı.
  int get todayFocusSessionCount =>
      StatisticsCalculator.todayFocusSessionCount(_sessions);

  /// Tüm zamanların toplam odak süresi (saniye).
  int get totalFocusSeconds =>
      StatisticsCalculator.totalFocusSeconds(_sessions);

  /// Tüm zamanların tamamlanmış odak oturumu sayısı.
  int get totalCompletedFocusSessionCount =>
      StatisticsCalculator.totalCompletedFocusSessionCount(_sessions);

  /// Son yedi günün odak süreleri; eskiden yeniye sıralıdır.
  List<DailyFocus> get lastSevenDays =>
      StatisticsCalculator.lastSevenDays(_sessions);

  /// Son yedi günün toplam odak süresi (saniye).
  int get lastSevenDaysFocusSeconds =>
      StatisticsCalculator.lastSevenDaysFocusSeconds(_sessions);

  /// İstatistik ekranında gösterilecek son beş tamamlanmış odak oturumu.
  List<FocusSession> get recentFocusSessions {
    final recent = StatisticsCalculator.completedFocusSessions(
      _sessions,
    ).toList();
    recent.sort(
      (first, second) => second.effectiveDate.compareTo(first.effectiveDate),
    );
    return List<FocusSession>.unmodifiable(
      recent.take(5).toList(growable: false),
    );
  }

  /// Yeni bir görev ekler; kayıt başarılıysa `true` döner.
  ///
  /// Başlık doğrulanmadan ve depoya yazılmadan listeye eklenmez.
  Future<bool> addTask({
    required String title,
    String? category,
    DateTime? dueDate,
  }) async {
    final validationError = StudyTask.validateTitle(title);
    if (validationError != null) {
      _setError(validationError);
      return false;
    }

    final task = StudyTask(
      id: _createId('task'),
      title: title.trim(),
      category: _normalizeOptionalText(category),
      dueDate: dueDate,
      createdAt: DateTime.now(),
    );
    return _commitTasks(<StudyTask>[task, ..._tasks]);
  }

  /// Var olan görevi günceller; kayıt başarılıysa `true` döner.
  Future<bool> updateTask(StudyTask updatedTask) async {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index == -1) {
      _setError('Görev bulunamadı. Liste yenilenmiş olabilir.');
      return false;
    }

    final validationError = StudyTask.validateTitle(updatedTask.title);
    if (validationError != null) {
      _setError(validationError);
      return false;
    }

    final normalized = updatedTask.copyWith(
      title: updatedTask.title.trim(),
      category: _normalizeOptionalText(updatedTask.category),
    );
    final next = List<StudyTask>.of(_tasks);
    next[index] = normalized;
    return _commitTasks(next);
  }

  /// Görevin tamamlanma durumunu değiştirir ve zaman damgasını günceller.
  Future<bool> setTaskCompleted(
    StudyTask task, {
    required bool isCompleted,
  }) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) {
      _setError('Görev bulunamadı. Liste yenilenmiş olabilir.');
      return false;
    }
    if (task.isCompleted == isCompleted) {
      return true;
    }

    final updated = task.copyWith(
      isCompleted: isCompleted,
      completedAt: isCompleted ? DateTime.now() : null,
    );
    final next = List<StudyTask>.of(_tasks);
    next[index] = updated;
    final saved = await _commitTasks(next);
    if (!saved) {
      return false;
    }
    if (isCompleted) {
      await _chainService.recordTaskReward(
        task: updated,
        sessions: _sessions,
        tasks: _tasks,
      );
      final chainError = _chainService.error;
      if (chainError != null) {
        _chainError = chainError;
      }
    }
    return true;
  }

  /// Görevi siler; kayıt başarılıysa `true` döner.
  Future<bool> deleteTask(StudyTask task) async {
    final next = _tasks
        .where((item) => item.id != task.id)
        .toList(growable: false);
    if (next.length == _tasks.length) {
      _setError('Silinecek görev bulunamadı.');
      return false;
    }
    return _commitTasks(next);
  }

  /// Tamamlanan bir oturumu geçmişe kaydeder.
  Future<bool> recordSession(FocusSession session) async {
    final next = List<FocusSession>.unmodifiable(<FocusSession>[
      session,
      ..._sessions,
    ]);
    try {
      final saved = await _sessionRepository.saveSessions(next);
      if (!saved) {
        _setError('Oturum kaydedilemedi. Lütfen tekrar deneyin.');
        return false;
      }
      _sessions = next;
      _lastError = null;
      notifyListeners();
      if (session.isCompleted && session.type.isFocus) {
        await _chainService.recordFocusReward(
          session: session,
          sessions: _sessions,
          tasks: _tasks,
        );
        final chainError = _chainService.error;
        if (chainError != null) {
          _chainError = chainError;
        }
      }
      return true;
    } on Object {
      _setError('Oturum kaydedilemedi. Lütfen tekrar deneyin.');
      return false;
    }
  }

  /// Ayarları doğrulayıp kaydeder; başarılıysa `true` döner.
  Future<bool> updateSettings(AppSettings settings) async {
    final validationError = settings.validationError;
    if (validationError != null) {
      _setError(validationError);
      return false;
    }

    try {
      final saved = await _settingsRepository.saveSettings(settings);
      if (!saved) {
        _setError('Ayarlar kaydedilemedi. Lütfen tekrar deneyin.');
        return false;
      }
      _settings = settings;
      _lastError = null;
      notifyListeners();
      return true;
    } on Object {
      _setError('Ayarlar kaydedilemedi. Lütfen tekrar deneyin.');
      return false;
    }
  }

  /// Tüm görevleri ve oturum kayıtlarını siler; ayarlar korunur.
  Future<bool> clearAllData() async {
    try {
      final tasksCleared = await _taskRepository.clear();
      final sessionsCleared = await _sessionRepository.clear();
      if (!tasksCleared || !sessionsCleared) {
        _setError('Verilerin tamamı silinemedi. Lütfen yeniden deneyin.');
        return false;
      }
      if (_chainService.isReady) {
        final chainReset = await _chainService.resetChain();
        if (!chainReset) {
          _setError('Kanıt defteri sıfırlanamadı. Lütfen yeniden deneyin.');
          return false;
        }
      }

      _tasks = const <StudyTask>[];
      _sessions = const <FocusSession>[];
      _lastError = null;
      notifyListeners();
      return true;
    } on Object {
      _setError('Veriler silinemedi. Lütfen yeniden deneyin.');
      return false;
    }
  }

  /// Bekleyen zincir işlemlerini bloklaştırır.
  Future<ChainBlock?> minePendingBlock() async {
    final block = await _chainService.minePending();
    _chainError = _chainService.error;
    notifyListeners();
    return block;
  }

  /// Zinciri doğrular ve sonucu döndürür.
  Future<ChainValidationResult?> validateChain() async {
    final result = await _chainService.validateChain();
    _chainError = _chainService.error;
    notifyListeners();
    return result;
  }

  /// İmzalı FOCUS transferi gönderir.
  Future<ChainReward?> sendFocusTransfer({
    required String toAddress,
    required int amount,
    String? memo,
  }) async {
    final result = await _chainService.sendTransfer(
      toAddress: toAddress,
      amount: amount,
      memo: memo,
    );
    _chainError = _chainService.error;
    notifyListeners();
    return result;
  }

  /// FOCUS karşılığında yerel bir ödülü kullanır.
  Future<ChainReward?> redeemReward(RewardOffer offer) async {
    final result = await _chainService.redeemReward(
      rewardId: offer.name,
      title: offer.title,
      cost: offer.cost,
    );
    _chainError = _chainService.error;
    notifyListeners();
    return result;
  }

  /// Demo için defteri bellekte kurcalar.
  Future<bool> simulateChainTamper() async {
    final tampered = await _chainService.simulateTamper();
    _chainError = _chainService.error;
    notifyListeners();
    return tampered;
  }

  /// Kurcalama demosundan önceki deftere döner.
  Future<void> restoreChainAfterTamper() async {
    await _chainService.restoreAfterTamper();
    _chainError = null;
    notifyListeners();
  }

  /// Zinciri genesis bloğuna sıfırlar.
  Future<bool> resetChain() async {
    final reset = await _chainService.resetChain();
    _chainError = _chainService.error;
    notifyListeners();
    return reset;
  }

  /// Zincir başlatmayı yeniden dener.
  Future<void> retryChainInitialization() async {
    try {
      await _chainService.initialize();
      _chainError = null;
    } on Object {
      _chainError =
          _chainService.error ??
          'Kanıt defteri başlatılamadı. Yerel depolamayı kontrol edin.';
    }
    notifyListeners();
  }

  void _handleChainChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _chainService.removeListener(_handleChainChanged);
    super.dispose();
  }

  Future<bool> _commitTasks(List<StudyTask> nextTasks) async {
    try {
      final saved = await _taskRepository.saveTasks(nextTasks);
      if (!saved) {
        _setError('Görevler kaydedilemedi. Lütfen tekrar deneyin.');
        return false;
      }
      _tasks = List<StudyTask>.unmodifiable(nextTasks);
      _lastError = null;
      notifyListeners();
      return true;
    } on Object {
      _setError('Görevler kaydedilemedi. Lütfen tekrar deneyin.');
      return false;
    }
  }

  void _setError(String message) {
    _lastError = message;
    notifyListeners();
  }

  String _createId(String prefix) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomPart = _random.nextInt(0x7fffffff);
    return '${prefix}_${timestamp}_$randomPart';
  }

  static String? _normalizeOptionalText(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static int _comparePendingTasks(StudyTask first, StudyTask second) {
    final firstDue = first.dueDate;
    final secondDue = second.dueDate;
    if (firstDue == null && secondDue == null) {
      return second.createdAt.compareTo(first.createdAt);
    }
    if (firstDue == null) {
      return 1;
    }
    if (secondDue == null) {
      return -1;
    }
    final byDueDate = firstDue.compareTo(secondDue);
    if (byDueDate != 0) {
      return byDueDate;
    }
    return second.createdAt.compareTo(first.createdAt);
  }

  static int _compareCompletedTasks(StudyTask first, StudyTask second) {
    final firstDate = first.completedAt ?? first.createdAt;
    final secondDate = second.completedAt ?? second.createdAt;
    return secondDate.compareTo(firstDate);
  }
}
