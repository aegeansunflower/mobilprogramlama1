> **Uyarı:** Bu içerik, SCÜ Şarkışla UBYO Mobil Programlama I dersi kapsamında tamamen eğitim amaçlı çevrilmiş ve derlenmiştir. Orijinal dokümantasyon kaynakları (dart.dev, docs.flutter.dev) kendi orijinal lisanslarına (BSD-3-Clause, CC-BY 4.0) tabidir. Bu çalışmanın hiçbir ticari amacı yoktur.

# Dart Core Kütüphaneleri — Konu Anlatımı

**Mobil Programlama I · 5. Takım (kamp)** · Konu: Dart Core Libraries (`dart:core`, `dart:async`, `dart:math`, `dart:convert`, `dart:io`, JS Interop, Iterable, Future, Stream)

Bu belge, [dart.dev](https://dart.dev/guides/libraries) dokümantasyonunun ilgili bölümlerinin Türkçe çevirisidir.

## İçindekiler

1. Dart'ın Core Kütüphaneleri
2. `dart:core`
3. `dart:async`
4. `dart:math`
5. `dart:convert`
6. `dart:io`
7. JavaScript Birlikte Çalışabilirliği (JS Interop)
8. Iterable Koleksiyonları
9. Future'lar, `async` ve `await`
10. Future'lar ve Hata Yönetimi
11. Stream Kullanımı
12. Stream Oluşturma

---

## 1. Dart'ın Core Kütüphaneleri

Dart, günlük programlama görevlerinin çoğu için gereken temel işlevleri sunan zengin bir core kütüphane setine sahiptir. Örneğin; nesne koleksiyonları üzerinde çalışmak (`dart:collection`), hesaplamalar yapmak (`dart:math`) ve veriyi kodlamak/kod çözmek (`dart:convert`) gibi. Ek API'ler yaygın olarak kullanılan paketlerde mevcuttur.

### Kütüphane Turu

Aşağıdaki kılavuzlar, Dart'ın core kütüphanelerinin başlıca özelliklerinin nasıl kullanılacağını ele alır. Yalnızca genel bir bakış sunarlar; kapsamlı değildirler. Bir kütüphane veya üyeleri hakkında daha fazla ayrıntıya ihtiyaç duyduğunuzda Dart API referansına başvurun.

- **`dart:core`**
  Dahili tipler, koleksiyonlar ve diğer temel işlevler. Bu kütüphane her Dart programına otomatik olarak içe aktarılır.
- **`dart:async`**
  `Future` ve `Stream` gibi sınıflarla asenkron programlama desteği.
- **`dart:math`**
  Matematiksel sabitler ve fonksiyonlar, ayrıca rastgele sayı üreteci.
- **`dart:convert`**
  JSON ve UTF-8 dahil olmak üzere farklı veri gösterimleri arasında dönüştürme yapan kodlayıcılar ve kod çözücüler.
- **`dart:io`**
  Dart VM kullanabilen programlar (Flutter uygulamaları, sunucular ve komut satırı betikleri dahil) için I/O (girdi/çıktı).
- **`dart:js_interop`**
  Web platformuyla interop (birlikte çalışabilirlik) API'leri. `package:web` ile birlikte `dart:js_interop`, `dart:html`'in yerini alır.

Belirtildiği gibi, bu sayfalar yalnızca bir genel bakıştır; yalnızca birkaç `dart:*` kütüphanesini kapsar, üçüncü taraf kütüphaneleri kapsamaz.

Dart'ın farklı platformlarda desteklediği tüm kütüphanelere genel bakış için aşağıdaki Çoklu Platform Kütüphaneleri, Native Platform Kütüphaneleri ve Web Platform Kütüphaneleri listelerine bakın.

Kütüphane bilgisi bulabileceğiniz diğer yerler: pub.dev sitesi ve Dart web geliştirici kütüphanesi kılavuzu. Tüm `dart:*` kütüphaneleri için API dokümantasyonunu Dart API referansında veya Flutter kullanıyorsanız Flutter API referansında bulabilirsiniz.

Dart dili hakkında daha fazla bilgi için dil dokümantasyonuna ve örneklere göz atın.

### Çoklu Platform Kütüphaneleri

Aşağıdaki tablo, tüm Dart platformlarında çalışan Dart core kütüphanelerini listeler.

| Kütüphane | Notlar |
| --- | --- |
| `dart:core` | Her Dart programı için dahili tipler, koleksiyonlar ve diğer temel işlevler. |
| `dart:async`, `package:async` | `Future` ve `Stream` gibi sınıflarla asenkron programlama desteği. `package:async`, `Future` ve `Stream` tipleri etrafında ek yardımcılar sunar. |
| `dart:collection`, `package:collection` | `dart:core` içindeki koleksiyon desteğini tamamlayan sınıflar ve yardımcılar. `package:collection`, daha ileri koleksiyon uygulamaları ve koleksiyonlar üzerinde/ile çalışma fonksiyonları sunar. |
| `dart:convert`, `package:convert` | JSON ve UTF-8 dahil olmak üzere farklı veri gösterimleri arasında dönüştürme yapan kodlayıcılar ve kod çözücüler. `package:convert` ek kodlayıcılar ve kod çözücüler sunar. |
| `dart:developer` | Hata ayıklayıcı ve denetçi gibi geliştirici araçlarıyla etkileşim. Yalnızca Native JIT ve geliştirme JavaScript derleyicisi. |
| `dart:math` | Matematiksel sabitler ve fonksiyonlar, ayrıca rastgele sayı üreteci. |
| `dart:typed_data`, `package:typed_data` | Sabit boyutlu veriyi (örneğin işaretsiz 8 baytlık tam sayılar) ve SIMD sayısal tiplerini verimli bir şekilde işleyen listeler. `package:typed_data`, typed data üzerinde çalışan ek sınıflar ve fonksiyonlar sunar. |

### Native Platform Kütüphaneleri

Aşağıdaki tablo, Dart native platformunda (AOT ve JIT ile derlenen kod) çalışan Dart core kütüphanelerini listeler.

| Kütüphane | Notlar |
| --- | --- |
| `dart:ffi`, `package:ffi` | Dart kodunun native C API'lerini kullanmasını sağlayan bir FFI (Foreign Function Interface / harici fonksiyon arayüzü). `package:ffi`, Dart string'lerini ve C string'lerini dönüştürme desteği dahil yardımcılar içerir. |
| `dart:io`, `package:io` | Web dışı uygulamalar için dosya, soket, HTTP ve diğer I/O desteği. `package:io`, ANSI renkleri, dosya kopyalama ve standart çıkış kodları desteği dahil işlevsellik sunar. |
| `dart:isolate` | Isolate'ler kullanarak eşzamanlı programlama: thread'lere benzer bağımsız worker'lar/çalışanlar. |
| `dart:mirrors` | İç gözlem (introspection) ve dinamik çağrı desteğiyle temel yansıma (reflection). Deneysel. Yalnızca Native JIT (Flutter değil). |

### Web Platform Kütüphaneleri

Aşağıdaki tablo, Dart web platformunda (JavaScript'e derlenen kod) çalışan Dart core kütüphanelerini listeler. En güncel, önerilen araçlar kalın, eski araçlar italik yazılmıştır (daha fazla bilgi için Javascript interoperability bölümüne bakın).

| Kütüphane | Notlar |
| --- | --- |
| `package:web` | JS interop etrafında oluşturulmuş hafif tarayıcı API binding'leri (bağlayıcıları). Tüm `dart:*` web kütüphanelerinin yerini alır. Geçiş kılavuzunu okuyun. |
| `dart:js_interop` | JavaScript ve tarayıcı API'leri ile interop (birlikte çalışabilirlik). `package:js`'in yerini alır. |
| `dart:js_interop_unsafe` | JavaScript nesnelerini dinamik olarak işlemek için yardımcı metotlar. `dart:js_util`'in yerini alır. |
| `dart:html` *(eski)* | Web tabanlı uygulamalar için HTML elementleri ve diğer kaynaklar. Bunun yerine `package:web` kullanın. |
| `dart:indexed_db` *(eski)* | İndeks desteği olan istemci tarafı anahtar-değer deposu. Bunun yerine `package:web` kullanın. |
| `dart:js`, `dart:js_util`, `package:js` *(eski)* | JS interop için düşük seviyeli primitive'ler (temel yapılar) ve daha yüksek seviyeli anotasyonlar. Bunun yerine `dart:js_interop` veya `dart:js_interop_unsafe` kullanın. |
| `dart:svg` *(eski)* | Ölçeklenebilir Vektör Grafikleri. Bunun yerine `package:web` kullanın. |
| `dart:web_audio` *(eski)* | Tarayıcıda yüksek kaliteli ses programlama. Bunun yerine `package:web` kullanın. |
| `dart:web_gl` *(eski)* | Tarayıcıda 3B programlama. Bunun yerine `package:web` kullanın. |

---

## 2. `dart:core`

`dart:core` kütüphanesi (API referansı), küçük ama kritik bir dizi dahili işlevsellik sunar. Bu kütüphane her Dart programına otomatik olarak içe aktarılır.

### Konsola Yazdırma

Top-level (üst düzey) `print()` fonksiyonu tek bir argüman alır (herhangi bir `Object`) ve bu nesnenin string değerini (`toString()` tarafından döndürülen) konsolda gösterir.

```dart
print(anObject);
print('I drink $tea.');
```

Temel string'ler ve `toString()` hakkında daha fazla bilgi için dil turundaki Strings bölümüne bakın.

### Sayılar

`dart:core` kütüphanesi, sayılarla çalışmak için bazı temel yardımcılara sahip `num`, `int` ve `double` sınıflarını tanımlar.

Bir string'i sırasıyla `int` ve `double`'ın `parse()` metotlarıyla tam sayıya veya ondalık sayıya dönüştürebilirsiniz:

```dart
assert(int.parse('42') == 42);
assert(int.parse('0x42') == 66);
assert(double.parse('0.50') == 0.5);
```

Veya `num`'un `parse()` metodunu kullanın; bu, mümkünse bir tam sayı, aksi halde bir double oluşturur:

```dart
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
```

Bir tam sayının tabanını belirtmek için bir `radix` parametresi ekleyin:

```dart
assert(int.parse('42', radix: 16) == 66);
```

Bir `int` veya `double`'ı string'e dönüştürmek için `toString()` metodunu kullanın. Ondalık noktasının sağındaki basamak sayısını belirtmek için `toStringAsFixed()` kullanın. String'deki anlamlı basamak sayısını belirtmek için `toStringAsPrecision()` kullanın:

```dart
// Convert an int to a string.
assert(42.toString() == '42');

// Convert a double to a string.
assert(123.456.toString() == '123.456');

// Specify the number of digits after the decimal.
assert(123.456.toStringAsFixed(2) == '123.46');

// Specify the number of significant figures.
assert(123.456.toStringAsPrecision(2) == '1.2e+2');
assert(double.parse('1.2e+2') == 120.0);
```

Daha fazla bilgi için `int`, `double` ve `num` API dokümantasyonuna bakın. Ayrıca `dart:math` bölümüne de göz atın.

### String'ler ve Düzenli İfadeler

Dart'ta bir string, UTF-16 kod birimlerinin değiştirilemez (immutable) bir dizisidir. Dil turu string'ler hakkında daha fazla bilgi içerir. String'ler içinde arama yapmak ve string parçalarını değiştirmek için düzenli ifadeler (`RegExp` nesneleri) kullanabilirsiniz.

`String` sınıfı `split()`, `contains()`, `startsWith()`, `endsWith()` ve daha fazlası gibi metotları tanımlar.

#### Bir string içinde arama

Bir string içinde belirli konumları bulabilir, ayrıca bir string'in belirli bir kalıpla başlayıp başlamadığını veya bittiğini kontrol edebilirsiniz. Örneğin:

```dart
// Check whether a string contains another string.
assert('Never odd or even'.contains('odd'));

// Does a string start with another string?
assert('Never odd or even'.startsWith('Never'));

// Does a string end with another string?
assert('Never odd or even'.endsWith('even'));

// Find the location of a string inside a string.
assert('Never odd or even'.indexOf('odd') == 6);
```

#### Bir string'den veri çıkarma

Bir string'den tek tek karakterleri sırasıyla `String` veya `int` olarak alabilirsiniz. Daha kesin olmak gerekirse, aslında tek tek UTF-16 kod birimleri alırsınız; tiz nota anahtarı sembolü (`'\u{1D11E}'`) gibi yüksek numaralı karakterler ikişer kod birimidir.

Ayrıca bir alt string çıkarabilir veya bir string'i alt string'ler listesine bölebilirsiniz:

```dart
// Grab a substring.
assert('Never odd or even'.substring(6, 9) == 'odd');

// Split a string using a string pattern.
var parts = 'progressive web apps'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'progressive');

// Get a UTF-16 code unit (as a string) by index.
assert('Never odd or even'[0] == 'N');

// Use split() with an empty string parameter to get
// a list of all characters (as Strings); good for
// iterating.
for (final char in 'hello'.split('')) {
  print(char);
}

// Get all the UTF-16 code units in the string.
var codeUnitList = 'Never odd or even'.codeUnits.toList();
assert(codeUnitList[0] == 78);
```

> **Not:** Çoğu durumda, saf kod birimleri yerine Unicode grapheme kümeleriyle çalışmak istersiniz. Bunlar kullanıcının algıladığı karakterlerdir (örneğin "🇬🇧" kullanıcı tarafından algılanan tek bir karakterdir ama birkaç UTF-16 kod birimidir). Bunun için Dart ekibi `characters` paketini sunar.

#### Büyük/küçük harfe dönüştürme

String'leri kolayca büyük ve küçük harf varyantlarına dönüştürebilirsiniz:

```dart
// Convert to uppercase.
assert('web apps'.toUpperCase() == 'WEB APPS');

// Convert to lowercase.
assert('WEB APPS'.toLowerCase() == 'web apps');
```

> **Not:** Bu metotlar her dil için çalışmaz. Örneğin, Türk alfabesindeki noktasız I yanlış dönüştürülür.

#### Kırpma ve boş string'ler

Baştaki ve sondaki tüm boşlukları `trim()` ile kaldırın. Bir string'in boş olup olmadığını (uzunluğu sıfır) kontrol etmek için `isEmpty` kullanın.

```dart
// Trim a string.
assert('  hello  '.trim() == 'hello');

// Check whether a string is empty.
assert(''.isEmpty);

// Strings with only white space are not empty.
assert('  '.isNotEmpty);
```

#### Bir string'in bir kısmını değiştirme

String'ler değiştirilemez (immutable) nesnelerdir; yani onları oluşturabilirsiniz ama değiştiremezsiniz. `String` API referansına yakından bakarsanız, metotların hiçbirinin aslında bir `String`'in durumunu değiştirmediğini fark edersiniz. Örneğin, `replaceAll()` metodu orijinal `String`'i değiştirmeden yeni bir `String` döndürür:

```dart
var greetingTemplate = 'Hello, NAME!';
var greeting = greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate didn't change.
assert(greeting != greetingTemplate);
```

#### Bir string oluşturma

Programlı olarak bir string üretmek için `StringBuffer` kullanabilirsiniz. Bir `StringBuffer`, `toString()` çağrılana kadar yeni bir `String` nesnesi üretmez. `writeAll()` metodunun isteğe bağlı ikinci bir parametresi vardır; bu, bir ayırıcı belirtmenizi sağlar—bu durumda bir boşluk.

```dart
var sb = StringBuffer();
sb
  ..write('Use a StringBuffer for ')
  ..writeAll(['efficient', 'string', 'creation'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString == 'Use a StringBuffer for efficient string creation.');
```

#### Düzenli ifadeler

`RegExp` sınıfı, JavaScript düzenli ifadeleriyle aynı yetenekleri sunar. String'lerde verimli arama ve kalıp eşleştirme için düzenli ifadeleri kullanın.

```dart
// Here's a regular expression for one or more digits.
var digitSequence = RegExp(r'\d+');

var lettersOnly = 'llamas live fifteen to twenty years';
var someDigits = 'llamas live 15 to 20 years';

// contains() can use a regular expression.
assert(!lettersOnly.contains(digitSequence));
assert(someDigits.contains(digitSequence));

// Replace every match with another string.
var exedOut = someDigits.replaceAll(digitSequence, 'XX');
assert(exedOut == 'llamas live XX to XX years');
```

Doğrudan `RegExp` sınıfıyla da çalışabilirsiniz. `Match` sınıfı bir düzenli ifade eşleşmesine erişim sağlar.

```dart
var digitSequence = RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// Check whether the reg exp has a match in a string.
assert(digitSequence.hasMatch(someDigits));

// Loop through all matches.
for (final match in digitSequence.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
```

#### Daha fazla bilgi

Metotların tam listesi için `String` API referansına başvurun. Ayrıca `StringBuffer`, `Pattern`, `RegExp` ve `Match` API referanslarına da bakın.

### Koleksiyonlar

Dart, listeler, set'ler ve map'ler için sınıflar içeren bir core koleksiyon API'siyle birlikte gelir.

> **İpucu:** Hem listeler hem de set'ler için mevcut olan API'leri kullanma alıştırması yapmak için Iterable koleksiyonları eğitimini izleyin.

#### Listeler

Dil turunun gösterdiği gibi, listeleri oluşturmak ve başlatmak için literal'leri kullanabilirsiniz. Alternatif olarak `List` constructor'larından birini kullanın. `List` sınıfı ayrıca listelere öğe ekleme ve listelerden öğe kaldırma için çeşitli metotlar tanımlar.

```dart
// Create an empty list of strings.
var grains = <String>[];
assert(grains.isEmpty);

// Create a list using a list literal.
var fruits = ['apples', 'oranges'];

// Add to a list.
fruits.add('kiwis');

// Add multiple items to a list.
fruits.addAll(['grapes', 'bananas']);

// Get the list length.
assert(fruits.length == 5);

// Remove a single item.
var appleIndex = fruits.indexOf('apples');
fruits.removeAt(appleIndex);
assert(fruits.length == 4);

// Remove all elements from a list.
fruits.clear();
assert(fruits.isEmpty);

// You can also create a List using one of the constructors.
var vegetables = List.filled(99, 'broccoli');
assert(vegetables.every((v) => v == 'broccoli'));
```

Bir listedeki bir nesnenin indeksini bulmak için `indexOf()` kullanın:

```dart
var fruits = ['apples', 'oranges'];

// Access a list item by index.
assert(fruits[0] == 'apples');

// Find an item in a list.
assert(fruits.indexOf('apples') == 0);
```

Bir listeyi `sort()` metoduyla sıralayın. İki nesneyi karşılaştıran bir sıralama fonksiyonu sağlayabilirsiniz. Bu sıralama fonksiyonu küçük için `< 0`, aynı için `0` ve büyük için `> 0` döndürmelidir. Aşağıdaki örnek, `Comparable` tarafından tanımlanan ve `String` tarafından uygulanan `compareTo()` kullanır.

```dart
var fruits = ['bananas', 'apples', 'oranges'];

// Sort a list.
fruits.sort((a, b) => a.compareTo(b));
assert(fruits[0] == 'apples');
```

Listeler parametreli tiplerdir (generic'ler), bu yüzden bir listenin içermesi gereken tipi belirtebilirsiniz:

```dart
// This list should contain only strings.
var fruits = <String>[];

fruits.add('apples');
var fruit = fruits[0];
assert(fruit is String);

fruits.add(5); // Error: 'int' can't be assigned to 'String'
```

> **Not:** Çoğu durumda, generic tipleri açıkça belirtmenize gerek yoktur çünkü Dart bunları sizin için çıkarım yapar. `['Dash', 'Dart']` gibi bir liste `List<String>` (okunuşu: string listesi) olarak anlaşılır.
>
> Ancak generic tipi belirtmeniz gereken durumlar vardır. Örneğin, Dart'ın çıkarım yapacak hiçbir şeyi olmadığında: `[]` herhangi bir şeyin bir kombinasyonunun listesi olabilir. Bu genellikle istediğiniz şey değildir, bu yüzden `<String>[]` veya `<Person>[]` ya da benzer bir şey yazarsınız.

Metotların tam listesi için `List` API referansına bakın.

#### Set'ler

Dart'ta bir set, benzersiz öğelerin sırasız bir koleksiyonudur. Bir set sırasız olduğundan, öğelerine indeks (konum) ile erişemezsiniz.

```dart
// Create an empty set of strings.
var ingredients = <String>{};

// Add new items to it.
ingredients.addAll(['gold', 'titanium', 'xenon']);
assert(ingredients.length == 3);

// Adding a duplicate item has no effect.
ingredients.add('gold');
assert(ingredients.length == 3);

// Remove an item from a set.
ingredients.remove('gold');
assert(ingredients.length == 2);

// You can also create sets using
// one of the constructors.
var atomicNumbers = Set.from([79, 22, 54]);
```

Bir veya daha fazla nesnenin bir set içinde olup olmadığını kontrol etmek için `contains()` ve `containsAll()` kullanın:

```dart
var ingredients = Set<String>();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Check whether an item is in the set.
assert(ingredients.contains('titanium'));

// Check whether all the items are in the set.
assert(ingredients.containsAll(['titanium', 'xenon']));
```

Bir kesişim (intersection), öğeleri diğer iki set içinde olan bir settir.

```dart
var ingredients = Set<String>();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Create the intersection of two sets.
var nobleGases = Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
```

Metotların tam listesi için `Set` API referansına bakın.

#### Map'ler

Bir map, yaygın olarak sözlük (dictionary) veya hash olarak bilinen, anahtar-değer çiftlerinin sırasız bir koleksiyonudur. Map'ler kolay erişim için bir anahtarı bir değere ilişkilendirir. JavaScript'ten farklı olarak, Dart nesneleri map değildir.

Bir map'i kısa bir literal söz dizimiyle bildirebilir veya geleneksel bir constructor (kurucu metot) kullanabilirsiniz:

```dart
// Maps often use strings as keys.
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu'],
};

// Maps can be built from a constructor.
var searchTerms = Map();

// Maps are parameterized types; you can specify what
// types the key and value should be.
var nobleGases = Map<int, String>();
```

Map öğelerini köşeli parantez söz dizimini kullanarak ekler, alır ve ayarlarsınız. Bir map'ten bir anahtarı ve değerini kaldırmak için `remove()` kullanın.

```dart
var nobleGases = {54: 'xenon'};

// Retrieve a value with a key.
assert(nobleGases[54] == 'xenon');

// Check whether a map contains a key.
assert(nobleGases.containsKey(54));

// Remove a key and its value.
nobleGases.remove(54);
assert(!nobleGases.containsKey(54));
```

Bir map'ten tüm değerleri veya tüm anahtarları alabilirsiniz:

```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu'],
};

// Get all the keys as an unordered collection
// (an Iterable).
var keys = hawaiianBeaches.keys;

assert(keys.length == 3);
assert(keys.contains('Oahu'));

// Get all the values as an unordered collection
// (an Iterable of Lists).
var values = hawaiianBeaches.values;
assert(values.length == 3);
assert(values.any((v) => v.contains('Waikiki')));
```

Bir map'in bir anahtar içerip içermediğini kontrol etmek için `containsKey()` kullanın. Map değerleri `null` olabildiğinden, bir anahtarın varlığını belirlemek için anahtarın değerini alıp `null` olup olmadığını kontrol etmeye güvenemezsiniz.

```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu'],
};

assert(hawaiianBeaches.containsKey('Oahu'));
assert(!hawaiianBeaches.containsKey('Florida'));
```

Bir anahtara yalnızca ve yalnızca o anahtar map'te zaten yoksa bir değer atamak istediğinizde `putIfAbsent()` metodunu kullanın. Değeri döndüren bir fonksiyon sağlamalısınız.

```dart
var teamAssignments = <String, String>{};
teamAssignments.putIfAbsent('Catcher', () => pickToughestKid());
assert(teamAssignments['Catcher'] != null);
```

Metotların tam listesi için `Map` API referansına bakın.

#### Ortak koleksiyon metotları

`List`, `Set` ve `Map` birçok koleksiyonda bulunan ortak işlevselliği paylaşır. Bu ortak işlevselliğin bir kısmı, `List` ve `Set`'in uyguladığı `Iterable` sınıfı tarafından tanımlanır.

> **Not:** `Map` `Iterable` uygulamasa da, `Map`'in `keys` ve `values` özelliklerini kullanarak ondan `Iterable`'lar elde edebilirsiniz.

Bir liste, set veya map'in öğeleri olup olmadığını kontrol etmek için `isEmpty` veya `isNotEmpty` kullanın:

```dart
var coffees = <String>[];
var teas = ['green', 'black', 'chamomile', 'earl grey'];
assert(coffees.isEmpty);
assert(teas.isNotEmpty);
```

Bir liste, set veya map'teki her öğeye bir fonksiyon uygulamak için `forEach()` kullanabilirsiniz:

```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

teas.forEach((tea) => print('I drink $tea'));
```

Bir map üzerinde `forEach()` çağırdığınızda, fonksiyonunuz iki argüman almalıdır (anahtar ve değer):

```dart
hawaiianBeaches.forEach((k, v) {
  print('I want to visit $k and swim at $v');
  // I want to visit Oahu and swim at
  // [Waikiki, Kailua, Waimanalo], etc.
});
```

Iterable'lar, tüm sonuçları tek bir nesnede veren `map()` metodunu sağlar:

```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

var loudTeas = teas.map((tea) => tea.toUpperCase());
loudTeas.forEach(print);
```

> **Not:** `map()` tarafından döndürülen nesne, tembel (lazy) olarak değerlendirilen bir `Iterable`'dır: fonksiyonunuz, döndürülen nesneden bir öğe isteyene kadar çağrılmaz.

Fonksiyonunuzun her öğede hemen çağrılmasını zorlamak için `map().toList()` veya `map().toSet()` kullanın:

```dart
var loudTeas = teas.map((tea) => tea.toUpperCase()).toList();
```

Bir koşula uyan tüm öğeleri almak için `Iterable`'ın `where()` metodunu kullanın. Bazı veya tüm öğelerin bir koşula uyup uymadığını kontrol etmek için `Iterable`'ın `any()` ve `every()` metotlarını kullanın.

```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

// Chamomile is not caffeinated.
bool isDecaffeinated(String teaName) => teaName == 'chamomile';

// Use where() to find only the items that return true
// from the provided function.
var decaffeinatedTeas = teas.where((tea) => isDecaffeinated(tea));
// or teas.where(isDecaffeinated)

// Use any() to check whether at least one item in the
// collection satisfies a condition.
assert(teas.any(isDecaffeinated));

// Use every() to check whether all the items in a
// collection satisfy a condition.
assert(!teas.every(isDecaffeinated));
```

Metotların tam listesi için `Iterable` API referansına, ayrıca `List`, `Set` ve `Map` referanslarına bakın.

### URI'ler

`Uri` sınıfı, URI'larda (URL olarak da bilir) kullanılmak üzere string'leri kodlamak ve kodunu çözmek için fonksiyonlar sağlar. Bu fonksiyonlar `&` ve `=` gibi URI'lar için özel olan karakterleri işler. `Uri` sınıfı ayrıca bir URI'nın bileşenlerini—host, port, scheme vb.—ayrıştırır ve açığa çıkarır.

#### Tam nitelikli URI'ları kodlama ve kodunu çözme

Bir URI'da özel anlamı olan karakterler (`/`, `:`, `&`, `#` gibi) dışındaki karakterleri kodlamak ve kodunu çözmek için `encodeFull()` ve `decodeFull()` metotlarını kullanın. Bu metotlar, özel URI karakterlerini koruyarak tam nitelikli bir URI'yi kodlamak veya kodunu çözmek için iyidir.

```dart
var uri = 'https://example.org/api?foo=some message';

var encoded = Uri.encodeFull(uri);
assert(encoded == 'https://example.org/api?foo=some%20message');

var decoded = Uri.decodeFull(encoded);
assert(uri == decoded);
```

`some` ile `message` arasındaki boşluğun nasıl yalnızca kodlandığına dikkat edin.

#### URI bileşenlerini kodlama ve kodunu çözme

Bir string'in URI'da özel anlamı olan tüm karakterlerini (`/`, `&` ve `:` dahil ancak bunlarla sınırlı olmamak üzere) kodlamak ve kodunu çözmek için `encodeComponent()` ve `decodeComponent()` metotlarını kullanın.

```dart
var uri = 'https://example.org/api?foo=some message';

var encoded = Uri.encodeComponent(uri);
assert(
  encoded == 'https%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message',
);

var decoded = Uri.decodeComponent(encoded);
assert(uri == decoded);
```

Her özel karakterin nasıl kodlandığına dikkat edin. Örneğin, `/` karakteri `%2F` olarak kodlanır.

#### URI'ları ayrıştırma

Bir `Uri` nesneniz veya bir URI string'iniz varsa, `path` gibi `Uri` alanlarını kullanarak parçalarını alabilirsiniz. Bir string'den bir `Uri` oluşturmak için `parse()` statik metodunu kullanın:

```dart
var uri = Uri.parse('https://example.org:8080/foo/bar#frag');

assert(uri.scheme == 'https');
assert(uri.host == 'example.org');
assert(uri.path == '/foo/bar');
assert(uri.fragment == 'frag');
assert(uri.origin == 'https://example.org:8080');
```

Alabileceğiniz daha fazla URI bileşeni için `Uri` API referansına bakın.

#### URI'lar oluşturma

`Uri()` constructor'ını kullanarak tek tek parçalardan bir URI oluşturabilirsiniz:

```dart
var uri = Uri(
  scheme: 'https',
  host: 'example.org',
  path: '/foo/bar',
  fragment: 'frag',
  queryParameters: {'lang': 'dart'},
);
assert(uri.toString() == 'https://example.org/foo/bar?lang=dart#frag');
```

Bir fragment belirtmenize gerek yoksa, `http` veya `https` şemalı bir URI oluşturmak için bunun yerine `Uri.http` veya `Uri.https` factory constructor'larını kullanabilirsiniz:

```dart
var httpUri = Uri.http('example.org', '/foo/bar', {'lang': 'dart'});
var httpsUri = Uri.https('example.org', '/foo/bar', {'lang': 'dart'});

assert(httpUri.toString() == 'http://example.org/foo/bar?lang=dart');
assert(httpsUri.toString() == 'https://example.org/foo/bar?lang=dart');
```

### Tarihler ve Zamanlar

Bir `DateTime` nesnesi zaman içinde bir noktadır. Saat dilimi ya UTC ya da yerel saat dilimidir.

`DateTime` nesnelerini çeşitli constructor'lar ve metotlar kullanarak oluşturabilirsiniz:

```dart
// Get the current date and time.
var now = DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000, isUtc: true);

// Parse an ISO 8601 date in the UTC time zone.
y2k = DateTime.parse('2000-01-01T00:00:00Z');

// Create a new DateTime from an existing one, adjusting just some properties:
var sameTimeLastYear = now.copyWith(year: now.year - 1);
```

> **Uyarı:** `DateTime` işlemleri, Yaz Saati Uygulaması ve diğer standart dışı zaman ayarlamalarıyla ilgili beklenmedik sonuçlar verebilir.

Bir tarihin `millisecondsSinceEpoch` özelliği, "Unix epoch"—1 Ocak 1970, UTC—'tan bu yana geçen milisaniye sayısını döndürür:

```dart
// 1/1/2000, UTC
var y2k = DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 1/1/1970, UTC
var unixEpoch = DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
```

İki tarih arasındaki farkı hesaplamak ve bir tarihi ileri veya geri kaydırmak için `Duration` sınıfını kullanın:

```dart
var y2k = DateTime.utc(2000);

// Add one year.
var y2001 = y2k.add(const Duration(days: 366));
assert(y2001.year == 2001);

// Subtract 30 days.
var december2000 = y2001.subtract(const Duration(days: 30));
assert(december2000.year == 2000);
assert(december2000.month == 12);

// Calculate the difference between two dates.
// Returns a Duration object.
var duration = y2001.difference(y2k);
assert(duration.inDays == 366); // y2k was a leap year.
```

> **Uyarı:** Saat kaymaları (örneğin yaz saati uygulamasına geçiş) nedeniyle bir `DateTime`'ı günlerce kaydırmak için bir `Duration` kullanmak sorunlu olabilir. Günleri kaydırmanız gerekiyorsa UTC tarihleri kullanın.

Metotların tam listesi için `DateTime` ve `Duration` API referanslarına bakın.

### Yardımcı Sınıflar

Core kütüphanesi, sıralama, değerleri eşleme ve iterasyon için yararlı olan çeşitli yardımcı sınıflar içerir.

#### Nesneleri karşılaştırma

Bir nesnenin başka bir nesneyle karşılaştırılabileceğini belirtmek için—genellikle sıralama için—`Comparable` arayüzünü uygulayın. `compareTo()` metodu küçük için `< 0`, aynı için `0` ve büyük için `> 0` döndürür.

```dart
class Line implements Comparable<Line> {
  final int length;
  const Line(this.length);

  @override
  int compareTo(Line other) => length - other.length;
}

void main() {
  var short = const Line(1);
  var long = const Line(100);
  assert(short.compareTo(long) < 0);
}
```

#### Map anahtarlarını uygulama (Implementing Map Keys)

Dart'taki her nesne otomatik olarak bir tam sayı hash kodu sağlar ve böylece bir map'te anahtar olarak kullanılabilir. Ancak, özel bir hash kodu üretmek için `hashCode` getter'ını geçersiz kılabilirsiniz. Bunu yaparsanız, `==` operatörünü de geçersiz kılmak isteyebilirsiniz. Eşit olan (`==` ile) nesneler aynı hash kodlarına sahip olmalıdır. Bir hash kodu benzersiz olmak zorunda değildir, ancak iyi dağıtılmış olmalıdır.

> **İpucu:** `hashCode` getter'ını tutarlı ve kolay bir şekilde uygulamak için `Object` sınıfı tarafından sağlanan statik hash metotlarını kullanmayı düşünün.

Bir nesnenin birden çok özelliği için tek bir hash kodu üretmek üzere `Object.hash()` kullanabilirsiniz. Bir koleksiyon için bir hash kodu üretmek için `Object.hashAll()` (öğe sırası önemliyse) veya `Object.hashAllUnordered()` kullanabilirsiniz.

```dart
class Person {
  final String firstName, lastName;

  Person(this.firstName, this.lastName);

  // Override hashCode using the static hashing methods
  // provided by the `Object` class.
  @override
  int get hashCode => Object.hash(firstName, lastName);

  // You should generally implement operator `==` if you
  // override `hashCode`.
  @override
  bool operator ==(Object other) {
    return other is Person &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }
}

void main() {
  var p1 = Person('Bob', 'Smith');
  var p2 = Person('Bob', 'Smith');
  var p3 = 'not a person';
  assert(p1.hashCode == p2.hashCode);
  assert(p1 == p2);
  assert(p1 != p3);
}
```

#### İterasyon

`Iterable` ve `Iterator` sınıfları, bir değerler koleksiyonuna sıralı erişimi destekler. Bu koleksiyonları kullanma alıştırması yapmak için Iterable koleksiyonları eğitimini izleyin.

`for-in` döngülerinde kullanılmak üzere `Iterator`'lar sağlayabilen bir sınıf oluşturursanız, (mümkünse) `Iterable`'ı genişletin veya uygulayın. Gerçek iterasyon yeteneğini tanımlamak için `Iterator` uygulayın.

```dart
class Process {
  // Represents a process...
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => ...
  @override
  bool moveNext() => ...
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (final process in Processes()) {
    // Do something with the process.
  }
}
```

### İstisnalar

Dart core kütüphanesi birçok yaygın istisna (exception) ve hata (error) tanımlar. İstisnalar, önceden planlayıp yakalayabileceğiniz durumlar olarak kabul edilir. Hatalar ise beklemediğiniz veya planlamadığınız durumlardır.

En yaygın hatalardan birkaçı:

- **`NoSuchMethodError`**
  Bir alıcı nesne (`null` olabilir) bir metodu uygulamadığında fırlatılır.
- **`ArgumentError`**
  Beklenmedik bir argümanla karşılaşan bir metot tarafından fırlatılabilir.

Uygulamaya özel bir istisna fırlatmak, bir hatanın oluştuğunu belirtmenin yaygın bir yoludur. `Exception` arayüzünü uygulayarak özel bir istisna tanımlayabilirsiniz:

```dart
class FooException implements Exception {
  final String? msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
```

Daha fazla bilgi için İstisnalar (dil turunda) ve `Exception` API referansına bakın.

### Zayıf Referanslar ve Finalizer'lar

Dart, çöp toplayıcı (garbage-collected) bir dildir; yani referans verilmeyen herhangi bir Dart nesnesi çöp toplayıcı tarafından yok edilebilir. Bu varsayılan davranış, native kaynakları içeren veya hedef nesnenin değiştirilemediği bazı senaryolarda istenmeyebilir.

Bir `WeakReference`, hedef nesneye, çöp toplayıcı tarafından nasıl toplandığını etkilemeyen bir referans saklar. Başka bir seçenek, bir nesneye özellik eklemek için bir `Expando` kullanmaktır.

Bir `Finalizer`, bir nesneye artık referans verilmediğinde bir geri çağırma (callback) fonksiyonu çalıştırmak için kullanılabilir. Ancak, bu geri çağırmanın çalıştırılacağı garanti edilmez.

Bir `NativeFinalizer`, `dart:ffi` kullanarak native kodla etkileşim için daha güçlü garantiler sağlar; geri çağırma, nesneye artık referans verilmediğinde en az bir kez çağrılır. Ayrıca, bir veritabanı bağlantısı veya açık dosyalar gibi native kaynakları kapatmak için kullanılabilir.

Bir nesnenin çöp toplanmasını ve çok erken sonlandırılmasını önlemek için sınıflar `Finalizable` arayüzünü uygulayabilir. Yerel bir değişken `Finalizable` olduğunda, bildirildiği kod bloğu çıkılana kadar çöp toplanmaz.

> **Sürüm notu:** Zayıf referanslar ve finalizer desteği Dart 2.17'de eklenmiştir.

---

## 3. `dart:async`

Asenkron programlama genellikle geri çağırma fonksiyonları kullanır, ancak Dart alternatifler sunar: `Future` ve `Stream` nesneleri. Bir `Future`, gelecekte bir noktada sağlanacak bir sonuç için bir sözdür (promise). Bir `Stream` ise bir değer dizisi—örneğin olaylar—elde etmenin bir yoludur. `Future`, `Stream` ve daha fazlası `dart:async` kütüphanesindedir (API referansı).

> **Not:** `Future` veya `Stream` API'lerini her zaman doğrudan kullanmanız gerekmez. Dart dili, `async` ve `await` gibi anahtar kelimeler kullanarak asenkron kodlamayı destekler. Ayrıntılar için asenkron programlama eğitimine bakın.

`dart:async` kütüphanesi hem web uygulamalarında hem de komut satırı uygulamalarında çalışır. Kullanmak için `dart:async`'i içe aktarın:

```dart
import 'dart:async';
```

> **İpucu:** `Future` ve `Stream` API'lerini kullanmak için `dart:async`'i içe aktarmanıza gerek yoktur, çünkü `dart:core` bu sınıfları dışa aktarır.

### Future

`Future` nesneleri Dart kütüphaneleri boyunca görünür; genellikle bir asenkron metot tarafından döndürülen nesne olarak. Bir future tamamlandığında, değeri kullanıma hazırdır.

#### `await` kullanma

`Future` API'sini doğrudan kullanmadan önce, bunun yerine `await` kullanmayı düşünün. `await` ifadeleri kullanan kod, `Future` API'sini kullanan koddan daha anlaşılır olabilir.

Aşağıdaki fonksiyonu düşünün. `Future`'ın `then()` metodunu kullanarak üç asenkron fonksiyonu art arda çalıştırır ve her biri tamamlanmadan önce bir sonrakini çalıştırmayı bekler.

```dart
void runUsingFuture() {
  // ...
  findEntryPoint()
      .then((entryPoint) {
        return runExecutable(entryPoint, args);
      })
      .then(flushThenExit);
}
```

`await` ifadeleriyle eşdeğer kod, senkron koda daha çok benzer:

```dart
Future<void> runUsingAsyncAwait() async {
  // ...
  var entryPoint = await findEntryPoint();
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
}
```

Bir `async` fonksiyonu `Future`'lardan istisnaları yakalayabilir. Örneğin:

```dart
var entryPoint = await findEntryPoint();
try {
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
} catch (e) {
  // Handle the error...
}
```

> **Önemli:** `async` fonksiyonlar `Future` döndürür. Fonksiyonunuzun bir future döndürmesini istemiyorsanız, farklı bir çözüm kullanın. Örneğin, fonksiyonunuzdan bir `async` fonksiyonu çağırabilirsiniz.

`await` ve ilgili Dart dil özelliklerini kullanma hakkında daha fazla bilgi için asenkron programlama eğitimine bakın.

#### Temel kullanım

`then()` metodunu, future tamamlandığında çalışan kodu planlamak için kullanabilirsiniz. Örneğin, `Client.read()` bir `Future` döndürür, çünkü HTTP istekleri biraz zaman alabilir. `then()` kullanmak, o `Future` tamamlandığında ve söz verilen string değeri mevcut olduğunda bir miktar kod çalıştırmanıza olanak tanır:

```dart
httpClient.read(url).then((String result) {
  print(result);
});
```

Bir `Future` nesnesinin fırlatabileceği hataları veya istisnaları işlemek için `catchError()` kullanın.

```dart
httpClient
    .read(url)
    .then((String result) {
      print(result);
    })
    .catchError((e) {
      // Handle or ignore the error.
    });
```

`then().catchError()` kalıbı, `try-catch`'in asenkron versiyonudur.

> **Önemli:** `catchError()`'u mutlaka `then()`'in sonucu üzerinde çağırın—orijinal `Future`'ın sonucu üzerinde değil. Aksi halde `catchError()`, yalnızca orijinal `Future`'ın hesaplamasından gelen hataları işleyebilir, ancak `then()` tarafından kaydedilen işleyiciden gelenleri işleyemez.

#### Birden çok asenkron metodu zincirleme

`then()` metodu bir `Future` döndürerek birden çok asenkron fonksiyonu belirli bir sırayla çalıştırmanın kullanışlı bir yolunu sunar. `then()` ile kaydedilen geri çağırma bir `Future` döndürürse, `then()` geri çağırma tarafından döndürülen `Future` ile aynı sonuçla tamamlanacak bir `Future` döndürür. Geri çağırma başka bir türden bir değer döndürürse, `then()` bu değerle tamamlanan yeni bir `Future` oluşturur.

```dart
Future result = costlyQuery(url);
result
    .then((value) => expensiveWork(value))
    .then((_) => lengthyComputation())
    .then((_) => print('Done!'))
    .catchError((exception) {
      /* Handle exception... */
    });
```

Önceki örnekte, metotlar aşağıdaki sırayla çalışır:

1. `costlyQuery()`
2. `expensiveWork()`
3. `lengthyComputation()`

Aynı kod `await` kullanılarak yazılmış hali:

```dart
try {
  final value = await costlyQuery(url);
  await expensiveWork(value);
  await lengthyComputation();
  print('Done!');
} catch (e) {
  /* Handle exception... */
}
```

#### Birden çok future'ı bekleme

Bazen algoritmanızın birçok asenkron fonksiyonu çağırması ve devam etmeden önce hepsinin tamamlanmasını beklemesi gerekir. Birden çok `Future`'ı yönetmek ve tamamlanmalarını beklemek için `Future.wait()` statik metodunu kullanın:

```dart
Future<void> deleteLotsOfFiles() async => /* ... */
Future<void> copyLotsOfFiles() async => /* ... */
Future<void> checksumLotsOfOtherFiles() async => /* ... */

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
```

`Future.wait()`, sağlanan tüm future'lar tamamlandığında tamamlanan bir future döndürür. Ya sonuçlarıyla ya da sağlanan future'lardan herhangi biri başarısız olursa bir hatayla tamamlanır.

#### Birden çok future için hata yönetimi

Ayrıca şu paralel işlemleri bekleyebilirsiniz:

- Future'lardan oluşan bir iterable
- Konumsal alanları future olan bir record

Bu extension'lar, sağlanan tüm future'ların sonuç değerleriyle bir `Future` döndürür. `Future.wait`'in aksine, hataları da işlemenize olanak tanırlar.

Koleksiyondaki herhangi bir future bir hatayla tamamlanırsa, `wait` bir `ParallelWaitError` ile tamamlanır. Bu, çağıranın bireysel hataları işlemesine ve gerekirse başarılı sonuçları atmasına olanak tanır.

Her future'dan sonuç değerlerine ihtiyacınız olmadığında, bir future iterable'ı üzerinde `wait` kullanın:

```dart
Future<int> delete() async => ...;
Future<String> copy() async => ...;
Future<bool> errorResult() async => ...;

void main() async {
  try {
    // Wait for each future in a list, returns a list of futures:
    var results = await [delete(), copy(), errorResult()].wait;
  } on ParallelWaitError<List<bool?>, List<AsyncError?>> catch (e) {
    print(e.values[0]);    // Prints successful future
    print(e.values[1]);    // Prints successful future
    print(e.values[2]);    // Prints null when the result is an error

    print(e.errors[0]);    // Prints null when the result is successful
    print(e.errors[1]);    // Prints null when the result is successful
    print(e.errors[2]);    // Prints error
  }
}
```

Her future'dan bireysel sonuç değerlerine ihtiyacınız olduğunda, bir future record'u üzerinde `wait` kullanın. Bu, future'ların farklı tiplerde olabileceği ek avantajını sağlar:

```dart
Future<int> delete() async => ...;
Future<String> copy() async => ...;
Future<bool> errorResult() async => ...;

void main() async {
  try {
    // Wait for each future in a record.
    // Returns a record of futures that you can destructure.
    final (deleteInt, copyString, errorBool) =
        await (delete(), copy(), errorResult()).wait;

    // Do something with the results...
  } on ParallelWaitError<
    (int?, String?, bool?),
    (AsyncError?, AsyncError?, AsyncError?)
  > catch (e) {
    // ...
  }
}
```

### Stream

`Stream` nesneleri Dart API'leri boyunca görünür ve veri dizilerini temsil eder. Örneğin, buton tıklamaları gibi HTML olayları stream'ler kullanılarak iletilir. Bir dosyayı da bir stream olarak okuyabilirsiniz.

#### Asenkron for döngüsü kullanma

Bazen `Stream` API'sini kullanmak yerine bir asenkron for döngüsü (`await for`) kullanabilirsiniz.

Aşağıdaki fonksiyonu düşünün. Her dosyayı veya dizini arayan bir fonksiyon literal'i geçirerek bir dosya listesine abone olmak için `Stream`'in `listen()` metodunu kullanır.

```dart
void main(List<String> arguments) {
  // ...
  FileSystemEntity.isDirectory(searchPath).then((isDir) {
    if (isDir) {
      final startingDir = Directory(searchPath);
      startingDir.list().listen((entity) {
        if (entity is File) {
          searchFile(entity, searchTerms);
        }
      });
    } else {
      searchFile(File(searchPath), searchTerms);
    }
  });
}
```

Bir asenkron for döngüsü (`await for`) dahil `await` ifadeleriyle eşdeğer kod, senkron koda daha çok benzer:

```dart
void main(List<String> arguments) async {
  // ...
  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    await for (final entity in startingDir.list()) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(File(searchPath), searchTerms);
  }
}
```

> **Önemli:** `await for` kullanmadan önce, kodun daha net olduğundan ve stream'in tüm sonuçlarını beklemek istediğinizden emin olun. Örneğin, DOM olay dinleyicileri için genellikle `await for` kullanmamalısınız, çünkü DOM sonsuz olay akışları gönderir. İki DOM olay dinleyicisini art arda kaydetmek için `await for` kullanırsanız, ikinci olay türü asla işlenmez.

`await` ve ilgili Dart dil özelliklerini kullanma hakkında daha fazla bilgi için asenkron programlama eğitimine bakın.

#### Stream verisini dinleme

Her değeri geldiği anda almak için ya `await for` kullanın ya da `listen()` metodunu kullanarak stream'e abone olun:

```dart
// Add an event handler to a button.
submitButton.onClick.listen((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
```

Bu örnekte, `onClick` özelliği submit butonu tarafından sağlanan bir `Stream` nesnesidir.

Yalnızca bir olayla ilgileniyorsanız, `first`, `last` veya `single` gibi bir özellik kullanarak onu alabilirsiniz. Olayı işlemeden önce test etmek için `firstWhere()`, `lastWhere()` veya `singleWhere()` gibi bir metot kullanın.

Olayların bir alt kümesiyle ilgileniyorsanız, `skip()`, `skipWhile()`, `take()`, `takeWhile()` ve `where()` gibi metotları kullanabilirsiniz.

#### Stream verisini dönüştürme

Çoğu zaman, bir stream'in verisini kullanmadan önce formatını değiştirmeniz gerekir. Farklı türde veriye sahip bir stream üretmek için `transform()` metodunu kullanın:

```dart
var lines = inputStream
    .transform(utf8.decoder)
    .transform(const LineSplitter());
```

Bu örnek iki transformer kullanır. İlk olarak, tam sayı stream'ini string stream'ine dönüştürmek için `utf8.decoder` kullanır. Ardından, string stream'ini ayrı satırların stream'ine dönüştürmek için bir `LineSplitter` kullanır. Bu transformer'lar `dart:convert` kütüphanesindendir (`dart:convert` bölümüne bakın).

#### Hataları ve tamamlanmayı işleme

Hata ve tamamlanma işleme kodunu nasıl belirteceğiniz, bir asenkron for döngüsü (`await for`) mi yoksa `Stream` API'sini mi kullandığınıza bağlıdır.

Bir asenkron for döngüsü kullanıyorsanız, hataları işlemek için `try-catch` kullanın. Stream kapandıktan sonra çalışan kod, asenkron for döngüsünden sonra gelir.

```dart
Future<void> readFileAwaitFor() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(utf8.decoder)
      .transform(const LineSplitter());
  try {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}
```

`Stream` API'sini kullanıyorsanız, hataları bir `onError` dinleyicisi kaydederek işleyin. Stream kapandıktan sonraki kodu, bir `onDone` dinleyicisi kaydederek çalıştırın.

```dart
var config = File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .listen(
      (String line) {
        print('Got ${line.length} characters from stream');
      },
      onDone: () {
        print('file is now closed');
      },
      onError: (e) {
        print(e);
      },
    );
```

### Daha Fazla Bilgi

Komut satırı uygulamalarında `Future` ve `Stream` kullanımına ilişkin bazı örnekler için `dart:io` dokümantasyonuna bakın. Ayrıca şu makale ve eğitimlere de göz atın:

- Asynchronous programming: futures, async, await
- Futures and error handling
- Asynchronous programming: streams
- Creating streams in Dart
- Dart asynchronous programming: Isolates and event loops

---

## 4. `dart:math`

`dart:math` kütüphanesi (API referansı), sinüs ve kosinüs, maksimum ve minimum gibi yaygın işlevlerin yanı sıra `pi` ve `e` gibi sabitler sağlar. Math kütüphanesindeki işlevselliğin çoğu üst düzey fonksiyonlar olarak uygulanmıştır.

Bu kütüphaneyi uygulamanızda kullanmak için `dart:math`'ı içe aktarın.

```dart
import 'dart:math';
```

### Trigonometri

Math kütüphanesi temel trigonometrik fonksiyonları sağlar:

```dart
// Cosine
assert(cos(pi) == -1.0);

// Sine
var degrees = 30;
var radians = degrees * (pi / 180);
// radians is now 0.52359.
var sinOf30degrees = sin(radians);
// sin 30° = 0.5
assert((sinOf30degrees - 0.5).abs() < 0.01);
```

> **Not:** Bu fonksiyonlar derece değil, radyan kullanır!

### Maksimum ve Minimum

Math kütüphanesi `max()` ve `min()` metotlarını sağlar:

```dart
assert(max(1, 1000) == 1000);
assert(min(1, -1000) == -1000);
```

### Math Sabitleri

Favori sabitlerinizi—`pi`, `e` ve daha fazlasını—Math kütüphanesinde bulun:

```dart
// See the Math library for additional constants.
print(e); // 2.718281828459045
print(pi); // 3.141592653589793
print(sqrt2); // 1.4142135623730951
```

### Rastgele Sayılar

`Random` sınıfıyla rastgele sayılar üretin. İsteğe bağlı olarak `Random` constructor'ına bir seed (tohum) sağlayabilirsiniz.

```dart
var random = Random();
random.nextDouble(); // Between 0.0 and 1.0: [0, 1)
random.nextInt(10); // Between 0 and 9.
```

Rastgele boolean'lar bile üretebilirsiniz:

```dart
var random = Random();
random.nextBool(); // true or false
```

> **Uyarı:** `Random`'ın varsayılan uygulaması, kriptografik amaçlar için uygun olmayan bir sözde rastgele bit akışı sağlar. Kriptografik olarak güvenli bir rastgele sayı üreteci oluşturmak için `Random.secure()` constructor'ını kullanın.

### Daha Fazla Bilgi

Metotların tam listesi için Math API referansına bakın. Ayrıca `num`, `int` ve `double` API referanslarına da bakın.

---

## 5. `dart:convert`

`dart:convert` kütüphanesi (API referansı), JSON ve UTF-8 için dönüştürücülerin yanı sıra ek dönüştürücüler oluşturma desteğine sahiptir. JSON, yapılandırılmış nesneleri ve koleksiyonları temsil etmek için basit bir metin formatıdır. UTF-8, Unicode karakter setindeki her karakteri temsil edebilen yaygın bir değişken genişlikli kodlamadır.

Bu kütüphaneyi kullanmak için `dart:convert`'i içe aktarın.

```dart
import 'dart:convert';
```

### JSON Kodlama ve Kod Çözme

JSON ile kodlanmış bir string'i `jsonDecode()` ile bir Dart nesnesine çözün:

```dart
// NOTE: Be sure to use double quotes ("),
// not single quotes ('), inside the JSON string.
// This string is JSON, not Dart.
var jsonString = '''
  [
    {"score": 40},
    {"score": 80}
  ]
''';

var scores = jsonDecode(jsonString);
assert(scores is List);

var firstScore = scores[0];
assert(firstScore is Map);
assert(firstScore['score'] == 40);
```

Desteklenen bir Dart nesnesini `jsonEncode()` ile JSON formatında bir string'e kodlayın:

```dart
var scores = [
  {'score': 40},
  {'score': 80},
  {'score': 100, 'overtime': true, 'special_guest': null},
];

var jsonText = jsonEncode(scores);
assert(
  jsonText ==
      '[{"score":40},{"score":80},'
          '{"score":100,"overtime":true,'
          '"special_guest":null}]',
);
```

Yalnızca `int`, `double`, `String`, `bool`, `null`, `List` veya `Map` (string anahtarlı) türündeki nesneler doğrudan JSON'a kodlanabilir. `List` ve `Map` nesneleri özyinelemeli olarak kodlanır.

Doğrudan kodlanabilir olmayan nesneleri kodlamak için iki seçeneğiniz vardır. Birincisi, `jsonEncode()`'u ikinci bir argümanla çağırmaktır: doğrudan kodlanabilir bir nesne döndüren bir fonksiyon. İkinci seçeneğiniz, ikinci argümanı atlamaktır; bu durumda kodlayıcı nesnenin `toJson()` metodunu çağırır.

Daha fazla örnek ve JSON ile ilgili paketlere bağlantılar için Using JSON bölümüne bakın.

### UTF-8 Karakterlerini Kodlama ve Kod Çözme

UTF8 ile kodlanmış baytları bir Dart string'ine çözmek için `utf8.decode()` kullanın:

```dart
List<int> utf8Bytes = [
  0xc3, 0x8e, 0xc3, 0xb1, 0xc5, 0xa3, 0xc3, 0xa9,
  0x72, 0xc3, 0xb1, 0xc3, 0xa5, 0xc5, 0xa3, 0xc3,
  0xae, 0xc3, 0xb6, 0xc3, 0xb1, 0xc3, 0xa5, 0xc4,
  0xbc, 0xc3, 0xae, 0xc5, 0xbe, 0xc3, 0xa5, 0xc5,
  0xa3, 0xc3, 0xae, 0xe1, 0xbb, 0x9d, 0xc3, 0xb1,
];

var funnyWord = utf8.decode(utf8Bytes);

assert(funnyWord == 'Îñţérñåţîöñåļîžåţîờñ');
```

Bir UTF-8 karakter akışını bir Dart string'ine dönüştürmek için `Stream`'in `transform()` metoduna `utf8.decoder` belirtin:

```dart
var lines = utf8.decoder.bind(inputStream).transform(const LineSplitter());
try {
  await for (final line in lines) {
    print('Got ${line.length} characters from stream');
  }
  print('file is now closed');
} catch (e) {
  print(e);
}
```

Bir Dart string'ini UTF8 ile kodlanmış baytlar listesi olarak kodlamak için `utf8.encode()` kullanın:

```dart
Uint8List encoded = utf8.encode('Îñţérñåţîöñåļîžåţîờñ');

assert(encoded.length == utf8Bytes.length);
for (int i = 0; i < encoded.length; i++) {
  assert(encoded[i] == utf8Bytes[i]);
}
```

### Diğer İşlevsellik

`dart:convert` kütüphanesi ayrıca ASCII ve ISO-8859-1 (Latin1) için dönüştürücülere sahiptir. Ayrıntılar için `dart:convert` kütüphanesinin API referansına bakın.

---

## 6. `dart:io`

`dart:io` kütüphanesi dosyalar, dizinler, süreçler, soketler, WebSocket'ler ve HTTP istemci ve sunucularıyla ilgilenmek için API'ler sağlar.

> **Önemli:** Yalnızca web dışı Flutter uygulamaları, komut satırı betikleri ve sunucular `dart:io`'yu içe aktarıp kullanabilir; web uygulamaları kullanamaz.

Genel olarak, `dart:io` kütüphanesi asenkron bir API uygular ve teşvik eder. Senkron metotlar kolayca bir uygulamayı bloke edebilir ve ölçeklendirmeyi zorlaştırabilir. Bu nedenle, çoğu işlem sonuçları `Future` veya `Stream` nesneleri aracılığıyla döndürür; bu, Node.js gibi modern sunucu platformlarında yaygın bir kalıptır.

`dart:io` kütüphanesindeki az sayıdaki senkron metot, metodun adında `Sync` son ekiyle açıkça işaretlenmiştir. Senkron metotlar burada ele alınmaz.

`dart:io` kütüphanesini kullanmak için onu içe aktarmalısınız:

```dart
import 'dart:io';
```

### Dosyalar ve Dizinler

I/O (`dart:io`) kütüphanesi, komut satırı uygulamalarının dosyaları okumasına ve yazmasına ve dizinlere göz atmasına olanak tanır. Bir dosyanın içeriğini okumak için iki seçeneğiniz vardır: hepsini birden veya akış halinde. Bir dosyayı hepsini birden okumak, dosyanın tüm içeriğini depolamak için yeterli belleği gerektirir. Dosya çok büyükse veya okurken işlemek istiyorsanız, Akış halinde dosya içeriği bölümünde açıklandığı gibi bir `Stream` kullanmalısınız.

#### Bir dosyayı metin olarak okuma

UTF-8 kullanılarak kodlanmış bir metin dosyasını okurken, tüm dosya içeriğini `readAsString()` ile okuyabilirsiniz. Tek tek satırlar önemli olduğunda `readAsLines()` kullanabilirsiniz. Her iki durumda da, dosyanın içeriğini bir veya daha fazla string olarak sağlayan bir `Future` nesnesi döndürülür.

```dart
void main() async {
  var config = File('config.txt');

  // Put the whole file in a single string.
  var stringContents = await config.readAsString();
  print('The file is ${stringContents.length} characters long.');

  // Put each line of the file into its own string.
  var lines = await config.readAsLines();
  print('The file is ${lines.length} lines long.');
}
```

#### Bir dosyayı ikili (binary) olarak okuma

Aşağıdaki kod, bir dosyanın tamamını bir int listesi olarak okur. `readAsBytes()` çağrısı, hazır olduğunda sonucu sağlayan bir `Future` döndürür.

```dart
void main() async {
  var config = File('config.txt');

  var contents = await config.readAsBytes();
  print('The file is ${contents.length} bytes long.');
}
```

#### Hataları işleme

Hataların yakalanmamış istisnalarla sonuçlanmaması için `Future` üzerinde bir `catchError` işleyicisi kaydedebilir veya (bir `async` fonksiyonda) `try-catch` kullanabilirsiniz:

```dart
void main() async {
  var config = File('config.txt');
  try {
    var contents = await config.readAsString();
    print(contents);
  } catch (e) {
    print(e);
  }
}
```

#### Dosya içeriğini akış halinde okuma

Bir dosyayı azar azar okumak için bir `Stream` kullanın. `Stream` API'sini ya da Dart'ın asenkron desteğinin bir parçası olan `await for`'u kullanabilirsiniz.

```dart
import 'dart:io';
import 'dart:convert';

void main() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = utf8.decoder.bind(inputStream).transform(const LineSplitter());
  try {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } catch (e) {
    print(e);
  }
}
```

#### Dosya içeriği yazma

Bir dosyaya veri yazmak için bir `IOSink` kullanabilirsiniz. Yazabileceğiniz bir `IOSink` elde etmek için `File`'ın `openWrite()` metodunu kullanın. Varsayılan mod olan `FileMode.write`, dosyadaki mevcut veriyi tamamen üzerine yazar.

```dart
var logFile = File('log.txt');
var sink = logFile.openWrite();
sink.write('FILE ACCESSED ${DateTime.now()}\n');
await sink.flush();
await sink.close();
```

Dosyanın sonuna eklemek için, `FileMode.append` belirtmek üzere isteğe bağlı `mode` parametresini kullanın:

```dart
var sink = logFile.openWrite(mode: FileMode.append);
```

İkili veri yazmak için `add(List<int> data)` kullanın.

#### Bir dizindeki dosyaları listeleme

Bir dizin için tüm dosya ve alt dizinleri bulmak asenkron bir işlemdir. `list()` metodu, bir dosya veya dizinle karşılaşıldığında bir nesne yayan bir `Stream` döndürür.

```dart
void main() async {
  var dir = Directory('tmp');

  try {
    var dirList = dir.list();
    await for (final FileSystemEntity f in dirList) {
      if (f is File) {
        print('Found file ${f.path}');
      } else if (f is Directory) {
        print('Found dir ${f.path}');
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
```

#### Diğer yaygın işlevsellik

`File` ve `Directory` sınıfları, aşağıdakilerle sınırlı olmamak üzere diğer işlevsellikleri içerir:

- Bir dosya veya dizin oluşturma: `File` ve `Directory` içinde `create()`
- Bir dosya veya dizin silme: `File` ve `Directory` içinde `delete()`
- Bir dosyanın uzunluğunu alma: `File` içinde `length()`
- Bir dosyaya rastgele erişim: `File` içinde `open()`

Metotların tam listesi için `File` ve `Directory` API dokümanlarına bakın.

### HTTP İstemcileri ve Sunucuları

`dart:io` kütüphanesi, komut satırı uygulamalarının HTTP kaynaklarına erişmek ve HTTP sunucuları çalıştırmak için kullanabileceği sınıflar sağlar.

#### HTTP sunucusu

`HttpServer` sınıfı, web sunucuları oluşturmak için düşük seviyeli işlevsellik sağlar. İstek işleyicileri eşleştirebilir, başlıklar ayarlayabilir, veri akışı yapabilir ve daha fazlasını yapabilirsiniz.

Aşağıdaki örnek web sunucusu basit metin bilgisi döndürür. Bu sunucu 8888 portunu ve 127.0.0.1 (localhost) adresini dinler, `/dart` yolu için isteklere yanıt verir. Diğer tüm yollar için yanıt 404 (sayfa bulunamadı) durum kodudur.

```dart
void main() async {
  final requests = await HttpServer.bind('localhost', 8888);
  await for (final request in requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType('text', 'plain')
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}
```

#### HTTP istemcisi

HTTP istekleri yapmak için doğrudan `dart:io` kullanmaktan kaçınmalısınız. `dart:io`'daki `HttpClient` sınıfı platforma bağımlıdır ve tek bir uygulamaya bağlıdır. Bunun yerine `package:http` gibi daha yüksek seviyeli bir kütüphane kullanın.

Fetch data from the internet eğitimi, `package:http` kullanarak HTTP isteklerinin nasıl yapılacağını açıklar.

### Daha Fazla Bilgi

Bu bölüm, `dart:io` kütüphanesinin başlıca özelliklerinin nasıl kullanılacağını gösterdi. Bu bölümde tartışılan API'lerin yanı sıra, `dart:io` kütüphanesi süreçler, soketler ve web soketleri için de API'ler sağlar. Sunucu tarafı ve komut satırı uygulama geliştirme hakkında daha fazla bilgi için server-side Dart genel bakışına bakın.

---

## 7. JavaScript Birlikte Çalışabilirliği (JS Interop)

Dart web uygulamanıza JavaScript kütüphanelerini ve API'lerini sorunsuz bir şekilde entegre edin.

Dart web platformu, Dart'tan JavaScript'i çağırmak ve tam tersini yapmak için güçlü araçlar sunar ve Dart kodunuzdan ayrılmadan geniş JavaScript ekosisteminden yararlanmanıza olanak tanır.

Bu bölüm, Dart'ta JavaScript birlikte çalışabilirliği hakkında bilgi edinmek için merkezi bir merkez sunar. Başlamak için kaynaklar, ayrıntılı kullanım kılavuzları ve en yeni `dart:js_interop` kütüphanesi hakkında bilgiler bulacaksınız. Belirli bir JavaScript kütüphanesini kullanmak veya tarayıcı API'leriyle etkileşim kurmak istiyorsanız, başlamanız gereken yer burasıdır.

JS interop ile başlayın:

- Get started with JavaScript interop
- How to mock JavaScript interop objects

Referans kılavuzlarını inceleyin:

- Usage reference
- JS types reference

Tarayıcıyla etkileşim kurun:

- `package:web` and migration

### Ek Kaynaklar

Önceki JS interop kütüphaneleri:

- Past JS interop

JavaScript interop hakkında ek dokümantasyon:

- `dart:js_interop` API reference
- `dart:js_interop_unsafe` API reference

### Kullanım (Usage)

JS interop, JavaScript API'leriyle Dart'tan etkileşim kurmak için mekanizmalar sağlar. Bu API'leri çağırmanıza ve onlardan elde ettiğiniz değerlerle açık, deyimsel bir söz dizimi kullanarak etkileşim kurmanıza olanak tanır.

Tipik olarak, bir JavaScript API'sine, onu global JS kapsamında bir yerde kullanılabilir hale getirerek erişirsiniz. Bu API'yı çağırmak ve ondan JS değerleri almak için `external` interop üyeleri kullanırsınız. JS değerlerini oluşturmak ve onlara tip sağlamak için, aynı zamanda interop üyeleri içeren interop tiplerini kullanır ve bildirirsiniz. Bir `List` veya `Function` gibi Dart değerlerini interop üyelerine geçirmek veya JS değerlerinden Dart değerlerine dönüştürmek için, interop üye bir primitive (temel) tip içermediği sürece dönüştürme fonksiyonlarını kullanırsınız.

#### Interop tipleri

Bir JS değeriyle etkileşime girerken, ona bir Dart tipi sağlamanız gerekir. Bunu bir interop tipi kullanarak veya bildirerek yapabilirsiniz. Interop tipleri ya Dart tarafından sağlanan bir "JS tipi" ya da bir interop tipini saran bir extension type'dır.

Interop tipleri, bir JS değeri için bir arayüz sağlamanıza olanak tanır ve üyeleri için interop API'leri bildirmenize izin verir. Ayrıca diğer interop API'lerinin imzasında da kullanılırlar.

```dart
extension type Window(JSObject _) implements JSObject {}
```

`Window`, rastgele bir `JSObject` için bir interop tipidir. `Window`'un aslında bir JS `Window` olduğuna dair bir çalışma zamanı garantisi yoktur. Ayrıca aynı değer için tanımlanan diğer herhangi bir interop arayüzüyle çakışma yoktur. `Window`'un aslında bir JS `Window` olup olmadığını kontrol etmek istiyorsanız, JS değerinin tipini interop aracılığıyla kontrol edebilirsiniz.

Ayrıca, Dart'ın sağladığı JS tipleri için onları sararak kendi interop tipinizi bildirebilirsiniz:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external Array();
}
```

Çoğu durumda, temsil tipi olarak `JSObject` kullanarak bir interop tipi bildirirsiniz, çünkü muhtemelen Dart tarafından sağlanan bir interop tipi olmayan JS nesneleriyle etkileşime giriyorsunuzdur.

Interop tipleri ayrıca genellikle temsil tiplerini uygulamalıdır, böylece `package:web` tarafından sağlanan birçok API gibi, temsil tipinin beklendiği yerlerde kullanılabilirler.

#### Interop üyeleri

`external` interop üyeleri, JS üyeleri için deyimsel bir söz dizimi sağlar. Argümanları ve dönüş değeri için bir Dart tip imzası yazmanıza olanak tanırlar. Bu üyelerin imzasında yazılabilecek tiplerin kısıtlamaları vardır. Bir interop üyesinin karşılık geldiği JS API'si; nerede bildirildiği, adı, ne tür bir Dart üyesi olduğu ve herhangi bir yeniden adlandırmanın bir kombinasyonuyla belirlenir.

##### Üst düzey interop üyeleri

Aşağıdaki JS üyeleri verildiğinde:

```javascript
globalThis.name = 'global';
globalThis.isNameEmpty = function() {
  return globalThis.name.length == 0;
}
```

Onlar için interop üyeleri şu şekilde yazabilirsiniz:

```dart
@JS()
external String get name;

@JS()
external set name(String value);

@JS()
external bool isNameEmpty();
```

Burada, global kapsamda açığa çıkarılan bir `name` özelliği ve bir `isNameEmpty` fonksiyonu vardır. Onlara erişmek için üst düzey interop üyeleri kullanırsınız. `name`'i almak ve ayarlamak için aynı ada sahip bir interop getter ve setter bildirin ve kullanın. `isNameEmpty` kullanmak için aynı ada sahip bir interop fonksiyon bildirin ve çağırın. Üst düzey interop getter'lar, setter'lar, metotlar ve field'lar bildirebilirsiniz. Interop field'ları, getter ve setter çiftlerine eşdeğerdir.

Üst düzey interop üyeleri, `dart:ffi` kullanılarak yazılabilenler gibi diğer `external` üst düzey üyelerden ayırt etmek için bir `@JS()` anotasyonuyla bildirilmelidir.

##### Interop tip üyeleri

Aşağıdaki gibi bir JS arayüzü verildiğinde:

```javascript
class Time {
  constructor(hours, minutes) {
    this._hours = Math.abs(hours) % 24;
    this._minutes = arguments.length == 1 ? 0 : Math.abs(minutes) % 60;
  }

  static dinnerTime = new Time(18, 0);

  static getTimeDifference(t1, t2) {
    return new Time(t1.hours - t2.hours, t1.minutes - t2.minutes);
  }

  get hours() {
    return this._hours;
  }

  set hours(value) {
    this._hours = Math.abs(value) % 24;
  }

  get minutes() {
    return this._minutes;
  }

  set minutes(value) {
    this._minutes = Math.abs(value) % 60;
  }

  isDinnerTime() {
    return this.hours == Time.dinnerTime.hours && this.minutes == Time.dinnerTime.minutes;
  }
}
// Need to expose the type to the global scope.
globalThis.Time = Time;
```

Onun için bir interop arayüzü şu şekilde yazabilirsiniz:

```dart
extension type Time._(JSObject _) implements JSObject {
  external Time(int hours, int minutes);
  external factory Time.onlyHours(int hours);

  external static Time dinnerTime;
  external static Time getTimeDifference(Time t1, Time t2);

  external int hours;
  external int minutes;
  external bool isDinnerTime();

  bool isMidnight() => hours == 0 && minutes == 0;
}
```

Bir interop tipi içinde, birkaç farklı türde `external` interop üyesi bildirebilirsiniz.

**Constructor'lar (Yapıcılar / Kurucular)**

Çağrıldığında, yalnızca konumsal parametreleri olan constructor'lar, `new` kullanılarak extension type'ın adıyla tanımlanan constructor'a sahip yeni bir JS nesnesi oluşturur. Örneğin, Dart'ta `Time(0, 0)` çağırmak, `new Time(0, 0)` gibi görünen bir JS çağrısı üretir. Benzer şekilde, `Time.onlyHours(0)` çağırmak, `new Time(0)` gibi görünen bir JS çağrısı üretir. İki constructor'ın JS çağrılarının, bir Dart adı verilip verilmediğine veya factory olup olmadığına bakılmaksızın aynı semantiği izlediğini unutmayın.

**Object Literal Constructor'ları (Nesne Literal Yapıcıları)**

Bazen sadece bir dizi özellik ve değerlerini içeren bir JS nesne literali oluşturmak yararlıdır. Bunu yapmak için, yalnızca adlandırılmış parametreleri olan bir constructor (factory olsun veya olmasın) bildirin; burada parametrelerin adları özellik adlarıyla eşleşir:

```dart
extension type Options._(JSObject o) implements JSObject {
  external Options({int a, int b});
  external int get a;
  external int get b;
}
```

`Options(a: 0, b: 1)` çağrısı, `{a: 0, b: 1}` JS nesnesini oluşturur. Nesne, çağrı argümanları tarafından tanımlanır, bu yüzden `Options(a: 0)` çağırmak `{a: 0}` ile sonuçlanır. Nesnenin özelliklerini `external` instance üyeleri aracılığıyla alabilir veya ayarlayabilirsiniz.

> **Not:** Eski `package:js`'in aksine, `dart:js_interop`'ta object literal constructor'ları `@anonymous` veya `@JS` anotasyonları gerektirmez.

**Statik üyeler**

Constructor'lar gibi, statik üyeler de JS kodunu üretmek için extension type'ın adını kullanır. Örneğin, `Time.getTimeDifference(t1, t2)` çağırmak, `Time.getTimeDifference(t1, t2)` gibi görünen bir JS çağrısı üretir. Benzer şekilde, `Time.dinnerTime` çağırmak, `Time.dinnerTime` gibi görünen bir JS çağrısıyla sonuçlanır. Üst düzey üyeler gibi, statik metotlar, getter'lar, setter'lar ve field'lar bildirebilirsiniz.

**Instance üyeler**

Diğer Dart tiplerinde olduğu gibi, instance üyeler kullanılmak için bir instance gerektirir. Bu üyeler, instance üzerindeki özellikleri alır, ayarlar veya çağırır. Örneğin:

```dart
final time = Time(0, 0);
print(time.isDinnerTime()); // false
final dinnerTime = Time.dinnerTime;
time.hours = dinnerTime.hours;
time.minutes = dinnerTime.minutes;
print(time.isDinnerTime()); // true
```

`dinnerTime.hours` çağrısı, `dinnerTime`'ın `hours` özelliğinin değerini alır. Benzer şekilde, `time.minutes=` çağrısı, `time`'ın `minutes` özelliğinin değerini ayarlar. `time.isDinnerTime()` çağrısı, `time`'ın `isDinnerTime` özelliğindeki fonksiyonu çağırır ve değeri döndürür. Üst düzey ve statik üyeler gibi, instance metotlar, getter'lar, setter'lar ve field'lar bildirebilirsiniz.

**Operatörler**

Interop tiplerinde yalnızca iki `external` interop operatörüne izin verilir: `[]` ve `[]=`. Bunlar, JS'in property accessor'larının (özellik erişimcilerinin) semantiğiyle eşleşen instance üyeleridir. Örneğin, onları şu şekilde bildirebilirsiniz:

```dart
extension type Array(JSArray<JSNumber> _) implements JSArray<JSNumber> {
  external JSNumber operator [](int index);
  external void operator []=(int index, JSNumber value);
}
```

`array[i]` çağırmak, `array`'in i. yuvasındaki değeri alır ve `array[i] = i.toJS` o yuvadaki değeri `i.toJS` olarak ayarlar. Diğer JS operatörleri `dart:js_interop`'taki yardımcı fonksiyonlar tarafından açığa çıkarılır.

Son olarak, herhangi bir extension type gibi, interop tipinde herhangi bir `external` olmayan üye bildirmenize izin verilir. Interop değerlerini kullanan bir boolean getter `isMidnight` buna bir örnektir.

**Interop tiplerindeki extension üyeleri**

Ayrıca interop tiplerinin extension'larında `external` üyeler yazabilirsiniz. Örneğin:

```dart
extension on Array {
  external int push(JSAny? any);
}
```

`push` çağırmanın semantiği, `Array` tanımında olsaydı olacağıyla aynıdır. Extension'lar `external` instance üyeler ve operatörlere sahip olabilir, ancak `external` statik üyeler veya constructor'lara sahip olamaz. Interop tipleri gibi, extension'da herhangi bir `external` olmayan üye de yazabilirsiniz. Bu extension'lar, bir interop tipi ihtiyacınız olan `external` üyeyi açığa çıkarmadığında ve yeni bir interop tipi oluşturmak istemediğinizde kullanışlıdır.

**Parametreler**

`external` interop metotları yalnızca konumsal ve isteğe bağlı argümanlar içerebilir. Çünkü JS üyeleri yalnızca konumsal argümanlar alır. Tek istisna, yalnızca adlandırılmış argümanlar içerebilen object literal constructor'larıdır.

`external` olmayan metotların aksine, isteğe bağlı argümanlar varsayılan değerleriyle değiştirilmez, bunun yerine atlanır. Örneğin:

```dart
external int push(JSAny? any, [JSAny? any2]);
```

Dart'ta `array.push(0.toJS)` çağırmak, `array.push(0.toJS, null)` değil, `array.push(0.toJS)` JS çağrısıyla sonuçlanır. Bu, kullanıcıların null geçmekten kaçınmak için aynı JS API'si için birden çok interop üyesi yazmak zorunda kalmamasını sağlar. Açık bir varsayılan değerle bir parametre bildirirseniz, değerin yok sayılacağına dair bir uyarı alırsınız.

##### `@JS()`

`@JS()`, derleyiciye bir bildirimin bir JS interop üyesi veya tipi olduğunu söyler ve isteğe bağlı olarak onu JS'de yeniden adlandırır veya ad alanına yerleştirir:

- **Üst düzey bildirimler:** Diğer `external` bildirimlerden (örneğin `dart:ffi`) ayırt etmek için tüm üst düzey interop üyelerinde gereklidir (string değerli veya değersiz).
- **Interop tipleri ve extension üyeleri:** Dart adı JS adıyla eşleştiğinde isteğe bağlıdır, çünkü derleyici temsil tipinden veya tipten JS interop'u çıkarır.

**Interop üyelerini ve tiplerini yeniden adlandırma**

Bazen bir JS özelliğine yazılandan farklı bir adla başvurmak yararlıdır. Örneğin, aynı JS özelliğine işaret eden iki `external` API yazmak istiyorsanız, en az biri için farklı bir ad yazmanız gerekir. Benzer şekilde, aynı JS arayüzüne başvuran birden çok interop tipi tanımlamak istiyorsanız, en az birini yeniden adlandırmanız gerekir. Başka bir örnek, JS adının Dart'ta yazılamamasıdır, örneğin `$a`.

Bunu yapmak için `@JS()`'e sabit bir string değeri sağlayın. Örneğin:

```dart
extension type Array._(JSArray<JSAny?> _) implements JSArray<JSAny?> {
  external int push(JSNumber number);
  @JS('push')
  external int pushString(JSString string);
}
```

`push` veya `pushString` çağırmak, `push` kullanan JS koduna yol açar.

Interop tiplerini de yeniden adlandırabilirsiniz:

```dart
@JS('Date')
extension type JSDate._(JSObject _) implements JSObject {
  external JSDate();

  external static int now();
}
```

`JSDate()` çağırmak, `new Date()` JS çağrısıyla sonuçlanır. Benzer şekilde, `JSDate.now()` çağırmak, `Date.now()` JS çağrısıyla sonuçlanır.

**Bir kütüphaneyi ad alanına yerleştirme**

Ayrıca, bir kütüphanenin tamamını ad alanına yerleştirebilir, içindeki tüm interop üst düzey üyelerine, interop tiplerine ve bu tiplerdeki statik interop üyelerine bir ön ek ekleyebilirsiniz. Bu, global JS kapsamına çok fazla üye eklemekten kaçınmak istiyorsanız kullanışlıdır.

```dart
@JS('library1')
library;

import 'dart:js_interop';

@JS()
external void method();

extension type JSType._(JSObject _) implements JSObject {
  external JSType();

  external static int get staticMember;
}
```

`method()` çağırmak `library1.method()` JS çağrısıyla, `JSType()` çağırmak `new library1.JSType()` JS çağrısıyla ve `JSType.staticMember` çağırmak `library1.JSType.staticMember` JS çağrısıyla sonuçlanır.

Interop üyeleri ve interop tiplerinden farklı olarak, Dart, kütüphanedeki `@JS()` anotasyonunda boş olmayan bir değer sağlamadığınız sürece JS çağrısına asla bir kütüphane adı eklemez. Varsayılan olarak kütüphanenin Dart adını kullanmaz.

```dart
library interop_library;

import 'dart:js_interop';

@JS()
external void method();
```

`method()` çağırmak `interop_library.method()` değil, `method()` JS çağrısıyla sonuçlanır.

Kütüphaneler, üst düzey üyeler ve interop tipleri için `.` ile ayrılmış birden çok ad alanı da yazabilirsiniz:

```dart
@JS('library1.library2')
library;

import 'dart:js_interop';

@JS('library3.method')
external void method();

@JS('library3.JSType')
extension type JSType._(JSObject _) implements JSObject {
  external JSType();
}
```

`method()` çağırmak `library1.library2.library3.method()` JS çağrısıyla, `JSType()` çağırmak `new library1.library2.library3.JSType()` JS çağrısıyla sonuçlanır, vb.

Ancak, interop tip üyelerinde veya interop tiplerinin extension üyelerinde, değerde `.` içeren `@JS()` anotasyonlarını kullanamazsınız.

`@JS()`'e değer sağlanmazsa veya değer boşsa, hiçbir yeniden adlandırma gerçekleşmez.

##### Dart fonksiyonlarını ve nesnelerini JS'e dışa aktarma

Önceki bölümler, Dart'tan JS üyelerinin nasıl çağrılacağını gösterir. Dart kodunu JS'te kullanılabilir olacak şekilde dışa aktarmak da yararlıdır. Bir Dart fonksiyonunu JS'e dışa aktarmak için, önce onu `Function.toJS` kullanarak dönüştürün; bu, Dart fonksiyonunu bir JS fonksiyonuyla sarar. Ardından, sarmalanmış fonksiyonu bir interop üyesi aracılığıyla JS'e geçirin. Bu noktada, diğer JS kodu tarafından çağrılmaya hazırdır.

Örneğin, bu kod bir Dart fonksiyonunu dönüştürür ve onu global bir özelliğe ayarlamak için interop kullanır, ardından JS'te çağrılır:

```dart
import 'dart:js_interop';

@JS()
external set exportedFunction(JSFunction value);

void printString(JSString string) {
  print(string.toDart);
}

void main() {
  exportedFunction = printString.toJS;
}
```

```javascript
globalThis.exportedFunction('hello world');
```

Bu şekilde dışa aktarılan fonksiyonlar, interop üyelerininkine benzer tip kısıtlamalarına sahiptir.

Bazen tüm bir Dart arayüzünü dışa aktarmak yararlıdır, böylece JS bir Dart nesnesiyle etkileşime girebilir. Bunu yapmak için, Dart sınıfını `@JSExport` kullanarak dışa aktarılabilir olarak işaretleyin ve o sınıfın instance'larını `createJSInteropWrapper` kullanarak sarın. Bu tekniğin daha ayrıntılı bir açıklaması için, JS değerlerinin nasıl taklit edileceği dahil, How to mock JavaScript interop objects bölümüne bakın.

#### `dart:js_interop` ve `dart:js_interop_unsafe`

`dart:js_interop`, ihtiyaç duyabileceğiniz tüm gerekli üyeleri içerir; bunlar arasında `@JS`, JS tipleri, dönüştürme fonksiyonları ve çeşitli yardımcı fonksiyonlar bulunur. Yardımcı fonksiyonlar şunları içerir:

- Derleyicilerin interop üyelerini ve tiplerini bulmak için kullandığı global kapsamı temsil eden `globalContext`.
- JS değerlerinin tipini incelemek için yardımcılar.
- JS operatörleri.
- Belirli JS değerlerinin tipini kontrol eden ve onları Dart değerlerine ve tam tersine dönüştüren `dartify` ve `jsify`. JS değerinin tipini bildiğinizde belirli dönüştürmeyi kullanmayı tercih edin, çünkü ekstra tip kontrolü pahalı olabilir.
- Modülleri dinamik olarak bir `JSObject` olarak içe aktarmanıza olanak tanıyan `importModule`.
- Bir JS interop değerinin, tip argümanı tarafından belirtilen JS tipinin bir instance'ı olup olmadığını kontrol etmenize olanak tanıyan `isA`.

Gelecekte bu kütüphaneye daha fazla yardımcı eklenebilir.

`dart:js_interop_unsafe`, özellikleri dinamik olarak aramanıza olanak tanıyan üyeler içerir. Örneğin:

```dart
JSFunction f = console['log'];
```

`log` adında bir interop üyesi bildirmek yerine, özelliğe erişmek için bir string kullanılabilir. `dart:js_interop_unsafe` ayrıca özellikleri dinamik olarak kontrol etmek, almak, ayarlamak ve çağırmak için fonksiyonlar sağlar.

> **İpucu:** Mümkünse `dart:js_interop_unsafe` kullanmaktan kaçının. Güvenlik uyumluluğunu garanti etmeyi zorlaştırır ve ihlallere yol açabilir, bu yüzden "güvensiz" (unsafe) olabilir.

#### JS Tipleri (Types)

Dart değerleri ve JS değerleri ayrı dil alanlarına aittir. Wasm'a derlenirken ayrı çalışma zamanlarında yürütülürler. Bu nedenle, JS değerlerini yabancı tipler olarak ele almalısınız. JS değerlerine Dart tipleri sağlamak için, `dart:js_interop` "JS tipleri" adı verilen, `JS` ön ekli bir dizi tip sunar. Bu tipler, derleme zamanında Dart değerleri ile JS değerleri arasında ayrım yapmak için kullanılır.

Önemli olarak, bu tipler Wasm veya JS'e derleyip derlemediğinize bağlı olarak farklı şekilde reify edilir. Bu, çalışma zamanı tiplerinin farklı olacağı ve bu nedenle `is` kontrollerini ve `as` cast'lerini kullanamayacağınız anlamına gelir. Bu JS değerleriyle etkileşim kurmak ve onları incelemek için `external` interop üyeleri veya dönüştürmeler kullanmalısınız.

##### Tip hiyerarşisi

JS tipleri doğal bir tip hiyerarşisi oluşturur:

- **Üst tip:** `JSAny`, herhangi bir null olmayan JS değeri.
  - **Primitive Tipler (Primitives):** `JSNumber`, `JSBoolean`, `JSString`, `JSSymbol`, `JSBigInt`
  - **`JSObject`,** herhangi bir JS nesnesi
    - `JSFunction`
      - `JSExportedDartFunction`, JS fonksiyonuna dönüştürülmüş bir Dart geri çağırmasını temsil eder
    - `JSArray`
    - `JSPromise`
    - `JSDataView`
    - `JSTypedArray`
      - `JSUint8Array` gibi JS typed array'leri
    - `JSBoxedDartObject`, kullanıcıların Dart değerlerini aynı Dart çalışma zamanı içinde opak bir şekilde kutlamasına ve geçirmesine olanak tanır
      - Dart 3.4'ten itibaren, `dart:js_interop`'taki `ExternalDartReference` tipi de kullanıcıların Dart değerlerini opak bir şekilde geçirmesine olanak tanır, ancak bu bir JS tipi değildir. Her iki seçeneğin arasındaki ödünleşimler hakkında daha fazla bilgi edinin.

Her tipin tanımını `dart:js_interop` API dokümanlarında bulabilirsiniz.

##### Dönüşümler (Conversions)

Bir alandaki bir değeri diğerine kullanmak için, muhtemelen değeri diğer alanın karşılık gelen tipine dönüştürmek isteyeceksiniz. Örneğin, bir `List<JSString>`'i, `JSArray<JSString>` ile temsil edilen bir JS string dizisine dönüştürmek isteyebilirsiniz, böylece diziyi bir JS interop API'sine geçirebilirsiniz.

Dart, alanlar arasında değerleri sizin için dönüştürmek amacıyla çeşitli Dart tipleri ve JS tipleri üzerinde bir dizi dönüştürme üyesi sağlar.

Değerleri Dart'tan JS'e dönüştüren üyeler genellikle `toJS` ile başlar:

```dart
String str = 'hello world';
JSString jsStr = str.toJS;
```

Değerleri JS'ten Dart'a dönüştüren üyeler genellikle `toDart` ile başlar:

```dart
JSNumber jsNum = ...;
int integer = jsNum.toDartInt;
```

Her JS tipinin bir dönüşümü yoktur ve her Dart tipinin bir dönüşümü yoktur. Genel olarak, dönüşüm tablosu aşağıdaki gibidir:

| `dart:js_interop` tipi | Dart tipi |
| --- | --- |
| `JSNumber`, `JSBoolean`, `JSString` | `num`, `int`, `double`, `bool`, `String` |
| `JSExportedDartFunction` | `Function` |
| `JSArray<T extends JSAny?>` | `List<T extends JSAny?>` |
| `JSPromise<T extends JSAny?>` | `Future<T extends JSAny?>` |
| `JSUint8Array` gibi typed array'ler | `dart:typed_data`'dan typed listeler |
| `JSBoxedDartObject` | Opak Dart değeri |
| `ExternalDartReference` | Opak Dart değeri |

> **Uyarı:** JavaScript'e karşı Wasm'a derlemek, dönüşümler için hem performans hem de semantikte tutarsızlıklar getirebilir. Dönüşümler derleyiciye bağlı olarak farklı maliyetlere sahip olabilir, bu yüzden değerleri yalnızca ihtiyacınız olduğunda dönüştürmeyi tercih edin.

Dönüşümler yeni bir değer üretebilir veya üretmeyebilir. Bu, sayılar gibi değiştirilemez değerler için önemli değildir, ancak `List` gibi tipler için önemlidir. Uygulamaya bağlı olarak, `JSArray`'e bir dönüşüm orijinal listenin bir referansını, bir proxy'sini veya bir klonunu döndürebilir. Bunu önlemek için, `List` ve `JSArray` arasındaki herhangi bir ilişkiye güvenmeyin ve yalnızca içeriklerinin aynı olmasına güvenin. Typed array dönüşümlerinin benzer bir kısıtlaması vardır. Daha fazla ayrıntı için belirli dönüştürme fonksiyonuna bakın.

##### External bildirimler ve `Function.toJS` üzerindeki gereksinimler

Tip güvenliği ve tutarlılığı sağlamak için, derleyici JS'e hangi tiplerin akabileceği konusunda gereksinimler koyar. Rastgele Dart değerlerini JS'e geçirmeye izin verilmez. Bunun yerine, derleyici kullanıcıların uyumlu bir interop tipi, `ExternalDartReference` veya derleyici tarafından örtük olarak dönüştürülecek bir primitive tip kullanmasını gerektirir. Örneğin, bunlara izin verilir:

```dart
@JS()
external void primitives(String a, int b, double c, num d, bool e);

@JS()
external JSArray jsTypes(JSObject _, JSString __);

extension type InteropType(JSObject _) implements JSObject {}

@JS()
external InteropType get interopType;

@JS()
external void externalDartReference(ExternalDartReference _);
```

Oysa bunlar bir hata döndürür:

```dart
@JS()
external Function get function;

@JS()
external set list(List _);
```

Aynı gereksinimler, bir Dart fonksiyonunu JS'te çağrılabilir yapmak için `Function.toJS` kullandığınızda da mevcuttur. Bu geri çağırmaya akan ve ondan çıkan değerler uyumlu bir interop tipi veya bir primitive tip olmalıdır.

`String` gibi bir Dart primitive tipi kullanırsanız, derleyicide o değeri bir JS değerinden bir Dart değerine dönüştürmek için örtük bir dönüşüm gerçekleşir. Performans kritikse ve string'in içeriğini incelemeye ihtiyacınız yoksa, dönüşüm maliyetinden kaçınmak için bunun yerine `JSString` kullanmak mantıklı olabilir, ikinci örnekte olduğu gibi.

##### Uyumluluk, tip kontrolleri ve cast'ler

JS tiplerinin çalışma zamanı tipi derleyiciye bağlı olarak farklılık gösterebilir. Bu, çalışma zamanı tip kontrolünü ve cast'leri etkiler. Bu nedenle, neredeyse her zaman değerin bir interop tipi olduğu veya hedef tipin bir interop tipi olduğu `is` kontrollerinden kaçının:

```dart
// YANLIŞ
void f(JSAny a) {
  if (a is String) { … }
}

// YANLIŞ
void f(JSAny a) {
  if (a is JSObject) { … }
}
```

Ayrıca, Dart tipleri ile interop tipleri arasındaki cast'lerden de kaçının:

```dart
// YANLIŞ
void f(JSString s) {
  s as String;
}
```

Bir JS değerini tip kontrolünden geçirmek için, JS değerinin kendisini inceleyen `typeofEquals` veya `instanceOfString` gibi bir interop üyesi kullanın:

```dart
// DOĞRU
void f(JSAny a) {
  // Here `a` is verified to be a JS function, so the cast is okay.
  if (a.typeofEquals('function')) {
    a as JSFunction;
  }
}
```

Dart 3.4'ten itibaren, bir değerin herhangi bir interop tipi olup olmadığını kontrol etmek için `isA` yardımcı fonksiyonunu kullanabilirsiniz:

```dart
// DOĞRU
void f(JSAny a) {
  if (a.isA<JSString>()) {} // `typeofEquals('string')`
  if (a.isA<JSArray>()) {} // `instanceOfString('Array')`
  if (a.isA<CustomInteropType>()) {} // `instanceOfString('CustomInteropType')`
}
```

Tip parametresine bağlı olarak, çağrıyı o tip için uygun tip kontrolüne dönüştürür.

JS interop tipleriyle geçersiz tip kontrollerinden kaçınmak için `invalid_runtime_check_with_js_interop_types` lint kuralını etkinleştirin.

##### `null` vs `undefined`

JS'in hem `null` hem de `undefined` değeri vardır. Bu, yalnızca `null`'a sahip olan Dart'ın aksinedir. JS değerlerinin kullanımını daha ergonomik hale getirmek için, bir interop üyesi JS `null` veya `undefined` döndürecekse, derleyici bu değerleri Dart `null`'a eşler. Bu nedenle, aşağıdaki örnekteki `value` gibi bir üye, bir JS nesnesi, JS `null` veya `undefined` döndürüyor olarak yorumlanabilir:

```dart
@JS()
external JSObject? get value;
```

Dönüş tipi null olabilir olarak bildirilmemişse, döndürülen değer JS `null` veya `undefined` ise, sağlamlığı sağlamak için program bir hata fırlatır.

> **Uyarı:** JS'e karşı Wasm'a derleme arasında `undefined` ile ilgili ince bir tutarsızlık vardır. JS'e derleme, `undefined` değerlerini Dart `null` gibi ele alırken, aslında değerin kendisini değiştirmez. Bir interop üyesi `undefined` döndürürse ve o değeri JS'e geri geçirirseniz, JS'e derlerken JS `null` değil, `undefined` görür.
>
> Ancak, Wasm'a derlerken bu böyle değildir ve değer JS'te `null` olacaktır. Çünkü derleyici Wasm'a derlerken değeri örtük olarak Dart `null`'a dönüştürür, böylece orijinal değerin JS `null` mi yoksa `undefined` mı olduğu bilgisini kaybeder. Bu ayrımın önemli olduğu kod yazmaktan kaçının, bunun yerine bir interop üyesine açıkça Dart `null` geçirin.
>
> Şu anda, interop üyelerine `undefined` sağlamanın veya JS `null` ile `undefined` değerleri arasında ayrım yapmanın platformla tutarlı bir yolu yoktur, ancak bu muhtemelen gelecekte değişecektir. Daha fazla ayrıntı için #54025'e bakın.

##### `JSBoxedDartObject` vs `ExternalDartReference`

Dart 3.4'ten itibaren, hem `JSBoxedDartObject` hem de `ExternalDartReference`, Dart nesnelerine opak referansları JavaScript üzerinden geçirmek için kullanılabilir. Ancak, `JSBoxedDartObject` opak referansı bir JavaScript nesnesine sarar, oysa `ExternalDartReference` referansın kendisidir ve bu nedenle bir JS tipi değildir.

Bir JS tipine ihtiyacınız varsa veya Dart değerlerinin başka bir Dart çalışma zamanına geçirilmediğinden emin olmak için ekstra kontrollere ihtiyacınız varsa `JSBoxedDartObject` kullanın. Örneğin, Dart nesnesinin bir `JSArray`'e yerleştirilmesi veya `JSAny` kabul eden bir API'ye geçirilmesi gerekiyorsa `JSBoxedDartObject` kullanın. Aksi takdirde `ExternalDartReference` kullanın, çünkü daha hızlı olacaktır.

Bir `ExternalDartReference`'a ve ondan dönüştürmek için `toExternalReference` ve `toDartObject`'e bakın.

### Eğitimler (JS Interop Tutorials)

Dart'ta yaygın JavaScript interop kullanım durumları için eğitimler.

#### JavaScript interop ile başlayın

Bu eğitimde, çeşitli JavaScript ve tarayıcı API'lerini kullanarak Dart'ta JavaScript ile etkileşimin temellerini öğreneceksiniz.

#### Dart'ta JavaScript interop nasıl taklit edilir (Mocking)

Bu eğitim, bir interop tipinin `external` instance üyelerini taklit etmek için Dart sınıflarını nasıl kullanabileceğinizi adım adım açıklar.

### Eski (Legacy) JS Interop

Dart'ın önceki JS interop desteğinin arşivi.

#### JavaScript interop'un evrimi

Dart 3.3, Dart kodunuz içinde JavaScript ve tarayıcı işlevlerine erişmek için birleşik bir dizi özellik ve API sunan yeni nesil bir JS interop sunar. Bu modern yaklaşım, geliştirici deneyimini iyileştirir ve WebAssembly (Wasm) desteğini etkinleştirerek Dart'ı web'in geleceğiyle uyumlu hale getirir.

Aşağıdaki tablo, Dart'ın yeni JS ve web interop çözümlerini eski karşılıklarıyla eşler:

| Yeni interop kütüphaneleri | Eski kütüphaneler |
| --- | --- |
| `package:web` | `dart:html`, `dart:indexed_db`, `dart:svg`, `dart:web_audio`, `dart:web_gl` |
| `dart:js_interop`, `dart:js_interop_unsafe` | `package:js`, `dart:js`, `dart:js_util` |

Önceki JS interop yinelemeleri eski kabul edilir ve Dart 3.7 (Şubat 2025) itibarıyla kullanımdan kaldırılmıştır. İleriye dönük olarak `dart:js_interop` kullanmayı tercih edin ve mümkün olduğunda eski interop kütüphanelerinin kullanımlarını taşıyın. `dart:html` gibi tarayıcı API'leri artık `package:web` tarafından desteklenmektedir.

> **Uyarı:** Eski interop kütüphanelerinin hiçbiri Wasm'a derlenirken desteklenmez.

**`dart:js`**

`dart:js`, JS nesneleriyle birlikte çalışmak için somut bir nesne sarmalayıcı açığa çıkarıyordu. Bu sarmalayıcı, sarmalanmış JS nesnesi üzerindeki özellikleri dinamik olarak almak, ayarlamak ve çağırmak için String tabanlı metotlar içeriyordu. Sarmalama maliyetleri nedeniyle daha az performanslıydı ve ergonomik olarak kullanımı daha zordu. Örneğin, interop üyeleri bildiremediğiniz ve bunun yerine String'lere güvendiğiniz için kod tamamlama elde edemiyordunuz. `dart:js`'te açığa çıkarılan `allowInterop` gibi işlevlerin çoğu daha sonra diğer interop kütüphaneleri aracılığıyla yeniden açığa çıkarıldı.

Bu kütüphane, `package:js` ve `dart:js_util` yayınlandığından beri eskidir.

**`package:js`**

`package:js`, interop tipleri ve üyeleri bildirme işlevselliğini tanıttı. Kullanıcıların interop extension type'ları yerine interop sınıfları yazmasına izin verdi. Çalışma zamanında, bu sınıflar `dart:js_interop`'un `JSObject`'ine benzer bir tipe indirgeniyordu.

```dart
@JS()
class JSType {}
```

`package:js` kullanıcıları, `dart:js_interop`'un söz dizimini ve semantiğini tanıdık bulacaktır. Birçok durumda, sınıf tanımını bir extension type ile değiştirerek `dart:js_interop`'a taşıyabilirsiniz.

Ancak önemli farklılıklar vardır:

- `package:js` tipleri tarayıcı API'leriyle birlikte çalışmak için kullanılamıyordu. `dart:js_interop` tipleri kullanılabilir.
- `package:js` dinamik dispatch'e (dynamic dispatch) izin veriyordu. Bu, `package:js` tipini `dynamic`'e cast edip üzerinde bir interop üyesi çağırırsanız doğru üyeye ileteceği anlamına geliyordu. Bu artık `dart:js_interop` ile mümkün değildir.
- `package:js`'in `@JS`'inin sağlamlık garantileri yoktu, çünkü `external` üyelerin dönüş tipleri kontrol edilmiyordu. `dart:js_interop` sağlamdır.
- `package:js` tipleri instance üyeleri yeniden adlandıramaz veya `external` olmayan üyelere sahip olamazdı.
- `package:js` tipleri, interop olmayan sınıfları alt tipleyebilir ve onların süper tipi olabilirdi. Bu genellikle mock'lar için kullanılırdı. `dart:js_interop` ile mocking, JS nesnesini ikame ederek yapılır. Mocking eğitimine bakın.
- `@anonymous` tipleri, object literal constructor'ı olan bir interop tipi bildirmenin bir yoluydu. `dart:js_interop` tipleri bu şekilde ayırt etmez ve herhangi bir `external` adlandırılmış argüman constructor'ı bir object literal constructor'ıdır.

**`@staticInterop`**

`@JS` ve `@anonymous` ile birlikte, `package:js` daha sonra `@staticInterop`'u açığa çıkardı; bu, interop extension type'larının bir prototipiydi. `dart:js_interop` kadar ifade edici ve kısıtlayıcıdır ve extension type'lar mevcut olana kadar geçiş söz dizimi olarak tasarlanmıştır.

`@staticInterop` tipleri örtük olarak `JSObject`'e indirgeniyordu. Kullanıcıların tüm instance üyeleri extension'larda bildirmesini gerektiriyordu, böylece yalnızca statik semantikler kullanılabiliyordu ve daha güçlü sağlamlık garantilerine sahipti. Kullanıcılar bunu tarayıcı API'leriyle etkileşim kurmak için kullanabiliyordu ve ayrıca yeniden adlandırma ve `external` olmayan üyeler gibi şeylere izin veriyordu. Interop extension type'ları gibi, dinamik dispatch desteği yoktu.

`@staticInterop` sınıfları neredeyse her zaman, sınıfı bir extension type olarak değiştirip anotasyonları kaldırarak bir interop extension type'a taşınabilir.

`dart:js_interop`, extension type'lar dile eklenene kadar statik interop semantiklerini desteklemek için `@staticInterop`'u (ve yalnızca `@staticInterop` da kullanılıyorsa `@anonymous`'u) açığa çıkardı. Bu tür tiplerin tümü artık extension type'lara taşınmalıdır.

**`dart:js_util`**

`dart:js_util`, bir `package:js` tipinde bildirilemeyen veya değerlerin ileri geri geçirilmesi için gerekli olan bir dizi yardımcı fonksiyon sağlıyordu. Bunlar şunları içeriyordu:

- `allowInterop` (şimdi `Function.toJS`)
- `getProperty`/`setProperty`/`callMethod`/`callConstructor` (şimdi `dart:js_interop_unsafe` içinde)
- Çeşitli JS operatörleri
- Tip kontrolü yardımcıları
- Mocking desteği
- Ve daha fazlası.

`dart:js_interop` ve `dart:js_interop_unsafe` artık bu yardımcıları, muhtemelen farklı bir söz dizimiyle içerir.

### `package:web`'e Geçiş

Dart'ın `package:web` paketi, tarayıcı API'lerine erişim sunarak Dart uygulamaları ile web arasındaki birlikte çalışabilirliği sağlar. Tarayıcıyla etkileşim kurmak ve DOM'daki nesneleri ve elementleri manipüle etmek için `package:web` kullanın.

```dart
import 'package:web/web.dart';

void main() {
  final div = document.querySelector('div')!;
  div.textContent = 'Text set at ${DateTime.now()}';
}
```

> **Önemli:** Eğer `dart:html` veya diğer Dart SDK web kütüphanelerini kullanan herkese açık bir Flutter paketi bakımını yapıyorsanız, mümkün olan en kısa sürede `package:web`'e taşımalısınız. `package:web`, uzun vadede Dart'ın web interop çözümü olarak `dart:html` ve diğer web kütüphanelerinin yerini almaktadır. Daha fazla bilgi için `package:web` vs `dart:html` bölümünü okuyun.

#### `package:web` vs `dart:html`

`package:web`'in amacı, mevcut Dart web kütüphaneleriyle ilgili birkaç endişeyi ele alarak Dart'ın web API'lerini açığa çıkarma biçimini yenilemektir:

- **Wasm uyumluluğu:** Paketler yalnızca `dart:js_interop` ve `dart:js_interop_unsafe` kullanıyorlarsa Wasm ile uyumlu olabilir. `package:web`, `dart:js_interop`'a dayalıdır, bu yüzden varsayılan olarak `dart2wasm`'da desteklenir. `dart:html` ve `dart:svg` gibi Dart core web kütüphaneleri kullanımdan kaldırılmıştır ve Wasm'a derlenirken desteklenmez.
- **Güncel kalma:** `package:web`, her IDL bildirimi için interop üyeleri ve interop tipleri otomatik olarak oluşturmak üzere Web IDL'i kullanır. `dart:html`'deki ek üyeler ve soyutlamalar yerine doğrudan referanslar oluşturmak, `package:web`'in daha öz, anlaşılması daha kolay, daha tutarlı olmasını ve Web gelişmelerinin geleceğiyle güncel kalabilmesini sağlar.
- **Sürümleme:** Bir paket olduğu için `package:web`, `dart:html` gibi bir kütüphaneden daha kolay sürümlenebilir ve geliştikçe kullanıcı kodunu bozmaktan kaçınabilir. Ayrıca kodu daha az dışlayıcı ve katkılara daha açık hale getirir. Geliştiriciler, kendi alternatif interop bildirimlerini oluşturabilir ve bunları `package:web` ile çakışma olmadan birlikte kullanabilir.

Bu iyileştirmeler doğal olarak `package:web` ile `dart:html` arasında bazı uygulama farklılıkları doğurur. Mevcut paketleri en çok etkileyen değişiklikler—IDL yeniden adlandırmaları ve tip testleri gibi—aşağıdaki geçiş bölümlerinde ele alınmıştır. Kısaltmak için yalnızca `dart:html`'e atıfta bulunuyoruz, ancak aynı geçiş kalıpları `dart:svg` gibi diğer tüm Dart core web kütüphaneleri için de geçerlidir.

#### `dart:html`'den geçiş

`dart:html` içe aktarımını kaldırın ve `package:web/web.dart` ile değiştirin:

```dart
import 'dart:html' as html; // Remove
import 'package:web/web.dart' as web; // Add
```

pubspec'inizdeki bağımlılıklara `web` ekleyin:

```
dart pub add web
```

Aşağıdaki bölümler, `dart:html`'den `package:web`'e geçişteki yaygın sorunlardan bazılarını ele alır.

Diğer geçiş sorunları için dart-lang/web deposunu kontrol edin ve bir sorun bildirin.

##### Yeniden adlandırmalar

`dart:html`'deki sembollerin çoğu, özgün IDL bildiriminden Dart stiline daha uygun olacak şekilde yeniden adlandırılmıştı. Örneğin, `appendChild` `append` oldu, `HTMLElement` `HtmlElement` oldu, vb.

Buna karşılık, karışıklığı azaltmak için `package:web` IDL tanımlarındaki özgün adları kullanır. `dart:html` ile `package:web` arasında yeniden adlandırılan tipleri dönüştürmek için bir `dart fix` mevcuttur.

İçe aktarımı değiştirdikten sonra, yeniden adlandırılan tüm nesneler yeni "tanımsız" hatalar olacaktır. Bunları şu şekilde ele alabilirsiniz:

- CLI'den `dart fix --dry-run` çalıştırarak.
- IDE'nizde `dart fix: Rename to 'package:web name'` seçeneğini seçerek.

`dart fix`, yaygın tip yeniden adlandırmalarının çoğunu kapsar. Yeniden adlandırmak için `dart fix`'i olmayan bir `dart:html` tipiyle karşılaşırsanız, önce bir sorun bildirerek bize haber verin.

Ardından, mevcut bir `dart:html` üyesinin `package:web` tip adını, tanımına bakarak manuel olarak keşfetmeyi deneyebilirsiniz. Bir `dart:html` üye tanımındaki `@Native` anotasyonunun değeri, derleyiciye o türden herhangi bir JS nesnesini açıklama eklediği Dart sınıfı olarak ele almasını söyler. Örneğin, `@Native` anotasyonu bize `dart:html`'in `HtmlElement` üyesinin native JS adının `HTMLElement` olduğunu söyler, dolayısıyla `package:web` adı da `HTMLElement` olacaktır:

```dart
@Native("HTMLElement")
class HtmlElement extends Element implements NoncedElement { }
```

`package:web`'deki tanımsız bir üye için `dart:html` tanımını bulmak için şu yöntemlerden birini deneyin:

- IDE'de tanımsız adı Ctrl veya command tuşuyla tıklayıp Go to Definition'ı seçin.
- `dart:html` API dokümanlarında adı arayın ve sayfasının Annotations başlığı altına bakın.

Benzer şekilde, tanımı `native` anahtar kelimesini kullanan bir `dart:html` üyesine karşılık gelen tanımsız bir `package:web` API'si bulabilirsiniz. Bir yeniden adlandırma için `@JSName` anotasyonunu kullanıp kullanmadığını kontrol edin; anotasyonun değeri, üyenin `package:web`'de kullandığı adı size söyleyecektir:

```dart
@JSName('appendChild')
Node append(Node node) native;
```

`native`, bu bağlamda `external` ile aynı anlama gelen dahili bir anahtar kelimedir.

##### Element ve HTMLElement

`Element` artık `HTMLElement`'tir, ancak `Element` extension type'ı da `HTMLElement`, `SVGElement` vb. için bir temel tip olarak mevcuttur. Bkz. Element MDN dokümantasyonu. `querySelector`, `HTMLElement` dışında `SVGElement` gibi `Element`'in diğer alt tiplerini de döndürebildiği için bir `Element` döndürür. Metotlarına erişmek istiyorsanız `HTMLElement`'e bir downcast gerekir.

```dart
element.querySelector('#selectme')!.className = 'test'; // valid in both

element.querySelector('#selectme')!.style.color = 'red'; // Remove
(element.querySelector('#selectme') as HTMLElement).style.color = 'red'; // Add
```

##### Liste işlemleri

`dart:html`'in aksine, `package:web` metotları `Element.querySelectorAll` ve `Element.children` gibi, `List` uygulamayan değerler döndürür. Bir `List` gerekiyorsa, onu bir sınıfla sarmanız gerekir.

Değiştirilemez işlemler için `JSImmutableListWrapper` kullanabilirsiniz:

```dart
final anchors = document.querySelectorAll('a');
for (final anchor in anchors) {} // Remove
for (final anchor in JSImmutableListWrapper(anchors)) {} //Add

for (final child in parent.children) {} // Remove
for (final child in JSImmutableListWrapper(parent.children)) {} // Add
```

`removeWhere` gibi basit değiştirilebilir işlemler için uygulama eklemeniz gerekir:

```dart
parent.children.removeWhere(test); // Remove

for (var i = parent.children.length - 1; i >= 0; --i) {
  if (test(parent.children.item(i)!)) {
    parent.children.item(i)!.remove();
  }
}  // Add
```

##### Yaygın DOM manipülasyon örnekleri

`dart:html`'den `package:web`'e geçişte yapılması gereken önemsiz değişikliklere bazı yaygın örnekler:

```dart
element.querySelector('#selector')?.innerHtml = 'something'; // Remove
element.querySelector('#selector')?.innerHTML = 'something'.toJS; // Add

element.parent.classes.add('class'); // Remove
element.parentElement.classList.add('class'); // Add

element.appendHtml(html); // Remove
element.insertAdjacentHTML('beforeend', html.toJS); // Add

var checkbox = CheckboxInputElement(); // Remove
var checkbox = HTMLInputElement()..type='checkbox'; // Add

element.text = 'Hello'; // Remove
element.textContent = 'Hello'; // Add

element.querySelectorAll('a').classes.add('link'); // Remove
for (final a in JSImmutableListWrapper(element.querySelectorAll('a'))) {
  a.classList.add('a');
} // Add
```

##### Tip testleri

`dart:html` kullanan kodun `is` gibi çalışma zamanı kontrollerini kullanması yaygındır. Bir `dart:html` nesnesiyle kullanıldığında, `is` ve `as` nesnenin `@Native` anotasyonundaki JS tipi olduğunu doğrular. Buna karşılık, tüm `package:web` tipleri `JSObject`'e reify edilir. Bu, çalışma zamanı tip testinin `dart:html` ile `package:web` tipleri arasında farklı davranmasına yol açar.

Tip testleri yapabilmek için, `is` tip testlerini kullanan herhangi bir `dart:html` kodunu `instanceOfString` gibi interop metotlarını veya daha kullanışlı ve tipli `isA` yardımcısını (Dart 3.4'ten itibaren mevcut) kullanacak şekilde taşıyın. JS tipleri sayfasının Compatibility, type checks, and casts bölümü alternatifleri ayrıntılı olarak ele alır.

```dart
obj is Window; // Remove
obj.instanceOfString('Window'); // Add

element is InputElement; // Remove
element.isA<HTMLInputElement>(); // Add
```

##### Tip imzaları

`dart:html`'deki birçok API, tip imzalarında çeşitli Dart tiplerini destekler. `dart:js_interop` yazılabilecek tipleri kısıtladığından, `package:web`'deki bazı üyeler artık üyeyi çağırmadan önce değeri dönüştürmenizi gerektirecektir. Interop dönüştürme metotlarını nasıl kullanacağınızı JS tipleri sayfasının Conversions bölümünden öğrenin.

Örneğin, `addEventListener`'a geri çağırmalar geçirirken, Dart fonksiyonunu `.toJS` kullanarak bir `JSFunction`'a dönüştürün:

```dart
window.addEventListener('click', callback); // Remove
window.addEventListener('click', callback.toJS); // Add
// where callback's first parameter accepts Event.
```

> **Not:** `.toJS` çağırmak her seferinde yeni bir `JSFunction` oluşturur. Dinleyiciyi daha sonra `removeEventListener` ile kaldırmak için, dönüştürülmüş `JSFunction`'ı bir değişkende saklayın ve aynı instance'ı her iki metoda da geçirin:
>
> ```dart
> final jsCallback = callback.toJS;
> window.addEventListener('click', jsCallback);
> // ...
> window.removeEventListener('click', jsCallback);
> ```

DOM olaylarına `addEventListener` yerine Dart Stream'leri ile abone olmayı tercih ediyorsanız, `package:web`'deki stream yardımcı extension'larını kullanabilirsiniz:

```dart
// Using the stream helper extension (same API shape as dart:html):
button.onClick.listen((event) {
  // event is already typed as MouseEvent without needing a cast:
  print('Clicked at (${event.clientX}, ${event.clientY})');
});

// Or using EventStreamProviders directly:
EventStreamProviders.clickEvent.forTarget(button).listen((event) {
  print('Clicked at (${event.clientX}, ${event.clientY})');
});
```

Genel olarak, hangi metotların dönüşüm gerektirdiğini, şu istisnanın bir varyasyonuyla işaretlendikleri için fark edebilirsiniz:

```
A value of type '...' can't be assigned to a variable of type 'JSFunction?'
```

##### Koşullu içe aktarımlar

Kodun, native ile web arasında ayrım yapmak için `dart:html`'in desteklenip desteklenmediğine dayalı koşullu bir içe aktarım kullanması yaygındır:

```dart
export 'src/hw_none.dart'
    if (dart.library.io) 'src/hw_io.dart'
    if (dart.library.html) 'src/hw_html.dart';
```

Ancak, `dart:html` kullanımdan kaldırıldığı ve Wasm'a derlenirken desteklenmediği için, doğru alternatif artık native ile web arasında ayrım yapmak için `dart.library.js_interop` kullanmaktır:

```dart
export 'src/hw_none.dart' // Stub implementation
    if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
    if (dart.library.js_interop) 'src/hw_web.dart'; // package:web implementation
```

##### Virtual dispatch ve mocking

`dart:html` sınıfları virtual dispatch'i (sanal çağrıyı) destekliyordu, ancak JS interop extension type'lar kullandığı için virtual dispatch mümkün değildir. Benzer şekilde, `package:web` tipleriyle dinamik çağrılar beklendiği gibi çalışmayacaktır (ya da sadece şans eseri çalışmaya devam edebilirler, ancak `dart:html` kaldırıldığında duracaklardır), çünkü üyeleri yalnızca statik olarak mevcuttur. Virtual dispatch'e dayanan tüm kodu bu sorundan kaçınmak için taşıyın.

Virtual dispatch'in bir kullanım durumu mocking'dir. Bir `dart:html` sınıfını uygulayan bir mock sınıfınız varsa, bunu bir `package:web` tipini uygulamak için kullanamazsınız. Bunun yerine, JS nesnesinin kendisini taklit etmeyi tercih edin. Daha fazla bilgi için mocking eğitimine bakın.

##### Native olmayan API'ler

`dart:html` sınıfları ayrıca önemsiz olmayan bir uygulamaya sahip API'ler içerebilir. Bu üyeler `package:web` yardımcılarında var olabilir veya olmayabilir. Kodunuz bu uygulamanın ayrıntılarına dayanıyorsa, gerekli kodu kopyalayabilirsiniz. Ancak, bunun uygulanabilir olmadığını düşünüyorsanız veya bu kod diğer kullanıcılar için de yararlı olacaksa, `package:web`'e bu üyeyi desteklemek için bir sorun bildirmeyi veya bir pull request yüklemeyi düşünün.

##### Zone'lar

`dart:html`'de geri çağırmalar otomatik olarak zone'lanır. `package:web`'de durum böyle değildir. Mevcut zone'da geri çağırmaların otomatik bağlanması yoktur.

Bu uygulamanız için önemliyse, zone'ları hâlâ kullanabilirsiniz, ancak bunları geri çağırmayı bağlayarak kendiniz yazmanız gerekecektir. Daha fazla ayrıntı için #54507'ye bakın.

Örneğin, bir DOM olay dinleyicisine bir geri çağırma geçirirken, `.toJS` ile dönüştürmeden önce onu mevcut zone'a manuel olarak bağlayın:

```dart
// Before: Callback lost zone context
element.addEventListener(
  'click',
  (web.Event event) {
    // ... relies on zone-local values
  }.toJS,
);

element.addEventListener(
  'click',
  Zone.current.bindUnaryCallback((web.Event event) {
    // ... zone-local values are preserved
  }).toJS,
);
```

Bunu otomatik yapmak için henüz mevcut bir dönüştürme API'si veya yardımcı yoktur.

##### Yardımcılar (Helpers)

`package:web`'in core (çekirdek) yapısı `external` interop üyeleri içerir, ancak `dart:html`'in varsayılan olarak sağladığı diğer işlevselliği sağlamaz. Bu farklılıkları azaltmak için `package:web`, core interop aracılığıyla doğrudan mevcut olmayan bir dizi kullanım durumunu ele almak için yardımcılar içerir. Yardımcı kütüphane, Dart web kütüphanelerinden bazı eski özellikleri açığa çıkarmak için çeşitli üyeler içerir.

Örneğin, core `package:web` yalnızca olay dinleyicileri (event listeners) ekleme ve kaldırma desteğine sahiptir. Bunun yerine, kodu kendiniz yazmadan Dart Stream'leri ile olaylara abone olmayı kolaylaştıran stream yardımcılarını kullanabilirsiniz.

```dart
// Original dart:html version:
final htmlInput = InputElement();
await htmlInput.onBlur.first;

// Migrated package:web version:
final webInput = HTMLInputElement();
await webInput.onBlur.first;
```

Tüm yardımcıları ve dokümantasyonlarını depoda `package:web/helpers` altında bulabilirsiniz. Kullanıcılara geçişte yardımcı olmak ve web API'lerini kullanmayı kolaylaştırmak için sürekli güncelleneceklerdir.

##### Örnekler

`dart:html`'den `package:web`'e taşınan bazı paket örnekleri:

- Upgrading url_launcher to package:web

---

## 8. Iterable Koleksiyonları

Liste ve set gibi `Iterable` nesnelerini kullanmaya yönelik etkileşimli bir kılavuz.

Bu eğitim, `Iterable` sınıfını uygulayan koleksiyonları—örneğin `List` ve `Set`—nasıl kullanacağınızı öğretir. Iterable'lar her tür Dart uygulaması için temel yapı taşlarıdır ve muhtemelen fark etmeden bile onları zaten kullanıyorsunuzdur. Bu eğitim, onlardan en iyi şekilde yararlanmanıza yardımcı olur.

Bu eğitimden en iyi şekilde yararlanmak için temel Dart söz dizimi bilgisine sahip olmalısınız.

Bu eğitim aşağıdaki konuları kapsar:

- Bir `Iterable`'ın öğelerini nasıl okursunuz.
- Bir `Iterable`'ın öğelerinin bir koşulu karşılayıp karşılamadığını nasıl kontrol edersiniz.
- Bir `Iterable`'ın içeriğini nasıl filtreleriniz.
- Bir `Iterable`'ın içeriğini farklı bir değere nasıl eşlersiniz.

Bu eğitimi tamamlamak için tahmini süre: 60 dakika.

### Koleksiyonlar nedir?

Bir koleksiyon, öğe (element) adı verilen bir nesne grubunu temsil eden bir nesnedir. Iterable'lar bir tür koleksiyondur.

Bir koleksiyon boş olabilir veya birçok öğe içerebilir. Amaca bağlı olarak, koleksiyonlar farklı yapılara ve uygulamalara sahip olabilir. En yaygın koleksiyon türlerinden bazıları şunlardır:

- `List`: Öğeleri indeksleriyle okumak için kullanılır.
- `Set`: Yalnızca bir kez görünebilen öğeleri içermek için kullanılır.
- `Map`: Öğeleri bir anahtar kullanarak okumak için kullanılır.

### Iterable nedir?

Bir `Iterable`, sıralı olarak erişilebilen öğelerden oluşan bir koleksiyondur.

Dart'ta bir `Iterable` soyut bir sınıftır, yani doğrudan örnekleyemezsiniz. Ancak, yeni bir `List` veya `Set` oluşturarak yeni bir `Iterable` oluşturabilirsiniz.

Hem `List` hem de `Set` birer `Iterable`'dır, bu yüzden `Iterable` sınıfıyla aynı metot ve özelliklere sahiptirler.

Bir `Map`, uygulamasına bağlı olarak dahili olarak farklı bir veri yapısı kullanır. Örneğin, `HashMap`, öğelerin (değerler olarak da adlandırılır) bir anahtar kullanılarak elde edildiği bir hash tablosu kullanır. Bir `Map`'in öğeleri de map'in `entries` veya `values` özelliği kullanılarak `Iterable` nesneleri olarak okunabilir.

Bu örnek, aynı zamanda bir `int` `Iterable`'ı olan bir `int` `List`'ini gösterir:

```dart
Iterable<int> iterable = [1, 2, 3];
```

`List`'ten farkı, `Iterable` ile öğeleri indeksle okumanın verimli olacağının garanti edilmemesidir. `Iterable`, `List`'in aksine `[]` operatörüne sahip değildir.

Örneğin, aşağıdaki geçersiz kodu düşünün:

```dart
// YANLIŞ
Iterable<int> iterable = [1, 2, 3];
int value = iterable[1];
```

Öğeleri `[]` ile okursanız, derleyici size `'[]' operatörünün Iterable sınıfı için tanımlanmadığını` söyler; bu, bu durumda `[index]`'i kullanamayacağınız anlamına gelir.

Bunun yerine öğeleri `elementAt()` ile okuyabilirsiniz; bu, o konumdaki öğeye ulaşana kadar iterable'ın öğeleri arasında adım adım ilerleyebilir.

```dart
Iterable<int> iterable = [1, 2, 3];
int value = iterable.elementAt(1);
```

Iterable uygulamasına ve öğe sayısına bağlı olarak, `elementAt` doğrusal bir karmaşıklığa sahip olabilir ve pahalı olabilir. Belirli öğelere tekrar tekrar erişmeyi planlıyorsanız, iterable üzerinde bir kez `.toList()` çağırarak onu bir listeye dönüştürmeyi, ardından `[]` operatörünü kullanmayı düşünün.

```dart
final items = veryLargeIterable().toList();

final tenthItem = items[9];
final hundredthItem = items[99];
final thousandthItem = items[999];
final lastItem = items.last;
```

Bir `Iterable`'ın öğelerine nasıl erişileceği hakkında daha fazla bilgi edinmek için sonraki bölüme geçin.

### Öğeleri okuma

Bir iterable'ın öğelerini `for-in` döngüsü kullanarak sıralı olarak okuyabilirsiniz.

#### Örnek: `for-in` döngüsü kullanma

Aşağıdaki örnek, öğelerin bir `for-in` döngüsü kullanılarak nasıl okunacağını gösterir.

**Ayrıntılar:** Perde arkasında, `for-in` döngüsü bir `iterator` kullanır. Ancak `Iterator` API'sini nadiren doğrudan kullanıldığını görürsünüz, çünkü `for-in` okunması ve anlaşılması daha kolaydır ve hataya daha az açıktır.

**Anahtar terimler:**

- **Iterable:** Dart `Iterable` sınıfı.
- **Iterator:** Bir `Iterable` nesnesinden öğeleri okumak için `for-in` tarafından kullanılan bir nesne.
- **for-in döngüsü:** Bir `Iterable`'dan öğeleri sıralı olarak okumanın kolay bir yolu.

#### Örnek: `first` ve `last` kullanma

Bazı durumlarda, bir `Iterable`'ın yalnızca ilk veya son öğesine erişmek istersiniz.

`Iterable` sınıfıyla öğelere doğrudan erişemezsiniz, bu yüzden ilk öğeye erişmek için `iterable[0]`'ı çağıramazsınız. Bunun yerine, ilk öğeyi alan `first`'ı kullanabilirsiniz.

Ayrıca, `Iterable` sınıfıyla son öğeye erişmek için `[]` operatörünü kullanamazsınız, ancak `last` özelliğini kullanabilirsiniz.

> **Uyarı:** Bir `Iterable`'ın son öğesine erişmek diğer tüm öğeler arasında adım atmayı gerektirdiğinden, `last` yavaş olabilir. Boş bir `Iterable` üzerinde `first` veya `last` kullanmak bir `StateError` ile sonuçlanır.

#### Örnek: `firstWhere()` kullanma

`firstWhere()`, belirli koşulları karşılayan ilk öğeyi bulmak için kullanılır. Bu metot, giriş bir koşulu karşılıyorsa `true` döndüren bir **predicate** geçirmenizi gerektirir.

```dart
String element = iterable.firstWhere((element) => element.length > 5);
```

Örneğin, 5 karakterden uzun ilk `String`'i bulmak istiyorsanız, öğe boyutu 5'ten büyük olduğunda `true` döndüren bir predicate geçirmelisiniz.

Bu örnekte, bir predicate yazmanın üç farklı yolunu görürsünüz:

- **İfade olarak:** Test kodu, ok söz dizimini (`=>`) kullanan tek bir satırdır.
- **Blok olarak:** Test kodu, parantezler arasında birden çok satıra ve bir `return` ifadesine sahiptir.
- **Fonksiyon olarak:** Test kodu, `firstWhere()` metoduna parametre olarak geçirilen harici bir fonksiyondadır.

Doğru ya da yanlış bir yol yoktur. Sizin için en iyi işleyen ve kodunuzu okumayı ve anlamayı kolaylaştıran yolu kullanın.

Son örnek, `firstWhere()`'ı isteğe bağlı adlandırılmış `orElse` parametresiyle çağırır; bu, bir öğe bulunamadığında bir alternatif sağlar. Bu durumda, sağlanan koşulu hiçbir öğe karşılamadığı için `'None!'` metni döndürülür.

> **Not:** Hiçbir öğe test predicate'ini karşılamazsa ve `orElse` parametresi sağlanmazsa, `firstWhere()` bir `StateError` fırlatır.

**Hızlı gözden geçirme:**

- Bir `Iterable`'ın öğelerine sıralı olarak erişilmelidir.
- Tüm öğeler arasında iterasyon yapmanın en kolay yolu `for-in` döngüsü kullanmaktır.
- İlk ve son öğeleri almak için `first` ve `last` getter'larını kullanabilirsiniz.
- Bir koşulu karşılayan ilk öğeyi `firstWhere()` ile de bulabilirsiniz.
- Test predicate'lerini ifadeler, bloklar veya fonksiyonlar olarak yazabilirsiniz.
- **Anahtar terimler:**
- **Predicate:** Belirli bir koşul karşılandığında `true` döndüren bir fonksiyon.

#### Alıştırma: Bir test predicate'i yazma

Bu alıştırma, `singleWhere()`'i tanıtır. Bu metot `firstWhere()`'e benzer şekilde çalışır, ancak bu durumda `Iterable`'ın yalnızca bir öğesinin predicate'i karşılamasını bekler. `Iterable`'daki birden fazla veya hiçbir öğe predicate koşulunu karşılamazsa, metot bir `StateError` istisnası fırlatır.

> **Uyarı:** `singleWhere()`, son öğeye kadar tüm `Iterable` boyunca adım atar; bu, `Iterable` sonsuzsa veya büyük bir öğe koleksiyonu içeriyorsa sorunlara yol açabilir.

Hedefiniz, aşağıdaki koşulları karşılayan `singleWhere()` için predicate'i uygulamaktır:

- Öğe `'a'` karakterini içerir.
- Öğe `'M'` karakteriyle başlar.

Test verisindeki tüm öğeler string'dir; yardım için sınıf dokümantasyonuna bakabilirsiniz.

### Koşulları kontrol etme

Bir `Iterable` ile çalışırken, bazen bir koleksiyonun tüm öğelerinin bir koşulu karşıladığını doğrulamanız gerekir.

Aşağıdaki gibi bir `for-in` döngüsü kullanan bir çözüm yazmak isteyebilirsiniz:

```dart
// YANLIŞ
for (final item in items) {
  if (item.length < 5) {
    return false;
  }
}
return true;
```

Ancak, aynı şeyi `every()` metodunu kullanarak yapabilirsiniz:

```dart
return items.every((item) => item.length >= 5);
```

`every()` metodunu kullanmak, daha okunabilir, daha kompakt ve hataya daha az açık kodla sonuçlanır.

#### Örnek: `any()` ve `every()` kullanma

`Iterable` sınıfı, koşulları doğrulamak için kullanabileceğiniz iki metot sağlar:

- `any()`: En az bir öğe koşulu karşılıyorsa `true` döndürür.
- `every()`: Tüm öğeler koşulu karşılıyorsa `true` döndürür.

Örnekte, `any()` en az bir öğenin `a` karakterini içerdiğini doğrular ve `every()` tüm öğelerin uzunluğunun 5'e eşit veya daha büyük olduğunu doğrular.

Kodu çalıştırdıktan sonra, `any()`'nin predicate'ini `false` döndürecek şekilde değiştirmeyi deneyin:

```dart
if (items.any((item) => item.contains('Z'))) {
  print('At least one item contains "Z"');
} else {
  print('No item contains "Z"');
}
```

Bir `Iterable`'ın hiçbir öğesinin belirli bir koşulu karşılamadığını doğrulamak için `any()`'yi de kullanabilirsiniz.

#### Alıştırma: Bir `Iterable`'ın bir koşulu karşıladığını doğrulama

Bu alıştırma, önceki örnekte açıklanan `any()` ve `every()` metotlarını kullanma alıştırması sağlar. Bu durumda, `age` üye alanına sahip `User` nesneleriyle temsil edilen bir kullanıcı grubuyla çalışırsınız.

İki fonksiyonu uygulamak için `any()` ve `every()` kullanın:

- **Bölüm 1:** `anyUserUnder18()` uygulayın.
  En az bir kullanıcı 17 veya daha küçükse `true` döndürün.
- **Bölüm 2:** `everyUserOver13()` uygulayın.
  Tüm kullanıcılar 14 veya daha büyükse `true` döndürün.

**Hızlı gözden geçirme:**

- Koşulları kontrol etmek için `for-in` döngüleri kullanabilirsiniz, ancak bunu yapmanın daha iyi yolları vardır.
- `any()` metodu, herhangi bir öğenin bir koşulu karşılayıp karşılamadığını kontrol etmenizi sağlar.
- `every()` metodu, tüm öğelerin bir koşulu karşıladığını doğrulamanızı sağlar.

### Filtreleme

Önceki bölümler, belirli bir predicate'i karşılayan bir öğeyi bulmanıza yardımcı olabilecek `firstWhere()` veya `singleWhere()` gibi metotları kapsar.

Peki belirli bir koşulu karşılayan tüm öğeleri bulmak istiyorsanız? Bunu `where()` metodunu kullanarak yapabilirsiniz.

```dart
var evenNumbers = numbers.where((number) => number.isEven);
```

Bu örnekte, `numbers` birden çok `int` değeri içeren bir `Iterable`'dır ve `where()` çift olan tüm sayıları bulur.

`where()`'in çıktısı başka bir `Iterable`'dır ve onun üzerinde iterasyon yapmak veya diğer `Iterable` metotlarını uygulamak için bu şekilde kullanabilirsiniz. Sonraki örnekte, `where()`'in çıktısı doğrudan `for-in` döngüsü içinde kullanılır.

```dart
var evenNumbers = numbers.where((number) => number.isEven);
for (final number in evenNumbers) {
  print('$number is even');
}
```

#### Örnek: `where()` kullanma

Bu örnekte, `where()` çift olan tüm sayıları bulmak için kullanılır, ardından sonuçların negatif bir sayı içerip içermediğini kontrol etmek için `any()` kullanılır.

Daha sonra örnekte, 1000'den büyük tüm sayıları bulmak için `where()` tekrar kullanılır. Hiç olmadığı için sonuç boş bir `Iterable`'dır.

> **Not:** `where()`'de hiçbir öğe predicate'i karşılamazsa, metot boş bir `Iterable` döndürür. `singleWhere()` veya `firstWhere()`'in aksine, `where()` bir `StateError` istisnası fırlatmaz.

#### Örnek: `takeWhile` kullanma

`takeWhile()` ve `skipWhile()` metotları da bir `Iterable`'dan öğeleri filtrelemenize yardımcı olabilir.

Bu örnekte, `takeWhile()` ve `skipWhile()`'ın sayılar içeren bir `Iterable`'ı nasıl bölebileceğini görürsünüz.

Bu örnekte, `takeWhile()`, predicate'i karşılayan öğeden önceki tüm öğeleri içeren bir `Iterable` döndürür. Öte yandan, `skipWhile()`, predicate'i karşılamayan ilk öğeden sonraki ve bu öğe dahil tüm öğeleri içeren bir `Iterable` döndürür.

Örneği çalıştırdıktan sonra, ilk negatif sayıya ulaşana kadar öğeleri almak için `takeWhile()`'ı değiştirin.

```dart
var numbersUntilNegative = numbers.takeWhile(
  (number) => !number.isNegative,
);
```

Koşulun `!` ile olumsuzlandığına dikkat edin.

#### Alıştırma: Bir listeden öğeleri filtreleme

Bu alıştırma, önceki alıştırmadaki `User` sınıfıyla `where()` metodunu kullanma alıştırması sağlar.

İki fonksiyonu uygulamak için `where()` kullanın:

- **Bölüm 1:** `filterOutUnder21()` uygulayın.
  21 ve üstü tüm kullanıcıları içeren bir `Iterable` döndürün.
- **Bölüm 2:** `findShortNamed()` uygulayın.
  Adları 3 veya daha az uzunlukta olan tüm kullanıcıları içeren bir `Iterable` döndürün.

**Hızlı gözden geçirme:**

- Bir `Iterable`'ın öğelerini `where()` ile filtreleyin.
- `where()`'in çıktısı başka bir `Iterable`'dır.
- Bir koşul karşılanana kadar veya sonrasındaki öğeleri elde etmek için `takeWhile()` ve `skipWhile()` kullanın.
- Bu metotların çıktısı boş bir `Iterable` olabilir.

### Map İşlemleri (Mapping)

Iterable'ları `map()` metoduyla eşlemek, her öğe üzerinde bir fonksiyon uygulayarak her öğeyi yeni bir öğeyle değiştirmenizi sağlar.

```dart
Iterable<int> output = numbers.map((number) => number * 10);
```

Bu örnekte, `numbers` `Iterable`'ının her öğesi 10 ile çarpılır.

Bir öğeyi farklı bir nesneye dönüştürmek için de `map()` kullanabilirsiniz—örneğin, aşağıdaki örnekte görebileceğiniz gibi, tüm `int`'leri `String`'e dönüştürmek için:

```dart
Iterable<String> output = numbers.map((number) => number.toString());
```

> **Not:** `map()` tembel (lazy) bir `Iterable` döndürür; yani sağlanan fonksiyon yalnızca öğeler üzerinde iterasyon yapıldığında çağrılır.

#### Örnek: Öğeleri değiştirmek için `map` kullanma

Bir `Iterable`'ın tüm öğelerini 2 ile çarpmak için `map()` kullanmayı gösteren bu örneği çalıştırın. Çıktının ne olacağını düşünüyorsunuz?

#### Alıştırma: Farklı bir tipe eşleme

Önceki örnekte, bir `Iterable`'ın öğelerini 2 ile çarptınız. Bu işlemin hem girdisi hem de çıktısı bir `int` `Iterable`'ıydı.

Bu alıştırmada, kodunuz bir `User` `Iterable`'ı alır ve her kullanıcının adını ve yaşını içeren string'ler içeren bir `Iterable` döndürmeniz gerekir.

`Iterable`'daki her string şu formatı izlemelidir: `'{name} is {age}'`—örneğin `'Alice is 21'`.

**Hızlı gözden geçirme:**

- `map()`, bir `Iterable`'ın tüm öğelerine bir fonksiyon uygular.
- `map()`'in çıktısı başka bir `Iterable`'dır.
- Fonksiyon, `Iterable` üzerinde iterasyon yapılana kadar değerlendirilmez.

### Alıştırma: Hepsini bir araya getirme

Öğrendiklerinizi son bir alıştırmada uygulama zamanı.

Bu alıştırma, bir string alan bir constructor'a sahip `EmailAddress` sınıfını sağlar. Sağlanan başka bir fonksiyon da bir e-posta adresinin geçerli olup olmadığını test eden `isValidEmailAddress()`'tir.

| Constructor / Fonksiyon | Tip İmzası | Açıklama |
| --- | --- | --- |
| `EmailAddress()` | `EmailAddress(String address)` | Belirtilen adres için bir `EmailAddress` oluşturur. |
| `isValidEmailAddress()` | `bool isValidEmailAddress(EmailAddress)` | Sağlanan `EmailAddress` geçerliyse `true` döndürür. |

Aşağıdaki kodu yazın:

**Bölüm 1:** `parseEmailAddresses()` uygulayın.

- E-posta adresleri içeren bir `Iterable<String>` alan ve bir `Iterable<EmailAddress>` döndüren `parseEmailAddresses()` fonksiyonunu yazın.
- Bir `String`'den `EmailAddress`'e eşlemek için `map()` metodunu kullanın.
- `EmailAddress` nesnelerini `EmailAddress(String)` constructor'ını kullanarak oluşturun.

**Bölüm 2:** `anyInvalidEmailAddress()` uygulayın.

- Bir `Iterable<EmailAddress>` alan ve `Iterable`'daki herhangi bir `EmailAddress` geçerli değilse `true` döndüren `anyInvalidEmailAddress()` fonksiyonunu yazın.
- `isValidEmailAddress()` sağlanan fonksiyonuyla birlikte `any()` metodunu kullanın.

**Bölüm 3:** `validEmailAddresses()` uygulayın.

- Bir `Iterable<EmailAddress>` alan ve yalnızca geçerli adresleri içeren başka bir `Iterable<EmailAddress>` döndüren `validEmailAddresses()` fonksiyonunu yazın.
- `Iterable<EmailAddress>`'ı filtrelemek için `where()` metodunu kullanın.
- Bir `EmailAddress`'in geçerli olup olmadığını değerlendirmek için sağlanan `isValidEmailAddress()` fonksiyonunu kullanın.

### Sırada Ne Var?

Tebrikler, eğitimi bitirdiniz! Daha fazla bilgi edinmek isterseniz, burada devam edebileceğiniz bazı öneriler var:

- DartPad ile oynayın.
- Bu eğitimin kapsamadığı metotlar hakkında bilgi edinmek için `Iterable` API referansını okuyun.

---

## 9. Future'lar, `async` ve `await`

Asenkron kodun nasıl yazılacağını ve pratik yapılacağını DartPad'de öğrenin!

Bu eğitim, future'ları ve `async` ve `await` anahtar kelimelerini kullanarak asenkron kod yazmayı öğretir. Gömülü DartPad editörlerini kullanarak, örnek kodu çalıştırarak ve alıştırmaları tamamlayarak bilginizi test edebilirsiniz.

Bu eğitimden en iyi şekilde yararlanmak için aşağıdakilere sahip olmalısınız:

- Temel Dart söz dizimi bilgisi.
- Başka bir dilde asenkron kod yazma deneyimi.
- `discarded_futures` ve `unawaited_futures` lint'lerinin etkinleştirilmiş olması.

Bu eğitim aşağıdaki konuları kapsar:

- `async` ve `await` anahtar kelimelerinin nasıl ve ne zaman kullanılacağı.
- `async` ve `await` kullanmanın yürütme sırasını nasıl etkilediği.
- `async` fonksiyonlardaki `try-catch` ifadelerini kullanarak asenkron bir çağrıdan gelen hataların nasıl işleneceği.

Bu eğitimi tamamlamak için tahmini süre: 40-60 dakika.

### Asenkron kod neden önemlidir?

Asenkron işlemler, programınızın başka bir işlemin bitmesini beklerken işi tamamlamasına olanak tanır. Yaygın asenkron işlemlerden bazıları şunlardır:

- Bir ağ üzerinden veri getirmek.
- Bir veritabanına yazmak.
- Bir dosyadan veri okumak.

Bu tür asenkron hesaplamalar genellikle sonuçlarını bir `Future` olarak veya sonuç birden çok parçadan oluşuyorsa bir `Stream` olarak sağlar. Bu hesaplamalar bir programa asenkronluk getirir. Bu ilk asenkronluğu karşılamak için, diğer düz Dart fonksiyonlarının da asenkron hale gelmesi gerekir.

Bu asenkron sonuçlarla etkileşim kurmak için `async` ve `await` anahtar kelimelerini kullanabilirsiniz. Çoğu asenkron fonksiyon, muhtemelen derinlerde doğası gereği asenkron bir hesaplamaya bağlı olan, yalnızca `async` Dart fonksiyonlarıdır.

#### Örnek: Asenkron bir fonksiyonu yanlış kullanma

Aşağıdaki örnek, asenkron bir fonksiyonu (`fetchUserOrder()`) kullanmanın yanlış yolunu gösterir. Daha sonra örneği `async` ve `await` kullanarak düzelteceksiniz. Bu örneği çalıştırmadan önce, sorunu tespit etmeye çalışın -- çıktının ne olacağını düşünüyorsunuz?

Örneğin, `fetchUserOrder()`'un sonunda ürettiği değeri yazdırmamasının nedeni şudur:

- `fetchUserOrder()`, bir gecikmeden sonra kullanıcının siparişini tanımlayan bir string sağlayan asenkron bir fonksiyondur: bir "Large Latte".
- Kullanıcının siparişini almak için `createOrderMessage()`, `fetchUserOrder()`'u çağırmalı ve bitmesini beklemelidir. `createOrderMessage()`, `fetchUserOrder()`'un bitmesini beklemediği için, `fetchUserOrder()`'un sonunda sağladığı string değeri alamaz.
- Bunun yerine, `createOrderMessage()` yapılacak bekleyen işin bir temsilini alır: tamamlanmamış bir future. Future'lar hakkında sonraki bölümde daha fazla bilgi edineceksiniz.
- `createOrderMessage()` kullanıcının siparişini tanımlayan değeri alamadığı için, örnek konsola "Large Latte" yazdırmaz ve bunun yerine "Your order is: Instance of '_Future<String>'" yazdırır.

Sonraki bölümlerde, `fetchUserOrder()`'un konsola istenen değeri ("Large Latte") yazdırması için gerekli kodu yazabilmeniz için future'ları ve future'larla çalışmayı (`async` ve `await` kullanarak) öğreneceksiniz.

**Anahtar terimler:**

- **senkron işlem:** Bir senkron işlem, tamamlanana kadar diğer işlemlerin yürütülmesini engeller.
- **senkron fonksiyon:** Bir senkron fonksiyon yalnızca senkron işlemler gerçekleştirir.
- **asenkron işlem:** Başlatıldıktan sonra, bir asenkron işlem tamamlanmadan önce diğer işlemlerin yürütülmesine izin verir.
- **asenkron fonksiyon:** Bir asenkron fonksiyon en az bir asenkron işlem gerçekleştirir ve ayrıca senkron işlemler de gerçekleştirebilir.

### Future nedir?

Bir future (küçük "f"), `Future` (büyük "F") sınıfının bir instance'ıdır. Bir future, asenkron bir işlemin sonucunu temsil eder ve iki duruma sahip olabilir: tamamlanmamış veya tamamlanmış.

> **Not:** Tamamlanmamış (Uncompleted), bir future'ın bir değer üretmeden önceki durumuna atıfta bulunan bir Dart terimidir.

#### Tamamlanmamış (Uncompleted)

Asenkron bir fonksiyonu çağırdığınızda, tamamlanmamış bir future döndürür. O future, fonksiyonun asenkron işleminin bitmesini veya bir hata fırlatmasını bekler.

#### Tamamlanmış (Completed)

Asenkron işlem başarılı olursa, future bir değerle tamamlanır. Aksi halde bir hatayla tamamlanır.

**Bir değerle tamamlanma**

`Future<T>` tipinde bir future, `T` tipinde bir değerle tamamlanır. Örneğin, `Future<String>` tipli bir future bir string değeri üretir. Bir future kullanılabilir bir değer üretmiyorsa, future'ın tipi `Future<void>`'tur.

**Bir hatayla tamamlanma**

Fonksiyon tarafından gerçekleştirilen asenkron işlem herhangi bir nedenle başarısız olursa, future bir hatayla tamamlanır.

#### Örnek: Future'ları tanıtma

Aşağıdaki örnekte, `fetchUserOrder()` konsola yazdırdıktan sonra tamamlanan bir future döndürür. Kullanılabilir bir değer döndürmediği için, `fetchUserOrder()` `Future<void>` tipine sahiptir. Örneği çalıştırmadan önce, hangisinin önce yazdırılacağını tahmin etmeye çalışın: "Large Latte" mi yoksa "Fetching user order..." mi?

Önceki örnekte, `fetchUserOrder()` 8. satırdaki `print()` çağrısından önce yürütülse de, konsol 8. satırdan ("Fetching user order...") çıktıyı `fetchUserOrder()`'dan ("Large Latte") gelen çıktıdan önce gösterir. Çünkü `fetchUserOrder()` "Large Latte" yazdırmadan önce geciktirir.

#### Örnek: Bir hatayla tamamlanma

Bir future'ın bir hatayla nasıl tamamlandığını görmek için aşağıdaki örneği çalıştırın. Birazdan hatanın nasıl işleneceğini öğreneceksiniz.

Bu örnekte, `fetchUserOrder()` kullanıcı ID'sinin geçersiz olduğunu belirten bir hatayla tamamlanır.

Future'lar ve nasıl tamamlandıklarını öğrendiniz, ancak asenkron fonksiyonların sonuçlarını nasıl kullanırsınız? Sonraki bölümde `async` ve `await` anahtar kelimeleriyle sonuçları nasıl alacağınızı öğreneceksiniz.

**Hızlı gözden geçirme:**

- Bir `Future<T>` instance'ı, `T` tipinde bir değer üretir.
- Bir future kullanılabilir bir değer üretmiyorsa, future'ın tipi `Future<void>`'tur.
- Bir future iki durumdan birinde olabilir: tamamlanmamış veya tamamlanmış.
- Bir future döndüren bir fonksiyonu çağırdığınızda, fonksiyon yapılacak işi kuyruğa alır ve tamamlanmamış bir future döndürür.
- Bir future'ın işlemi bittiğinde, future bir değerle veya bir hatayla tamamlanır.

**Anahtar terimler:**

- **Future:** Dart `Future` sınıfı.
- **future:** Dart `Future` sınıfının bir instance'ı.

### Future'larla çalışma: `async` ve `await`

`async` ve `await` anahtar kelimeleri, asenkron fonksiyonları tanımlamanın ve sonuçlarını kullanmanın bildirimsel bir yolunu sağlar. `async` ve `await` kullanırken şu iki temel kuralı hatırlayın:

- Bir `async` fonksiyon tanımlamak için fonksiyon gövdesinden önce `async` ekleyin.
- `await` anahtar kelimesi yalnızca `async` fonksiyonlarda çalışır.

İşte `main()`'i senkron bir fonksiyondan asenkron bir fonksiyona dönüştüren bir örnek.

İlk olarak, fonksiyon gövdesinden önce `async` anahtar kelimesini ekleyin:

```dart
void main() async { ··· }
```

Fonksiyonun bildirilmiş bir dönüş tipi varsa, tipi `Future<T>` olacak şekilde güncelleyin; burada `T`, fonksiyonun döndürdüğü değerin tipidir. Fonksiyon açıkça bir değer döndürmüyorsa, dönüş tipi `Future<void>`'tur:

```dart
Future<void> main() async { ··· }
```

Artık bir `async` fonksiyonunuz olduğuna göre, bir future'ın tamamlanmasını beklemek için `await` anahtar kelimesini kullanabilirsiniz:

```dart
print(await createOrderMessage());
```

Aşağıdaki iki örneğin gösterdiği gibi, `async` ve `await` anahtar kelimeleri, senkron koda çok benzeyen asenkron kodla sonuçlanır. Tek farklar, asenkron örnekte vurgulanmıştır.

#### Örnek: senkron fonksiyonlar

```dart
String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(const Duration(seconds: 2), () => 'Large Latte');

void main() {
  print('Fetching user order...');
  print(createOrderMessage());
}
```

Çıktı:

```
Fetching user order...
Your order is: Instance of 'Future<String>'
```

#### Örnek: asenkron fonksiyonlar

```dart
Future<String> createOrderMessage() async {
  var order = await fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(const Duration(seconds: 2), () => 'Large Latte');

Future<void> main() async {
  print('Fetching user order...');
  print(await createOrderMessage());
}
```

Çıktı:

```
Fetching user order...
Your order is: Large Latte
```

Asenkron örnek üç şekilde farklıdır:

- `createOrderMessage()`'un dönüş tipi `String`'den `Future<String>`'e değişir.
- `createOrderMessage()` ve `main()` fonksiyon gövdelerinden önce `async` anahtar kelimesi görünür.
- Asenkron fonksiyonlar `fetchUserOrder()` ve `createOrderMessage()` çağrılmadan önce `await` anahtar kelimesi görünür.

**Anahtar terimler:**

- **async:** Bir fonksiyonu asenkron olarak işaretlemek için gövdesinden önce `async` anahtar kelimesini kullanabilirsiniz.
- **async fonksiyon:** Bir `async` fonksiyon, `async` anahtar kelimesiyle etiketlenmiş bir fonksiyondur.
- **await:** Asenkron bir ifadenin tamamlanmış sonucunu almak için `await` anahtar kelimesini kullanabilirsiniz. `await` anahtar kelimesi yalnızca bir `async` fonksiyon içinde çalışır.

#### `async` ve `await` ile yürütme akışı

Bir `async` fonksiyon, ilk `await` anahtar kelimesine kadar senkron olarak çalışır. Bu, bir `async` fonksiyon gövdesi içinde, ilk `await` anahtar kelimesinden önceki tüm senkron kodun hemen yürütüldüğü anlamına gelir.

#### Örnek: `async` fonksiyonlar içinde yürütme

Bir `async` fonksiyon gövdesi içinde yürütmenin nasıl ilerlediğini görmek için aşağıdaki örneği çalıştırın. Çıktının ne olacağını düşünüyorsunuz?

Önceki örnekteki kodu çalıştırdıktan sonra, 2. ve 3. satırları ters çevirmeyi deneyin:

```dart
var order = await fetchUserOrder();
print('Awaiting user order...');
```

`print('Awaiting user order')` artık `printOrderMessage()` içindeki ilk `await` anahtar kelimesinden sonra göründüğü için çıktının zamanlamasının değiştiğine dikkat edin.

#### Alıştırma: `async` ve `await` kullanma

Aşağıdaki alıştırma, kısmen tamamlanmış kod parçacıkları içeren başarısız bir birim testidir. Göreviniz, testleri geçmesi için kod yazdırarak alıştırmayı tamamlamaktır. `main()`'i uygulamanıza gerek yok.

Asenkron işlemleri simüle etmek için, sizin için sağlanan aşağıdaki fonksiyonları çağırın:

| Fonksiyon | Tip imzası | Açıklama |
| --- | --- | --- |
| `fetchRole()` | `Future<String> fetchRole()` | Kullanıcının rolünün kısa bir açıklamasını alır. |
| `fetchLoginAmount()` | `Future<int> fetchLoginAmount()` | Bir kullanıcının kaç kez giriş yaptığını alır. |

**Bölüm 1: `reportUserRole()`**

`reportUserRole()` fonksiyonuna, aşağıdakileri yapacak kodu ekleyin:

- Aşağıdaki string ile tamamlanan bir future döndürür: `"User role: <user role>"`
  Not: `fetchRole()` tarafından döndürülen gerçek değeri kullanmalısınız.
  Örnek dönüş değeri: `"User role: tester"`
- Kullanıcı rolünü, sağlanan `fetchRole()` fonksiyonunu çağırarak alır.

**Bölüm 2: `reportLogins()`**

Aşağıdakileri yapacak şekilde asenkron bir `reportLogins()` fonksiyonu uygulayın:

- `"Total number of logins: <# of logins>"` string'ini döndürür.
  Not: `fetchLoginAmount()` tarafından döndürülen gerçek değeri kullanmalısınız.
  `reportLogins()` örnek dönüş değeri: `"Total number of logins: 57"`
- Giriş sayısını, sağlanan `fetchLoginAmount()` fonksiyonunu çağırarak alır.

### Hataları işleme

Bir `async` fonksiyondaki hataları işlemek için `try-catch` kullanın:

```dart
try {
  print('Awaiting user order...');
  var order = await fetchUserOrder();
} catch (err) {
  print('Caught error: $err');
}
```

Bir `async` fonksiyon içinde, `try-catch` bloklarını senkron kodda yapacağınız gibi yazabilirsiniz.

#### Örnek: `try-catch` ile `async` ve `await`

Asenkron bir fonksiyondan gelen bir hatanın nasıl işleneceğini görmek için aşağıdaki örneği çalıştırın. Çıktının ne olacağını düşünüyorsunuz?

#### Alıştırma: Hataları işleme

Bu alıştırma, önceki bölümde açıklanan yaklaşımı kullanarak asenkron kodla hataları işleme alıştırması sağlar. Asenkron işlemleri simüle etmek için, kodunuz sizin için sağlanan aşağıdaki fonksiyonu çağıracaktır:

| Fonksiyon | Tip imzası | Açıklama |
| --- | --- | --- |
| `fetchNewUsername()` | `Future<String> fetchNewUsername()` | Eski bir kullanıcı adını değiştirmek için kullanabileceğiniz yeni kullanıcı adını döndürür. |

Aşağıdakileri yapan asenkron bir `changeUsername()` fonksiyonu uygulamak için `async` ve `await` kullanın:

- Sağlanan asenkron `fetchNewUsername()` fonksiyonunu çağırır ve sonucunu döndürür.
  `changeUsername()` örnek dönüş değeri: `"jane_smith_92"`
- Oluşan herhangi bir hatayı yakalar ve hatanın string değerini döndürür.
  Hem `Exception`'ları hem de `Error`'ları string'e dönüştürmek için `toString()` metodunu kullanabilirsiniz.

### Alıştırma: Hepsini bir araya getirme

Öğrendiklerinizi son bir alıştırmada uygulama zamanı. Asenkron işlemleri simüle etmek için, bu alıştırma `fetchUsername()` ve `logoutUser()` asenkron fonksiyonlarını sağlar:

| Fonksiyon | Tip imzası | Açıklama |
| --- | --- | --- |
| `fetchUsername()` | `Future<String> fetchUsername()` | Geçerli kullanıcıyla ilişkili adı döndürür. |
| `logoutUser()` | `Future<String> logoutUser()` | Geçerli kullanıcının oturumunu kapatır ve oturumu kapatılan kullanıcı adını döndürür. |

Aşağıdakileri yazın:

**Bölüm 1: `addHello()`**

- Tek bir `String` argümanı alan bir `addHello()` fonksiyonu yazın.
- `addHello()`, `String` argümanını `'Hello '` ile öncelenmiş olarak döndürür.
- Örnek: `addHello('Jon')` `'Hello Jon'` döndürür.

**Bölüm 2: `greetUser()`**

- Hiç argüman almayan bir `greetUser()` fonksiyonu yazın.
- Kullanıcı adını almak için `greetUser()`, sağlanan asenkron `fetchUsername()` fonksiyonunu çağırır.
- `greetUser()`, kullanıcı adını `addHello()`'ya geçirerek ve sonucu döndürerek kullanıcı için bir karşılama oluşturur.
- Örnek: `fetchUsername()` `'Jenny'` döndürürse, `greetUser()` `'Hello Jenny'` döndürür.

**Bölüm 3: `sayGoodbye()`**

- Aşağıdakileri yapan bir `sayGoodbye()` fonksiyonu yazın:
  - Hiç argüman almaz.
  - Herhangi bir hatayı yakalar.
  - Sağlanan asenkron `logoutUser()` fonksiyonunu çağırır.
- `logoutUser()` başarısız olursa, `sayGoodbye()` istediğiniz herhangi bir string'i döndürür.
- `logoutUser()` başarılı olursa, `sayGoodbye()` `'<result> Thanks, see you next time'` string'ini döndürür; burada `<result>`, `logoutUser()`'u çağırarak döndürülen string değeridir.

### Future'lar için hangi lint'ler çalışır?

`async` ve future'larla çalışırken ortaya çıkan yaygın hataları yakalamak için aşağıdaki lint'leri etkinleştirin:

- `discarded_futures`
- `unawaited_futures`

### Sırada Ne Var?

Tebrikler, eğitimi bitirdiniz! Daha fazla bilgi edinmek isterseniz, burada devam edebileceğiniz bazı öneriler var:

- DartPad ile oynayın.
- Dart'ta future'lar ve asenkron kod hakkında daha fazla bilgi edinin:
  - Streams eğitimi: Bir dizi asenkron olayla nasıl çalışılacağını öğrenin.
  - Dart'ta eşzamanlılık: Dart'ta eşzamanlılığı anlayın ve nasıl uygulayacağınızı öğrenin.
  - Asenkron programlama: Dart'ın asenkron kodlama için dil ve kütüphane desteğine dalın.
  - Google'dan Dart videoları: Asenkron kodlamayla ilgili bir veya daha fazla videoyu izleyin.
- Dart SDK'yı edinin!

---

## 10. Future'lar ve Hata Yönetimi

Asenkron kod yazarken hataları ve istisnaları işleme hakkında bilmek istediğiniz her şey. Ve daha fazlası.

Dart dilinin yerleşik asenkron desteği vardır ve bu, asenkron Dart kodunu okumayı ve yazmayı çok daha kolay hale getirir. Ancak, bazı kodlar—özellikle daha eski kodlar—hâlâ `then()`, `catchError()` ve `whenComplete()` gibi `Future` metotlarını kullanıyor olabilir.

Bu sayfa, bu `Future` metotlarını kullanırken bazı yaygın tuzaklardan kaçınmanıza yardımcı olabilir.

> **Uyarı:** Kodunuz dilin asenkron desteğini kullanıyorsa—`async`, `await` ve `try-catch` ile hata işleme—bu sayfaya ihtiyacınız yoktur. Daha fazla bilgi için asenkron programlama eğitimine bakın.

### Future API'si ve geri çağırmalar

`Future` API'sini kullanan fonksiyonlar, bir `Future`'ı tamamlayan değeri (veya hatayı) işleyen geri çağırmalar kaydeder. Örneğin:

```dart
myFunc().then(processValue).catchError(handleError);
```

Kaydedilen geri çağırmalar aşağıdaki kurallara göre tetiklenir: `then()`'in geri çağırması, bir değerle tamamlanan bir `Future` üzerinde çağrılırsa tetiklenir; `catchError()`'un geri çağırması, bir hatayla tamamlanan bir `Future` üzerinde çağrılırsa tetiklenir.

Yukarıdaki örnekte, `myFunc()`'un `Future`'ı bir değerle tamamlarsa, `then()`'in geri çağırması tetiklenir. `then()` içinde yeni bir hata üretilmezse, `catchError()`'un geri çağırması tetiklenmez. Öte yandan, `myFunc()` bir hatayla tamamlarsa, `then()`'in geri çağırması tetiklenmez ve `catchError()`'un geri çağırması tetiklenir.

### `then()` ile `catchError()` kullanma örnekleri

Zincirlenmiş `then()` ve `catchError()` çağrıları, `Future`'larla uğraşırken yaygın bir kalıptır ve kabaca `try-catch` bloklarının eşdeğeri olarak düşünülebilir.

Sonraki birkaç bölüm bu kalıba örnekler verir.

#### `catchError()` kapsamlı bir hata işleyici olarak

Aşağıdaki örnek, `then()`'in geri çağırması içinden bir istisna fırlatmayı ele alır ve `catchError()`'un bir hata işleyici olarak çok yönlülüğünü gösterir:

```dart
myFunc()
    .then((value) {
      doSomethingWith(value);
      ...
      throw Exception('Some arbitrary error');
    })
    .catchError(handleError);
```

`myFunc()`'un `Future`'ı bir değerle tamamlarsa, `then()`'in geri çağırması tetiklenir. `then()`'in geri çağırması içindeki kod fırlatırsa (yukarıdaki örnekte yaptığı gibi), `then()`'in `Future`'ı bir hatayla tamamlanır. Bu hata `catchError()` tarafından işlenir.

`myFunc()`'un `Future`'ı bir hatayla tamamlarsa, `then()`'in `Future`'ı o hatayla tamamlanır. Hata ayrıca `catchError()` tarafından işlenir.

Hatanın `myFunc()` içinde mi yoksa `then()` içinde mi ortaya çıktığına bakılmaksızın, `catchError()` bunu başarılı bir şekilde işler.

#### `then()` içinde hata işleme

Daha ayrıntılı hata işleme için, `then()` içinde ikinci bir (`onError`) geri çağırma kaydederek hatalarla tamamlanan `Future`'ları işleyebilirsiniz. İşte `then()`'in imzası:

```dart
Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError});
```

İsteğe bağlı `onError` geri çağırmasını yalnızca `then()`'e iletilen bir hata ile `then()` içinde üretilen bir hata arasında ayrım yapmak istiyorsanız kaydedin:

```dart
asyncErrorFunction()
    .then(
      successCallback,
      onError: (e) {
        handleError(e); // Original error.
        anotherAsyncErrorFunction(); // Oops, new error.
      },
    )
    .catchError(handleError); // Error from within then() handled.
```

Yukarıdaki örnekte, `asyncErrorFunction()`'un `Future`'ının hatası `onError` geri çağırmasıyla işlenir; `anotherAsyncErrorFunction()`, `then()`'in `Future`'ının bir hatayla tamamlanmasına neden olur; bu hata `catchError()` tarafından işlenir.

Genel olarak, iki farklı hata işleme stratejisi uygulamak önerilmez: ikinci bir geri çağırmayı yalnızca hatayı `then()` içinde yakalamak için zorlayıcı bir neden varsa kaydedin.

#### Uzun bir zincirin ortasındaki hatalar

Bir dizi `then()` çağrısına sahip olmak ve zincirin herhangi bir yerinden üretilen hataları `catchError()` kullanarak yakalamak yaygındır:

```dart
Future<String> one() => Future.value('from one');
Future<String> two() => Future.error('error from two');
Future<String> three() => Future.value('from three');
Future<String> four() => Future.value('from four');

void main() {
  one() // Future completes with "from one".
      .then((_) => two()) // Future completes with two()'s error.
      .then((_) => three()) // Future completes with two()'s error.
      .then((_) => four()) // Future completes with two()'s error.
      .then((value) => value.length) // Future completes with two()'s error.
      .catchError((e) {
        print('Got error: $e'); // Finally, callback fires.
        return 42; // Future completes with 42.
      })
      .then((value) {
        print('The value is $value');
      });
}

// Output of this program:
//   Got error: error from two
//   The value is 42
```

Yukarıdaki kodda, `one()`'ın `Future`'ı bir değerle tamamlanır, ancak `two()`'nun `Future`'ı bir hatayla tamamlanır. Bir hatayla tamamlanan bir `Future` üzerinde `then()` çağrıldığında, `then()`'in geri çağırması tetiklenmez. Bunun yerine, `then()`'in `Future`'ı alıcısının hatasıyla tamamlanır. Örneğimizde bu, `two()` çağrıldıktan sonra, sonraki her `then()` tarafından döndürülen `Future`'ın `two()`'nun hatasıyla tamamlandığı anlamına gelir. Bu hata nihayet `catchError()` içinde işlenir.

#### Belirli hataları işleme

Belirli bir hatayı mı yakalamak istiyorsunuz? Ya da birden çok hatayı mı?

`catchError()`, fırlatılan hatanın türünü sorgulamamıza izin veren isteğe bağlı `test` adlı bir argüman alır.

```dart
Future<T> catchError(Function onError, {bool Function(Object error)? test});
```

Sağlanan parametrelere göre bir kullanıcının kimliğini doğrulayan ve kullanıcıyı uygun bir URL'ye yönlendiren `handleAuthResponse(params)` fonksiyonunu düşünün. Karmaşık iş akışı göz önüne alındığında, `handleAuthResponse()` çeşitli hatalar ve istisnalar üretebilir ve bunları farklı şekilde işlemelisiniz. `test`'i kullanarak bunu nasıl yapabileceğiniz aşağıda açıklanmıştır:

```dart
void main() {
  handleAuthResponse(const {'username': 'dash', 'age': 3})
      .then((_) => ...)
      .catchError(handleFormatException, test: (e) => e is FormatException)
      .catchError(
        handleAuthorizationException,
        test: (e) => e is AuthorizationException,
      );
}
```

### `whenComplete()` kullanarak asenkron try-catch-finally

Eğer `then().catchError()` bir `try-catch`'i yansıtıyorsa, `whenComplete()` de `finally`'nin eşdeğeridir. `whenComplete()` içinde kaydedilen geri çağırma, `whenComplete()`'in alıcısı tamamlandığında çağrılır, ister bir değerle ister bir hatayla tamamlansın:

```dart
final server = connectToServer();
server
    .post(myUrl, fields: const {'name': 'Dash', 'profession': 'mascot'})
    .then(handleResponse)
    .catchError(handleError)
    .whenComplete(server.close);
```

`server.post()` geçerli bir yanıt mı yoksa bir hata mı üretirse üretsin `server.close`'u çağırmak istiyoruz. Bunun gerçekleşmesini `whenComplete()` içine yerleştirerek sağlıyoruz.

#### `whenComplete()` tarafından döndürülen `Future`'ı tamamlama

`whenComplete()` içinden bir hata yayılmazsa, `Future`'ı `whenComplete()`'in üzerinde çağrıldığı `Future` ile aynı şekilde tamamlanır. Bunu örneklerle anlamak en kolaydır.

Aşağıdaki kodda, `then()`'in `Future`'ı bir hatayla tamamlanır, bu yüzden `whenComplete()`'in `Future`'ı da bu hatayla tamamlanır.

```dart
void main() {
  asyncErrorFunction()
      // Future completes with an error:
      .then((_) => print("Won't reach here"))
      // Future completes with the same error:
      .whenComplete(() => print('Reaches here'))
      // Future completes with the same error:
      .then((_) => print("Won't reach here"))
      // Error is handled here:
      .catchError(handleError);
}
```

Aşağıdaki kodda, `then()`'in `Future`'ı bir hatayla tamamlanır ve bu hata artık `catchError()` tarafından işlenir. `catchError()`'un `Future`'ı `someObject` ile tamamlandığı için, `whenComplete()`'in `Future`'ı da o aynı nesneyle tamamlanır.

```dart
void main() {
  asyncErrorFunction()
      // Future completes with an error:
      .then((_) => ...)
      .catchError((e) {
        handleError(e);
        printErrorMessage();
        return someObject; // Future completes with someObject
      })
      .whenComplete(() => print('Done!')); // Future completes with someObject
}
```

#### `whenComplete()` içinde ortaya çıkan hatalar

`whenComplete()`'in geri çağırması bir hata fırlatırsa, `whenComplete()`'in `Future`'ı o hatayla tamamlanır:

```dart
void main() {
  asyncErrorFunction()
      // Future completes with a value:
      .catchError(handleError)
      // Future completes with an error:
      .whenComplete(() => throw Exception('New error'))
      // Error is handled:
      .catchError(handleError);
}
```

### Olası sorun: hata işleyicilerini erken kaydetmemek

Hata işleyicilerinin bir `Future` tamamlanmadan önce kurulması çok önemlidir: bu, bir `Future`'ın bir hatayla tamamlandığı, hata işleyicinin henüz eklenmediği ve hatanın yanlışlıkla yayıldığı senaryolardan kaçınır. Şu kodu düşünün:

```dart
void main() {
  Future<Object> future = asyncErrorFunction();

  // BAD: Too late to handle asyncErrorFunction() exception.
  Future.delayed(const Duration(milliseconds: 500), () {
    future.then(...).catchError(...);
  });
}
```

Yukarıdaki kodda, `catchError()` `asyncErrorFunction()` çağrıldıktan yarım saniye sonraya kadar kaydedilmez ve hata işlenmeden kalır.

`asyncErrorFunction()` `Future.delayed()` geri çağırması içinde çağrılırsa sorun ortadan kalkar:

```dart
void main() {
  Future.delayed(const Duration(milliseconds: 500), () {
    asyncErrorFunction()
        .then(...)
        .catchError(...); // We get here.
  });
}
```

### Olası sorun: senkron ve asenkron hataları yanlışlıkla karıştırma

`Future` döndüren fonksiyonlar neredeyse her zaman hatalarını future'da yaymalıdır. Böyle bir fonksiyonun çağıranının birden çok hata işleme senaryosu uygulamak zorunda kalmasını istemediğimiz için, herhangi bir senkron hatanın dışarı sızmasını önlemek isteriz. Şu kodu düşünün:

```dart
Future<int> parseAndRead(Map<String, dynamic> data) {
  final filename = obtainFilename(data); // Could throw.
  final file = File(filename);
  return file.readAsString().then((contents) {
    return parseFileData(contents); // Could throw.
  });
}
```

Bu koddaki iki fonksiyon potansiyel olarak senkron olarak fırlatabilir: `obtainFilename()` ve `parseFileData()`. `parseFileData()` bir `then()` geri çağırması içinde yürütüldüğü için, hatası fonksiyonun dışına sızmaz. Bunun yerine, `then()`'in `Future`'ı `parseFileData()`'nın hatasıyla tamamlanır, hata en sonunda `parseAndRead()`'in `Future`'ını tamamlar ve hata `catchError()` tarafından başarılı bir şekilde işlenebilir.

Ancak `obtainFilename()` bir `then()` geri çağırması içinde çağrılmaz; fırlatırsa, senkron bir hata yayılır:

```dart
void main() {
  parseAndRead(data).catchError((e) {
    print('Inside catchError');
    print(e);
    return -1;
  });
}

// Program Output:
//   Unhandled exception:
//   <error from obtainFilename>
//   ...
```

`catchError()` kullanmak hatayı yakalamadığı için, `parseAndRead()`'in bir istemcisi bu hata için ayrı bir hata işleme stratejisi uygular.

#### Çözüm: Kodunuzu sarmak için `Future.sync()` kullanma

Bir fonksiyondan yanlışlıkla senkron bir hatanın fırlatılmamasını sağlamanın yaygın bir kalıbı, fonksiyon gövdesini yeni bir `Future.sync()` geri çağırması içine sarmaktır:

```dart
Future<int> parseAndRead(Map<String, dynamic> data) {
  return Future.sync(() {
    final filename = obtainFilename(data); // Could throw.
    final file = File(filename);
    return file.readAsString().then((contents) {
      return parseFileData(contents); // Could throw.
    });
  });
}
```

Geri çağırma `Future` olmayan bir değer döndürürse, `Future.sync()`'in `Future`'ı o değerle tamamlanır. Geri çağırma fırlatırsa (yukarıdaki örnekte yaptığı gibi), `Future` bir hatayla tamamlanır. Geri çağırmanın kendisi bir `Future` döndürürse, o `Future`'ın değeri veya hatası `Future.sync()`'in `Future`'ını tamamlar.

Kodu `Future.sync()` içine sardıktan sonra, `catchError()` tüm hataları işleyebilir:

```dart
void main() {
  parseAndRead(data).catchError((e) {
    print('Inside catchError');
    print(e);
    return -1;
  });
}

// Program Output:
//   Inside catchError
//   <error from obtainFilename>
```

`Future.sync()`, kodunuzu yakalanmamış istisnalara karşı dayanıklı hale getirir. Fonksiyonunuzda çok fazla kod varsa, büyük olasılıkla farkında olmadan tehlikeli bir şey yapıyor olabilirsiniz:

```dart
Future fragileFunc() {
  return Future.sync(() {
    final x = someFunc(); // Unexpectedly throws in some rare cases.
    var y = 10 / x; // x should not equal 0.
    ...
  });
}
```

`Future.sync()` yalnızca oluşabileceğini bildiğiniz hataları işlemenize olanak tanımakla kalmaz, aynı zamanda hataların yanlışlıkla fonksiyonunuzun dışına sızmasını da önler.

### Daha Fazla Bilgi

`Future`'lar hakkında daha fazla bilgi için `Future` API referansına bakın.

---

## 11. Stream Kullanımı

Asenkron programlama: Streams — tek abonelikli ve yayın (broadcast) stream'leri nasıl tüketirsiniz öğrenin.

**Önemli olan ne?**

- Stream'ler bir dizi asenkron veri sağlar.
- Veri dizileri, kullanıcı tarafından oluşturulan olayları ve dosyalardan okunan verileri içerir.
- Bir stream'i ya `await for` ya da `Stream` API'sinden `listen()` kullanarak işleyebilirsiniz.
- Stream'ler hatalara yanıt vermenin bir yolunu sağlar.
- İki tür stream vardır: tek abonelik (single subscription) veya yayın (broadcast).

Dart'ta asenkron programlama, `Future` ve `Stream` sınıflarıyla karakterize edilir.

Bir `Future`, hemen tamamlanmayan bir hesaplamayı temsil eder. Normal bir fonksiyonun sonucu döndürdüğü yerde, asenkron bir fonksiyon sonunda sonucu içerecek bir `Future` döndürür. Future, sonucun ne zaman hazır olduğunu size söyler.

Bir stream, asenkron olayların bir dizisidir. Asenkron bir `Iterable` gibidir—isteğiniz üzerine bir sonraki olayı almak yerine, hazır olduğunda bir olay olduğunu size söyler.

### Stream olaylarını alma

Stream'ler birçok şekilde oluşturulabilir, ancak hepsi aynı şekilde kullanılabilir: asenkron for döngüsü (yaygın olarak `await for` olarak adlandırılır), `for` döngüsünün bir `Iterable` üzerinde iterasyon yapması gibi bir stream'in olayları üzerinde iterasyon yapar. Örneğin:

```dart
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (final value in stream) {
    sum += value;
  }
  return sum;
}
```

Bu kod, bir tamsayı olayları stream'inin her olayını alır, toplar ve (bir future olarak) toplamı döndürür. Döngü gövdesi bittiğinde, fonksiyon bir sonraki olay gelene kadar veya stream bitene kadar duraklatılır.

Fonksiyon `async` anahtar kelimesiyle işaretlenmiştir; bu, `await for` döngüsünü kullanırken gereklidir.

Aşağıdaki örnek, önceki kodu bir `async*` fonksiyonu kullanarak basit bir tamsayı stream'i üreterek test eder.

> **Not:** Bu sayfa çalıştırılabilir örnekleri görüntülemek için gömülü DartPad'ler kullanır. DartPad'ler yerine boş kutular görürseniz, DartPad sorun giderme sayfasına gidin.

> **Not:** Sonucu Konsol'da görmek için Run'a tıklayın.

### Hata olayları

Stream'ler içlerinde daha fazla olay olmadığında biter ve olayları alan kod, yeni bir olay geldiği gibi bildirildiği gibi bu konuda bilgilendirilir. `await for` döngüsü kullanarak olayları okurken, stream bittiğinde döngü durur.

Bazı durumlarda, stream bitmeden önce bir hata olur; belki uzak bir sunucudan bir dosya getirilirken ağ başarısız oldu ya da belki olayları oluşturan kodda bir hata var, ama birinin bunu bilmesi gerekiyor.

Stream'ler ayrıca veri olaylarını ilettiği gibi hata olaylarını da iletebilir. Çoğu stream ilk hatadan sonra durur, ancak birden fazla hata ileten stream'ler ve bir hata olayından sonra daha fazla veri ileten stream'ler olması mümkündür. Bu belgede yalnızca en fazla bir hata ileten stream'leri ele alıyoruz.

`await for` kullanarak bir stream okurken, hata döngü ifadesi tarafından fırlatılır. Bu da döngüyü sonlandırır. Hatayı `try-catch` kullanarak yakalayabilirsiniz. Aşağıdaki örnek, döngü iterator'u 4'e eşit olduğunda bir hata fırlatır.

> **Not:** Sonucu Konsol'da görmek için Run'a tıklayın.

### Stream'lerle çalışma

`Stream` sınıfı, bir stream üzerinde `Iterable`'ın metotlarına benzer yaygın işlemleri sizin için yapabilen bir dizi yardımcı metot içerir. Örneğin, `Stream` API'sinden `lastWhere()` kullanarak bir stream'deki son pozitif tam sayıyı bulabilirsiniz.

```dart
Future<int> lastPositive(Stream<int> stream) =>
    stream.lastWhere((x) => x >= 0);
