/// Kullanıcının takip ettiği tek bir çalışma görevini temsil eder.
///
/// Model değişmezdir; güncellemeler [copyWith] ile yeni bir nesne üretir.
/// Başlık doğrulaması [validateTitle] üzerinden merkezi olarak yapılır.
class StudyTask {
  /// Yeni bir görev nesnesi oluşturur.
  const StudyTask({
    required this.id,
    required this.title,
    required this.createdAt,
    this.category,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  });

  /// Görev başlığının izin verilen en fazla karakter sayısı.
  static const int maxTitleLength = 120;

  /// Görevin kalıcı depodaki benzersiz kimliği.
  final String id;

  /// Kullanıcıya gösterilen görev başlığı.
  final String title;

  /// İsteğe bağlı ders veya kategori etiketi.
  final String? category;

  /// İsteğe bağlı son teslim tarihi.
  final DateTime? dueDate;

  /// Görevin oluşturulduğu zaman.
  final DateTime createdAt;

  /// Görevin tamamlanıp tamamlanmadığı.
  final bool isCompleted;

  /// Görev tamamlandıysa tamamlanma zamanı.
  ///
  /// Günlük tamamlanan görev sayısını doğru hesaplamak için tutulur.
  final DateTime? completedAt;

  /// Görev başlığını doğrular; geçerliyse `null`, değilse hata mesajı döner.
  static String? validateTitle(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Görev başlığı boş olamaz.';
    }
    if (trimmed.length > maxTitleLength) {
      return 'Görev başlığı en fazla $maxTitleLength karakter olabilir.';
    }
    return null;
  }

  /// Görevin tamamlanma durumunu değiştirir.
  ///
  /// Tamamlanan göreve [completedAt] olarak [changedAt] yazılır; geri alınırsa
  /// tamamlanma zamanı temizlenir. Böylece günlük istatistikler tutarlı kalır.
  StudyTask toggleCompletion({DateTime? changedAt}) {
    final now = changedAt ?? DateTime.now();
    return copyWith(
      isCompleted: !isCompleted,
      completedAt: isCompleted ? null : now,
    );
  }

  static const Object _absent = Object();

  /// Seçilen alanları değiştirilmiş yeni bir görev döndürür.
  ///
  /// [category], [dueDate] ve [completedAt] için `null` geçmek alanı
  /// temizler; parametreyi hiç geçmemek mevcut değeri korur.
  StudyTask copyWith({
    String? title,
    Object? category = _absent,
    Object? dueDate = _absent,
    bool? isCompleted,
    Object? completedAt = _absent,
  }) {
    return StudyTask(
      id: id,
      title: title ?? this.title,
      category: identical(category, _absent)
          ? this.category
          : category as String?,
      dueDate: identical(dueDate, _absent)
          ? this.dueDate
          : dueDate as DateTime?,
      createdAt: createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: identical(completedAt, _absent)
          ? this.completedAt
          : completedAt as DateTime?,
    );
  }

  /// Görevi yerel depoya yazılabilecek JSON haritasına dönüştürür.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  /// JSON haritasından görev üretir; zorunlu alanlar geçersizse hata fırlatır.
  ///
  /// Depodaki tek bir bozuk kayıt uygulamayı düşürmesin diye repository bu
  /// hatayı yakalar ve yalnızca ilgili kaydı atlar.
  factory StudyTask.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final title = json['title'];
    final createdAtRaw = json['createdAt'];

    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('Görev kimliği eksik veya geçersiz.');
    }
    if (title is! String || validateTitle(title) != null) {
      throw const FormatException('Görev başlığı eksik veya geçersiz.');
    }

    final createdAt = createdAtRaw is String
        ? DateTime.tryParse(createdAtRaw)
        : null;
    if (createdAt == null) {
      throw const FormatException('Görev oluşturulma tarihi geçersiz.');
    }

    final dueDateRaw = json['dueDate'];
    final completedAtRaw = json['completedAt'];

    return StudyTask(
      id: id,
      title: title.trim(),
      category: _readOptionalText(json['category']),
      dueDate: dueDateRaw is String ? DateTime.tryParse(dueDateRaw) : null,
      createdAt: createdAt,
      isCompleted: json['isCompleted'] == true,
      completedAt: completedAtRaw is String
          ? DateTime.tryParse(completedAtRaw)
          : null,
    );
  }

  static String? _readOptionalText(Object? value) {
    if (value is! String) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
