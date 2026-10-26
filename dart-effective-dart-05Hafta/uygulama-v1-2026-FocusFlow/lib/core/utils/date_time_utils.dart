const List<String> _monthNames = <String>[
  'Ocak',
  'Şubat',
  'Mart',
  'Nisan',
  'Mayıs',
  'Haziran',
  'Temmuz',
  'Ağustos',
  'Eylül',
  'Ekim',
  'Kasım',
  'Aralık',
];

const List<String> _shortMonthNames = <String>[
  'Oca',
  'Şub',
  'Mar',
  'Nis',
  'May',
  'Haz',
  'Tem',
  'Ağu',
  'Eyl',
  'Eki',
  'Kas',
  'Ara',
];

const List<String> _weekdayNames = <String>[
  'Pazartesi',
  'Salı',
  'Çarşamba',
  'Perşembe',
  'Cuma',
  'Cumartesi',
  'Pazar',
];

const List<String> _shortWeekdayNames = <String>[
  'Pzt',
  'Sal',
  'Çar',
  'Per',
  'Cum',
  'Cmt',
  'Paz',
];

String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Saatin yıl, ay ve gün bilgisini koruyarak gün başlangıcını döndürür.
DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// İki tarihin aynı takvim gününe ait olup olmadığını söyler.
bool isSameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

/// Tarihi `24 Ekim 2026` biçiminde Türkçe olarak biçimlendirir.
String formatTurkishDate(DateTime date) =>
    '${date.day} ${_monthNames[date.month - 1]} ${date.year}';

/// Tarihi `24 Ekim 2026, Cuma` biçiminde gün adıyla birlikte gösterir.
String formatTurkishDateWithWeekday(DateTime date) =>
    '${formatTurkishDate(date)}, ${_weekdayNames[date.weekday - 1]}';

/// Tarihi `24 Eki` biçiminde kısa Türkçe olarak biçimlendirir.
String formatShortTurkishDate(DateTime date) =>
    '${date.day} ${_shortMonthNames[date.month - 1]}';

/// Haftanın gününü `Pzt`, `Sal` gibi kısa biçimde döndürür.
String formatShortWeekday(DateTime date) =>
    _shortWeekdayNames[date.weekday - 1];

/// Saat bilgisini `14:05` biçiminde döndürür.
String formatTime(DateTime date) =>
    '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';

/// Son tarihi kullanıcı için anlaşılır biçimde gösterir.
///
/// Bugün, yarın ve dün için özel metinler; diğer günler için kısa tarih
/// kullanılır. Farklı yıla ait tarihlerde yıl da eklenir.
String formatDueDate(DateTime dueDate, {DateTime? now}) {
  final today = dateOnly(now ?? DateTime.now());
  final target = dateOnly(dueDate);
  final dayDifference = target.difference(today).inDays;

  return switch (dayDifference) {
    0 => 'Bugün',
    1 => 'Yarın',
    -1 => 'Dün',
    _ =>
      target.year == today.year
          ? formatShortTurkishDate(target)
          : '${formatShortTurkishDate(target)} ${target.year}',
  };
}

/// Saate göre günün bölümüne uygun bir karşılama metni üretir.
String greetingFor(DateTime time) {
  if (time.hour < 12) {
    return 'Günaydın';
  }
  if (time.hour < 18) {
    return 'İyi günler';
  }
  return 'İyi akşamlar';
}
