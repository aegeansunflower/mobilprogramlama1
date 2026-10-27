// DART KONUSU: Libraries & imports — `part` (drift'in ürettiği
// `chain_database.g.dart`), `show`. Metadata — `@DriftDatabase` (paket
// annotation'ı), `@override`. Classes & objects — named / factory
// constructor.

/// Zincirin cihazdaki SQLite kopyası (drift).
library;

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart' show driftDatabase;

part 'chain_database.g.dart';

/// Blok tablosu. Blok, saklanan hash'i dahil tam JSON olarak tutulur; böylece
/// doğrulama, depodaki değerleri yeniden hesaplananlarla karşılaştırabilir.
@DataClassName('StoredBlock')
class StoredBlocks extends Table {
  IntColumn get blockIndex => integer()();
  TextColumn get hash => text()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {blockIndex};
}

/// Zincir veritabanı.
@DriftDatabase(tables: [StoredBlocks])
class ChainDatabase extends _$ChainDatabase {
  ChainDatabase(super.e);

  /// Cihazdaki kalıcı veritabanı.
  factory ChainDatabase.onDevice() =>
      ChainDatabase(driftDatabase(name: 'yoklama_chain'));

  @override
  int get schemaVersion => 1;

  /// Tüm bloklar, indeks sırasıyla.
  Future<List<StoredBlock>> allBlocks() => (select(
    storedBlocks,
  )..orderBy([(t) => OrderingTerm.asc(t.blockIndex)])).get();

  /// Bloklardaki her değişiklikte yeni liste yayınlar.
  Stream<List<StoredBlock>> watchAll() => (select(
    storedBlocks,
  )..orderBy([(t) => OrderingTerm.asc(t.blockIndex)])).watch();

  /// Blok ekler. Aynı indeksle ikinci kez yazmak hata verir (append-only).
  Future<void> insertBlock(int index, String hash, String json) =>
      into(storedBlocks).insert(
        StoredBlocksCompanion.insert(
          blockIndex: Value(index),
          hash: hash,
          json: json,
        ),
      );

  /// **Yalnızca demo / test:** bir bloğun JSON'unu doğrudan değiştirir.
  /// Zincire müdahale eden bir saldırganı taklit eder.
  Future<void> overwriteJson(int index, String json) =>
      (update(storedBlocks)..where((t) => t.blockIndex.equals(index))).write(
        StoredBlocksCompanion(json: Value(json)),
      );
}
