import 'dart:convert';

import '../../data/local_storage_service.dart';
import '../models/focus_chain.dart';

/// FocusChain defterinin cihazdaki kalıcı kaydını yönetir.
class FocusChainRepository {
  /// Yerel depolama servisiyle repository oluşturur.
  FocusChainRepository(this._storage);

  /// Defterin saklandığı anahtar.
  static const String storageKey = 'focus_flow.chain.ledger.v1';

  final LocalStorageService _storage;

  /// Kayıtlı defteri okur; kayıt yoksa veya bozuksa `null` döner.
  FocusChain? loadChain() {
    final raw = _storage.read(storageKey);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return FocusChain.fromJson(decoded);
    } on FormatException {
      return null;
    }
  }

  /// Defteri JSON olarak cihaza yazar.
  Future<bool> saveChain(FocusChain chain) async {
    try {
      return await _storage.write(storageKey, jsonEncode(chain.toJson()));
    } on Object {
      return false;
    }
  }

  /// Kayıtlı defteri siler.
  Future<bool> clear() => _storage.remove(storageKey);
}
