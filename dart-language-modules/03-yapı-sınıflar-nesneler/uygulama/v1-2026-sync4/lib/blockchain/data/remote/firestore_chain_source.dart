// DART KONUSU: Libraries & imports — `as fs` önekiyle içe aktarma (Firestore'un
// `Transaction` sınıfı web3dart'ın `Transaction` sınıfıyla çakışır). Class
// modifiers — `final class`.

/// Firestore üzerindeki paylaşılan zincir.
library;

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:sarkisla_yoklama/blockchain/data/remote/remote_chain_source.dart';

/// Firestore düzeni:
/// * `chain/meta`            → `{length: int, head: String}` (genesis dahil
///   uzunluk; genesis her cihazda üretildiği için saklanmaz, boş zincir = 1)
/// * `chain/meta/blocks/{i}` → blok JSON'u (belge kimliği sıfır dolgulu)
///
/// Güvenlik kuralları (`firestore.rules`) blokların yalnızca eklenebilmesini,
/// güncellenip silinememesini sağlar.
final class FirestoreChainSource implements RemoteChainSource {
  FirestoreChainSource([fs.FirebaseFirestore? firestore])
    : _db = firestore ?? fs.FirebaseFirestore.instance;

  final fs.FirebaseFirestore _db;

  fs.DocumentReference<Map<String, dynamic>> get _meta =>
      _db.collection('chain').doc('meta');

  fs.CollectionReference<Map<String, dynamic>> get _blocks =>
      _meta.collection('blocks');

  static String _docId(int index) => index.toString().padLeft(8, '0');

  @override
  Future<List<Map<String, Object?>>> fetchFrom(int fromIndex) async {
    final snap = await _blocks
        .where('index', isGreaterThanOrEqualTo: fromIndex)
        .orderBy('index')
        .get();
    return [for (final doc in snap.docs) doc.data()];
  }

  @override
  Future<bool> tryAppend(
    Map<String, Object?> blockJson, {
    required int expectedLength,
  }) => _db.runTransaction((tx) async {
    final meta = await tx.get(_meta);
    final length = (meta.data()?['length'] as int?) ?? 1;
    if (length != expectedLength) return false;
    tx
      ..set(_blocks.doc(_docId(expectedLength)), blockJson)
      ..set(_meta, {'length': expectedLength + 1, 'head': blockJson['hash']});
    return true;
  });

  @override
  Stream<int> watchLength() =>
      _meta.snapshots().map((s) => (s.data()?['length'] as int?) ?? 1);
}
