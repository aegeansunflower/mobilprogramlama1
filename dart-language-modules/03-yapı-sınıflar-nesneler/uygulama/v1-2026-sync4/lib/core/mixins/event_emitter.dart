// DART KONUSU: Class modifiers — `mixin class` (hem tek başına sınıf hem
// mixin olarak kullanılabilir). Classes & objects — generics, private alan.

/// Basit, senkron olay yayıncısı.
library;

/// Dinleyicilere olay yayınlar.
///
/// `mixin class` seçildi çünkü iki biçimde de gerçekten kullanılıyor:
/// * `Blockchain with EventEmitter<Block>` → zincire blok eklenince
///   dinleyiciler haber alır (bkz. `test/blockchain/chain_test.dart`).
/// * `EventEmitter<String>()` → tek başına bir nesne olarak (bkz.
///   `test/core/result_test.dart`).
mixin class EventEmitter<E> {
  final List<void Function(E event)> _listeners = [];

  /// Dinleyici ekler. Döndürülen fonksiyon dinleyiciyi kaldırır.
  void Function() listen(void Function(E event) listener) {
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  /// Tüm dinleyicilere [event] olayını iletir.
  void emit(E event) {
    for (final listener in List.of(_listeners)) {
      listener(event);
    }
  }

  /// Kayıtlı dinleyici sayısı.
  int get listenerCount => _listeners.length;
}
