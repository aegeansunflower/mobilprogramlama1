> **Uyarı:** Bu içerik, SCÜ Şarkışla UBYO Mobil Programlama I dersi kapsamında tamamen eğitim amaçlı çevrilmiş ve derlenmiştir. Orijinal dokümantasyon kaynakları (dart.dev, docs.flutter.dev) kendi orijinal lisanslarına (BSD-3-Clause, CC-BY 4.0) tabidir. Bu çalışmanın hiçbir ticari amacı yoktur.

# Dart Dil Rehberi: Dart Anatomisi ve Temel Sözdizimi

**Mobil Programlama I — 1. Takım (helloworld)** • **Konu:** Dart Program Anatomisi, Temel Tipler, Değişkenler, Operatörler, Kontrol Akışı ve Dokümantasyon

Bu belge, resmi [dart.dev/language](https://dart.dev/language) dokümantasyonunun ilgili bölümlerinin kapsamlı ve terim karşılıklarını koruyan Türkçe çevirisidir. Kod örneklerinin çalıştırılabilir halleri `uygulama/v1-2026-helloworld/` klasöründedir.

---

## 📑 İçindekiler

- [1. Dart Program Anatomisi ve Temel Kavramlar](#1-dart-program-anatomisi-ve-temel-kavramlar)
  - [1.1 İlk Dart Programı (Hello World)](#11-i̇lk-dart-programı-hello-world)
  - [1.2 Giriş Noktası: main() Fonksiyonu](#12-giriş-noktası-main-fonksiyonu)
  - [1.3 Önemli Temel Dil İlkeleri](#13-önemli-temel-dil-i̇lkeleri)
- [2. Değişkenler ve Bellek Yönetimi (Variables)](#2-değişkenler-ve-bellek-yönetimi-variables)
  - [2.1 Değişken Tanımlama (var, Object, Tipler)](#21-değişken-tanımlama-var-object-tipler)
  - [2.2 Sesli Null Güvenliği (Sound Null Safety)](#22-sesli-null-güvenliği-sound-null-safety)
  - [2.3 Varsayılan Değerler (Default Values)](#23-varsayılan-değerler-default-values)
  - [2.4 Geç Başlatma: late Değişkenler](#24-geç-başlatma-late-değişkenler)
  - [2.5 Sabitler: final ve const Derinlemesine](#25-sabitler-final-ve-const-derinlemesine)
  - [2.6 Joker Değişkenler (Wildcards)](#26-joker-değişkenler-wildcards)
- [3. Temel Yerleşik Veri Tipleri (Built-in Types)](#3-temel-yerleşik-veri-tipleri-built-in-types)
  - [3.1 Sayılar (Numbers: int, double, num)](#31-sayılar-numbers-int-double-num)
  - [3.2 Metinler (Strings) ve İnterpolasyon](#32-metinler-strings-ve-i̇nterpolasyon)
  - [3.3 Mantıksal Değerler (Booleans)](#33-mantıksal-değerler-booleans)
  - [3.4 Tip Dönüşümleri (Type Conversions)](#34-tip-dönüşümleri-type-conversions)
- [4. Operatörler Anatomisi (Operators)](#4-operatörler-anatomisi-operators)
  - [4.1 Operatör Öncelik Tablosu](#41-operatör-öncelik-tablosu)
  - [4.2 Aritmetik Operatörler](#42-aritmetik-operatörler)
  - [4.3 Eşitlik ve İlişkisel Operatörler](#43-eşitlik-ve-i̇lişkisel-operatörler)
  - [4.4 Tip Test Operatörleri (as, is, is!)](#44-tip-test-operatörleri-as-is-is)
  - [4.5 Atama Operatörleri (=, ??=, += vb.)](#45-atama-operatörleri---vb)
  - [4.6 Mantıksal Operatörler (!, ||, &&)](#46-mantıksal-operatörler--)
  - [4.7 Koşullu İfadeler (? : ve ??)](#47-koşullu-i̇fadeler---ve-)
  - [4.8 Basamaklı Çağrı Operatörü (Cascade Notation: .. ve ?..)](#48-basamaklı-çağrı-operatörü-cascade-notation--ve-)
  - [4.9 Yayılma Operatörleri (Spread: ... ve ...?)](#49-yayılma-operatörleri-spread--ve-)
- [5. Kontrol Akışı (Control Flow)](#5-kontrol-akışı-control-flow)
  - [5.1 Dallanma: if, else if, else](#51-dallanma-if-else-if-else)
  - [5.2 if-case ve Desen Eşleme (Pattern Matching)](#52-if-case-ve-desen-eşleme-pattern-matching)
  - [5.3 switch İfadeleri ve switch Blokları](#53-switch-i̇fadeleri-ve-switch-blokları)
  - [5.4 Döngüler: for, for-in, forEach, while, do-while](#54-döngüler-for-for-in-foreach-while-do-while)
  - [5.5 break ve continue Kullanımı](#55-break-ve-continue-kullanımı)
  - [5.6 İddialar (assert)](#56-i̇ddialar-assert)
- [6. Hata ve İstisna Yönetimi (Exceptions)](#6-hata-ve-i̇stisna-yönetimi-exceptions)
  - [6.1 İstisna Fırlatma (throw)](#61-i̇stisna-fırlatma-throw)
  - [6.2 İstisna Yakalama: try, on, catch](#62-i̇stisna-yakalama-try-on-catch)
  - [6.3 finally Bloğu](#63-finally-bloğu)
- [7. Dokümantasyon ve Yorum Satırları (Comments)](#7-dokümantasyon-ve-yorum-satırları-comments)
  - [7.1 Tek Satırlı ve Çok Satırlı Yorumlar](#71-tek-satırlı-ve-çok-satırlı-yorumlar)
  - [7.2 Dartdoc Standartları (/// ve [Referanslar])](#72-dartdoc-standartları--ve-referanslar)
- [8. Kütüphaneler, Paketler ve İçe Aktarma (Libraries & Imports)](#8-kütüphaneler-paketler-ve-i̇çe-aktarma-libraries--imports)
  - [8.1 import Direktifi ve Önekler (as)](#81-import-direktifi-ve-önekler-as)
  - [8.2 Seçici İçe Aktarma (show, hide)](#82-seçici-i̇çe-aktarma-show-hide)
  - [8.3 Gecikmeli Yükleme (deferred as)](#83-gecikmeli-yükleme-deferred-as)
- [9. Uygulama Mimarisi Eşleştirmesi](#9-uygulama-mimarisi-eşleştirmesi)

---

# 1. Dart Program Anatomisi ve Temel Kavramlar

*Kaynak: <https://dart.dev/language>*

Dart; istemci optimizasyonlu, çoklu platformlarda (mobil, web, masaüstü, sunucu) yüksek hızlı uygulamalar geliştirmek için tasarlanmış modern bir nesne yönelimli programlama dilidir.

## 1.1 İlk Dart Programı (Hello World)

Aşağıdaki kod parçası minimal bir Dart uygulamasının anatomisini gösterir:

```dart
// Konsola metin yazdıran temel fonksiyon
void main() {
  print('Merhaba Mobil Programlama!');
}
```

Bu basit program şu temel ögeleri barındırır:
1. `// ...`: Tek satırlı yorum ifadesi. Derleyici tarafından göz ardı edilir.
2. `void`: Fonksiyonun herhangi bir değer döndürmediğini (dönüş tipinin boş olduğunu) belirten anahtar kelime.
3. `main()`: Uygulamanın çalıştırılmaya başlandığı en üst düzey (top-level) zorunlu başlangıç fonksiyonu.
4. `print()`: Verilen nesneyi veya metni standart çıktı akışına (konsola) yazdıran yerleşik fonksiyon.
5. `'...'`: Tek tırnak ile tanımlanmış bir dize (String literal).
6. `;`: Dart dilinde her bir deyimin (statement) sonuna zorunlu olarak konulan noktalı virgül.

## 1.2 Giriş Noktası: main() Fonksiyonu

Her Dart uygulaması üst düzey bir `main()` fonksiyonuna sahip olmak zorundadır. `main()` fonksiyonu opsiyonel olarak komut satırı argümanlarını temsil eden `List<String>` parametresi kabul edebilir:

```dart
void main(List<String> arguments) {
  print('Alınan argüman sayısı: ${arguments.length}');
  for (var arg in arguments) {
    print('Argüman: $arg');
  }
}
```

## 1.3 Önemli Temel Dil İlkeleri

Dart dilini öğrenirken ve kod yazarken aşağıdaki altın kurallar her zaman geçerlidir:

- **Her Şey Bir Nesnedir (Everything is an Object):** Bir değişkene atayabileceğiniz her değer bir nesnedir (object) ve her nesne bir sınıfın (class) örneğidir. Sayılar (`int`, `double`), fonksiyonlar ve hatta `null` değeri bile birer nesnedir. Tüm nesneler (Null hariç) `Object` sınıfından miras alır.
- **Güçlü ve Statik Tip Sistemi (Sound Type System):** Dart tür güvenliğini garanti eden güçlü bir tip sistemine sahiptir. Kod çalıştırılmadan önce derleme anında tipler denetlenir. Tip çıkarımı (type inference) sayesinde türleri açıkça yazmasanız bile (`var isim = 'Emir';`), Dart değişkenin türünü otomatik olarak `String` olarak sabitler.
- **Sesli Null Güvenliği (Sound Null Safety):** Dart 2.12 ve Dart 3 ile birlikte dilde null referans hataları derleme zamanında engellenir. Bir değişken açıkça nullable (`?`) olarak işaretlenmedikçe `null` değeri alamaz.
- **Üst Düzey Ögeler (Top-level Functions & Variables):** Dart'ta fonksiyonlar, değişkenler ve sabitler bir sınıfın içine hapsedilmek zorunda değildir. Java veya C#'ın aksine doğrudan dosya düzeyinde üst düzey (top-level) olarak tanımlanabilirler.

---

# 2. Değişkenler ve Bellek Yönetimi (Variables)

*Kaynak: <https://dart.dev/language/variables>*

## 2.1 Değişken Tanımlama (var, Object, Tipler)

Bir değişken tanımlandığında bellekte o değişkenin türüne uygun alan tahsis edilir:

```dart
// 1. var ile Tip Çıkarımı (Type Inference)
var isim = 'Ahmet'; // Derleyici isim değişkenini otomatik olarak String olarak belirler
// isim = 42; // HATA! Bir String değişkene int atanamaz.

// 2. Açık Tip Belirterek (Explicit Typing)
String takimAdi = 'helloworld';
int setSayisi = 3;
double agirlik = 72.5;

// 3. Object veya dynamic Kullanımı
// Değişkenin türü herhangi bir nesne olabiliyorsa Object kullanılır
Object genelVeri = 'Metin';
genelVeri = 100; // Geçerli

// dynamic: Statik tip denetimini tamamen kapatır (Önerilmez)
dynamic dinamikDeger = 'Test';
dinamikDeger = 12.34;
dinamikDeger = false;
```

## 2.2 Sesli Null Güvenliği (Sound Null Safety)

Dart dilinde değişkenler varsayılan olarak **null değer alamaz (non-nullable)**:

```dart
int a = 10;
// a = null; // HATA! Derleyici 'int' türüne null atanmasına izin vermez.

// Nullable yapmak için tipin sonuna '?' eklenir:
int? b = 20;
b = null; // Geçerli! b değişkeni ya bir int ya da null olabilir.
```

Null güvenliğinin üç temel prensibi:
1. **Varsayılan olarak non-nullable:** Kodunuzdaki tipler aksi belirtilmedikçe asla null olamaz.
2. **Kademeli ve tam:** Kod derlendiğinde, non-nullable bir değişkenin runtime'da null olamayacağı matematiksel olarak garanti edilir.
3. **Daha hızlı kod:** Derleyici gereksiz null kontrolleri yapmadığı için AOT (Ahead-of-Time) derlemede çok daha hafif ve hızlı makine kodu üretilir.

## 2.3 Varsayılan Değerler (Default Values)

Nullable tiplerde bir başlangıç değeri atanmazsa varsayılan değerleri otomatik olarak `null` olur:

```dart
int? sayi; // sayi == null
assert(sayi == null);
```

Non-nullable bir değişken tanımlandığı anda veya kullanılmadan önce mutlaka bir başlangıç değerine kavuşturulmalıdır:

```dart
int toplam;
if (durum) {
  toplam = 100;
} else {
  toplam = 0;
}
print(toplam); // Geçerli, çünkü her iki yolda da değer atandı.
```

## 2.4 Geç Başlatma: late Değişkenler

`late` anahtar kelimesi iki temel senaryoda kullanılır:
1. Değişken non-nullable'dır ancak tanımlandığı anda başlatılamaz, daha sonra çalışma anında atanacaktır.
2. Değişken tembel olarak (lazy initialization) başlatılmak istenmektedir; yani değişkene ilk kez erişilene kadar hesaplaması ertelenir.

```dart
late String apiYaniti;

void veriGetir() {
  apiYaniti = 'Sunucudan gelen veri';
  print(apiYaniti);
}

// Lazy initialization örneği:
late final String agirHesaplama = _agirIslemYap();
```

## 2.5 Sabitler: final ve const Derinlemesine

Bir değişkenin değerinin sonradan değiştirilememesi istendiğinde `final` veya `const` kullanılır.

### final
- Çalışma anında (runtime) **yalnızca bir kez** atanır.
- Değeri çalışma anında belirlenen fonksiyon çağrıları, kullanıcı girişleri veya `DateTime.now()` için kullanılır.

```dart
final String cihazId = getDeviceId();
final DateTime baslangicZamani = DateTime.now();
// cihazId = "yeni-id"; // HATA! final değişken yeniden atanamaz.
```

### const
- **Derleme anı (compile-time)** sabitidir.
- Kod derlenirken değeri kesin olarak bilinen ifadelerdir.
- Bellekte kanonikleştirilir (canonicalized); aynı `const` nesne bellekte tek bir adresi paylaşır.

```dart
const double piSayisi = 3.14159265359;
const int standartDinlenmeSuresi = 90; // saniye
const List<int> sabitSayilar = [1, 2, 3];
// sabitSayilar.add(4); // HATA! const liste değiştirilemez (Unsupported operation).
```

### final ve const Karşılaştırma Özeti

| Kriter | `final` | `const` |
| :--- | :--- | :--- |
| **Zamanlama** | Çalışma Zamanı (Runtime) | Derleme Zamanı (Compile-time) |
| **Değer Kaynağı** | API, cihaz sensörü, tarih, form girdisi | Sabit sayılar, string literalleri, matematiksel kurallar |
| **Sınıf Düzeyi** | Sınıf alanı (field) olabilir | Sınıfta kullanılacaksa `static const` olmalıdır |
| **Koleksiyon İmmutability** | Referans sabittir, elemanlar eklenebilir | Liste/Map tamamen dondurulur (değiştirilemez) |

## 2.6 Joker Değişkenler (Wildcards)

Dart 3.7+ sürümlerinde alt çizgi `_` joker değişken olarak kullanılabilir. Kullanılmayan döngü sayaçlarında veya parametrelerde ad çakışmasını önler:

```dart
for (var _ in [1, 2, 3]) {
  print('Tekrarlandı');
}
```

---

# 3. Temel Yerleşik Veri Tipleri (Built-in Types)

*Kaynak: <https://dart.dev/language/built-in-types>*

## 3.1 Sayılar (Numbers: int, double, num)

Dart dilinde sayılar `num` üst sınıfının iki somut alt sınıfı ile temsil edilir:

### int
64-bitlik tam sayılardır. Plataform bağımlı olarak:
- Yerel platformlarda (mobil/masaüstü): -2⁶³ ile 2⁶³ - 1 arasındadır.
- Web ortamında (JavaScript derlemesinde): -2⁵³ ile 2⁵³ - 1 arasındadır.

```dart
int setSayisi = 4;
int hexDeger = 0xDEADBEEF;
```

### double
64-bit çift duyarlıklı IEEE 754 kayan noktalı sayılardır.

```dart
double agirlik = 72.5;
double usluSayi = 1.42e5;
```

### num
Hem `int` hem de `double` değerlerini kapsayan üst tiptir:

```dart
num genelSayi = 10;
genelSayi = 10.5; // Geçerli
```

## 3.2 Metinler (Strings) ve İnterpolasyon

Dart'ta metinler UTF-16 kod birimleri dizisidir. Tek tırnak (`'`) veya çift tırnak (`"`) ile tanımlanabilir:

```dart
String s1 = 'Tek tırnaklı metin';
String s2 = "Çift tırnaklı metin";
String s3 = 'Kesme işareti içeren dize: Ali\'nin kitabı';
```

### Dize İnterpolasyonu (String Interpolation)
Bir ifadenin değerini metin içine yerleştirmek için `${ifade}` sözdizimi kullanılır. Basit bir değişken için süslü parantez atlanabilir:

```dart
double agirlik = 70.0;
int tekrar = 10;
// $agirlik ve ${agirlik * tekrar} kullanımı:
String sonuc = '$agirlik kg ağırlık ile $tekrar tekrar yapıldı. Toplam: ${agirlik * tekrar} kg';
```

### Çok Satırlı Metinler (Multi-line Strings)
Üç tek tırnak (`'''`) veya üç çift tırnak (`"""`) kullanılarak satır sonları korunarak çok satırlı metin oluşturulur:

```dart
String rehber = '''
PPL Antrenman Döngüsü:
1. Push (İtiş)
2. Pull (Çekiş)
3. Legs (Bacak)
''';
```

### Ham Metinler (Raw Strings)
`r` öneki ile kaçış karakterlerinin (`\n`, `\t` vb.) işletilmesi engellenir:

```dart
String yol = r'C:\Users\emir_\Desktop\mobil';
```

## 3.3 Mantıksal Değerler (Booleans)

Dart'ta boole değerleri `bool` anahtar kelimesiyle ifade edilir ve yalnızca iki literale sahiptir: `true` ve `false`.

```dart
bool tukeniseUlasildi = true;
bool hedefTamamlandi = false;
```

## 3.4 Tip Dönüşümleri (Type Conversions)

```dart
// String -> int
int bir = int.parse('1');

// String -> double
double ondalik = double.parse('3.14');

// int -> String
String birMetin = 1.toString();

// double -> String (ondalık basamak formatlama)
String piMetin = 3.14159.toStringAsFixed(2); // "3.14"
```

---

# 4. Operatörler Anatomisi (Operators)

*Kaynak: <https://dart.dev/language/operators>*

Dart zengin bir operatör kümesine sahiptir.

## 4.1 Operatör Öncelik Tablosu

İfadeler değerlendirilirken operatörlerin öncelik sırası en yüksekten en düşüğe şöyledir:

| Öncelik | Operatörler | Açıklama |
| :--- | :--- | :--- |
| **1 (En Yüksek)** | `[]`, `.`, `?.`, `()` | Üye erişimi, indeksleme, koşullu erişim, fonksiyon çağrısı |
| **2** | `++`, `--`, `!`, `~` | Birli önek (unary prefix), mantıksal DEĞİL, bitwise DEĞİL |
| **3** | `*`, `/`, `~/`, `%` | Çarpma, bölme, tamsayı bölme, mod alma |
| **4** | `+`, `-` | Toplama, çıkarma |
| **5** | `<<`, `>>`, `>>>` | Bit kaydırma operatörleri |
| **6** | `&` | Bitwise VE |
| **7** | `^` | Bitwise XOR |
| **8** | `|` | Bitwise VEYA |
| **9** | `>=`, `>`, `<=`, `<`, `as`, `is`, `is!` | İlişkisel karşılaştırmalar ve tip testleri |
| **10** | `==`, `!=` | Eşitlik ve eşitsizlik |
| **11** | `&&` | Mantıksal VE |
| **12** | `||` | Mantıksal VEYA |
| **13** | `??` | Null birleşim (if-null) |
| **14** | `? :` | Üçlü koşul (ternary conditional) |
| **15** | `..`, `?..` | Basamaklı çağrı (cascade) |
| **16 (En Düşük)** | `=`, `+=`, `-=`, `*=`, `/=`, `~/=`, `??=` | Atama ve bileşik atamalar |

## 4.2 Aritmetik Operatörler

```dart
int a = 10;
int b = 3;

print(a + b);  // 13 (Toplama)
print(a - b);  // 7  (Çıkarma)
print(a * b);  // 30 (Çarpma)
print(a / b);  // 3.3333333333333335 (Bölme - double döner)
print(a ~/ b); // 3  (Tamsayı Bölme - int döner)
print(a % b);  // 1  (Kalan / Modülüs)
```

## 4.3 Eşitlik ve İlişkisel Operatörler

- `==`: İki nesnenin eşit olup olmadığını test eder.
- `!=`: İki nesnenin farklı olup olmadığını test eder.
- `>`, `<`, `>=`, `<=`: Büyüktür, küçüktür, büyük eşittir, küçük eşittir.

## 4.4 Tip Test Operatörleri (as, is, is!)

- `is`: Nesne belirtilen tipe sahipse `true` döndürür.
- `is!`: Nesne belirtilen tipe sahip değilse `true` döndürür.
- `as`: Nesneyi belirli bir alt tipe tür dönüştürme (typecast) işlemine tabi tutar.

```dart
if (nesne is Exercise) {
  // Akıllı tip dönüşümü (Smart Cast): nesne bu blokta Exercise olarak davranır
  print(nesne.name);
}

// Zorla dönüştürme:
(nesne as Exercise).name;
```

## 4.5 Atama Operatörleri (=, ??=, += vb.)

```dart
int x = 5;
x += 2; // x = x + 2 (7)

// ??= Operatörü: Yalnızca değişken null ise değer ata
int? dinamikSayi;
dinamikSayi ??= 10; // dinamikSayi null olduğu için 10 atandı
dinamikSayi ??= 20; // dinamikSayi artık null değil, 10 olarak kaldı
```

## 4.6 Mantıksal Operatörler (!, ||, &&)

```dart
bool basarili = true;
bool dinleniyor = false;

if (basarili && !dinleniyor) {
  print('Antrenmana devam edilebilir.');
}
```

## 4.7 Koşullu İfadeler (? : ve ??)

### Üçlü Koşul (Ternary Operator)
`koşul ? ifade1 : ifade2`
Koşul doğruysa `ifade1`, yanlışsa `ifade2` çalışır:

```dart
String durum = reachedFailure ? 'Tükenişe Ulaşıldı' : 'Rezervde Tekrar Var';
```

### Null Birleşim (If-Null: ??)
`ifade1 ?? ifade2`
`ifade1` null değilse onun değerini, null ise `ifade2`'nin değerini döndürür:

```dart
String kategori = secilenKategori ?? 'Push';
```

## 4.8 Basamaklı Çağrı Operatörü (Cascade Notation: .. ve ?..)

Aynı nesne üzerinde art arda işlem yapmak için kullanılır:

```dart
var boya = Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0;
```

## 4.9 Yayılma Operatörleri (Spread: ... ve ...?)

Koleksiyonların içine başka bir koleksiyonun elemanlarını yayarak eklemeyi sağlar:

```dart
var pushHareketleri = ['Bench Press', 'OHP'];
var tumHareketler = ['Squat', ...pushHareketleri, 'Deadlift'];
// Nullable koleksiyon için null-aware spread:
List<String>? ekstra;
var liste = ['İlk', ...?ekstra];
```

---

# 5. Kontrol Akışı (Control Flow)

*Kaynak: <https://dart.dev/language/branches> ve <https://dart.dev/language/loops>*

## 5.1 Dallanma: if, else if, else

Dart dilinde mantıksal koşullar `if` ifadeleri ile yürütülür:

```dart
int yapilanTekrar = 10;
int hedefTekrar = 10;
double agirlik = 70.0;
double hedefAgirlik = 70.0;

if (yapilanTekrar >= hedefTekrar && agirlik >= hedefAgirlik) {
  print('Hedef başarıyla tamamlandı. Ağırlığı artırın!');
} else if (yapilanTekrar >= hedefTekrar) {
  print('Tekrar sayısı sağlandı, ancak ağırlık artırılmalı.');
} else {
  print('Hedefe ulaşılamadı. Aynı ağırlıkta devam edin.');
}
```

## 5.2 if-case ve Desen Eşleme (Pattern Matching)

Dart 3 ile gelen `if-case` yapısı, koşul kontrolü yaparken aynı zamanda veri desenlerini eşleştirir ve değişkenleri ayrıştırır:

```dart
var veri = [1, 2];
if (veri case [int a, int b]) {
  print('İki elemanlı liste: $a ve $b');
}
```

## 5.3 switch İfadeleri ve switch Blokları

Dart 3 ile `switch` hem bir deyim (statement) hem de bir ifade (expression) olarak kullanılabilir.

### switch İfadesi (Değer Döndüren)
```dart
String kategoriEtiketi(WorkoutCategory cat) => switch (cat) {
  WorkoutCategory.push => 'İtiş Günü (Göğüs/Omuz/Triceps)',
  WorkoutCategory.pull => 'Çekiş Günü (Sırt/Biceps)',
  WorkoutCategory.legs => 'Bacak Günü (Quad/Ham/Calf)',
};
```

### switch Bloğu (Klasik)
```dart
switch (secim) {
  case 'A':
    print('Seçenek A');
    break;
  case 'B':
    print('Seçenek B');
    break;
  default:
    print('Bilinmeyen Seçim');
}
```

## 5.4 Döngüler: for, for-in, forEach, while, do-while

### Standart for Döngüsü
```dart
for (int i = 1; i <= 3; i++) {
  print('$i. set tamamlandı.');
}
```

### for-in Döngüsü
```dart
var hareketler = ['Bench Press', 'Incline DB Press', 'Dips'];
for (final hareket in hareketler) {
  print('Egzersiz: $hareket');
}
```

### while ve do-while
```dart
int kalanSaniye = 90;
while (kalanSaniye > 0) {
  kalanSaniye--;
}

do {
  print('En az bir kez çalışır.');
} while (false);
```

## 5.5 break ve continue Kullanımı

- `break`: Döngüyü tamamen sonlandırır.
- `continue`: Döngünün o anki adımını atlayıp bir sonraki iterasyona geçer.

## 5.6 İddialar (assert)

Geliştirme aşamasında (debug mode) belirli kuralların doğrulanmasını sağlar. Canlı ortamda (production) devre dışı kalır ve performansı etkilemez:

```dart
assert(setSayisi > 0, 'Set sayısı sıfırdan büyük olmalıdır!');
assert(agirlik >= 0.0, 'Ağırlık negatif olamaz!');
```

---

# 6. Hata ve İstisna Yönetimi (Exceptions)

*Kaynak: <https://dart.dev/language/error-handling>*

## 6.1 İstisna Fırlatma (throw)

```dart
void setKontrol(int sets) {
  if (sets <= 0) {
    throw ArgumentError('Set sayısı pozitif bir tamsayı olmalıdır.');
  }
}
```

## 6.2 İstisna Yakalama: try, on, catch

- `on`: Yakalanacak istisnanın özel tipini belirtmek için kullanılır.
- `catch`: İstisna nesnesine (`e`) ve yığın izine (`s` - stack trace) erişmek için kullanılır.

```dart
try {
  int sonuc = int.parse('gecersiz_sayi');
} on FormatException catch (e) {
  print('Biçim hatası oluştu: $e');
} catch (e, stackTrace) {
  print('Beklenmeyen genel hata: $e');
  print('Hata Yığını: $stackTrace');
}
```

## 6.3 finally Bloğu

Hata oluşsa da oluşmasa da her durumda mutlaka çalıştırılması gereken kodlar için kullanılır:

```dart
try {
  baglantiAc();
} finally {
  baglantiKapat(); // Kaynakları serbest bırak
}
```

---

# 7. Dokümantasyon ve Yorum Satırları (Comments)

*Kaynak: <https://dart.dev/language/comments>*

## 7.1 Tek Satırlı ve Çok Satırlı Yorumlar

```dart
// Tek satırlı açıklama

/*
  Çok satırlı
  açıklama bloğu
*/
```

## 7.2 Dartdoc Standartları (/// ve [Referanslar])

Dart topluluğunda dokümantasyon üretmek için üç bölü (`///`) standarttır. Köşeli parantez `[SinifAdi]` içine yazılan ifadeler `dart doc` aracı tarafından otomatik tıklanabilir bağlantılara dönüştürülür:

```dart
/// Antrenman hacmini hesaplayan ve koç geri bildirimi üreten fonksiyon.
/// 
/// [sets] yapılan toplam set sayısını, [reps] tekrarı temsil eder.
/// Sonuç bir [WorkoutEvaluation] nesnesi olarak döndürülür.
WorkoutEvaluation hesapla({required int sets, required int reps}) {
  // ...
}
```

---

# 8. Kütüphaneler, Paketler ve İçe Aktarma (Libraries & Imports)

*Kaynak: <https://dart.dev/language/libraries>*

Dart modüler bir kütüphane yapısına sahiptir:

## 8.1 import Direktifi ve Önekler (as)

```dart
// Dart çekirdek kütüphanesi
import 'dart:math';

// Paket içe aktarma
import 'package:flutter/material.dart';

// İsim çakışmalarını önlemek için önek (as)
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

Element element1 = Element();
lib2.Element element2 = lib2.Element();
```

## 8.2 Seçici İçe Aktarma (show, hide)

```dart
// Yalnızca foo fonksiyonunu içe aktar:
import 'package:ornek/ornek.dart' show foo;

// bar hariç her şeyi içe aktar:
import 'package:ornek/ornek.dart' hide bar;
```

## 8.3 Gecikmeli Yükleme (deferred as)

Uygulamanın başlangıç boyutunu azaltmak ve sayfayı yalnızca ihtiyaç duyulduğunda yüklemek için kullanılır:

```dart
import 'package:agirlik_modulu/agirlik.dart' deferred as agirlikLib;

Future<void> yukle() async {
  await agirlikLib.loadLibrary();
  agirlikLib.hesapla();
}
```

---

# 9. Uygulama Mimarisi Eşleştirmesi

Bu dokümanda açıklanan tüm Dart dili prensipleri, `uygulama/v1-2026-helloworld/` klasöründeki kaynak kodlarda birebir uygulanmıştır:

1. **`int` ve `double` Kullanımı:** [`workout_set.dart`](../uygulama/v1-2026-helloworld/lib/models/workout_set.dart) modelinde set/tekrar (`int`) ve ağırlık/tonaj (`double`) tür ayrımları.
2. **`const` ve `final` Kullanımı:** [`exercise.dart`](../uygulama/v1-2026-helloworld/lib/models/exercise.dart) içinde değiştirilemez antrenman ilkeleri (`const`), anlık seans hesaplamaları (`final`).
3. **`if / else` Karar Blokları:** [`workout_calculator.dart`](../uygulama/v1-2026-helloworld/lib/services/workout_calculator.dart) motorunda tükenişe (failure / RIR 0) ulaşılma durumu ve Progressive Overload hedeflerinin analizi.
