# FocusFlow Proof

FocusFlow Proof, Pomodoro odak oturumlarını ve görevleri takip eden; tamamlanan
her odak ve görevi cihazda çalışan kriptografik bir **kanıt defterine** yazan
Türkçe, yerel öncelikli bir Flutter uygulamasıdır.

Uygulama bir hesap, sunucu, API veya internet bağlantısı gerektirmez. Tüm
görevler, oturumlar, FOCUS bakiyesi, bloklar, rozetler ve cüzdan anahtarı
cihazda `shared_preferences` içinde saklanır.

> Bu proje **yalnızca mobil/Android** hedeflidir. Web derlemesi ve web
> markalaması kapsam dışıdır.

## Neden FocusFlow Proof?

Projenin eski çalışma adı “FocusFlow Chain” idi. “Chain” adı başka bir projeye
ait olduğu için uygulamanın yeni adı **FocusFlow Proof** olarak belirlendi.
Blok yapısı, proof-of-work, Merkle kökleri ve Ed25519 imzaları korunuyor; ancak
uygulama ve arayüz hiçbir yerde “Chain” adını kullanmıyor. Kanıt katmanı
arayüzde **Kanıt Defteri** olarak adlandırılıyor.

## Özellikler

- **Ana Sayfa:** Günlük odak süresi, tamamlanan görevler, bekleyen görevler,
  FOCUS bakiyesi, son blok ve kanıt defteri durumu.
- **Odak:** 25 dk odak / 5 dk kısa mola / 15 dk uzun mola varsayılanları;
  başlat, duraklat, devam et, sıfırla. Kalan süre hedef bitiş zamanından
  hesaplanır; oturum yalnızca bir kez kaydedilir.
- **Görevler:** Ekleme, düzenleme, tamamlama, silme; Tümü / Bekleyenler /
  Tamamlananlar filtreleri; boş başlık reddi; isteğe bağlı kategori ve son
  tarih.
- **Kanıt Defteri:** Blok ve işlem gezgini, ağ durumu, proof-of-work bilgisi,
  hash bağlantıları, Merkle kökü, doğrulama sonucu ve kurcalama demosu.
- **Cüzdan:** FOCUS bakiyesi, Ed25519 imzalı transfer, işlem geçmişi ve
  NFT benzeri kanıt rozetleri.
- **İstatistikler:** Toplam odak süresi, oturum sayısı, günlük değerler, son
  yedi gün grafiği, FOCUS bakiyesi ve defter yüksekliği.
- **Ayarlar:** Pomodoro süreleri, açık/koyu/sistem teması, defter doğrulama,
  defter sıfırlama ve onaylı veri temizleme.

## FOCUS Tokenomisi

| Kaynak | Kazanç |
| --- | --- |
| İlk cüzdan (genesis) | 10 FOCUS hoş geldin ödülü |
| Tamamlanan odak oturumu | Her tam 5 dakika için 1 FOCUS (en az 1) |
| Tamamlanan görev | 2 FOCUS |
| Blok üretimi (coinbase) | 1 FOCUS |
| Rozet basımı | Rozete göre 3–25 FOCUS |
| Transfer | Ek ücret yok |

Örnek: 25 dakikalık bir odak oturumu 5 FOCUS + 1 FOCUS blok ödülü üretir.
Aynı işlem sırasında yeni bir rozet hak edilirse rozet ödülü ve rozet bloğunun
coinbase ödülü de bakiyeye eklenir.

## Kanıt Defteri Mimarisi

```text
Odak oturumu / görev tamamlanır
        │
        ▼
ChainTransaction.create
  • kanonik JSON gövdesi
  • SHA-256 işlem kimliği
        │
        ▼
Bekleyen işlem kuyruğu (mempool)
        │
        ▼
ChainBlock.mine
  • işlemlerin Merkle kökü
  • önceki blok hash'i
  • nonce + proof-of-work (zorluk 3)
  • SHA-256 blok hash'i
        │
        ▼
Yerel defter + SharedPreferences
        │
        ▼
ChainValidator
  • hash ve previousHash zinciri
  • proof-of-work hedefi
  • Merkle kökü
  • işlem kimlikleri
  • Ed25519 imzaları
  • bakiye / harcama kontrolü
```

### Kriptografik bileşenler

