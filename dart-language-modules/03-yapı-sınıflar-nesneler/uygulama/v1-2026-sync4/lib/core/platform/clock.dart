// DART KONUSU: Class modifiers — `interface class`. Classes & objects —
// const constructor, callable class (`call`).

/// Test edilebilir saat soyutlaması.
library;

/// Sistem saati.
///
/// `interface class` seçildi: varsayılan uygulama somuttur ve doğrudan
/// örneklenebilir (`const Clock()`). Ancak başka kütüphaneler yalnızca
/// `implements` ile *yeniden yazabilir*, `extends` ile miras alamaz. Testler
/// QR'ın 15 saniyede eskimesini denemek için `FixedClock implements Clock`
/// yazar; `now()` davranışının kısmen miras alınıp bozulması engellenir.
interface class Clock {
  const Clock();

  /// Şu anki zaman (UTC).
  DateTime now() => DateTime.now().toUtc();

  /// Callable class: `clock()` yazımı `clock.now()` ile aynıdır.
  DateTime call() => now();
}
