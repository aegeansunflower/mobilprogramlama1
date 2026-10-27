// DART KONUSU: Libraries & imports — koşullu export'un yerel (dart:ffi)
// tarafı; `show` ile seçici import.

/// Android, iOS ve masaüstü: bellek içi yerel SQLite.
library;

import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift/native.dart' show NativeDatabase;

/// Her açılışta boş başlayan demo veritabanı.
QueryExecutor openDemoDatabase() => NativeDatabase.memory();
