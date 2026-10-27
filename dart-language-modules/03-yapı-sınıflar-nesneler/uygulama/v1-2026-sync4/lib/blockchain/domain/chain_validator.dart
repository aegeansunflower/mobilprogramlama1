// DART KONUSU: Classes & objects — callable class (`call` metodu sayesinde
// `validator(blocks)` yazılabilir), const constructor. Class modifiers —
// `final class`.

/// Tüm zinciri baştan sona doğrulayan kural seti.
library;

import 'package:sarkisla_yoklama/blockchain/domain/block.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validation.dart';
import 'package:sarkisla_yoklama/blockchain/domain/consensus.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';

/// Zincir doğrulayıcı.
///
/// Her blok için sırayla şunları denetler: indeks → Merkle kökü → blok hash'i
/// → genesis/bağlantı → zaman → konsensüs (imza). Bozulan **ilk** bloğu
/// döndürür. Kurcalama ekranı bu sonuçla bozulmanın tam yerini gösterir.
final class ChainValidator {
  const ChainValidator(this.consensus);

  final ConsensusStrategy consensus;

  /// Callable class: `await validator(blocks)`.
  Future<ChainValidation> call(List<Block<Record>> blocks) async {
    if (blocks.isEmpty) return const InvalidGenesis();
    final genesisHash = Block<Record>.genesis().hash;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block.index != i) return IndexGap(i, actual: block.index);

      final merkle = block.recomputeMerkleRoot();
      if (merkle != block.merkleRoot) {
        return MerkleMismatch(i, stored: block.merkleRoot, computed: merkle);
      }

      final computed = block.computeHash();
      if (computed != block.hash) {
        return HashMismatch(i, stored: block.hash, computed: computed);
      }

      if (i == 0) {
        if (block.hash != genesisHash) return const InvalidGenesis();
        continue;
      }

      final previous = blocks[i - 1];
      if (block.previousHash != previous.hash) {
        return BrokenLink(
          i,
          expected: previous.hash,
          actual: block.previousHash,
        );
      }
      if (block.timestamp.isBefore(previous.timestamp)) {
        return TimestampRegression(i);
      }

      final issue = await consensus.check(block);
      if (issue != null) return issue;
    }
    return ChainValid(length: blocks.length, head: blocks.last.hash);
  }
}