```

### İki tür stream

İki tür stream vardır.

#### Tek abonelik (Single subscription) stream'ler

En yaygın stream türü, daha büyük bir bütünün parçaları olan bir olay dizisi içerir. Olayların doğru sırada ve hiçbiri atlanmadan iletilmesi gerekir. Bu, bir dosyayı okuduğunuzda veya bir web isteği aldığınızda elde ettiğiniz stream türüdür.

Böyle bir stream yalnızca bir kez dinlenebilir. Daha sonra tekrar dinlemek, ilk olayları kaçırmak anlamına gelebilir ve stream'in geri kalanı anlamsız olur. Dinlemeye başladığınızda, veri getirilir ve parçalar halinde sağlanır.

#### Yayın (Broadcast) stream'ler

Diğer stream türü, birer birer işlenebilen bireysel mesajlar içindir. Bu tür bir stream, örneğin bir tarayıcıdaki fare olayları için kullanılabilir.

Böyle bir stream'i istediğiniz zaman dinlemeye başlayabilirsiniz ve dinlediğiniz sırada tetiklenen olayları alırsınız. Birden fazla dinleyici aynı anda dinleyebilir ve önceki bir aboneliği iptal ettikten sonra daha sonra tekrar dinleyebilirsiniz.

### Bir stream'i işleyen metotlar

`Stream<T>` üzerindeki aşağıdaki metotlar stream'i işler ve bir sonuç döndürür:

```dart
Future<T> get first;
Future<bool> get isEmpty;
Future<T> get last;
Future<int> get length;
Future<T> get single;
Future<bool> any(bool Function(T element) test);
Future<bool> contains(Object? needle);
Future<E> drain<E>([E? futureValue]);
Future<T> elementAt(int index);
Future<bool> every(bool Function(T element) test);
Future<T> firstWhere(bool Function(T element) test, {T Function()? orElse});
Future<S> fold<S>(S initialValue, S Function(S previous, T element) combine);
Future forEach(void Function(T element) action);
Future<String> join([String separator = '']);
Future<T> lastWhere(bool Function(T element) test, {T Function()? orElse});
Future pipe(StreamConsumer<T> streamConsumer);
Future<T> reduce(T Function(T previous, T element) combine);
Future<T> singleWhere(bool Function(T element) test, {T Function()? orElse});
Future<List<T>> toList();
Future<Set<T>> toSet();
```

Bu fonksiyonların tümü, `drain()` ve `pipe()` hariç, `Iterable` üzerindeki benzer bir fonksiyona karşılık gelir. Her biri, bir `await for` döngüsü kullanan bir `async` fonksiyon kullanılarak (veya diğer metotlardan biri kullanılarak) kolayca yazılabilir. Örneğin, bazı uygulamalar şu şekilde olabilir:

```dart
Future<bool> contains(Object? needle) async {
  await for (final event in this) {
    if (event == needle) return true;
  }
  return false;
}

