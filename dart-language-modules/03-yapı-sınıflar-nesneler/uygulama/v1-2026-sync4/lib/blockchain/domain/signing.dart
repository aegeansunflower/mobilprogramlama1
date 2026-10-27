// DART KONUSU: Class modifiers — `abstract interface class` (imza
// sözleşmeleri), `final class` (Ed25519 uygulamaları). Libraries & imports —
// `as cg` (cryptography paketinin `Hash` / `Signature` adları bizimkilerle
// çakışır). Metadata — `@visibleForTesting`, `@override`.

/// Blok ve QR imzalama.
library;

import 'dart:convert' show base64Url;

import 'package:cryptography/cryptography.dart' as cg;
import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Blok/QR imzalayan yetkili (Proof of Authority düğümü).
abstract interface class BlockSigner {
  /// Yetkili kimliği (öğretim görevlisinin uid'i).
  String get authorityId;

  /// İmza algoritmasının adı.
  String get algorithm;

  /// Açık anahtar baytları. Firestore `authorities/{uid}` altına yazılır.
  Future<List<int>> publicKey();

  /// [message] baytlarını imzalar.
  Future<List<int>> sign(List<int> message);
}

/// İmza doğrulayıcı.
abstract interface class SignatureVerifier {
  /// Doğrulanan algoritmanın adı.
  String get algorithm;

  /// [signature] imzasının [message] için [publicKey] ile geçerli olup
  /// olmadığını döndürür.
  Future<bool> verify(
    List<int> message, {
    required List<int> signature,
    required List<int> publicKey,
  });
}

/// Ed25519 imzalayıcı. Özel anahtar tohumu (seed) [KeyValueStore] içinde,
/// gerçek cihazda Android Keystore / iOS Keychain'de saklanır.
///
/// `final class` seçildi: anahtar yönetimi alt sınıflarca değiştirilemez.
final class Ed25519Signer implements BlockSigner {
  Ed25519Signer._(this.authorityId, this._keyPair);

  /// Depoda anahtar varsa yükler, yoksa yeni anahtar üretip saklar.
  static Future<Ed25519Signer> loadOrCreate({
    required String authorityId,
    required KeyValueStore store,
  }) async {
    final key = storageKey(authorityId);
    final stored = await store.read(key);
    if (stored != null) {
      return await fromSeed(authorityId, base64Url.decode(stored));
    }
    final keyPair = await _algorithm.newKeyPair();
    final seed = await keyPair.extractPrivateKeyBytes();
    await store.write(key, base64Url.encode(seed));
    return Ed25519Signer._(authorityId, keyPair);
  }

  /// Bilinen tohumdan imzalayıcı oluşturur (deterministik testler için).
  @visibleForTesting
  static Future<Ed25519Signer> fromSeed(
    String authorityId,
    List<int> seed,
  ) async =>
      Ed25519Signer._(authorityId, await _algorithm.newKeyPairFromSeed(seed));

  /// Depodaki anahtar adı.
  static String storageKey(String authorityId) =>
      'poa.ed25519.seed.$authorityId';

  static final cg.Ed25519 _algorithm = cg.Ed25519();

  @override
  final String authorityId;

  final cg.SimpleKeyPair _keyPair;

  @override
  String get algorithm => 'Ed25519';

  @override
  Future<List<int>> publicKey() async =>
      (await _keyPair.extractPublicKey()).bytes;

  @override
  Future<List<int>> sign(List<int> message) async =>
      (await _algorithm.sign(message, keyPair: _keyPair)).bytes;
}

/// Ed25519 imza doğrulayıcı.
final class Ed25519Verifier implements SignatureVerifier {
  const Ed25519Verifier();

  @override
  String get algorithm => 'Ed25519';

  @override
  Future<bool> verify(
    List<int> message, {
    required List<int> signature,
    required List<int> publicKey,
  }) async {
    if (signature.length != 64 || publicKey.length != 32) return false;
    return await cg.Ed25519().verify(
      message,
      signature: cg.Signature(
        signature,
        publicKey: cg.SimplePublicKey(publicKey, type: cg.KeyPairType.ed25519),
      ),
    );
  }
}
