# 🏛️ Şarkışla Yoklama — Blockchain Tabanlı Dijital Yoklama Sistemi

[![Flutter](https://img.shields.io/badge/Flutter-3.47%2B-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20Local--First-green.svg)](#-proje-mimarisi)
[![Consensus](https://img.shields.io/badge/Consensus-Proof%20of%20Authority-orange.svg)](#-blok-yaşam-döngüsü-ve-konsensüs)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Sivas Cumhuriyet Üniversitesi **Şarkışla Uygulamalı Bilimler Yüksekokulu** için geliştirilmiş; **Bilişim Sistemleri ve Teknolojileri** ile **Yapay Zeka ve Makine Öğrenmesi** bölümlerinde kullanılan **blockchain tabanlı, hile korumalı, dijital yoklama sistemi** (Flutter / Dart 3).

Geleneksel imza föylerinin kaybolma, mükerrer imza atılma ve sonradan usulsüz tahrif edilme risklerini tamamen ortadan kaldırır. Yoklama kayıtları, yetkili öğretim görevlilerinin **Ed25519 kriptografik anahtarlarıyla** dijital olarak imzalanır; **Proof of Authority (PoA)** konsensüsüyle yalnızca eklenebilir (**append-only**) yerel ve bulut zincirlerine işlenir.

> 💡 **Dart 3 Akademik İnceleme Notu:** Kod tabanının Dart dokümantasyonundaki 4 ana başlığı (*Metadata, Libraries & imports, Classes & objects, Class modifiers*) nerede ve nasıl uyguladığının detaylı dökümü [DART_KONULARI.md](DART_KONULARI.md) dosyasında incelenebilir.

---

## 📋 İçindekiler
- [Proje Genel Bakışı ve Temel Yetenekler](#-proje-genel-bakışı)
- [Hile ve Suistimal Önleme Mimarisi](#-hile-ve-suistimal-önleme-mekanizması)
- [Blok Yaşam Döngüsü ve Konsensüs](#-blok-yaşam-döngüsü-ve-konsensüs)
- [Detaylı Dosya ve Proje Dizin Mimarisi](#-detaylı-dosya-ve-proje-mimarisi)
- [Kurulum ve Çalıştırma Rehberi](#-kurulum-ve-çalıştırma-rehberi)
  - [Gereksinimler](#gereksinimler)
  - [1. Bağımlılıklar ve Kod Üretimi](#1-bağımlılıklar-ve-kod-üretimi)
  - [2. Demo Modunda Çalıştırma (Hızlı Başlangıç)](#2-demo-modunda-çalıştırma-firebase-gerekmez)
  - [3. Web Tarayıcısında ve Yerel Ağda Çalıştırma](#3-web-tarayıcısında-ve-yerel-ağda-çalıştırma-web_acbat)
  - [4. Firebase Canlı Modunda Çalıştırma](#4-firebase-canlı-modunda-çalıştırma)
- [Hazır Demo Hesapları](#-hazır-demo-hesapları)
- [Mobil Dağıtım ve Derleme (APK & iOS IPA)](#-mobil-dağıtım-ve-derleme)
- [Test ve Kod Kalitesi](#-test-ve-kod-kalitesi)
- [Tasarım Sistemi ve Erişilebilirlik](#-tasarım-sistemi-ve-erişilebilirlik)

---

## 🌟 Proje Genel Bakışı

Uygulama, rol tabanlı yetkilendirme ile öğretim görevlileri ve öğrenciler için iki ana modül sunar:

| Öğretim Görevlisi | Öğrenci |
|---|---|
| 🔐 E-posta + şifre veya biyometrik (parmak izi/FaceID) giriş | 🎓 Okul numarası + şifre / biyometrik giriş |
| 📚 Bölüm bazlı ders seçimi ve oturum yönetimi | 📊 Kayıtlı dersler, devam yüzdesi, kalan devamsızlık hakkı |
| ⏱️ 15 saniyede bir dönen, Ed25519 imzalı dinamik QR üretimi | 📷 Dahili kamera ile dinamik QR tarama ve anlık geri bildirim |
| 👥 Canlı katılımcı akış paneli ve anlık onaylama | 🧾 Kriptografik işlem hash'i ve blok makbuzu |
| 🛑 Oturumu sonlandırma: kayıtları blok zincirine mühürleme | 🛡️ Oturum kapandığında Merkle kanıtı ile **Doğrulandı ✓** rozeti |
| ✏️ Düzeltme bloğu ekleme (asla geçmiş kayıt değiştirilmez) | ⚠️ Devamsızlık sınırı yaklaşınca otomatik görsel uyarılar |
| 🔍 Blok zinciri gezgini ve simüle edilmiş kurcalama tespiti | 📜 Tüm dönem boyunca değişmez yoklama geçmişi dökümü |
| 📈 PDF ve CSV formatında kurumsal devam raporları | 📱 Tek cihaz eşleştirme güvenliği |

---

## 🛡️ Hile ve Suistimal Önleme Mekanizması

Sistem, yoklamaların sınıf dışından veya başkası yerine verilmesini engellemek için çok katmanlı güvenlik doğrulamaları uygular:

1. **Dinamik ve Kriptografik QR:** QR kodu her 15 saniyede bir yeni bir tek kullanımlık rastgele sayı (`nonce`) ve zaman damgasıyla yenilenir. QR içeriği görevlinin özel anahtarıyla imzalanır (`SYQ2.<yük>.<imza>`). Fotoğrafı çekilip arkadaşa gönderilen QR'lar saniyeler içinde geçersiz olur.
2. **Tek Cihaz Eşleşmesi (Hardware Binding):** Öğrenci hesabı giriş yapılan ilk donanım kimliği (UUID/Hardware ID) ile kilitlenir. Bir öğrenci, başka bir arkadaşının telefonu üzerinden kendi hesabına yoklama giremez.
3. **Mükerrer Yoklama Engeli:** Aynı oturumda bir öğrenci yalnızca tek bir işlem hash'i alabilir; sistem çift kaydı reddeder.
4. **Coğrafi Konum Doğrulaması (Geofencing):** İsteğe bağlı olarak, öğrencinin cihaz konumu ile Şarkışla Kampüsü koordinatları arasındaki mesafe denetlenir.
5. **Kayıt Değiştirilemezliği (Tamper Evident):** Herhangi bir veri tabanı yöneticisi veya saldırgan SQLite ya da Firestore'daki eski bir kaydı değiştirirse, zincirdeki SHA-256 hash'leri ve Merkle kökleri uyuşmaz. Gezgin ekranı bozulmanın **hangi blokta ve ne sebeple** gerçekleştiğini kırmızı alarm ile gösterir.

---

## ⛓️ Blok Yaşam Döngüsü ve Konsensüs

```
[Görevli Oturumu Başlatır] 
       │
       ▼
[Dinamik QR Üretimi] ──(15 sn Nonce & Ed25519 İmza)──► [Öğrenci QR'ı Tarar]
                                                               │
                                                               ▼
                                                    [İmza, Cihaz, Konum Kontrolü]
                                                               │
                                                               ▼
                                                    [Öğrenciye İşlem Hash'i Verilir]
                                                               │
[Görevli Oturumu Kapatır] ◄────────────────────────────────────┘
       │
       ▼
[Tüm Katılımcılar + Devamsızlar Derlenir]
       │
       ▼
[Merkle Ağacı İnşa Edilir (Merkle Root)]
       │
       ▼
[Blok Başlığı Oluşturulur & Görevli İmzalar]
       │
       ▼
[Local Drift SQLite + Firestore Senkronu + (Opsiyonel) Polygon Testnet Çapası]
       │
       ▼
[Öğrenci Cihazında Merkle Kanıtı Doğrulanır: "Doğrulandı ✓"]
```

- **Proof of Authority (PoA):** Yalnızca yetkilendirilmiş öğretim görevlileri (`AuthorityDirectory`) blok mühürleyebilir.
- **İyimser Kilitleme (Optimistic Locking):** İki öğretim görevlisi aynı anda blok eklediğinde zincir çatallanmaz; versiyon kontrolü devreye girer.
- **Düzeltme Blokları:** Yanlışlıkla devamsız yazılan bir öğrenci için eski blok değiştirilmez; geriye dönük referans veren bir `CorrectionRecord` içeren yeni bir blok eklenir.

---

## 📁 Detaylı Dosya ve Proje Mimarisi

Proje, **Clean Architecture** (Temiz Mimari) prensiplerine göre katmanlandırılmış olup katmanlar arası bağımlılıklar kesin kurallarla ayrılmıştır:
- `domain`: Saf Dart iş kuralları, sözleşmeler ve değişmez veri modelleri (UI ve veri tabanından tamamen bağımsızdır).
- `data`: SQLite (Drift), Firebase Firestore, Web3/Ethereum entegrasyonları.
- `presentation`: Flutter arayüzleri, Riverpod sağlayıcıları ve görsel bileşenler.

```
sarkisla_yoklama/
├── .github/workflows/
│   └── ios-ipa.yml                  # Bulut Mac üzerinden imzasız iOS IPA derleme CI iş akışı
├── assets/
│   ├── fonts/                       # Lisanslı yazı tipleri (Inter, Newsreader, Fira Code)
│   └── images/                      # Okul logosu ve kampüs arka plan görselleri
├── contracts/
│   └── AttendanceLedger.sol         # Ethereum/Polygon EVM blok hash'i çapalama akıllı sözleşmesi
├── firestore.rules                  # Firebase Firestore rol ve zincir güvenlik kuralları
├── lib/
│   ├── main.dart                    # Uygulama giriş noktası (Config, Riverpod Scope, Localizations)
│   │
│   ├── app/                         # Uygulama geneli yapılandırma ve yönlendirme
│   │   ├── app.dart                 # Ana MaterialApp widget'ı, tema ve l10n bağlayıcıları
│   │   ├── config.dart              # Demo / Firebase ortam bayrakları
│   │   ├── demo_database.dart       # Platforma duyarlı SQLite export yöneticisi
│   │   ├── demo_database_native.dart# Masaüstü/Mobil yerel SQLite sürücüsü
│   │   ├── demo_database_web.dart   # Tarayıcı için WebAssembly SQLite (sqlite3.wasm) sürücüsü
│   │   ├── demo_seed.dart           # Önceden yüklenmiş hiyerarşik demo ders ve kullanıcı verileri
│   │   ├── providers.dart           # Uygulama düzeyi Riverpod DI konteyneri
│   │   └── router.dart              # go_router rol tabanlı sayfa korumaları ve deferred loading
│   │
│   ├── core/                        # Çekirdek yardımcılar, kriptografi ve sözleşmeler
│   │   ├── core.dart                # Core katmanı için barrel export dosyası
│   │   ├── annotations/             # Özel kaynak kod denetim annotation'ları
│   │   │   ├── on_chain_record.dart # @OnChainRecord (zincir modelleri için)
│   │   │   └── role_restricted.dart # @RoleRestricted (rol kısıtlamalı metotlar için)
│   │   ├── constants/               # Sabitler ve gelişmiş enum'lar
│   │   │   ├── department.dart      # Bölümler (BST, YZMO)
│   │   │   └── role.dart            # Kullanıcı rolleri (Instructor, Student)
│   │   ├── crypto/                  # Kriptografik işlemler
│   │   │   ├── canonical_json.dart  # Deterministik JSON sıralama (SHA-256 kararlılığı için)
│   │   │   ├── hash.dart            # Değişmez SHA-256 değer nesnesi
│   │   │   └── hashable.dart        # İçerik hash'i üreten mixin
│   │   ├── errors/                  # Hata yönetimi
│   │   │   └── failure.dart         # Sealed sınıf hiyerarşisiyle Failure türleri
│   │   ├── extensions/              # Extension metotları
│   │   │   ├── date_time_x.dart     # Zaman damgası ve Türkçe tarih biçimlendiricileri
│   │   │   └── string_x.dart        # SHA-256, hash kısaltma ve öğrenci no doğrulama
│   │   ├── mixins/                  # Ortak davranış sınıfları
│   │   │   ├── event_emitter.dart   # Olay dinleyici altyapısı
│   │   │   └── timestamped.dart     # Zaman damgalı kayıt desteği
│   │   ├── platform/                # Platform soyutlamaları
│   │   │   ├── clock.dart           # Test edilebilir saat arayüzü
│   │   │   └── key_value_store.dart # Güvenli yerel anahtar-değer deposu
│   │   └── result/                  # Fonksiyonel hata modeli
│   │       └── result.dart          # Result<T> sealed sınıfı (Ok / Err)
│   │
│   ├── blockchain/                  # Blockchain çekirdeği ve veri katmanı
│   │   ├── blockchain.dart          # Blockchain katmanı barrel export'u
│   │   ├── domain/                  # Saf Dart blockchain modelleri
│   │   │   ├── block.dart           # Final Block sınıfı, başlık, mühür ve hash kontrolü
│   │   │   ├── block_base.dart      # Base BlockBase sınıfı ve Signed mixin'i
│   │   │   ├── block_codec.dart     # Blok JSON serileştirme/ayrıştırma
│   │   │   ├── blockchain.dart      # Bellek içi zincir yöneticisi ve olay yayımı
│   │   │   ├── blockchain_repository.dart # Depo soyutlama arayüzü
│   │   │   ├── chain_receipt.dart   # Makbuz ve Merkle kanıtı taşıyıcısı
│   │   │   ├── chain_validation.dart# Doğrulama sonuçları (ChainValid / ChainBroken türleri)
│   │   │   ├── chain_validator.dart # Blok blok bütünlük ve imza denetleyici callable class
│   │   │   ├── consensus.dart       # Proof of Authority stratejisi
│   │   │   ├── merkle_tree.dart     # Merkle ağacı inşası, kök hash ve kanıt (proof) üretimi
│   │   │   ├── record.dart          # Zincire yazılabilecek kayıtların temel soyut sınıfı
│   │   │   └── signing.dart         # Ed25519 imzalama ve doğrulama motoru
│   │   └── data/                    # Blok kayıt depoları
│   │       ├── local/
│   │       │   ├── chain_database.dart   # Drift (SQLite) veritabanı şeması ve DAO
│   │       │   └── chain_database.g.dart # Drift tarafından üretilen kod
│   │       ├── remote/              # Bulut senkronizasyonu
│   │       │   ├── firestore_authority_directory.dart # Yetkili görevli anahtar dizini
│   │       │   ├── firestore_chain_source.dart        # Firestore blok okuma/yazma
│   │       │   └── remote_chain_source.dart           # Uzak kaynak sözleşmesi
│   │       ├── web3/
│   │       │   └── ethereum_anchored_repository.dart  # Polygon testnet çapalama servisi
│   │       └── local_first_blockchain_repository.dart # SQLite + Cloud hibrit depo yöneticisi
│   │
│   ├── auth/                        # Kimlik doğrulama katmanı
│   │   ├── auth.dart                # Kimlik doğrulama barrel export'u
│   │   ├── domain/
│   │   │   ├── app_user.dart        # AppUser (Instructor ve Student modelleri)
│   │   │   ├── auth_services.dart   # AuthRepository, Biometric ve Cihaz kimliği sözleşmeleri
│   │   │   └── auth_state.dart      # Sealed kimlik doğrulama durumları
│   │   ├── data/
│   │   │   ├── biometric_authenticator.dart  # Parmak izi / Yüz tanıma entegrasyonu
│   │   │   ├── demo_auth_repository.dart     # Çevrimdışı hazır demo kullanıcı sağlayıcısı
│   │   │   ├── device_identity.dart          # Donanım kimliği (UUID) bağlama
│   │   │   └── firebase_auth_repository.dart # Firebase Authentication adaptörü
│   │   └── presentation/
│   │       ├── auth_controller.dart # Giriş/çıkış kontrolcüsü (Riverpod)
│   │       ├── auth_shell.dart      # Dinamik oturum kabuğu
│   │       ├── login_page.dart      # İki bölümlü responsive giriş sayfası
│   │       └── role_select_page.dart# Hızlı rol/hesap seçim ekranı
│   │
│   ├── attendance/                  # Yoklama iş mantığı ve ekranları
│   │   ├── attendance.dart          # Yoklama modülü barrel export'u
│   │   ├── domain/
│   │   │   ├── attendance_ledger.dart     # Yoklama defteri hesaplama extension'ları
│   │   │   ├── attendance_record.dart     # Tekil yoklama kaydı (@OnChainRecord)
│   │   │   ├── attendance_repository.dart # Yoklama depo sözleşmesi
│   │   │   ├── attendance_session.dart    # Aktif yoklama oturumu nesnesi
│   │   │   ├── attendance_status.dart     # Sealed katılım durumları (Present, Late, Absent, Excused)
│   │   │   ├── correction_record.dart     # Düzeltme kaydı modeli (@OnChainRecord)
│   │   │   ├── course.dart                # Ders bilgisi modeli
│   │   │   ├── geofence.dart              # Kampüs coğrafi sınır hesaplama
│   │   │   ├── qr_token.dart              # İmzalı dinamik QR ayrıştırıcı ve doğrulayıcı
│   │   │   └── usecases/                  # Kullanım senaryoları (Use Cases)
│   │   │       ├── check_in.dart          # Öğrenci QR tarama ve yoklama gönderme
│   │   │       ├── correct_attendance.dart# Görevli düzeltme işlemi
│   │   │       └── end_session.dart       # Oturumu kapatıp blok mühürleme
│   │   ├── data/
│   │   │   ├── demo_attendance_repository.dart      # Çevrimdışı demo oturum sağlayıcısı
│   │   │   ├── firestore_attendance_repository.dart # Firestore canlı oturum servisi
│   │   │   └── location_providers.dart              # GPS konum sağlayıcıları
│   │   └── presentation/
│   │       ├── attendance_providers.dart  # Yoklama durum sağlayıcıları
│   │       ├── shared_widgets.dart        # Ortak kart, başlık ve rozet widget'ları
│   │       ├── instructor/                # Öğretim görevlisi ekranları
│   │       │   ├── chain_page.dart        # Blok zinciri gezgini ve kurcalama testi
│   │       │   ├── course_detail_page.dart# Ders detay ve geçmiş oturumlar
│   │       │   ├── instructor_pages.dart  # Görevli ana paneli ve bölüm listesi
│   │       │   └── live_session_page.dart # Canlı dinamik QR ve katılımcı akış ekranı
│   │       ├── student/                   # Öğrenci ekranları
│   │       │   ├── scanner_page.dart      # Mobil kamera ile QR okuma ekranı
│   │       │   └── student_pages.dart     # Öğrenci ana sayfası, ders listesi ve makbuz
│   │       └── reports/                   # Raporlama modülü
│   │           ├── course_report.dart     # Devam istatistikleri ve özet hesaplamaları
│   │           └── report_page.dart       # PDF ve CSV dışa aktarım ekranı
│   │
│   ├── ui/                          # Tasarım sistemi, tema ve animasyonlar
│   │   ├── ui.dart                  # UI katmanı barrel export'u
│   │   ├── motion/
│   │   │   ├── motion.dart          # Yay (spring) eğrileri ve süre sabitleri
│   │   │   └── page_transitions.dart# Sayfa geçiş animasyonları
│   │   ├── theme/
│   │   │   ├── app_palette.dart     # Kurumsal renk paleti (Bordo, Zümrüt Yeşili, Nötr)
│   │   │   ├── app_theme.dart       # ThemeData üreticisi (Açık ve Koyu tema)
│   │   │   └── tokens.dart          # Boşluk (Space), Yuvarlaklık (Radii) ve Boyut token'ları
│   │   └── widgets/
│   │       ├── async_value_view.dart# Riverpod AsyncValue durum sarmalayıcısı
│   │       ├── status.dart          # Katılım durumu görselleştirme rozetleri
│   │       ├── success_check.dart   # Başarılı yoklama için mikro animasyonlu onay kutusu
│   │       └── surfaces.dart        # Dokunsal kartlar ve duyarlı yüzeyler
│   │
│   └── l10n/                        # Çoklu dil desteği (Localization)
│       ├── app_tr.arb               # Türkçe metin çevirileri (Varsayılan)
│       └── app_en.arb               # İngilizce metin çevirileri
│
├── test/                            # Birim, widget, blockchain ve mimari testleri
│   ├── attendance/                  # QR, check-in, geofence, oturum testleri
│   ├── auth/                        # Biyometrik ve oturum açma testleri
│   ├── blockchain/                  # SHA-256, Merkle, Ed25519, PoA, kurcalama senaryoları
│   ├── core/                        # Canonical JSON, Hash, Result testleri
│   ├── tool/                        # Annotation sözleşme denetim testleri
│   └── ui/                          # Golden ve widget UI akış testleri
│
├── tool/
│   └── check_annotations.dart       # Kod tabanını tarayan özel annotation analiz aracı
├── web/
│   ├── index.html                   # Web barındırma kabuğu
│   └── sqlite3.wasm                 # Tarayıcıda SQLite çalıştıran WebAssembly ikilisi
├── web_ac.bat                       # Tek tıkla yerel ağda web sunucusu başlatan script
├── pubspec.yaml                     # Bağımlılıklar, SDK kısıtları ve font tanımları
└── analysis_options.yaml            # Very Good Analysis katı kural seti
```

---

## 🚀 Kurulum ve Çalıştırma Rehberi

### Gereksinimler

- **Flutter SDK:** `^3.47.0` veya üzeri
- **Dart SDK:** `^3.13.0` veya üzeri
- **Android için:** Android SDK 36, JDK 21 (Android Studio kurulması şart değildir; Android komut satırı araçları yeterlidir)
- **Tarayıcı / Web için:** Google Chrome veya Chromium tabanlı herhangi bir modern tarayıcı
- **Python (Opsiyonel):** `web_ac.bat` üzerinden yerel web sunucusu açmak için Python 3

---

### 1. Bağımlılıklar ve Kod Üretimi

Projeyi klonladıktan veya indirdikten sonra proje ana dizininde bir terminal açın ve aşağıdaki komutları sırasıyla çalıştırın:

```bash
# Paket bağımlılıklarını indirin
flutter pub get

# Drift veritabanı ve JSON serileştirme kodlarını derleyin
dart run build_runner build --delete-conflicting-outputs
```

> ⚠️ **Windows Kullanıcıları İçin Önemli Not:** Projenin bulunduğu dosya yolunda Türkçe karakter (`ç, ğ, ı, ö, ş, ü`) bulunmamasına dikkat edin. Dart analiz sunucusu ve `build_runner` Türkçe karakterli yollarda hata verebilir.

---

### 2. Demo Modunda Çalıştırma (Firebase Gerektirmez)

Uygulama, herhangi bir bulut servisine veya Firebase kurulumuna ihtiyaç duymadan **tam teşekküllü yerel SQLite** üzerinde çalışacak bir Demo Modu ile gelir.

```bash
# Bağlı varsayılan cihazda (Android Emülatör / Telefon / Windows Desktop) başlatın:
flutter run
```

Bu modda:
- Tüm öğretim görevlileri ve öğrenciler hazırdır.
- Zincir yerel SQLite'ta saklanır.
- Kamera yerine veya kameraya ek olarak tek tuşla test verisi üreten **"Demo Eylemleri"** etkindir:
  - Canlı yoklama ekranında: *"Demo: öğrenci katılımı ekle"*
  - QR tarayıcıda: *"Demo: açık oturumun QR'ını üret"*
  - Zincir ekranında: *"Demo: bir kaydı kurcala"*

---

### 3. Web Tarayıcısında ve Yerel Ağda Çalıştırma (`web_ac.bat`)

Uygulamanın web sürümü, tarayıcı içinde WebAssembly SQLite (`sqlite3.wasm`) çalıştırır.

#### Kolay Yöntem (Windows):
Proje kök dizinindeki **`web_ac.bat`** dosyasına çift tıklayın:
1. Uygulama otomatik olarak `http://localhost:8080` adresinde açılır.
2. Konsol penceresinde yerel IPv4 adresiniz (örnek: `http://192.168.1.102:8080`) yazdırılır.
3. Aynı Wi-Fi ağına bağlı olan **iPhone, iPad veya Android** cihazlarınızdan Safari veya Chrome ile bu adrese girerek uygulamayı telefonunuzda anında deneyimleyebilirsiniz.
4. Çıkmak için açılan siyah komut penceresini kapatmanız yeterlidir.

#### Manuel Yöntem:
```bash
# 1. Web sürümünü derleyin
flutter build web --release

# 2. Chrome'da anlık yenileme (hot-reload) ile test etmek için:
flutter run -d chrome
```

---

### 4. Firebase Canlı Modunda Çalıştırma

Kurumsal canlı ortama geçmek için:

1. [Firebase Console](https://console.firebase.google.com)'da yeni bir proje açın.
2. **Authentication** (E-posta/Şifre sağlayıcısı) ve **Cloud Firestore** servislerini aktif hale getirin.
3. CLI araçlarını kurup bağlayın:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
4. Projedeki hazır kuralları Firestore'a dağıtın:
   ```bash
   firebase deploy --only firestore:rules
   ```
5. Firestore üzerinde `users/{uid}` ve `courses/{id}` belgelerini tanımlayın.
6. Uygulamayı Firebase bayrağıyla derleyip başlatın:
   ```bash
   flutter run --dart-define=BACKEND=firebase
   ```

---

## 👥 Hazır Demo Hesapları

Demo modunda giriş yapmak için aşağıdaki hesaplardan herhangi birini kullanabilirsiniz.  
Tüm hesapların ortak şifresi: **`demo1234`**

### Öğretim Görevlileri
| Unvan | Adı Soyadı | Giriş E-postası | Bölüm Yetkisi |
|---|---|---|---|
| Prof. Dr. | ADEM KARAKAŞ | `adem.karakas@sarkisla.edu.tr` | Bilişim Sistemleri / YZMO |
| Prof. Dr. | TURGUT ÖZTÜRK | `turgut.ozturk@sarkisla.edu.tr` | Bilişim Sistemleri / YZMO |
| Doç. Dr. | MESUT POLATGİL | `mesut.polatgil@sarkisla.edu.tr` | Bilişim Sistemleri / YZMO |
| Dr. Öğr. Üyesi | ABDULKERİM GÜLER | `abdulkerim.guler@sarkisla.edu.tr` | Bilişim Sistemleri / YZMO |
| Dr. Öğr. Üyesi | UMUT SARAY | `umut.saray@sarkisla.edu.tr` | Bilişim Sistemleri / YZMO |

### Öğrenciler
| Bölüm | Adı Soyadı | Giriş (Okul No) | Kayıtlı Ders Sayısı |
|---|---|---|---|
| Bilişim Sistemleri (BST) | Osman Ceran | `2024481004` | 4 Ders |
| Bilişim Sistemleri (BST) | Emir Sevgili | `2024481007` | 4 Ders |
| Bilişim Sistemleri (BST) | Eymen İşleksoy | `2024481050` | 4 Ders |
| Bilişim Sistemleri (BST) | Samed Hırabaşoğlu | `2024481009` | 4 Ders |
| Bilişim Sistemleri (BST) | Ömer Murat | `2024481021` | 4 Ders |

---

## 📱 Mobil Dağıtım ve Derleme

### Android (APK)
Mimari bazında optimize edilmiş ve dosya boyutu küçültülmüş release APK'ları oluşturmak için:

```bash
flutter build apk --release --split-per-abi
```
Çıktı dosyası: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

---

### iOS (IPA — macOS Olmadan Windows'ta Kurulum)

macOS ve Xcode olmadan, doğrudan Windows üzerinden iPhone'a kurulum yapmak için projeye hazır bir **GitHub Actions CI/CD** iş akışı eklenmiştir:

1. **Bulut Derlemesi:**
   - GitHub deponuzda **Actions** sekmesine gidin.
   - Sol menüden **"iOS IPA (imzasız)"** iş akışını seçip **Run workflow** butonuna tıklayın.
   - GitHub'ın macOS sunucusu uygulamayı derler (yaklaşık 15–20 dk).
   - İş akışı tamamlandığında **Artifacts** bölümünden `sarkisla_yoklama-ipa` zip dosyasını bilgisayarınıza indirin.
2. **Windows'ta Cihaza Yükleme:**
   - Bilgisayarınıza [Sideloadly](https://sideloadly.io) uygulamasını ve Microsoft Store'dan **Apple Devices** (veya iTunes) yükleyin.
   - iPhone'unuzu USB kablosuyla bilgisayara bağlayın ve ekranda *"Bu Bilgisayara Güven"* seçeneğini onaylayın.
   - *Ayarlar → Gizlilik ve Güvenlik → Geliştirici Modu*'nu aktif edin (iOS 16+).
   - Sideloadly'yi açın, indirdiğiniz IPA dosyasını pencereye sürükleyin, Apple ID'nizi girip **Start**'a basın.
3. **İlk Çalıştırma Onayı:**
   - iPhone'da *Ayarlar → Genel → VPN ve Cihaz Yönetimi* menüsüne gidin.
   - Apple kimliğinizi seçip **"Güven"** butonuna dokunun. Uygulama kullanıma hazırdır!

---

## 🧪 Test ve Kod Kalitesi

Proje, kurumsal yazılım standartlarına ve sıfır hata toleransına uygun şekilde test edilmiştir:

```bash
# 1. Statik kod analizi (Very Good Analysis kuralları - Sıfır uyarı hedeflenir)
flutter analyze

# 2. Tüm birim, widget ve entegrasyon testlerini çalıştırın (86 test)
flutter test

# 3. Ekran görüntüsü (Golden) UI regresyon testlerini güncellemek için:
flutter test test/ui --update-goldens

# 4. Kaynak kod düzeyindeki özel annotation sözleşmelerini denetleyin:
dart run tool/check_annotations.dart
```

### Test Kapsamı
- **Kriptografi ve Zincir:** Genesis bloğu inşası, Merkle ağacı ve kanıt doğrulamaları, Ed25519 PoA imza testleri, eşzamanlı blok ekleme senaryoları.
- **Kurcalama ve Tehdit Simülasyonu:** Kayıt değiştirme, blok silme, zincir arasına sahte blok ekleme, sahte genesis bloğu enjekte etme testleri.
- **Yoklama Kuralları:** QR son kullanma süresi, geçersiz nonce, aynı öğrencinin çift yoklama denemesi, yabancı cihaz eşleşmesi, coğrafi sınır dışı kalma.

---

## 🎨 Tasarım Sistemi ve Erişilebilirlik

- **Kurumsal ve Minimalist Estetik:** Göz yoran neon gradyanlar yerine sıcak kâğıt tonlu zeminler (`#FAF7F2`), ince konturlu beyaz kartlar ve tek mat vurgu rengi kullanılmıştır.
- **Renk Semantiği:** 
  - Öğretim Görevlisi: Kurumsal Bordo (`#8B1E2D`)
  - Öğrenci: Güven Veren Zümrüt Yeşili (`#1E5E4B`)
  - Koyu Tema: Göz dostu sıcak antrasit (`#18191B`)
- **Tipografi:** Başlıklarda akademik ciddiyeti yansıtan **Newsreader** (Serif), gövde metinlerinde yüksek okunabilirlikli **Inter**, hash ve blok zinciri kodlarında **Fira Code**. Yazı tipleri uygulamaya gömülüdür; çevrimdışı ve PDF raporlarında Türkçe karakter hatası vermez.
- **Mikro-Animasyonlar:** Dokunma tepkilerinde yaylanma (spring) hareketleri, liste elemanlarında kademeli (staggered) akış, başarılı yoklamada çizilen dinamik onay animasyonu (`SuccessCheck`).
- **Erişilebilirlik (A11y):** Dokunma alanları minimum 48 dp olarak tasarlanmıştır. Renk kontrastları **WCAG AA** standartlarına tam uyumludur. Sistemde *"Animasyonları Azalt"* seçeneği açık olan kullanıcılarda hareketler otomatik olarak devre dışı kalır.

---

## 📄 Lisans ve Katkı

Bu proje açık kaynaklı olup akademik ve kurumsal kullanıma uygundur.
- Yazı tipleri: SIL Open Font License (OFL) ile lisanslanmıştır (`assets/fonts/`).
- Kurumsal Logolar: Sivas Cumhuriyet Üniversitesi Kurumsal Kimlik kılavuzuna aittir.

Katkıda bulunmak için lütfen bir **Issue** açın veya doğrudan **Pull Request** gönderin. Herhangi bir sorunuzda Şarkışla Uygulamalı Bilimler Yüksekokulu Bilişim Sistemleri ve Teknolojileri Bölümü ile iletişime geçebilirsiniz.