Future forEach(void Function(T element) action) async {
  await for (final event in this) {
    action(event);
  }
}

Future<List<T>> toList() async {
  final result = <T>[];
  await forEach(result.add);
  return result;
}

Future<String> join([String separator = '']) async =>
    (await toList()).join(separator);
```

(Gerçek uygulamalar biraz daha karmaşıktır, ancak esas olarak tarihsel nedenlerden dolayı.)

### Bir stream'i değiştiren metotlar

`Stream` üzerindeki aşağıdaki metotlar orijinal stream'e dayalı yeni bir stream döndürür. Her biri, orijinal stream'i dinlemeden önce yeni stream üzerinde birinin dinlemesini bekler.

```dart
Stream<R> cast<R>();
Stream<S> expand<S>(Iterable<S> Function(T element) convert);
Stream<S> map<S>(S Function(T event) convert);
Stream<T> skip(int count);
Stream<T> skipWhile(bool Function(T element) test);
Stream<T> take(int count);
Stream<T> takeWhile(bool Function(T element) test);
Stream<T> where(bool Function(T event) test);
```

Yukarıdaki metotlar, bir iterable'ı başka bir iterable'a dönüştüren `Iterable` üzerindeki benzer metotlara karşılık gelir. Bunların tümü, bir `await for` döngüsü kullanan bir `async` fonksiyon kullanılarak kolayca yazılabilir.

```dart
Stream<E> asyncExpand<E>(Stream<E>? Function(T event) convert);
Stream<E> asyncMap<E>(FutureOr<E> Function(T event) convert);
Stream<T> distinct([bool Function(T previous, T next)? equals]);
```

`asyncExpand()` ve `asyncMap()` fonksiyonları `expand()` ve `map()`'e benzer, ancak fonksiyon argümanlarının asenkron bir fonksiyon olmasına izin verir. `distinct()` fonksiyonu `Iterable` üzerinde yoktur, ancak olabilirdi.

```dart
Stream<T> handleError(Function onError, {bool Function(dynamic error)? test});
Stream<T> timeout(
  Duration timeLimit, {
  void Function(EventSink<T> sink)? onTimeout,
});
Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer);
```

Son üç fonksiyon daha özeldir. Bir `await for` döngüsünün doğrudan yönetemediği hata işlemeyi içerirler; karşılaşılan ilk hata döngüyü ve stream aboneliğini sonlandırır ve kurtarma için yerleşik bir mekanizma yoktur.

Aşağıdaki kod, bir `await for` döngüsü tarafından tüketilmeden önce bir stream'den hataları filtrelemek için `handleError()`'ın nasıl kullanılacağını gösterir.

```dart
Stream<S> mapLogErrors<S, T>(
  Stream<T> stream,
  S Function(T event) convert,
) async* {
  var streamWithoutErrors = stream.handleError((e) => log(e));

  await for (final event in streamWithoutErrors) {
    yield convert(event);
  }
}
```

Önceki örnekte, stream tarafından hiçbir olay yayılmazsa bir `await for` döngüsüne asla geri dönülmez. Bundan kaçınmak için, yeni bir stream oluşturmak üzere `timeout()` fonksiyonunu kullanın. `timeout()`, bir zaman sınırı belirlemenize ve döndürülen stream üzerinde olay yaymaya devam etmenize olanak tanır.

Aşağıdaki kod önceki örneği değiştirir. İki saniyelik bir zaman aşımı ekler ve iki veya daha fazla saniye boyunca hiçbir olay olmazsa ilgili bir hata üretir.

```dart
Stream<S> mapLogErrors<S, T>(
  Stream<T> stream,
  S Function(T event) convert,
) async* {
  var streamWithoutErrors = stream.handleError((e) => log(e));
  var streamWithTimeout = streamWithoutErrors.timeout(
    const Duration(seconds: 2),
    onTimeout: (eventSink) {
      eventSink.addError('Timed out after 2 seconds');
      eventSink.close();
    },
  );

  await for (final event in streamWithTimeout) {
    yield convert(event);
  }
}
```

#### `transform()` fonksiyonu

`transform()` fonksiyonu yalnızca hata işleme için değildir; stream'ler için daha genelleştirilmiş bir "map"tir. Normal bir map, gelen her olay için bir değer gerektirir. Ancak, özellikle I/O stream'leri için, bir çıktı olayı üretmek birkaç gelen olay gerektirebilir. Bir `StreamTransformer` bununla çalışabilir. Örneğin, `Utf8Decoder` gibi kod çözücüler transformer'dır. Bir transformer yalnızca bir fonksiyon gerektirir, `bind()`; bu bir `async` fonksiyon tarafından kolayca uygulanabilir.

#### Bir dosyayı okuma ve çözme

Aşağıdaki kod bir dosyayı okur ve stream üzerinde iki transform çalıştırır. İlk olarak veriyi UTF8'den dönüştürür ve ardından bir `LineSplitter` üzerinden geçirir. `#` (hashtag) ile başlayanlar hariç tüm satırlar yazdırılır.

