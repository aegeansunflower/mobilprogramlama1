import '../core/focus_chain_network.dart';
import '../utils/canonical_json.dart';
import '../utils/merkle_tree.dart';
import 'chain_transaction.dart';

/// FocusChain'deki değişmez bir blok.
///
/// Blok hash'i; indeks, zaman, önceki hash, Merkle kökü, nonce, zorluk ve
/// madenci adresinin kanonik JSON özetidir. Proof-of-work hedefi, hash'in
/// başında [difficulty] kadar sıfır bulunmasını gerektirir.
class ChainBlock {
  /// Var olan alanlardan blok oluşturur.
  const ChainBlock({
    required this.index,
    required this.timestamp,
    required this.transactions,
    required this.previousHash,
    required this.hash,
    required this.nonce,
    required this.difficulty,
    required this.minerAddress,
  });

  /// Blok zincirindeki sıra numarası; genesis bloğu sıfırdır.
  final int index;

  /// Bloğun üretilme zamanı (Unix milisaniye).
  final int timestamp;

  /// Blokta onaylanan işlemler.
  final List<ChainTransaction> transactions;

  /// Önceki bloğun hash'i.
  final String previousHash;

  /// Bu bloğun hesaplanmış hash'i.
  final String hash;

  /// Proof-of-work için denenmiş sayaç.
  final int nonce;

  /// Bloğun üretildiği andaki zorluk seviyesi.
  final int difficulty;

  /// Bloğu üreten düğümün cüzdan adresi.
  final String minerAddress;

  /// Bloktaki işlem sayısı.
  int get transactionCount => transactions.length;

  /// Blok zamanının yerel karşılığı.
  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();

  /// İşlemlerden hesaplanan Merkle kökü.
  String get merkleRoot => MerkleTree.rootOf(transactions);

  /// Proof-of-work hedefi.
  String get target => FocusChainNetwork.difficultyTarget(difficulty);

  /// Blok hash'ini yeniden hesaplar.
  String calculateHash() {
    return _calculateHash(
      index: index,
      timestamp: timestamp,
      previousHash: previousHash,
      merkleRoot: merkleRoot,
      nonce: nonce,
      difficulty: difficulty,
      minerAddress: minerAddress,
    );
  }

  /// Hash hem yeniden hesaplanan değere hem de zorluk hedefine uyuyor mu?
  bool get hasValidProof {
    final calculated = calculateHash();
    return calculated == hash && hash.startsWith(target);
  }

  /// Yeni bir bloğu proof-of-work ile üretir.
  static ChainBlock mine({
    required int index,
    required int timestamp,
    required List<ChainTransaction> transactions,
    required String previousHash,
    required int difficulty,
    required String minerAddress,
  }) {
    final merkleRoot = MerkleTree.rootOf(transactions);
    final target = FocusChainNetwork.difficultyTarget(difficulty);
    var nonce = 0;
    while (true) {
      final hash = _calculateHash(
        index: index,
        timestamp: timestamp,
        previousHash: previousHash,
        merkleRoot: merkleRoot,
        nonce: nonce,
        difficulty: difficulty,
        minerAddress: minerAddress,
      );
      if (hash.startsWith(target)) {
        return ChainBlock(
          index: index,
          timestamp: timestamp,
          transactions: List<ChainTransaction>.unmodifiable(transactions),
          previousHash: previousHash,
          hash: hash,
          nonce: nonce,
          difficulty: difficulty,
          minerAddress: minerAddress,
        );
      }
      nonce++;
    }
  }

  /// Blok alanlarını değiştirilmiş yeni bir kopya döndürür.
  ///
  /// Demo bütünlük testinde hash bilinçli olarak eski bırakılabilir.
  ChainBlock copyWith({
    int? index,
    int? timestamp,
    List<ChainTransaction>? transactions,
    String? previousHash,
    String? hash,
    int? nonce,
    int? difficulty,
    String? minerAddress,
  }) {
    return ChainBlock(
      index: index ?? this.index,
      timestamp: timestamp ?? this.timestamp,
      transactions: transactions ?? this.transactions,
      previousHash: previousHash ?? this.previousHash,
      hash: hash ?? this.hash,
      nonce: nonce ?? this.nonce,
      difficulty: difficulty ?? this.difficulty,
      minerAddress: minerAddress ?? this.minerAddress,
    );
  }

  /// Bloğu JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'index': index,
      'timestamp': timestamp,
      'transactions': transactions
          .map((transaction) => transaction.toJson())
          .toList(growable: false),
      'previousHash': previousHash,
      'hash': hash,
      'nonce': nonce,
      'difficulty': difficulty,
      'minerAddress': minerAddress,
    };
  }

  /// JSON'dan blok üretir; zorunlu alanlar geçersizse reddeder.
  factory ChainBlock.fromJson(Map<String, dynamic> json) {
    final index = json['index'];
    final timestamp = json['timestamp'];
    final previousHash = json['previousHash'];
    final hash = json['hash'];
    final nonce = json['nonce'];
    final difficulty = json['difficulty'];
    final minerAddress = json['minerAddress'];
    final transactionsRaw = json['transactions'];

    if (index is! int || index < 0) {
      throw const FormatException('Blok indeksi geçersiz.');
    }
    if (timestamp is! int || timestamp <= 0) {
      throw const FormatException('Blok zamanı geçersiz.');
    }
    if (previousHash is! String || previousHash.length != 64) {
      throw const FormatException('Önceki blok hash değeri geçersiz.');
    }
    if (hash is! String || hash.length != 64) {
      throw const FormatException('Blok hash değeri geçersiz.');
    }
    if (nonce is! int || nonce < 0) {
      throw const FormatException('Blok nonce değeri geçersiz.');
    }
    if (difficulty is! int || difficulty < 0) {
      throw const FormatException('Blok zorluğu geçersiz.');
    }
    if (minerAddress is! String || minerAddress.trim().isEmpty) {
      throw const FormatException('Madenci adresi geçersiz.');
    }
    if (transactionsRaw is! List<dynamic>) {
      throw const FormatException('Blok işlem listesi geçersiz.');
    }

    final transactions = <ChainTransaction>[];
    for (final item in transactionsRaw) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Blok işlemi geçersiz.');
      }
      transactions.add(ChainTransaction.fromJson(item));
    }

    return ChainBlock(
      index: index,
      timestamp: timestamp,
      transactions: List<ChainTransaction>.unmodifiable(transactions),
      previousHash: previousHash,
      hash: hash,
      nonce: nonce,
      difficulty: difficulty,
      minerAddress: minerAddress,
    );
  }

  static String _calculateHash({
    required int index,
    required int timestamp,
    required String previousHash,
    required String merkleRoot,
    required int nonce,
    required int difficulty,
    required String minerAddress,
  }) {
    final payload = <String, Object?>{
      'index': index,
      'timestamp': timestamp,
      'previousHash': previousHash,
      'merkleRoot': merkleRoot,
      'nonce': nonce,
      'difficulty': difficulty,
      'minerAddress': minerAddress,
    };
    return sha256Hex(canonicalJsonEncode(payload));
  }
}