- **SHA-256:** İşlem kimlikleri, blok hash'leri ve kanonik JSON özetleri.
- **Merkle ağacı:** Her bloktaki işlemlerin tek bir kök hash altında
  özetlenmesi.
- **Proof-of-work:** Blok hash'inin başında `difficulty` kadar sıfır
  bulunması. Varsayılan zorluk `3`; demo için hızlı fakat gerçek bir PoW
  döngüsüdür.
- **Ed25519:** Cüzdan açık/özel anahtar çifti ve kullanıcı transferlerinin
  imzalanması. Özel anahtar cihazdan dışarı çıkmaz.
- **Hash bağlantısı:** Her blok `previousHash` ile önceki bloğa bağlanır.
  Sonradan değiştirilen bir işlem, blok hash'ini ve tüm sonraki bağlantıları
  geçersiz kılar.

### İşlem türleri

`genesis`, `focusReward`, `taskReward`, `achievementReward`, `miningReward`,
`transfer`.

Sistem ödülleri `FOCUSFLOW_SYSTEM` adresinden üretilir. Kullanıcı transferleri
`0x` ile başlayan 40 hex karakterli cüzdan adresleri arasında yapılır.

## Rozetler

Kanıt defterine NFT benzeri işlemlerle basılan sekiz rozet vardır:

| Rozet | Koşul | Ödül |
| --- | --- | --- |
| İlk Odak | İlk odak oturumunu tamamla | 5 FOCUS |
| Odak Serisi | 5 odak oturumu tamamla | 10 FOCUS |
| Derin Çalışma | Toplam 10 saat odaklan | 25 FOCUS |
| Haftalık Disiplin | 7 gün üst üste odaklan | 20 FOCUS |
| İlk Görev | İlk görevi tamamla | 3 FOCUS |
| Görev Avcısı | 10 görev tamamla | 15 FOCUS |
| Blok Ustası | 5 blok üret | 10 FOCUS |
| Akış Hali | Tek oturumda 50 dakika odaklan | 15 FOCUS |

Her rozetin `FFNFT-001` biçiminde bir token kimliği ve defterde kendi
`achievementReward` işlemi bulunur.

## Demo Akışı

1. Uygulamayı aç. Genesis bloğu ve 10 FOCUS hoş geldin ödülü otomatik oluşur.
2. **Odak** sekmesinde bir oturum tamamla. Odak ödülü işlemi, proof-of-work
   bloğu ve varsa yeni rozetler deftere yazılır.
3. **Görevler** sekmesinde bir görevi tamamla. Görev ödülü ve blok ödülü
   bakiyeye eklenir.
4. **Cüzdan** sekmesinde bakiyeyi, işlemleri ve rozetleri incele. Demo alıcı
   düğmesiyle geçerli bir adres doldurup imzalı transfer gönder.
5. **Kanıt** sekmesinde blokları ve işlemleri gez. **Defteri doğrula** ile tüm
   hash, PoW, imza ve bakiye kontrollerini çalıştır.
6. **Defteri kurcala** ile bellekteki son blok işlemini değiştir; doğrulamanın
   hatayı yakaladığını gör. Demo sırasında cüzdan bakiyesi sağlam defterden
   okunur ve transfer/madencilik işlemleri kilitlenir. **Sağlam deftere dön**
   ile her şey eski haline gelir.
7. **Ayarlar → FocusFlow Proof** bölümünden defteri doğrula veya genesis
   bloğuna sıfırla.

## Çalıştırma

```bash
flutter pub get
flutter run
```

Android hata ayıklama APK'sı:

```bash
flutter build apk --debug
```

APK çıktısı:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

> Android Studio'nun JDK 25 sürümü Kotlin ile uyumsuzluk çıkarırsa
> `flutter config --jdk-dir="<JDK-17-yolu>"` ile JDK 17 seçilebilir. Bu projede
> derleme JDK 17 ile doğrulanmıştır.

## Doğrulama

```bash
dart format lib test
flutter analyze
flutter test
flutter build apk --debug
```

Projede birim, widget ve dar ekran smoke testleri bulunur. Testler; süre
biçimlendirme, görev doğrulama, JSON serileştirme, istatistik hesaplama, sayaç
yaşam döngüsü, yerel depolama, blok üretimi, Merkle/PoW doğrulaması, Ed25519
transfer doğrulaması, kurcalama tespiti, rozet motoru ve beş sekmeli uygulama
gezinmesini kapsar.

