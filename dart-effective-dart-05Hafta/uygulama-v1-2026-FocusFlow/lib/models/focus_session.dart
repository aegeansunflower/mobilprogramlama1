/// Pomodoro oturumunun türü.
enum SessionType {
  /// Odaklanma oturumu.
  focus,

  /// Kısa mola.
  shortBreak,

  /// Uzun mola.
  longBreak,
}

/// Oturum türlerinin kullanıcıya gösterilen Türkçe adları.
extension SessionTypeDetails on SessionType {
  /// Tam etiket; örneğin `Kısa mola`.
  String get label => switch (this) {
    SessionType.focus => 'Odak',
    SessionType.shortBreak => 'Kısa mola',
    SessionType.longBreak => 'Uzun mola',
  };

  /// Tamamlanan bir oturumun istatistiklere odak olarak sayılıp sayılmadığı.
  bool get isFocus => this == SessionType.focus;
}

/// Tamamlanmış veya yarım kalmış bir Pomodoro oturumunun kaydı.
class FocusSession {
  /// Yeni bir oturum kaydı oluşturur.
  const FocusSession({
    required this.id,
    required this.type,
    required this.plannedDurationSeconds,
    required this.actualDurationSeconds,
    required this.startedAt,
    this.completedAt,
    this.isCompleted = false,
  });

  /// Kaydın kalıcı depodaki benzersiz kimliği.
  final String id;

  /// Oturumun türü.
  final SessionType type;

  /// Başlangıçta planlanan süre.
  final int plannedDurationSeconds;

  /// Gerçekleşen süre; tamamlanan oturumlarda planlanan süreye eşittir.
  final int actualDurationSeconds;

  /// Oturumun başladığı zaman.
  final DateTime startedAt;

  /// Oturum tamamlandıysa bitiş zamanı.
  final DateTime? completedAt;

  /// Oturumun tamamlanıp tamamlanmadığı.
  final bool isCompleted;

  /// İstatistiklerde gün ataması yapılırken kullanılacak tarih.
  ///
  /// Tamamlanan oturumlarda bitiş, diğerlerinde başlangıç zamanı esas alınır.
  DateTime get effectiveDate => completedAt ?? startedAt;

  /// Kaydı yerel depoya yazılabilecek JSON haritasına dönüştürür.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'plannedDurationSeconds': plannedDurationSeconds,
      'actualDurationSeconds': actualDurationSeconds,
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  /// JSON haritasından oturum kaydı üretir.
  ///
  /// Zorunlu alanlar geçersizse [FormatException] fırlatır; repository bu
  /// kaydı atlayarak diğer oturumların yüklenmesine devam eder.
  factory FocusSession.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final typeRaw = json['type'];
    final planned = json['plannedDurationSeconds'];
    final actual = json['actualDurationSeconds'];
    final startedAtRaw = json['startedAt'];

    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('Oturum kimliği eksik veya geçersiz.');
    }
    final type = _parseSessionType(typeRaw);
    if (type == null) {
      throw const FormatException('Oturum türü geçersiz.');
    }
    if (planned is! int || planned <= 0) {
      throw const FormatException('Planlanan süre geçersiz.');
    }
    if (actual is! int || actual < 0) {
      throw const FormatException('Gerçekleşen süre geçersiz.');
    }

    final startedAt = startedAtRaw is String
        ? DateTime.tryParse(startedAtRaw)
        : null;
    if (startedAt == null) {
      throw const FormatException('Oturum başlangıç zamanı geçersiz.');
    }

    final completedAtRaw = json['completedAt'];
    return FocusSession(
      id: id,
      type: type,
      plannedDurationSeconds: planned,
      actualDurationSeconds: actual,
      startedAt: startedAt,
      completedAt: completedAtRaw is String
          ? DateTime.tryParse(completedAtRaw)
          : null,
      isCompleted: json['isCompleted'] == true,
    );
  }

  static SessionType? _parseSessionType(Object? value) {
    if (value is! String) {
      return null;
    }
    for (final type in SessionType.values) {
      if (type.name == value) {
        return type;
      }
    }
    return null;
  }
}
