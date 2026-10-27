// DART KONUSU: Class modifiers — `abstract interface class` (konsensüs ve
// yetkili dizini sözleşmeleri), `final class` (Proof of Authority). Classes &
// objects — named constructor, initializer list, `Map.unmodifiable`.

/// Proof of Authority konsensüsü.
library;

import 'package:sarkisla_yoklama/blockchain/domain/block.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validation.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/blockchain/domain/signing.dart';

/// Bir bloğun zincire kabul edilip edilemeyeceğine karar veren kural.
///
/// İleride (ör. Ethereum testnet) farklı bir konsensüse geçilirse yalnızca bu
/// arayüzün yeni bir uygulaması yazılır.
abstract interface class ConsensusStrategy {
  /// Konsensüsün adı.
  String get name;

  /// Blok kabul edilebilirse `null`, değilse hata nedeni.
  Future<ChainBroken?> check(Block<Record> block);
}

/// Yetkili (öğretim görevlisi) açık anahtarlarının dizini.
abstract interface class AuthorityDirectory {
  /// [authorityId] yetkilisinin açık anahtarı; yetkili değilse `null`.
  Future<List<int>?> publicKeyOf(String authorityId);

  /// Yeni yetkili kaydeder (öğretim görevlisinin ilk girişi).
  Future<void> register(String authorityId, List<int> publicKey);
}

/// Bellek içi yetkili dizini (testler ve demo modu).
final class InMemoryAuthorityDirectory implements AuthorityDirectory {
  InMemoryAuthorityDirectory([Map<String, List<int>>? keys])
    : _keys = {...?keys};

  final Map<String, List<int>> _keys;

  @override
  Future<List<int>?> publicKeyOf(String authorityId) async =>
      _keys[authorityId];

  @override
  Future<void> register(String authorityId, List<int> publicKey) async =>
      _keys[authorityId] = List.unmodifiable(publicKey);
}

/// Proof of Authority: yalnızca dizinde kayıtlı yetkililerin imzaladığı
/// bloklar geçerlidir.
///
/// `final class` seçildi: konsensüs kuralı gevşetilmek üzere alt
/// sınıflanamaz.
final class ProofOfAuthority implements ConsensusStrategy {
  const ProofOfAuthority({
    required this.directory,
    this.verifier = const Ed25519Verifier(),
  });

  final AuthorityDirectory directory;
  final SignatureVerifier verifier;

  @override
  String get name => 'Proof of Authority (${verifier.algorithm})';

  @override
  Future<ChainBroken?> check(Block<Record> block) async {
    // Genesis imzasızdır; deterministik olduğu için ChainValidator ayrıca
    // denetler.
    if (block.isGenesis) return null;
    final key = await directory.publicKeyOf(block.authorityId);
    if (key == null) {
      return UnknownAuthority(block.index, authorityId: block.authorityId);
    }
    final valid = await block.verifySignature(verifier, key);
    if (valid) return null;
    return BadSignature(block.index, authorityId: block.authorityId);
  }
}
