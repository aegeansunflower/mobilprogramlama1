# 📱 Dart Core Libraries Mobil Uygulaması — kamp Takımı

SCÜ Şarkışla UBYO | Bilişim Sistemleri ve Teknolojileri Bölümü  
**Mobil Programlama I · 5. Takım (kamp)**  
**Öğrenciler:** Uğurhan Çolak, Arif Kaan Bolel, Efe Genç  
**Konu:** Dart Core Libraries (`dart:core`, `dart:async`, `dart:math`, `dart:convert`, `dart:io`)

---

## 🎯 Proje Hakkında

Bu mobil uygulama, **Dart Core Kütüphaneleri** konusunun pratik ve görsel bir simülasyonunu sunmak üzere Flutter ve Dart 3 ile geliştirilmiştir. Uygulama içerisinde Dart çekirdek kütüphanelerinin sunduğu temel yetenekler reaktif ve modern bir arayüz üzerinde gösterilmektedir.

### 🧩 Kullanılan Dart Core Kütüphaneleri ve İşlevleri

1. **`dart:async` (Asenkron Programlama & Reaktivite):**
   - `Future`, `Stream`, `StreamController` ve `StreamSubscription` kullanılarak canlı veri akışları, zamanlayıcılar ve asenkron işlemler yönetilir.
   - Olay dinleyicileri (event listeners) ile eşzamanlı veri akışı simüle edilir.

2. **`dart:convert` (Veri Kodlama ve Kod Çözme):**
   - `jsonEncode` ve `jsonDecode` kullanılarak JSON veri formatı dönüşümleri gerçekleştirilir.
   - `utf8` ve string kodlayıcı/kod çözücüler ile metin manipülasyonu yapılır.

3. **`dart:math` (Matematiksel Fonksiyonlar & Rastgelelik):**
   - `Random`, `Random.secure()`, `max`, `min`, `sin`, `cos` ve matematiksel sabitler (`pi`, `e`) kullanılarak dinamik hesaplamalar ve rastgele anahtar/değer üretimi sağlanır.

4. **`dart:io` (I/O & Sistem İşlemleri):**
   - `File`, `Directory` ve I/O stream'leri ile dosya ve sistem düzeyinde veri akış senaryoları desteklenir.

5. **`dart:core` (Temel Tipler ve Koleksiyonlar):**
   - `List`, `Map`, `Set`, `Iterable` tembel değerlendirme (`map()`, `where()`, `toList()`), `DateTime`, `Duration`, `Uri` ve `StringBuffer` API'leri aktif olarak kullanılır.

---

## 🚀 Kurulum ve Çalıştırma

Projeyi bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyebilirsiniz:

### 1. Bağımlılıkları İndirin
```bash
flutter pub get
```

### 2. Uygulamayı Başlatın
```bash
# Chrome / Web üzerinde çalıştırmak için:
flutter run -d chrome

# Android cihaz/emülatör için:
flutter run -d android

# macOS masaüstü için:
flutter run -d macos
```

---

## 📂 Dizin Yapısı
```
v1-2026-kamp/
├── lib/
│   ├── main.dart       # Siber Kasa / Core Libraries uygulama girişi
│   └── main1.dart      # ChainPulse Mobile & Akıllı Telefon Çerçeve Simülatörü
├── pubspec.yaml        # Flutter bağımlılıkları ve konfigürasyonu
└── README.md           # Bu dokümantasyon
```
