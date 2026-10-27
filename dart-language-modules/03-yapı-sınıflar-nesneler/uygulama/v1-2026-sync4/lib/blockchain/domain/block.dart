// DART KONUSU: Class modifiers — `final class` (base sınıftan türeyen kapalı
// sınıf). Classes & objects — generative, named, redirecting ve factory
// constructor'lar; `super` parametreleri; initializer list; `late final`;
// static üyeler; `copyWith`; `operator ==` / `hashCode`; `toString`; generics.
// Libraries & imports — `part` (elle bölünmüş JSON kodlayıcı), `show`.
// Metadata — `@immutable`, `@visibleForTesting`, `@override`.

/// Zincirin temel yapı taşı.
library;

import 'dart:convert' show base64Url;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/blockchain/domain/block_base.dart';
import 'package:sarkisla_yoklama/blockchain/domain/merkle_tree.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/core/core.dart';
// Barrel bu extension'ı `hide` ile gizlediği için doğrudan dosyadan alınır.
import 'package:sarkisla_yoklama/core/extensions/date_time_x.dart'
    show EpochMillisX;

part 'block_codec.dart';

/// [T] türünde işlemler taşıyan, imzalı blok.
///
/// `final class` seçildi: bloğun alanları ve hash hesabı kesinleşmiştir.
/// Alt sınıflama ya da taklit, zincir doğrulamasını atlatmanın bir yolu
/// olurdu. `BlockBase` `base` olduğu için alt sınıfın `base`, `final` veya
/// `sealed` olması zaten zorunludur.
@immutable
final class Block<T extends Record> extends BlockBase with Signed {
  /// Generative constructor: yeni ve imzasız bir blok. Merkle kökü initializer
  /// list içinde hesaplanır.
  Block({
    required super.index,
    required super.timestamp,
    required super.previousHash,
    required super.authorityId,
    required List<T> transactions,
  }) : transactions = List.unmodifiable(transactions),
       merkleRoot = MerkleTree.fromRecords(transactions).root,
       signature = null,
       _storedHash = null;

  /// Redirecting constructor: [previous] bloğunun ardına gelecek bloğu
  /// oluşturur. İndeks ve `previousHash` alanlarını kendisi doldurur.
  Block.next(
    Block<T> previous, {
    required List<T> transactions,
    required String authorityId,
    required DateTime timestamp,
  }) : this(
         index: previous.index + 1,
         previousHash: previous.hash,
         authorityId: authorityId,
         timestamp: timestamp,
         transactions: transactions,
       );

  /// Depodan okunan blok. Hash ve Merkle kökü *saklanan* değerlerdir;
  /// doğrulama bunları yeniden hesaplananlarla karşılaştırır.
  Block._restored({
    required super.index,
    required super.timestamp,
    required super.previousHash,
    required super.authorityId,
    required List<T> transactions,
    required this.merkleRoot,
    required Hash hash,
    this.signature,
  }) : transactions = List.unmodifiable(transactions),
       _storedHash = hash;

  /// Factory constructor: her cihazda aynı olan deterministik genesis bloğu.
  factory Block.genesis() => Block(
    index: 0,
    timestamp: genesisTime,
    previousHash: Hash.zero,
    authorityId: genesisAuthority,
    transactions: List<T>.empty(),
  );

  /// Factory constructor: JSON'dan blok çözer (bkz. `block_codec.dart`).
  factory Block.fromJson(Map<String, Object?> json, RecordDecoder<T> decode) =>
      _blockFromJson(json, decode);

  /// Genesis bloğunun sabit zamanı.
  static final DateTime genesisTime = DateTime.utc(2026, 9);

  /// Genesis bloğunun yetkili adı.
  static const String genesisAuthority = 'genesis';

  /// Bloktaki işlemler (değiştirilemez liste).
  final List<T> transactions;

  @override
  final Hash merkleRoot;

  @override
  final List<int>? signature;

  final Hash? _storedHash;

  late final Hash _computedHash = computeHash();

  @override
  Hash get hash => _storedHash ?? _computedHash;

  /// İmzalı kopyasını döndürür.
  Block<T> signedWith(List<int> signature) => Block._restored(
    index: index,
    timestamp: timestamp,
    previousHash: previousHash,
    authorityId: authorityId,
    transactions: transactions,
    merkleRoot: merkleRoot,
    hash: hash,
    signature: signature,
  );

  /// Alanları değiştirilmiş kopya. **Saklanan hash ve Merkle kökü korunur.**
  /// Bu, veritabanındaki bir kaydın elle değiştirilmesini birebir taklit
  /// eder; bu yüzden yalnızca kurcalama testlerinde kullanılır.
  @visibleForTesting
  Block<T> copyWith({
    List<T>? transactions,
    Hash? previousHash,
    DateTime? timestamp,
    String? authorityId,
    List<int>? signature,
  }) => Block._restored(
    index: index,
    timestamp: timestamp ?? this.timestamp,
    previousHash: previousHash ?? this.previousHash,
    authorityId: authorityId ?? this.authorityId,
    transactions: transactions ?? this.transactions,
    merkleRoot: merkleRoot,
    hash: hash,
    signature: signature ?? this.signature,
  );

  /// İşlemlerden yeniden hesaplanan Merkle kökü.
  Hash recomputeMerkleRoot() => MerkleTree.fromRecords(transactions).root;

  /// [recordHash] işleminin bu bloktaki konumu; yoksa -1.
  int indexOfRecord(Hash recordHash) =>
      transactions.indexWhere((t) => t.recordHash == recordHash);

  /// [recordHash] işlemi için Merkle kanıtı; işlem blokta yoksa `null`.
  MerkleProof? proofFor(Hash recordHash) {
    final i = indexOfRecord(recordHash);
    return i < 0 ? null : MerkleTree.fromRecords(transactions).proofFor(i);
  }

  /// JSON gösterimi (bkz. `block_codec.dart`).
  Map<String, Object?> toJson() => _blockToJson(this);

  @override
  bool operator ==(Object other) =>
      other is Block && other.hash == hash && other.index == index;

  @override
  int get hashCode => Object.hash(index, hash);

  @override
  String toString() =>
      'Block(#$index, ${hash.short}, ${transactions.length} işlem, '
      '${isSigned ? 'imzalı' : 'imzasız'})';
}
