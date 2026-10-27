// DART KONUSU: Libraries & imports — `as fs`, `show`. Class modifiers —
// `final class`. Classes & objects — private önbellek alanı.

/// Firestore'daki yetkili (öğretim görevlisi) açık anahtarları.
library;

import 'dart:convert' show base64Url;

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:sarkisla_yoklama/blockchain/domain/consensus.dart';

/// `authorities/{uid}` → `{publicKey: base64url, algorithm: "Ed25519"}`.
///
/// Güvenlik kuralları bir görevlinin yalnızca kendi belgesini, yalnızca bir
/// kez yazabilmesini sağlar. Anahtar değişikliği yöneticinin işidir.
final class FirestoreAuthorityDirectory implements AuthorityDirectory {
  FirestoreAuthorityDirectory([fs.FirebaseFirestore? db])
    : _db = db ?? fs.FirebaseFirestore.instance;

  final fs.FirebaseFirestore _db;
  final Map<String, List<int>> _cache = {};

  @override
  Future<List<int>?> publicKeyOf(String authorityId) async {
    if (_cache[authorityId] case final key?) return key;
    final doc = await _db.collection('authorities').doc(authorityId).get();
    final encoded = doc.data()?['publicKey'] as String?;
    if (encoded == null) return null;
    return _cache[authorityId] = base64Url.decode(encoded);
  }

  @override
  Future<void> register(String authorityId, List<int> publicKey) async {
    final ref = _db.collection('authorities').doc(authorityId);
    if ((await ref.get()).exists) return;
    await ref.set({
      'publicKey': base64Url.encode(publicKey),
      'algorithm': 'Ed25519',
    });
    _cache[authorityId] = publicKey;
  }
}
