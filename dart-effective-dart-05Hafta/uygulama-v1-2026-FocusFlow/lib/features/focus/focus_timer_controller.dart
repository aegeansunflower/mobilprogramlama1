import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/app_settings.dart';
import '../../models/focus_session.dart';

/// Pomodoro sayacının bulunduğu durum.
enum FocusTimerStatus {
  /// Sayaç başlamaya hazır.
  idle,

  /// Sayaç çalışıyor.
  running,

  /// Sayaç duraklatıldı.
  paused,

  /// Süre tamamlandı ve oturum kaydedilmeye hazır.
  completed,
}

/// Pomodoro sayacının durumunu ve zaman hesaplamasını yönetir.
///
/// Kalan süre her saniye yalnızca bir azaltılarak değil, hedef bitiş zamanı
/// ile [DateTime.now] arasındaki farktan hesaplanır. Böylece uygulama arka
/// plana alınıp geri döndüğünde sayaç sapmaz.
///
/// UI bu sınıfı dinler; sayaç kuralları widget içine gömülmez.
class FocusTimerController extends ChangeNotifier {
  /// Verilen ayarlarla sayacı oluşturur.
  ///
  /// [onSessionCompleted] yalnızca süre bir kez dolduğunda çağrılır.
  /// [clock] testlerde zamanı kontrol etmek için değiştirilebilir.
  FocusTimerController({
    required AppSettings settings,
    required this.onSessionCompleted,
    DateTime Function()? clock,
  }) : _settings = settings,
       _clock = clock ?? DateTime.now,
       _totalSeconds = settings.durationSecondsFor(SessionType.focus),
       _remainingSeconds = settings.durationSecondsFor(SessionType.focus);

  /// Süre dolduğunda kaydedilecek oturumu dışarıya bildirir.
  final void Function(FocusSession session) onSessionCompleted;

  final DateTime Function() _clock;

  AppSettings _settings;
  SessionType _type = SessionType.focus;
  FocusTimerStatus _status = FocusTimerStatus.idle;
  Timer? _ticker;
  DateTime? _targetEnd;
  DateTime? _startedAt;
  int _totalSeconds;
  int _remainingSeconds;
  bool _completionHandled = false;

  /// Seçili oturum türü.
  SessionType get type => _type;

  /// Sayacın güncel durumu.
  FocusTimerStatus get status => _status;

  /// Seçili oturumun toplam süresi (saniye).
  int get totalSeconds => _totalSeconds;

  /// Kalan süre (saniye).
  int get remainingSeconds => _remainingSeconds;

  /// Kalan sürenin toplam süreye oranı; halka göstergesi için kullanılır.
  double get progress {
    if (_totalSeconds == 0) {
      return 0;
    }
    return (_remainingSeconds / _totalSeconds).clamp(0.0, 1.0).toDouble();
  }

  /// Oturum sürerken mod değiştirilip değiştirilemeyeceği.
  bool get canChangeType =>
      _status == FocusTimerStatus.idle || _status == FocusTimerStatus.completed;

  /// Sayacın çalışıyor veya duraklatılmış olup olmadığı.
  bool get isActive =>
      _status == FocusTimerStatus.running || _status == FocusTimerStatus.paused;

  /// Oturum türünü değiştirir ve sayacı başa alır.
  ///
  /// Çalışan veya duraklatılmış bir oturum varken istek yok sayılır; böylece
  /// kullanıcı istemeden mevcut oturumu kaybetmez.
  void selectType(SessionType type) {
    if (!canChangeType) {
      return;
    }
    _ticker?.cancel();
    _ticker = null;
    _targetEnd = null;
    _startedAt = null;
    _completionHandled = false;
    _type = type;
    _totalSeconds = _settings.durationSecondsFor(type);
    _remainingSeconds = _totalSeconds;
    _status = FocusTimerStatus.idle;
    notifyListeners();
  }

