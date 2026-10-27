import '../models/chain_transaction.dart';
import 'canonical_json.dart';

/// İşlem kimliklerinden deterministik bir Merkle kökü üretir.
///
/// Blok hash'ine yalnızca tek bir kök değer girmesi, blok boyutu büyüse bile
/// doğrulama maliyetini ve blok başlığını sabit tutar.
abstract final class MerkleTree {
  /// Verilen işlemlerin Merkle kökünü döndürür.
  static String rootOf(Iterable<ChainTransaction> transactions) {
    final leaves = transactions.map((transaction) => transaction.id).toList();
    if (leaves.isEmpty) {
      return sha256Hex('');
    }

    var level = leaves;
    while (level.length > 1) {
      final next = <String>[];
      for (var index = 0; index < level.length; index += 2) {
        final left = level[index];
        final right = index + 1 < level.length ? level[index + 1] : left;
        next.add(sha256Hex('$left$right'));
      }
      level = next;
    }
    return level.single;
  }
}
