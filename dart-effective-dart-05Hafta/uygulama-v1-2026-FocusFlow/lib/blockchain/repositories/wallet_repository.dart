import 'dart:convert';

import '../../data/local_storage_service.dart';
import '../models/wallet_account.dart';

/// Yerel cüzdanın cihazdaki kalıcı kaydını yönetir.
class WalletRepository {
  /// Yerel depolama servisiyle repository oluşturur.
  WalletRepository(this._storage);

  /// Cüzdanın saklandığı anahtar.
  static const String storageKey = 'focus_flow.chain.wallet.v1';

  final LocalStorageService _storage;

  /// Kayıtlı cüzdanı okur; kayıt yoksa veya bozuksa `null` döner.
  WalletAccount? loadWallet() {
    final raw = _storage.read(storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return WalletAccount.fromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  /// Cüzdanı JSON olarak cihaza yazar.
  Future<bool> saveWallet(WalletAccount wallet) async {
    try {
      return await _storage.write(storageKey, jsonEncode(wallet.toJson()));
    } on Object {
      return false;
    }
  }

  /// Kayıtlı cüzdanı siler.
  Future<bool> clear() => _storage.remove(storageKey);
}