## Proje Yapısı

```text
lib/
  main.dart                         # SharedPreferences, depolar ve denetleyici
  app.dart                          # MaterialApp, tema, splash, 5 sekmeli kabuk
  core/
    theme/app_theme.dart            # Renk paleti, açık/koyu tema
    utils/date_time_utils.dart      # Türkçe tarih ve gün yardımcıları
    utils/duration_formatter.dart   # 25:00 / 1 sa 5 dk biçimlendirme
  models/
    study_task.dart                 # Görev modeli + JSON + doğrulama
    focus_session.dart              # Oturum modeli + SessionType
    app_settings.dart               # Süreler, tema, aralık doğrulaması
  data/
    local_storage_service.dart      # SharedPreferences sarmalayıcısı
    task_repository.dart            # Görev kalıcılığı
    focus_session_repository.dart   # Oturum kalıcılığı
    settings_repository.dart        # Ayar kalıcılığı
  blockchain/
    core/                           # Ağ sabitleri, ödül hesaplayıcı
    models/                         # İşlem, blok, defter, cüzdan, doğrulama
    repositories/                   # Defter ve cüzdan kalıcılığı
    services/                       # Doğrulayıcı, cüzdan imzalama
    achievements/                   # Rozet motoru
    state/focus_chain_service.dart  # Defter, madencilik, transfer, doğrulama
    utils/                          # Kanonik JSON, Merkle, biçimlendirme
  state/app_controller.dart         # UI'dan bağımsız uygulama durumu
  features/
    home/ focus/ tasks/ chain/ wallet/ statistics/ settings/
  widgets/                          # Ortak kart, boş durum, gezinme, snackbar
test/                               # Birim, widget ve smoke testleri
```

## Effective Dart ile İlişkilendirme

- **Style:** Sınıf/enum adları `UpperCamelCase`, metot/değişkenler
  `lowerCamelCase`, dosyalar `snake_case`; `const`/`final` kullanımı ve
  `dart format` uygulanmıştır.
- **Documentation:** Modeller, repository'ler, `AppController`,
  `FocusTimerController`, defter servisi ve doğrulayıcı gibi public API'lerde
  davranışı açıklayan `///` yorumları bulunur.
- **Usage:** Null safety, gelişmiş switch ifadeleri, enum'lar, `async/await`,
  hata yakalama ve `Timer`/`AnimationController` benzeri kaynakların
  `dispose` edilmesi uygulanmıştır.
- **Design:** UI, modeller, sayaç mantığı, istatistik hesaplama, kriptografik
  defter ve veri erişimi ayrı dosyalara ayrılmıştır. Repository'ler depolamayı
  soyutlar; sayaç kalan süreyi hedef bitiş zamanından hesaplar; istatistikler
  sabit demo sayılar değil gerçek kayıtlardan üretilir.

## Sayaç Davranışı

Sayaç her saniye yalnızca bir azaltılmaz. Başlatma/duraklatma sırasında hedef
bitiş zamanı (`DateTime`) oluşturulur; kalan süre bu hedef ile `DateTime.now()`
farkından hesaplanır. Uygulama arka plana alınsa bile süre kaymaz; ön plana
dönüldüğünde `WidgetsBindingObserver` üzerinden `syncNow()` çağrılır.
Tamamlanan oturum bir kez kaydedilir ve sayaç kaynakları `dispose` edilir.

## Bilinen Sınırlar

- Tek düğümlü yerel demodur; gerçek bir P2P ağı veya dağıtık mutabakat yoktur.
- FOCUS gerçek para değildir; transferler yalnızca demo amaçlıdır.
- Cüzdan özel anahtarı cihazda `shared_preferences` içinde saklanır; üretim
  ortamında donanım destekli güvenli depolama kullanılmalıdır.
- Kurcalama demosu yalnızca bellekte çalışır; kalıcı deftere yazılmaz.
- Arka plan alarmı veya push bildirimi yoktur.
- Uygulama tamamen kapatılırsa devam eden oturum kaldığı yerden sürmez;
  tamamlanmış oturumlar ve defter kalıcıdır.
- Android hedeflenir; web ve masaüstü markalaması kapsam dışıdır.
