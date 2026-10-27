import 'package:flutter_test/flutter_test.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';

void main() {
  group('Hash', () {
    test('SHA-256 bilinen test vektörü', () {
      expect(
        Hash.ofString('abc').hex,
        'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad',
      );
    });

    test('fromHex biçimi doğrular ve küçük harfe çevirir', () {
      final upper = 'A' * 64;
      expect(Hash.fromHex(upper).hex, 'a' * 64);
      expect(() => Hash.fromHex('xyz'), throwsFormatException);
    });

    test('değer eşitliği ve hashCode', () {
      expect(Hash.ofString('x'), Hash.ofString('x'));
      expect({Hash.ofString('x'), Hash.ofString('x')}, hasLength(1));
      expect(Hash.zero.hex, '0' * 64);
    });
  });

  group('canonicalJson', () {
    test('anahtar sırasından bağımsızdır', () {
      expect(
        canonicalJson({
          'b': 1,
          'a': {'d': 2, 'c': 3},
        }),
        canonicalJson({
          'a': {'c': 3, 'd': 2},
          'b': 1,
        }),
      );
    });
  });

  group('MerkleTree', () {
    final leaves = [for (var i = 0; i < 7; i++) Hash.ofString('tx$i')];

    test('boş ağaç sabit köke sahiptir', () {
      expect(MerkleTree(const []).root, MerkleTree.emptyRoot);
    });

    test('her yaprak için kanıt köke ulaşır (tek sayıda yaprak dahil)', () {
      final tree = MerkleTree(leaves);
      for (var i = 0; i < leaves.length; i++) {
        expect(
          MerkleTree.verify(leaves[i], tree.proofFor(i), tree.root),
          isTrue,
          reason: 'yaprak $i',
        );
      }
    });

    test('yanlış yaprak ya da kök ile kanıt reddedilir', () {
      final tree = MerkleTree(leaves);
      final proof = tree.proofFor(2);
      expect(MerkleTree.verify(leaves[3], proof, tree.root), isFalse);
      expect(MerkleTree.verify(leaves[2], proof, Hash.zero), isFalse);
    });

    test('kanıt JSON gidiş-dönüşü', () {
      final tree = MerkleTree(leaves);
      final proof = MerkleProof.fromJson(tree.proofFor(5).toJson());
      expect(MerkleTree.verify(leaves[5], proof, tree.root), isTrue);
    });

    test('yaprak sırası kökü değiştirir', () {
      expect(
        MerkleTree(leaves).root,
        isNot(MerkleTree(leaves.reversed.toList()).root),
      );
    });
  });
}
