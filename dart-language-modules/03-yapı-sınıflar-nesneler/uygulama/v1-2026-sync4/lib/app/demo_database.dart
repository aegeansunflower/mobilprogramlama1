// DART KONUSU: Libraries & imports — koşullu dışa aktarım (conditional
// export). Derleyici platforma göre iki uygulamadan birini seçer:
// mobil/masaüstünde `dart:ffi` tabanlı SQLite, tarayıcıda WebAssembly SQLite.

/// Demo modunun bellek içi zincir veritabanı.
library;

export 'demo_database_native.dart'
    if (dart.library.js_interop) 'demo_database_web.dart';
