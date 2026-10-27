// DART KONUSU: Class modifiers — `abstract interface class` ve `final class`.
// Libraries & imports — `show`.

/// Uzak (paylaşılan) zincir kaynağı.
library;

import 'dart:async' show StreamController;

/// Tüm cihazların paylaştığı zincir kopyası.
abstract interface class RemoteChainSource {
  /// [fromIndex] ve sonrasındaki blokların JSON'ları.
  Future<List<Map<String, Object?>>> fetchFrom(int fromIndex);

  /// Bloğu, uzak zincirin uzunluğu hâlâ [expectedLength] ise ekler.
  ///
  /// Başka bir görevli araya blok eklediyse `false` döner. Bu iyimser
  /// kilit (optimistic lock) sayesinde zincir hiçbir zaman dallanmaz.
  Future<bool> tryAppend(
    Map<String, Object?> blockJson, {
    required int expectedLength,
  });

  /// Uzak zincir uzunluğu değiştikçe yeni uzunluğu yayınlar.
  Stream<int> watchLength();
}

/// Bellek içi uzak zincir. Demo modunda ve testlerde birden çok "cihazın"
/// aynı zinciri paylaşmasını sağlar.
///
/// Genesis bloğu saklanmaz (her cihaz aynısını üretir); bu yüzden boş
/// zincirin uzunluğu 1'dir.
final class InMemoryRemoteChainSource implements RemoteChainSource {
  // _blocks[i] → zincirdeki (i + 1). blok.
  final List<Map<String, Object?>> _blocks = [];
  final StreamController<int> _length = StreamController.broadcast();

  int get _chainLength => _blocks.length + 1;

  @override
  Future<List<Map<String, Object?>>> fetchFrom(int fromIndex) async => [
    for (final b in _blocks.skip(fromIndex < 1 ? 0 : fromIndex - 1)) Map.of(b),
  ];

  @override
  Future<bool> tryAppend(
    Map<String, Object?> blockJson, {
    required int expectedLength,
  }) async {
    if (_chainLength != expectedLength) return false;
    _blocks.add(Map.of(blockJson));
    _length.add(_chainLength);
    return true;
  }

  @override
  Stream<int> watchLength() => _length.stream;
}
