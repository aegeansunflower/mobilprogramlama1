// DART KONUSU: Libraries & imports — koşullu export'un web tarafı; `show`.

/// Tarayıcı: WebAssembly SQLite (`web/sqlite3.wasm`), bellek içi.
library;

import 'package:drift/drift.dart' show LazyDatabase, QueryExecutor;
import 'package:drift/wasm.dart' show WasmDatabase;
import 'package:sqlite3/wasm.dart' show InMemoryFileSystem, WasmSqlite3;

/// Her açılışta boş başlayan demo veritabanı. `sqlite3.wasm` ilk sorguda
/// yüklenir.
QueryExecutor openDemoDatabase() => LazyDatabase(() async {
  final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  sqlite3.registerVirtualFileSystem(InMemoryFileSystem(), makeDefault: true);
  return WasmDatabase.inMemory(sqlite3);
});
