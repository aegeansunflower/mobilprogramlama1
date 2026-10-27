// DART KONUSU: Classes & objects — const constructor, factory `fromJson`,
// getter, `operator ==` / `hashCode`, `toString`. Metadata — `@immutable`.

/// Öğrenciye verilen, zincirde doğrulanabilir yoklama makbuzu.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/blockchain/domain/merkle_tree.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Bir kaydın hangi blokta olduğunu ve Merkle kanıtını taşır.
///
/// Öğrenci cihazı bloğun tamamını indirmeden yalnızca bu makbuzla kaydının
/// zincirde olduğunu doğrular ([isValid]) ve "Doğrulandı ✓" gösterir.
@immutable
final class ChainReceipt {
  const ChainReceipt({
    required this.recordHash,
    required this.blockIndex,
    required this.blockHash,
    required this.merkleRoot,
    required this.proof,
  });

  factory ChainReceipt.fromJson(Map<String, Object?> json) => ChainReceipt(
    recordHash: Hash.fromHex(json['recordHash']! as String),
    blockIndex: json['blockIndex']! as int,
    blockHash: Hash.fromHex(json['blockHash']! as String),
    merkleRoot: Hash.fromHex(json['merkleRoot']! as String),
    proof: MerkleProof.fromJson(json['proof']! as List<Object?>),
  );

  final Hash recordHash;
  final int blockIndex;
  final Hash blockHash;
  final Hash merkleRoot;
  final MerkleProof proof;

  /// Kayıt hash'i Merkle kanıtıyla blok köküne ulaşıyor mu?
  bool get isValid => MerkleTree.verify(recordHash, proof, merkleRoot);

  Map<String, Object?> toJson() => {
    'recordHash': recordHash.hex,
    'blockIndex': blockIndex,
    'blockHash': blockHash.hex,
    'merkleRoot': merkleRoot.hex,
    'proof': proof.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is ChainReceipt &&
      other.recordHash == recordHash &&
      other.blockHash == blockHash;

  @override
  int get hashCode => Object.hash(recordHash, blockHash);

  @override
  String toString() => 'ChainReceipt(#$blockIndex ${blockHash.short})';
}
