<div align="center">

📱 DayPlanner
Günlük Planlama ve Rutin Takip Uygulaması
SCÜ Şarkışla UBYO · Bilişim Sistemleri ve Teknolojileri
Mobil Programlama I · 2. Takım





Gününü planla, önceliklerini belirle ve rutinlerini takip et.
</div>

📌 İçindekiler
- Proje Hakkında
- Öne Çıkan Özellikler
- Responsive ve Adaptive Tasarım
- Teknolojiler
- Kurulum ve Çalıştırma
- Proje Yapısı
- Takım
🎯 Proje Hakkında
DayPlanner, günlük görevleri ve alışkanlıkları tek bir yerde yönetmek için geliştirilen Flutter tabanlı bir planlama uygulamasıdır. Arayüz; farklı ekran boyutlarına, dikey ve yatay cihaz yönelimlerine ve mobil, web ve masaüstü kullanımına uyum sağlayacak şekilde tasarlanmıştır.

Uygulama, Material 3 bileşenlerini ve Provider durum yönetimini kullanır. Kullanıcılar günlerini saat bloklarına ayırabilir, görevlerini önceliklendirebilir, alışkanlık serilerini takip edebilir ve haftalık verimlilik verilerini inceleyebilir.
✨ Öne Çıkan Özellikler
Özellik	Açıklama
🗓️ Günlük planlama	Görevleri zaman dilimlerine göre düzenleme ve günlük akışı takip etme.
🎯 Eisenhower matrisi	Görevleri önem ve aciliyet durumuna göre dört grupta değerlendirme.
🔁 Rutin ve alışkanlık takibi	Sabah, öğle, akşam ve gece rutinlerini yönetme; alışkanlık serilerini görüntüleme.
📊 Verimlilik analizi	Günlük tamamlanma oranlarını ve haftalık ilerlemeyi inceleme.
🎨 Tema ayarları	Aydınlık ve karanlık temalar arasında geçiş yapma.
💾 Yerel veri saklama	Profil, tema ve planlama verilerini shared_preferences ile cihazda saklama.
📱 Esnek arayüz	Farklı ekranlarda yeniden düzenlenen kartlar, listeler ve navigasyon.


📐 Responsive ve Adaptive Tasarım
Arayüz, yalnızca ekranı küçültmek yerine mevcut alana göre bileşenlerin boyutunu ve yerleşimini düzenlemeyi hedefler.
Kullanılan düzen yapıları
- Expanded, Flexible, Spacer — Satır ve sütunlardaki kullanılabilir alanı esnek biçimde paylaşır.
- Wrap — Etiketleri ve kategori rozetlerini yer kalmadığında otomatik olarak alt satıra geçirir.
- Row ve Column — Eisenhower matrisinin 2 × 2 görünümünü oluşturur.
- GridView ve IntrinsicHeight — Izgara ve içerik yüksekliğine göre düzenlenen bileşenlerde kullanılır.
- ListView.builder — Tarih seçici gibi kaydırılabilir listeleri verimli biçimde oluşturur.
- Adaptive navigation — Mobil yerleşimde NavigationBar, geniş ekranlarda Drawer tabanlı gezinme sunar.
Farklı ekranlara uyum
Ortam	Arayüz yaklaşımı
📱 Dar ekran	Dikey içerik akışı ve alt navigasyon
📲 Yatay ekran	Kullanılabilir genişliğe göre esneyen bileşenler
💻 Geniş ekran	Daha geniş içerik alanı ve yan menüyle gezinme
🌗 Farklı temalar	Material 3 aydınlık ve karanlık tema seçenekleri


Not: Responsive davranışın her cihazda doğru çalıştığını doğrulamak için dar ve geniş ekranlarda, ayrıca dikey ve yatay yönelimlerde test yapılmalıdır.

🧰 Teknolojiler
- Flutter — Çok platformlu uygulama arayüzü
- Dart — Uygulama programlama dili
- Material 3 — Arayüz tasarım sistemi
- Provider — Durum yönetimi
- shared_preferences — Yerel anahtar-değer depolama
🚀 Kurulum ve Çalıştırma
Gereksinimler
- Flutter SDK ve Dart
- Android cihazı/emülatörü veya desteklenen bir masaüstü/web geliştirme ortamı
- Terminal ya da komut satırı
1. Projeyi edin
git clone <REPOSITORY_URL>
cd DayPlanner
<REPOSITORY_URL> alanını projenin Git deposu adresiyle değiştir. Kaynak kod bilgisayarında zaten bulunuyorsa doğrudan proje klasörüne geçebilirsin.
2. Paketleri yükle
flutter pub get
3. Kullanılabilir cihazları kontrol et
flutter devices
4. Uygulamayı başlat
Android
flutter run -d android
Web (Chrome)
flutter run -d chrome
Windows masaüstü
flutter run -d windows
Platform komutu çalışmazsa ilgili Flutter platform desteğinin ve gerekli geliştirme araçlarının kurulu olduğunu kontrol et.

🗂️ Proje Yapısı
DayPlanner/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── category.dart
│   │   ├── daily_summary.dart
│   │   ├── routine.dart
│   │   └── task.dart
│   ├── providers/
│   │   └── planner_provider.dart
│   ├── screens/
│   │   ├── analytics_screen.dart
│   │   ├── day_planner_screen.dart
│   │   ├── main_navigation_screen.dart
│   │   ├── routine_planner_screen.dart
│   │   ├── settings_screen.dart
│   │   └── task_list_screen.dart
│   ├── services/
│   │   ├── mock_data.dart
│   │   └── storage_service.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── widgets/
│       ├── add_routine_dialog.dart
│       ├── add_task_dialog.dart
│       ├── date_selector.dart
│       ├── progress_card.dart
│       ├── routine_card.dart
│       └── task_card.dart
├── pubspec.yaml
└── README.md
<details>
<summary><strong>📁 Klasörlerin görevleri</strong></summary>

Dizin	Sorumluluk
models/	Görev, rutin, kategori ve günlük özet veri modelleri
providers/	Uygulama durumunun yönetilmesi ve ekranlara aktarılması
screens/	Ana sayfalar ve ekran düzeyindeki arayüzler
services/	Örnek veriler ve yerel depolama işlemleri
theme/	Material 3 aydınlık ve karanlık tema tanımları
widgets/	Ekranlar arasında yeniden kullanılan arayüz bileşenleri


</details>

👥 Takım
SCÜ Şarkışla UBYO · Bilişim Sistemleri ve Teknolojileri Bölümü
Mobil Programlama I · 2. Takım
- Furkan Yazgülü
- Görkem Arda Önler
- Ege Ayçiçek
<div align="center">

DayPlanner · Gününü planla, ilerlemeni takip et.
</div>