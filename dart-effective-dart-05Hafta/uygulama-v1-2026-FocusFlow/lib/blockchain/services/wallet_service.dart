import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:cryptography/cryptography.dart';

import '../core/focus_chain_network.dart';
import '../models/wallet_account.dart';
import '../repositories/wallet_repository.dart';

/// Ed25519 anahtar üretimi, adres türetme ve imza işlemlerini yönetir.
class WalletService {
  /// Cüzdan deposuyla servisi oluşturur.
  const WalletService(this._repository);

  final WalletRepository _repository;

  static final Ed25519 _algorithm = Ed25519();

  /// Kayıtlı cüzdanı yükler; yoksa güvenli rastgele yeni bir cüzdan üretir.
  Future<WalletAccount> loadOrCreate() async {
    final existing = _repository.loadWallet();
    if (existing != null) {
      return existing;
    }

    final wallet = await createWallet();
    await _repository.saveWallet(wallet);
    return wallet;
  }

  /// Yeni bir Ed25519 cüzdanı üretir.
  Future<WalletAccount> createWallet() async {
    final keyPair = await _algorithm.newKeyPair();
    final privateKey = await keyPair.extractPrivateKeyBytes();
    final publicKey = await keyPair.extractPublicKey();
    final address = addressFromPublicKey(publicKey.bytes);

    return WalletAccount(
      address: address,
      publicKey: base64Encode(publicKey.bytes),
      privateKey: base64Encode(privateKey),
    );
  }

  /// Açık anahtarın SHA-256 özetinden `0x` önekli 20 baytlık adres türetir.
  static String addressFromPublicKey(List<int> publicKeyBytes) {
    final digest = crypto.sha256.convert(publicKeyBytes).bytes;
    final addressBytes = digest.take(20);
    final hex = addressBytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '0x$hex';
  }

  /// Verilen metni cüzdanın özel anahtarıyla imzalar.
  Future<String> sign({
    required WalletAccount wallet,
    required String payload,
  }) async {
    final keyPair = await _algorithm.newKeyPairFromSeed(
      base64Decode(wallet.privateKey),
    );
    final signature = await _algorithm.sign(
      utf8.encode(payload),
      keyPair: keyPair,
    );
    return base64Encode(signature.bytes);
  }

  /// İmzayı açık anahtarla doğrular.
  Future<bool> verify({
    required String payload,
    required String signature,
    required String publicKey,
  }) async {
    try {
      final publicKeyBytes = base64Decode(publicKey);
      final signatureBytes = base64Decode(signature);
      if (publicKeyBytes.length != 32 || signatureBytes.length != 64) {
        return false;
      }
      final simplePublicKey = SimplePublicKey(
        publicKeyBytes,
        type: KeyPairType.ed25519,
      );
      return await _algorithm.verify(
        utf8.encode(payload),
        signature: Signature(signatureBytes, publicKey: simplePublicKey),
      );
    } on FormatException {
      return false;
    } on Object {
      return false;
    }
  }

  /// Adresin geçerli bir yerel cüzdan adresi olup olmadığını döndürür.
  static bool isValidAddress(String address) {
    return FocusChainNetwork.isValidUserAddress(address);
  }
}
