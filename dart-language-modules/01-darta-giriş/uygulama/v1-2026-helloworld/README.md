# Antrenman (Push-Pull-Legs) Hacim & Performans Hesaplayıcısı 🏋️‍♂️

> **Ders:** Mobil Programlama I (SCÜ Şarkışla UBYO - Bilişim Sistemleri ve Teknolojileri)  
> **Modül:** `dart-language-modules / 01-dart-anatomy`  
> **Takım Adı:** `helloworld`  
> **Dönem:** 2026-Güz  
> **Versiyon:** `v1-2026-helloworld`

---

## 🎯 Projenin Amacı ve Özeti

Bu mobil uygulama, **Dart Anatomisi (01-dart-anatomy)** konusu kapsamında geliştirilmiştir. Spor bilimindeki popüler **Push-Pull-Legs (İtiş-Çekiş-Bacak)** hipertrofi antrenman modelini temel alarak; Dart programlama dilinin temel yapı taşları olan **`int`**, **`double`**, **`const`**, **`final`** ve **`if / else`** mekanizmalarını gerçek bir senaryoda simüle eder.

---

## 🧠 Kullanılan Dart Mimarisi ve Prensipleri

| Dart Yapısı | Projedeki Kullanımı ve Açıklaması |
| :--- | :--- |
| **`int`** | Tam sayı sayımları için kullanıldı: Set sayısı (`sets`), yapılan tekrar (`reps`), hedeflenen tekrar (`targetReps`) ve dinlenme süresi (`recommendedRestSeconds`). |
| **`double`** | Ondalıklı hassas ölçümler için kullanıldı: Ağırlık kg (`weight`), hedef ağırlık (`targetWeight`), toplam antrenman tonajı (`totalVolume = sets * reps * weight`) ve Epley formülü 1RM tahmini (`estimatedOneRepMax`). |
| **`const`** | Derleme zamanında (compile-time) belirlenen ve asla değişmeyen spor kuralları:<br>• `defaultRestPushPull = 90` sn (İtiş/Çekiş taban dinlenmesi)<br>• `defaultRestLegs = 120` sn (Bacak taban dinlenmesi)<br>• `failureBonusRestSeconds = 30` sn (Tükeniş bonus dinlenmesi)<br>• `progressiveOverloadStepKg = 2.5` kg (Aşırı yüklenme artış adımı) |
| **`final`** | Çalışma anında (runtime) bir kez hesaplanan ve sonradan değiştirilemeyen anlık kayıtlar (`final double totalVolume`, `final DateTime timestamp`, `final WorkoutEvaluation evaluation`). |
| **`if / else`** | **Tükeniş (Failure) Kontrolü:** `if (reachedFailure)` ile merkezi sinir sistemi toparlanması için dinlenme süresi artırılır (+30 sn) ve back-off seti tavsiye edilir.<br>**Hedef Kontrolü:** `if (reps >= targetReps && weight >= targetWeight)` ile hedefin tuttuğu kontrol edilir ve Progressive Overload (+2.5 kg) önerilir; tutmadıysa `else if` bloklarıyla kişiselleştirilmiş koç geri bildirimi üretilir. |

---

## ✨ Uygulama Özellikleri

1. **PPL Kategori ve Egzersiz Seçici:**
   - **Push (İtiş):** Bench Press, Overhead Press, Incline DB Press, Dips vb.
   - **Pull (Çekiş):** Deadlift, Barbell Row, Pull-Up, Lat Pulldown, Biceps Curl vb.
   - **Legs (Bacak):** Squat, Romanian Deadlift, Leg Press, Leg Curl vb.
2. **İnteraktif Veri Girişi:**
   - Set, tekrar ve ağırlık değerleri için tek tıkla çalışan `+` ve `-` sayaçları.
   - Tükeniş (Failure / RIR 0) durum anahtarı (Switch).
3. **Canlı Tonaj & Performans Analizi:**
   - Anlık toplam tonaj (`sets × reps × weight` kg).
   - Epley formülü ile tahmini 1RM (Tek Tekrar Maksimumu).
   - Akıllı Koç değerlendirmesi ve Progressive Overload tavsiyeleri.
4. **Çalışan Dinlenme Kronometresi (Rest Timer):**
   - Kategoriye ve tükeniş durumuna göre otomatik ayarlanan, geri sayımlı dairesel sayaç.
5. **Antrenman Günlüğü:**
   - Günlük toplam hacim ve Push/Pull/Legs yüzde dağılım grafikleri.
   - Kaydedilen tüm setlerin listesi ve silme yönetimi.
6. **Dart Mantığı Dokümantasyon Sekmesi:**
   - Projenin arkasındaki kod mimarisini ve kuralları gösteren eğitim ekranı.

---

## 📁 Dosya ve Dizin Yapısı

```
v1-2026-helloworld/
├── lib/
│   ├── main.dart                          # Uygulama başlangıcı ve tema yönetimi
│   ├── models/
│   │   ├── exercise.dart                  # PPL egzersiz modelleri ve const antrenman prensipleri
│   │   └── workout_set.dart               # int, double, final set modeli ve tonaj hesabı
│   ├── services/
│   │   ├── workout_calculator.dart        # if/else tükeniş ve hedef analiz motoru
│   │   └── workout_storage_service.dart   # SharedPreferences veri kayıt servisi
│   ├── theme/
│   │   └── app_theme.dart                 # Koyu ve açık tema tanımları
│   ├── widgets/
│   │   └── rest_timer_dialog.dart         # Geri sayımlı dinlenme sayacı
│   └── screens/
│       ├── home_screen.dart               # Alt navigasyon çubuğu ve sekme yönetimi
│       ├── calculator_screen.dart         # Hacim hesaplama ve koç değerlendirme ekranı
│       ├── history_screen.dart            # Günlük toplam hacim ve set geçmişi
│       └── dart_logic_screen.dart         # Dart değişken ve karar yapıları rehberi
├── pubspec.yaml                           # Flutter bağımlılıkları
├── preview.html                           # Tarayıcıda doğrudan test edilebilen canlı mobil simülatör
├── index.html                             # Web önizleme dosyası
└── README.md                              # Bu dokümantasyon dosyası
```

---

## 🚀 Çalıştırma

### 1. Flutter İle Çalıştırma:
```bash
flutter pub get
flutter run
```

### 2. Tarayıcıda (Kurulumsuz) Doğrudan Önizleme:
`preview.html` veya `index.html` dosyasına çift tıklayarak herhangi bir web tarayıcısında (Chrome, Edge) tam fonksiyonel mobil simülatörüyle anında test edebilirsiniz.