```dart
import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  var file = File(args[0]);
  var lines = utf8.decoder
      .bind(file.openRead())
      .transform(const LineSplitter());
  await for (final line in lines) {
    if (!line.startsWith('#')) print(line);
  }
}
```

### `listen()` metodu

`Stream` üzerindeki son metot `listen()`'dır. Bu bir "düşük seviyeli" metottur—diğer tüm stream fonksiyonları `listen()` cinsinden tanımlanır.

```dart
StreamSubscription<T> listen(
  void Function(T event)? onData, {
  Function? onError,
  void Function()? onDone,
  bool? cancelOnError,
});
```

Yeni bir `Stream` türü oluşturmak için, `Stream` sınıfını genişletip `listen()` metodunu uygulayabilirsiniz—`Stream` üzerindeki diğer tüm metotlar çalışmak için `listen()` çağırır.

`listen()` metodu bir stream üzerinde dinlemeye başlamanıza olanak tanır. Bunu yapana kadar, stream hangi olayları görmek istediğinizi açıklayan hareketsiz bir nesnedir. Dinlediğinizde, etkin stream olay üreten bir `StreamSubscription` nesnesi döndürülür. Bu, bir `Iterable`'ın yalnızca bir nesne koleksiyonu olmasına, ancak asıl iterasyonu yapanın `iterator` olmasına benzer.

