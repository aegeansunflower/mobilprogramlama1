// DART KONUSU: Class modifiers — `abstract interface class` (generic depo
// sözleşmesi). Metadata — `@RoleRestricted`. Classes & objects — generics.

/// Zincir deposu sözleşmesi.
library;

import 'package:sarkisla_yoklama/blockchain/domain/block.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_receipt.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validation.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/blockchain/domain/signing.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Zincir nerede tutulursa tutulsun (yerel SQLite + Firestore, ya da ileride
/// Ethereum/Polygon akıllı sözleşmesi) uygulamanın kullandığı tek arayüz.
///
/// `abstract interface class` seçildi: ortak davranış yoktur ve uygulamalar
/// yalnızca `implements` ile yazılır. Sunum katmanı somut sınıfı hiç bilmez.
abstract interface class BlockchainRepository<T extends Record> {
  /// Yerel zincirdeki bloklar; her değişiklikte yeni liste yayınlar.
  Stream<List<Block<T>>> watchBlocks();

  /// Güncel bloklar.
  Future<List<Block<T>>> currentBlocks();

  /// Uzak zincirde olup yerelde olmayan blokları çeker. Eklenen blok
  /// sayısını döndürür.
  Future<Result<int>> sync();

  /// Kayıtları bloğa dönüştürür, imzalar ve hem yerel hem uzak zincire ekler.
  @RoleRestricted(Role.instructor)
  Future<Result<Block<T>>> appendBlock(
    List<T> transactions, {
    required BlockSigner signer,
    required Role actor,
  });

  /// Tüm zinciri doğrular.
  Future<ChainValidation> validate();

  /// [recordHash] kaydı için makbuz. Kayıt henüz bir bloğa girmediyse
  /// `null`.
  Future<ChainReceipt?> receiptFor(Hash recordHash);
}