  /// Sayacı başlatır veya duraklatılmış sayaca devam eder.
  void start() {
    if (_status == FocusTimerStatus.running) {
      return;
    }
    if (_status == FocusTimerStatus.completed || _remainingSeconds <= 0) {
      _resetInternal();
    }

    _startedAt ??= _clock();
    _targetEnd = _clock().add(Duration(seconds: _remainingSeconds));
    _status = FocusTimerStatus.running;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _handleTick());
    notifyListeners();
  }

  /// Çalışan sayacı duraklatır ve kalan süreyi dondurur.
  void pause() {
    if (_status != FocusTimerStatus.running) {
      return;
    }

    final completed = _refreshRemaining();
    _ticker?.cancel();
    _ticker = null;
    _targetEnd = null;
    if (!completed) {
      _status = FocusTimerStatus.paused;
      notifyListeners();
    }
  }

  /// Duraklatılmış sayaca devam eder.
  void resume() => start();

  /// Sayacı seçili modun başlangıç süresine döndürür.
  ///
  /// Devam eden oturum kaydedilmez; bu nedenle UI önce onay ister.
  void reset() {
    _resetInternal();
    notifyListeners();
  }

  /// Uygulama ön plana döndüğünde kalan süreyi hedef zamana göre günceller.
  void syncNow() {
    if (_status != FocusTimerStatus.running) {
      return;
    }
    final completed = _refreshRemaining();
    if (!completed) {
      notifyListeners();
    }
  }

  /// Ayarlar değiştiğinde yeni süreleri uygular.
  ///
  /// Devam eden veya duraklatılmış oturumun süresi değiştirilmez; yeni
  /// süreler bir sonraki oturumda geçerli olur.
  void applySettings(AppSettings settings) {
    if (settings == _settings) {
      return;
    }
    _settings = settings;
    if (_status == FocusTimerStatus.idle) {
      final total = _settings.durationSecondsFor(_type);
      if (total != _totalSeconds) {
        _totalSeconds = total;
        _remainingSeconds = total;
        notifyListeners();
      }
    }
  }

  void _handleTick() {
    if (_status != FocusTimerStatus.running) {
      return;
    }
    final completed = _refreshRemaining();
    if (!completed) {
      notifyListeners();
    }
  }

  bool _refreshRemaining() {
    final target = _targetEnd;
    if (target == null) {
      return false;
    }

    final remainingMilliseconds = target.difference(_clock()).inMilliseconds;
    var nextRemaining = remainingMilliseconds <= 0
        ? 0
        : (remainingMilliseconds + 999) ~/ 1000;
    if (nextRemaining > _totalSeconds) {
      nextRemaining = _totalSeconds;
    }

    _remainingSeconds = nextRemaining;
    if (nextRemaining == 0) {
      _completeSession();
      return true;
    }
    return false;
  }

  void _completeSession() {
    if (_completionHandled) {
      return;
    }
    _completionHandled = true;
    _ticker?.cancel();
    _ticker = null;
    _targetEnd = null;
    _remainingSeconds = 0;
    _status = FocusTimerStatus.completed;

    final completedAt = _clock();
    final startedAt =
        _startedAt ?? completedAt.subtract(Duration(seconds: _totalSeconds));
    final session = FocusSession(
      id: 'session_${completedAt.microsecondsSinceEpoch}',
      type: _type,
      plannedDurationSeconds: _totalSeconds,
      actualDurationSeconds: _totalSeconds,
      startedAt: startedAt,
      completedAt: completedAt,
      isCompleted: true,
    );

    notifyListeners();
    onSessionCompleted(session);
  }

  void _resetInternal() {
    _ticker?.cancel();
    _ticker = null;
    _targetEnd = null;
    _startedAt = null;
    _completionHandled = false;
    _totalSeconds = _settings.durationSecondsFor(_type);
    _remainingSeconds = _totalSeconds;
    _status = FocusTimerStatus.idle;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    super.dispose();
  }
}