Stream aboneliği, aboneliği duraklatmanıza, bir duraklamadan sonra devam ettirmenize ve tamamen iptal etmenize olanak tanır. Her veri olayı veya hata olayı için ve stream kapandığında çağrılacak geri çağırmalar ayarlayabilirsiniz.

### Diğer Kaynaklar

Dart'ta stream'leri ve asenkron programlamayı kullanma hakkında daha fazla ayrıntı için aşağıdaki dokümantasyonu okuyun.

- Creating Streams in Dart, kendi stream'lerinizi oluşturma hakkında bir makale
- Futures and Error Handling, `Future` API'sini kullanarak hataların nasıl işleneceğini açıklayan bir makale
- Asynchronous programming, Dart'ın asenkronluk için dil desteğine derinlemesine dalar
- Stream API reference

---

## 12. Stream Oluşturma

Bir stream, sonuçların bir dizisidir; kendi stream'lerinizi nasıl oluşturacağınızı öğrenin.

Lasse Nielsen tarafından yazılmıştır — Nisan 2013 (Mayıs 2021'de güncellendi).

`dart:async` kütüphanesi, birçok Dart API'si için önemli olan iki tip içerir: `Stream` ve `Future`. Bir `Future` tek bir hesaplamanın sonucunu temsil ederken, bir stream sonuçların bir dizisidir. Sonuçlardan (hem veri hem hatalar) ve stream'in kapanmasından haberdar olmak için bir stream'i dinlersiniz. Ayrıca dinlerken duraklatabilir veya tamamlanmadan önce stream'i dinlemeyi durdurabilirsiniz.

Ancak bu makale stream'leri kullanmakla ilgili değildir. Kendi stream'lerinizi oluşturmakla ilgilidir. Birkaç şekilde stream oluşturabilirsiniz:

- Mevcut stream'leri dönüştürerek.
- Bir `async*` fonksiyonu kullanarak sıfırdan bir stream oluşturarak.
- Bir `StreamController` kullanarak bir stream oluşturarak.

Bu makale her yaklaşım için kodu gösterir ve stream'inizi doğru uygulamanıza yardımcı olacak ipuçları verir.

Stream'leri kullanma hakkında yardım için Asynchronous Programming: Streams bölümüne bakın.

### Mevcut bir stream'i dönüştürme

Stream oluşturmanın yaygın durumu, zaten bir stream'e sahip olmanız ve orijinal stream'in olaylarına dayalı yeni bir stream oluşturmak istemenizdir. Örneğin, girdiyi UTF-8 çözerek tam sayı stream'ine dönüştürmek isteyebileceğiniz bir bayt stream'iniz olabilir. En genel yaklaşım, orijinal stream'deki olayları bekleyen ve sonra yeni olaylar çıkaran yeni bir stream oluşturmaktır. Örnek:

```dart
/// Splits a stream of consecutive strings into lines.
///
/// The input string is provided in smaller chunks through
/// the `source` stream.
Stream<String> lines(Stream<String> source) async* {
  // Stores any partial line from the previous chunk.
  var partial = '';
  // Wait until a new chunk is available, then process it.
  await for (final chunk in source) {
    var lines = chunk.split('\n');
    lines[0] = partial + lines[0]; // Prepend partial line.
    partial = lines.removeLast(); // Remove new partial line.
    for (final line in lines) {
      yield line; // Add lines to output stream.
    }
  }
  // Add final partial line to output stream, if any.
  if (partial.isNotEmpty) yield partial;
}
```

Birçok yaygın dönüşüm için, `map()`, `where()`, `expand()` ve `take()` gibi `Stream` tarafından sağlanan dönüştürme metotlarını kullanabilirsiniz.

Örneğin, her saniye artan bir sayaç yayan bir `counterStream` stream'iniz olduğunu varsayalım. İşte nasıl uygulanabileceği:

```dart
var counterStream = Stream<int>.periodic(
  const Duration(seconds: 1),
  (x) => x,
).take(15);
```

Olayları hızlıca görmek için şöyle bir kod kullanabilirsiniz:

```dart
counterStream.forEach(print); // Print an integer every second, 15 times.
```

Stream olaylarını dönüştürmek için, dinlemeden önce stream üzerinde `map()` gibi bir dönüştürme metodu çağırabilirsiniz. Metot yeni bir stream döndürür.

```dart
// Double the integer in each event.
var doubleCounterStream = counterStream.map((int x) => x * 2);
doubleCounterStream.forEach(print);
```

`map()` yerine, aşağıdakiler gibi başka bir dönüştürme metodu da kullanabilirsiniz:

```dart
.where((int x) => x.isEven) // Retain only even integer events.
.expand((x) => [x, x]) // Duplicate each event.
.take(5) // Stop after the first five events.
```

Çoğu zaman, bir dönüştürme metodu ihtiyacınız olan tek şeydir. Ancak, dönüşüm üzerinde daha da fazla kontrole ihtiyacınız varsa, `Stream`'in `transform()` metoduyla bir `StreamTransformer` belirtebilirsiniz. Platform kütüphaneleri birçok yaygın görev için stream transformer'ları sağlar. Örneğin, aşağıdaki kod, `dart:convert` kütüphanesi tarafından sağlanan `utf8.decoder` ve `LineSplitter` transformer'larını kullanır.

```dart
Stream<List<int>> content = File('someFile.txt').openRead();
List<String> lines = await content
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .toList();
```

### Sıfırdan bir stream oluşturma

Yeni bir stream oluşturmanın bir yolu, bir asenkron generator (`async*`) fonksiyonudur. Stream, fonksiyon çağrıldığında oluşturulur ve fonksiyonun gövdesi stream dinlendiğinde çalışmaya başlar. Fonksiyon döndüğünde, stream kapanır. Fonksiyon dönene kadar, `yield` veya `yield*` ifadelerini kullanarak stream üzerinde olay yayabilir.

İşte düzenli aralıklarla sayı yayan basit bir örnek:

```dart
Stream<int> timedCounter(Duration interval, [int? maxCount]) async* {
  int i = 0;
  while (true) {
    await Future.delayed(interval);
    yield i++;
    if (i == maxCount) break;
  }
}
```

Bu fonksiyon bir `Stream` döndürür. O stream dinlendiğinde, gövde çalışmaya başlar. İstenen aralık kadar tekrar tekrar geciktirir ve ardından bir sonraki sayıyı yayar. `maxCount` parametresi atlanırsa, döngüde bir durdurma koşulu yoktur, bu yüzden stream sonsuza kadar artan sayılar çıkarır - ya da dinleyici aboneliğini iptal edene kadar.

Dinleyici iptal ettiğinde (`listen()` metodu tarafından döndürülen `StreamSubscription` nesnesi üzerinde `cancel()` çağırarak), gövde bir `yield` ifadesine ulaştığında, `yield` bunun yerine bir `return` ifadesi gibi davranır. Kapsayan herhangi bir `finally` bloğu yürütülür ve fonksiyon çıkar. Fonksiyon çıkmadan önce bir değer yaymaya çalışırsa, bu başarısız olur ve bir `return` gibi davranır.

Fonksiyon sonunda çıktığında, `cancel()` metodu tarafından döndürülen future tamamlanır. Fonksiyon bir hatayla çıkarsa, future o hatayla tamamlanır; aksi halde `null` ile tamamlanır.

Daha kullanışlı başka bir örnek, bir future dizisini bir stream'e dönüştüren bir fonksiyondur:

```dart
Stream<T> streamFromFutures<T>(Iterable<Future<T>> futures) async* {
  for (final future in futures) {
    var result = await future;
    yield result;
  }
}
```

Bu fonksiyon, futures iterable'ından yeni bir future ister, o future'ı bekler, sonuç değerini yayar ve sonra döngüye girer. Bir future bir hatayla tamamlanırsa, stream o hatayla tamamlanır.

Sıfırdan bir stream oluşturan bir `async*` fonksiyonuna sahip olmak nadirdir. Verisini bir yerden alması gerekir ve çoğu zaman bu yer başka bir stream'dir. Bazı durumlarda, yukarıdaki future dizisi gibi, veri diğer asenkron olay kaynaklarından gelir. Ancak birçok durumda, bir `async*` fonksiyonu birden çok veri kaynağını kolayca işlemek için fazla basittir. İşte `StreamController` sınıfının devreye girdiği yer burasıdır.

### Bir `StreamController` kullanma

Stream'inizin olayları programınızın farklı yerlerinden geliyorsa ve yalnızca bir `async` fonksiyon tarafından dolaşılabilecek bir stream veya future'dan gelmiyorsa, stream'i oluşturmak ve doldurmak için bir `StreamController` kullanın.

Bir `StreamController` size yeni bir stream ve herhangi bir noktada ve herhangi bir yerden stream'e olay eklemenin bir yolunu verir. Stream, dinleyicileri ve duraklatmayı işlemek için gereken tüm mantığa sahiptir. Stream'i döndürürsünüz ve controller'ı kendinize saklarsınız.

Aşağıdaki örnek (stream_controller_bad.dart'den), önceki örneklerdeki `timedCounter()` fonksiyonunu uygulamak için `StreamController`'ın temel, ancak kusurlu bir kullanımını gösterir. Bu kod, döndürülecek bir stream oluşturur ve ardından ne future ne de stream olayı olan timer olaylarına dayalı olarak veri besler.

```dart
// YANLIŞ
// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  var controller = StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  return controller.stream;
}
```

Daha önce olduğu gibi, `timedCounter()` tarafından döndürülen stream'i şu şekilde kullanabilirsiniz:

```dart
var counterStream = timedCounter(const Duration(seconds: 1), 15);
counterStream.listen(print); // Print an integer every second, 15 times.
```

`timedCounter()`'ın bu uygulamasının birkaç sorunu vardır:

- Aboneleri olmadan önce olay üretmeye başlar.
- Abone bir duraklama istese bile olay üretmeye devam eder.

Sonraki bölümlerin gösterdiği gibi, `StreamController` oluştururken `onListen` ve `onPause` gibi geri çağırmaları belirterek bu iki sorunu da düzeltebilirsiniz.

#### Bir aboneliği bekleme

Kural olarak, stream'ler işlerine başlamadan önce aboneleri beklemelidir. Bir `async*` fonksiyonu bunu otomatik olarak yapar, ancak bir `StreamController` kullanırken tam kontrole sahipsiniz ve yapmamanız gerektiğinde bile olay ekleyebilirsiniz. Bir stream'in abonesi yoksa, `StreamController` olayları arabelleğe alır; bu, stream hiç abone almazsa bir bellek sızıntısına yol açabilir.

Stream'i kullanan kodu aşağıdakiyle değiştirmeyi deneyin:

```dart
void listenAfterDelay() async {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  await Future.delayed(const Duration(seconds: 5));

  // After 5 seconds, add a listener.
  await for (final n in counterStream) {
    print(n); // Print an integer every second, 15 times.
  }
}
```

Bu kod çalıştığında, stream çalışıyor olmasına rağmen ilk 5 saniye boyunca hiçbir şey yazdırılmaz. Ardından dinleyici eklenir ve `StreamController` tarafından arabelleğe alındıkları için ilk 5 civarı olay hep birden yazdırılır.

Aboneliklerden haberdar olmak için, `StreamController` oluştururken bir `onListen` argümanı belirtin. `onListen` geri çağırması, stream ilk abonesini aldığında çağrılır. Bir `onCancel` geri çağırması belirtirseniz, controller son abonesini kaybettiğinde çağrılır. Önceki örnekte, `Timer.periodic()` bir `onListen` işleyicisine taşınmalıdır, sonraki bölümde gösterildiği gibi.

#### Duraklama durumuna saygı gösterme

Dinleyici bir duraklama istediğinde olay üretmekten kaçının. Bir `async*` fonksiyonu, stream aboneliği duraklatılmışken bir `yield` ifadesinde otomatik olarak duraklar. Öte yandan bir `StreamController`, duraklama sırasında olayları arabelleğe alır. Olayları sağlayan kod duraklamaya saygı göstermezse, arabelleğin boyutu süresiz olarak büyüyebilir. Ayrıca, dinleyici duraklattıktan kısa süre sonra dinlemeyi bırakırsa, arabelleği oluşturmak için harcanan iş boşa gider.

Duraklama desteği olmadan ne olduğunu görmek için, stream'i kullanan kodu aşağıdakiyle değiştirmeyi deneyin:

```dart
void listenWithPause() {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  late StreamSubscription<int> subscription;

  subscription = counterStream.listen((int counter) {
    print(counter); // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause(Future.delayed(const Duration(seconds: 5)));
    }
  });
}
```

Beş saniyelik duraklama bittiğinde, o süre boyunca tetiklenen olaylar hep birden alınır. Bunun nedeni, stream'in kaynağının duraklamalara saygı göstermemesi ve stream'e olay eklemeye devam etmesidir. Böylece stream olayları arabelleğe alır ve stream duraklaması kaldırıldığında arabelleğini boşaltır.

`timedCounter()`'ın aşağıdaki sürümü (stream_controller.dart'den), `StreamController` üzerindeki `onListen`, `onPause`, `onResume` ve `onCancel` geri çağırmalarını kullanarak duraklamayı uygular.

```dart
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  late StreamController<int> controller;
  Timer? timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (counter == maxCount) {
      timer?.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
    onListen: startTimer,
    onPause: stopTimer,
    onResume: startTimer,
    onCancel: stopTimer,
  );

  return controller.stream;
}
```

Bu kodu yukarıdaki `listenWithPause()` fonksiyonuyla çalıştırın. Duraklatıldığında saymayı durdurduğunu ve sonrasında güzelce devam ettiğini göreceksiniz.

Duraklama durumundaki değişikliklerden haberdar olmak için `onListen`, `onCancel`, `onPause` ve `onResume` dinleyicilerinin tümünü kullanmalısınız. Bunun nedeni, abonelik ve duraklama durumlarının ikisi de aynı anda değişirse, yalnızca `onListen` veya `onCancel` geri çağırmasının çağrılmasıdır.

### Son ipuçları

Bir `async*` fonksiyonu kullanmadan bir stream oluştururken, bu ipuçlarını aklınızda bulundurun:

- **Senkron bir controller kullanırken dikkatli olun**—örneğin, `StreamController(sync: true)` kullanılarak oluşturulan bir controller. Duraklatılmamış senkron bir controller üzerinde bir olay gönderdiğinizde (örneğin, `EventSink` tarafından tanımlanan `add()`, `addError()` veya `close()` metotlarını kullanarak), olay stream'deki tüm dinleyicilere hemen gönderilir. Stream dinleyicileri, dinleyiciyi ekleyen kod tamamen dönene kadar asla çağrılmamalıdır ve yanlış zamanda senkron bir controller kullanmak bu sözü bozabilir ve iyi kodun başarısız olmasına neden olabilir. Senkron controller'lardan kaçının.
- **`StreamController` kullanırsanız,** `onListen` geri çağırması, `listen` çağrısı `StreamSubscription`'ı döndürmeden önce çağrılır. `onListen` geri çağırmasının aboneliğin zaten var olmasına bağlı olmasına izin vermeyin. Örneğin, aşağıdaki kodda, `subscription` değişkeni geçerli bir değere sahip olmadan önce bir `onListen` olayı tetiklenir (ve `handler` çağrılır):

  ```dart
  subscription = stream.listen(handler);
  ```

- `StreamController` tarafından tanımlanan `onListen`, `onPause`, `onResume` ve `onCancel` geri çağırmaları, stream'in dinleyici durumu değiştiğinde stream tarafından çağrılır, ancak bir olayın tetiklenmesi sırasında veya başka bir durum değişikliği işleyicisinin çağrısı sırasında asla çağrılmaz. Bu durumlarda, durum değişikliği geri çağırması önceki geri çağırma tamamlanana kadar ertelenir.
- **`Stream` arayüzünü kendiniz uygulamaya çalışmayın.** Olaylar, geri çağırmalar ve dinleyicilerin eklenmesi ve kaldırılması arasındaki etkileşimi incelikli bir şekilde yanlış yapmak kolaydır. Yeni bir stream'in `listen` çağrısını uygulamak için her zaman mevcut bir stream'i, muhtemelen bir `StreamController`'dan, kullanın.
- Ayrıca, `Stream` sınıfını genişletip `listen` metodunu ve ek işlevselliği üzerine uygulayarak daha fazla işlevselliğe sahip sınıflar oluşturmak mümkün olsa da, bu genellikle önerilmez çünkü kullanıcıların dikkate alması gereken yeni bir tür getirir. Bir `Stream` (ve daha fazlası) olan bir sınıf yerine, genellikle bir `Stream`'i (ve daha fazlasını) içeren bir sınıf yapabilirsiniz.
