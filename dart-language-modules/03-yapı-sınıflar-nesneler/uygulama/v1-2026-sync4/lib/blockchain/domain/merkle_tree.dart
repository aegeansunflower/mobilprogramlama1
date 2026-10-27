// DART KONUSU: Class modifiers — `final class`. Classes & objects — named /
// factory constructor, initializer list, static metotlar, private alanlar,
// records (`(Hash, bool)`), `toString`. Metadata — `@immutable`.

/// Merkle ağacı ve üyelik kanıtı.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Blok içindeki işlemlerin Merkle ağacı.
///
/// Yaprak ve iç düğümler farklı öneklerle (`0x00` / `0x01`) hash'lenir. Böylece
/// bir iç düğüm yaprak gibi gösterilerek sahte kanıt üretilemez (ikinci ön
/// görüntü saldırısı). Tek kalan düğüm çoğaltılmaz, bir üst seviyeye taşınır.
@immutable
final class MerkleTree {
  /// İşlem hash'lerinden ağaç kurar.
  MerkleTree(List<Hash> leaves)
    : _levels = _build([for (final leaf in leaves) _leaf(leaf)]);

  /// Kayıtlardan ağaç kurar.
  factory MerkleTree.fromRecords(Iterable<Record> records) =>
      MerkleTree([for (final r in records) r.recordHash]);

  /// Boş bloğun kökü.
  static final Hash emptyRoot = Hash.ofString('merkle:empty');

  final List<List<Hash>> _levels;

  /// Ağacın kökü.
  Hash get root => _levels.isEmpty ? emptyRoot : _levels.last.single;

  /// Yaprak sayısı.
  int get leafCount => _levels.isEmpty ? 0 : _levels.first.length;

  /// [index] numaralı yaprak için üyelik kanıtı.
  MerkleProof proofFor(int index) {
    RangeError.checkValidIndex(index, _levels.first, 'index');
    final steps = <(Hash, bool)>[];
    var position = index;
    for (var level = 0; level < _levels.length - 1; level++) {
      final nodes = _levels[level];
      final sibling = position.isEven ? position + 1 : position - 1;
      if (sibling < nodes.length) {
        steps.add((nodes[sibling], sibling < position));
      }
      position ~/= 2;
    }
    return MerkleProof(steps);
  }

  /// [leaf] işlem hash'inin [proof] ile [root] köküne ulaştığını doğrular.
  static bool verify(Hash leaf, MerkleProof proof, Hash root) {
    var current = _leaf(leaf);
    for (final (sibling, siblingOnLeft) in proof.steps) {
      current = siblingOnLeft
          ? _node(sibling, current)
          : _node(current, sibling);
    }
    return current == root;
  }

  static Hash _leaf(Hash h) => Hash.of([0x00, ...h.bytes]);

  static Hash _node(Hash l, Hash r) => Hash.of([0x01, ...l.bytes, ...r.bytes]);

  static List<List<Hash>> _build(List<Hash> leaves) {
    if (leaves.isEmpty) return const [];
    final levels = [leaves];
    while (levels.last.length > 1) {
      final current = levels.last;
      levels.add([
        for (var i = 0; i < current.length; i += 2)
          if (i + 1 < current.length)
            _node(current[i], current[i + 1])
          else
            current[i],
      ]);
    }
    return levels;
  }
}

/// Bir yaprağın köke giden yolu: her adımda kardeş düğüm ve kardeşin solda
/// olup olmadığı.
@immutable
final class MerkleProof {
  const MerkleProof(this.steps);

  /// JSON'dan çözer (öğrenci makbuzu Firestore'dan gelir).
  factory MerkleProof.fromJson(List<Object?> json) => MerkleProof([
    for (final step in json.cast<Map<String, Object?>>())
      (Hash.fromHex(step['h']! as String), step['l']! as bool),
  ]);

  final List<(Hash, bool)> steps;

  List<Map<String, Object>> toJson() => [
    for (final (hash, left) in steps) {'h': hash.hex, 'l': left},
  ];

  @override
  String toString() => 'MerkleProof(${steps.length} adım)';
}
