String _twoDigits(int value) => value.toString().padLeft(2, '0');

/// Saniye değerini geri sayım saatine dönüştürür.
///
/// Örnekler: `0` → `00:00`, `1500` → `25:00`, `3661` → `1:01:01`.
/// Negatif değerler sayaçta anlamlı olmadığı için sıfır kabul edilir.
String formatClock(int totalSeconds) {
  final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  final hours = safeSeconds ~/ 3600;
  final minutes = (safeSeconds % 3600) ~/ 60;
  final seconds = safeSeconds % 60;

  if (hours > 0) {
    return '$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
  }
  return '${_twoDigits(minutes)}:${_twoDigits(seconds)}';
}

/// Saniye değerini kullanıcıya gösterilecek okunaklı bir süreye dönüştürür.
///
/// Tam dakikalar `25 dk`, saatli süreler `1 sa 5 dk` biçiminde gösterilir.
/// Sıfırdan büyük ama bir dakikadan kısa süreler `< 1 dk` olarak ifade edilir.
String formatHumanDuration(int totalSeconds) {
  final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
  if (safeSeconds == 0) {
    return '0 dk';
  }
  if (safeSeconds < 60) {
    return '< 1 dk';
  }

  final totalMinutes = safeSeconds ~/ 60;
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  if (hours == 0) {
    return '$totalMinutes dk';
  }
  if (minutes == 0) {
    return '$hours sa';
  }
  return '$hours sa $minutes dk';
}
