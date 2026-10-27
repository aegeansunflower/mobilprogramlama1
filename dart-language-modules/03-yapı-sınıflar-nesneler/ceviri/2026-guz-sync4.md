> **Uyarı:** Bu içerik, SCÜ Şarkışla UBYO Mobil Programlama I dersi kapsamında tamamen eğitim amaçlı çevrilmiş ve derlenmiştir. Orijinal dokümantasyon kaynakları (dart.dev, docs.flutter.dev) kendi orijinal lisanslarına (BSD-3-Clause, CC-BY 4.0) tabidir. Bu çalışmanın hiçbir ticari amacı yoktur.

# Dart Dil Rehberi: İleri Düzey ve Dil Özellikleri

**Mobil Programlama I · 3. Takım (Sync4)** · Konu: Metadata,Libraries & imports,Classes & objects,
Class modifiers

Bu belge, [dart.dev](https://dart.dev/language) dokümantasyonunun ilgili bölümlerinin Türkçe çevirisidir.

## İçindekiler:

- **Meta Veriler** (Metadata)
- **Kütüphaneler ve içe aktarmalar** (Libraries & imports)
- **Sınıflar ve Nesneler** (Classes and objects)
  - Sınıflar
  - Yapıcılar
  - Birincil Yapıcılar
  - Yöntemler
  - Bir sınıfı genişletme
  - Mixin'ler
  - Numaralandırmalar
  - Nokta kısaltmaları
  - Genişletme yöntemleri
  - Uzantı türleri
  - Çağrılabilir nesneler
- **Sınıf Değiştiricileri** (Class modifiers)
  - Genel bakış be kullanım
  - API yöneticileri için sınıf değiştiricileri
  - Referans

---



# Metadata

Dart'ta metadata ve annotation'lar.

Kodunuz hakkında ek statik bilgi sağlamak için metadata kullanın. Bir metadata annotation'ı `@` karakteriyle başlar; ardından ya bir compile-time constant'a referans (örneğin `deprecated`) ya da bir constant constructor çağrısı gelir.

Metadata, yapının bildiriminden veya yönergesinden önce annotation eklenerek çoğu Dart program yapısına eklenebilir.

## Yerleşik annotation'lar

Aşağıdaki annotation'lar tüm Dart kodlarında kullanılabilir:

### @Deprecated
Bir bildirimi deprecated olarak işaretler; bu, bildirimden uzaklaşılması gerektiğini belirtir ve yerine geçecek öğeyi açıklayan bir mesaj ile olası kaldırılma tarihini içerir.

Genel `@Deprecated` annotation'ının yanı sıra, bir bildirimin belirli kullanımlarını deprecated yapmak için özel annotation'lar da kullanabilirsiniz:

* `@Deprecated.extend()`: Sınıfın genişletilmesi deprecated'dır.
* `@Deprecated.implement()`: Sınıfın veya mixin'in uygulanması deprecated'dır.
* `@Deprecated.subclass()`: Sınıftan veya mixin'den alt sınıf türetilmesi (genişletme veya uygulama) deprecated'dır.
* `@Deprecated.mixin()`: Sınıfın mixin olarak eklenmesi deprecated'dır.
* `@Deprecated.instantiate()`: Sınıftan örnek oluşturulması deprecated'dır.
* `@Deprecated.optional()`: Parametre için argüman verilmemesi deprecated'dır.

İşte `@Deprecated` annotation'ının kullanımına dair bir örnek:

```dart
class Television {
  /// Use [turnon] to turn the power on instead.
  @Deprecated('Use turnon instead')
  void activate() {
    turnon();
  }
}

/// Turns the TV's power on.
void turnon() {
}
```

### @deprecated
Bir bildirimi, belirtilmemiş gelecekteki bir sürüme kadar deprecated olarak işaretler. Bunun yerine `@Deprecated` kullanmayı ve bir deprecation mesajı eklemeyi tercih edin.

### @override
Bir örnek üyesini, üst sınıftaki veya arayüzdeki aynı adlı bir üyenin override'ı ya da uygulaması olarak işaretler. `@override` kullanım örnekleri için Bir sınıfı genişletme bölümüne bakın.

### @pragma
Derleyici veya analyzer gibi Dart araçlarına bir bildirimle ilgili belirli talimatlar ya da ipuçları sağlar.

Dart analyzer, `@override` annotation'ı gerektiğinde ve `@deprecated` veya `@Deprecated` ile işaretlenmiş üyeler kullanıldığında tanılama (diagnostics) şeklinde geri bildirim sağlar.

## Analyzer tarafından desteklenen annotation'lar

Yerleşik annotation'lar için destek ve analiz sağlamanın ötesinde, Dart analyzer `package:meta` içindeki çeşitli annotation'lar için ek destek ve tanılama sunar. Paketin sağladığı yaygın olarak kullanılan annotation'lardan bazıları şunlardır:

### @visibleForTesting
Bir paket üyesini yalnızca public olarak işaretler; böylece üyeye paketin testlerinden erişilebilir. Analyzer, üyeyi otomatik tamamlama önerilerinden gizler ve başka bir paketten kullanılırsa uyarı verir.

### @awaitNotRequired
`Future` türündeki değişkenleri veya `Future` döndüren fonksiyonları, çağıranın `Future`'ı await etmesini gerektirmeyecek şekilde işaretler. Bu, analyzer'ın `discarded_futures` veya `unawaited_futures` lint'leri nedeniyle `Future`'ı await etmeyen çağıranları uyarmasını engeller.

Bunlar ve paketin sağladığı diğer annotation'lar hakkında, neyi belirttikleri, hangi işlevleri sağladıkları ve nasıl kullanıldıkları konusunda daha fazla bilgi edinmek için `package:meta/meta.dart` API belgelerine göz atın.

## Özel annotation'lar

Kendi metadata annotation'larınızı tanımlayabilirsiniz. İşte iki argüman alan bir `@Todo` annotation'ının tanımlanmasına dair bir örnek:

```dart
class Todo {
  final String who;
  final String what;

  const Todo(this.who, this.what);
}
```

Ve işte bu `@Todo` annotation'ının kullanımına dair bir örnek:

```dart
@Todo('Dash', 'Implement this function')
void doSomething() {
  print('Do something');
}
```

### Desteklenen hedeflerin belirtilmesi

Annotation'ınızla işaretlenmesi gereken dil yapılarının türünü belirtmek için `package:meta` içindeki `@Target` annotation'ını kullanın.

Örneğin, önceki `@Todo` annotation'ının yalnızca fonksiyonlarda ve metotlarda kullanılmasına izin vermek isterseniz, aşağıdaki annotation'ı eklersiniz:

```dart
import 'package:meta/meta_meta.dart';

@Target({TargetKind.function, TargetKind.method})
class Todo {
  // ...
}
```

Bu yapılandırmayla, `Todo` üst düzey bir fonksiyon veya metot dışındaki herhangi bir bildirimde annotation olarak kullanılırsa analyzer uyarı verir.

---
**Önceki:** Fonksiyonlar
**Sonraki:** Kütüphaneler ve içe aktarmalar
# Kütüphaneler ve içe aktarmalar

Kütüphanelerin içe aktarılması (import) ve uygulanmasına ilişkin kılavuz.

`import` ve `library` yönergeleri, modüler ve paylaşılabilir bir kod tabanı oluşturmanıza yardımcı olabilir. Kütüphaneler yalnızca API'ler sağlamakla kalmaz, aynı zamanda bir gizlilik birimidir: alt çizgi (`_`) ile başlayan tanımlayıcılar yalnızca kütüphane içinde görülebilir. Her Dart dosyası (ve part'ları), `library` yönergesi kullanmasa bile bir kütüphanedir.

Kütüphaneler paketler kullanılarak dağıtılabilir.

Dart, `public`, `protected` veya `private` gibi erişim belirteci anahtar sözcükleri yerine alt çizgi kullanır. Diğer dillerdeki erişim belirteçleri daha ayrıntılı kontrol sağlarken, Dart'ın alt çizgi kullanımı ve kütüphane tabanlı gizliliği basit bir yapılandırma mekanizması sunar, dinamik erişimin verimli şekilde uygulanmasına yardımcı olur ve tree shaking'i (ölü kodun ayıklanması) iyileştirir.

## Kütüphaneleri kullanma

Bir kütüphanedeki namespace'in başka bir kütüphanenin kapsamında nasıl kullanılacağını belirtmek için `import` kullanın.

Örneğin, Dart web uygulamaları genellikle `dart:js_interop` kütüphanesini kullanır; bu kütüphaneyi şu şekilde içe aktarabilirler:

```dart
import 'dart:js_interop';
```

`import` için tek zorunlu argüman, kütüphaneyi belirten bir URI'dir. Yerleşik kütüphaneler için URI özel `dart:` şemasına sahiptir. Diğer kütüphaneler için bir dosya sistemi yolu veya `package:` şemasını kullanabilirsiniz. `package:` şeması, pub aracı gibi bir paket yöneticisi tarafından sağlanan kütüphaneleri belirtir. Örneğin:

```dart
import 'package:test/test.dart';
```

> **Not**
> URI, uniform resource identifier (tekdüzen kaynak tanımlayıcısı) anlamına gelir. URL'ler (uniform resource locator, tekdüzen kaynak konum belirleyicisi) yaygın bir URI türüdür.

### Kütüphane önekini (prefix) belirleme

Çakışan tanımlayıcılara sahip iki kütüphaneyi içe aktarırsanız, kütüphanelerden biri veya her ikisi için bir önek belirtebilirsiniz. Örneğin, `library1` ve `library2`'nin her ikisinde de bir `Element` sınıfı varsa, şuna benzer bir kodunuz olabilir:

```dart
import 'package:lib1/lib1.dart';
import 'package:lib2/lib2.dart' as lib2;

// Uses Element from lib1.
Element element1 = Element();

// Uses Element from lib2.
lib2.Element element2 = lib2.Element();
```

Wildcard adı `_` olan `import` önekleri bağlayıcı (binding) değildir, ancak o kütüphanedeki private olmayan extension'lara erişim sağlar.

### Bir kütüphanenin yalnızca bir kısmını içe aktarma

Bir kütüphanenin yalnızca bir kısmını kullanmak istiyorsanız, kütüphaneyi seçici olarak içe aktarabilirsiniz. Örneğin:

```dart
// Import only foo.
import 'package:lib1/lib1.dart' show foo;

// Import all names EXCEPT foo.
import 'package:lib2/lib2.dart' hide foo;
```

### Bir kütüphaneyi tembel (lazy) yükleme

Deferred loading (lazy loading olarak da bilinir), bir web uygulamasının bir kütüphaneyi ihtiyaç duyulduğunda ve duyulursa, talep üzerine yüklemesini sağlar. Aşağıdaki ihtiyaçlardan birini veya birkaçını karşılamak istediğinizde deferred loading kullanın.

* Bir web uygulamasının ilk açılış süresini kısaltmak.
* A/B testi yapmak; örneğin bir algoritmanın alternatif uygulamalarını denemek.
* İsteğe bağlı ekranlar ve diyaloglar gibi nadiren kullanılan işlevleri yüklemek.

Bu, Dart'ın tüm deferred bileşenleri başlangıçta yüklediği anlamına gelmez. Web uygulaması, deferred bileşenleri gerektiğinde web üzerinden indirebilir.

`dart` aracı, web dışındaki hedefler için deferred loading'i desteklemez. Bir Flutter uygulaması geliştiriyorsanız, Flutter kılavuzundaki deferred components bölümünde yer alan deferred loading uygulamasına başvurun.

Bir kütüphaneyi tembel yüklemek için önce onu `deferred as` kullanarak içe aktarın.

```dart
import 'package:greetings/hello.dart' deferred as hello;
```

Kütüphaneye ihtiyaç duyduğunuzda, kütüphanenin tanımlayıcısını kullanarak `loadLibrary()` çağırın.

```dart
Future<void> greet() async {
  await hello.loadLibrary();
  hello.printGreeting();
}
```

Yukarıdaki kodda `await` anahtar sözcüğü, kütüphane yüklenene kadar yürütmeyi duraklatır. `async` ve `await` hakkında daha fazla bilgi için asenkron programlama bölümüne göz atın.

Bir kütüphane üzerinde `loadLibrary()` fonksiyonunu sorunsuz şekilde birden çok kez çağırabilirsiniz. Kütüphane yalnızca bir kez yüklenir.

Deferred loading kullanırken aşağıdakileri göz önünde bulundurun:

* Deferred bir kütüphanenin sabitleri, içe aktaran dosyada sabit değildir. Unutmayın, bu sabitler deferred kütüphane yüklenene kadar mevcut değildir.
* İçe aktaran dosyada deferred bir kütüphanedeki türleri kullanamazsınız. Bunun yerine arayüz türlerini, hem deferred kütüphane hem de içe aktaran dosya tarafından içe aktarılan bir kütüphaneye taşımayı düşünün.
* Dart, `deferred as` namespace ile tanımladığınız namespace'e `loadLibrary()` fonksiyonunu örtük olarak ekler. `loadLibrary()` fonksiyonu bir `Future` döndürür.

## library yönergesi

Kütüphane düzeyinde doc comment'ler veya metadata annotation'ları belirtmek için bunları dosyanın başındaki bir `library` bildirimine ekleyin.

```dart
/// A really great test library.
@TestOn('browser')
library;
```

## Kütüphaneleri uygulama

Bir paketin nasıl uygulanacağına dair öneriler için Paket oluşturma bölümüne bakın. Bu bölümde şunlar yer alır:

* Kütüphane kaynak kodunun nasıl düzenleneceği.
* `export` yönergesinin nasıl kullanılacağı.
* `part` yönergesinin ne zaman kullanılacağı.
* Birden fazla platformu destekleyen bir kütüphane geliştirmek için koşullu import ve export'ların nasıl kullanılacağı.

**Önceki:** Metadata
**Sonraki:** Sınıflar
# Sınıflar

Sınıflar, sınıf örnekleri ve bunların üyelerinin özeti.

Dart, sınıflar ve mixin tabanlı kalıtım içeren nesne yönelimli bir dildir. Her nesne bir sınıfın örneğidir ve `Null` hariç tüm sınıflar `Object`'den türemiştir. Mixin tabanlı kalıtım, her sınıfın (en üst sınıf olan `Object?` hariç) tam olarak bir üst sınıfa sahip olmasına rağmen, bir sınıf gövdesinin birden fazla sınıf hiyerarşisinde yeniden kullanılabileceği anlamına gelir.

Extension method'lar, sınıfı değiştirmeden veya bir alt sınıf oluşturmadan sınıfa işlevsellik eklemenin bir yoludur. Sınıf değiştiricileri, kütüphanelerin bir sınıfın alt türünü nasıl oluşturabileceğini kontrol etmenizi sağlar.

## Sınıf üyelerini kullanma

Nesneler, işlevlerden ve verilerden (sırasıyla yöntemler ve örnek değişkenleri) oluşan üyelere sahiptir. Bir yöntemi çağırdığınızda, onu bir nesne üzerinde çağırırsınız: yöntem, o nesnenin işlevlerine ve verilerine erişebilir.

Bir örnek değişkenine veya yönteme başvurmak için nokta (`.`) kullanın:

```dart
var p = Point(2, 2);

// Get the value of y.
assert(p.y == 2);

// Invoke distanceTo() on p.
double distance = p.distanceTo(Point(4, 4));
```

En soldaki işlenen null olduğunda istisna oluşmasını önlemek için yerine `?.` kullanın:

```dart
// If p is non-null, set a variable equal to its y value.
var a = p?.y;
```

## Constructor'ları kullanma

Bir nesneyi constructor kullanarak oluşturabilirsiniz. Constructor adları `ClassName` veya `ClassName.identifier` olabilir. Örneğin, aşağıdaki kod `Point()` ve `Point.fromJson()` constructor'larını kullanarak `Point` nesneleri oluşturur:

```dart
var p1 = Point(2, 2);
var p2 = Point.fromJson({'x': 1, 'y': 2});
```

Aşağıdaki kod aynı sonucu verir, ancak constructor adının önünde isteğe bağlı `new` anahtar sözcüğünü kullanır:

```dart
var p1 = new Point(2, 2);
var p2 = new Point.fromJson({'x': 1, 'y': 2});
```

Bazı sınıflar sabit constructor'lar sağlar. Sabit bir constructor kullanarak derleme zamanı sabiti oluşturmak için constructor adının önüne `const` anahtar sözcüğünü ekleyin:

```dart
var p = const ImmutablePoint(2, 2);
```

İki özdeş derleme zamanı sabitinin oluşturulması, tek bir standart örnekle sonuçlanır:

```dart
var a = const ImmutablePoint(1, 1);
var b = const ImmutablePoint(1, 1);

assert(identical(a, b)); // They are the same instance!
```

Sabit bir bağlamda, bir constructor veya sabit değerden önce gelen `const` ifadesini atlayabilirsiniz. Örneğin, sabit bir map oluşturan şu koda bakın:

```dart
// Lots of const keywords here.
const pointAndLine = const {
  'point': const [const ImmutablePoint(0, 0)],
  'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
};
```

`const` anahtar sözcüğünün ilk kullanımı dışındakilerin hepsini atlayabilirsiniz:

```dart
// Only one const, which establishes the constant context.
const pointAndLine = {
  'point': [ImmutablePoint(0, 0)],
  'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
};
```

Sabit bir constructor, sabit bağlamın dışındaysa ve `const` olmadan çağrılırsa, sabit olmayan bir nesne oluşturur:

```dart
var a = const ImmutablePoint(1, 1); // Creates a constant
var b = ImmutablePoint(1, 1); // Does NOT create a constant

assert(!identical(a, b)); // NOT the same instance!
```

## Bir nesnenin türünü alma

Çalışma zamanında bir nesnenin türünü öğrenmek için, bir `Type` nesnesi döndüren `Object` özelliği `runtimeType`'ı kullanabilirsiniz.

```dart
print('The type of a is ${a.runtimeType}');
```

> **Uyarı**
> Bir nesnenin türünü test etmek için `runtimeType` yerine bir tür test operatörü kullanın. Üretim ortamlarında `object is Type` testi, `object.runtimeType == Type` testinden daha kararlıdır.

Buraya kadar sınıfların nasıl kullanıldığını gördünüz. Bu bölümün geri kalanında sınıfların nasıl uygulanacağı anlatılmaktadır.

## Örnek değişkenleri

Örnek değişkenlerini şu şekilde bildirirsiniz:

```dart
class Point {
  double? x; // Declare instance variable x, initially null.
  double? y; // Declare y, initially null.
  double z = 0; // Declare z, initially 0.
}
```

Nullable bir tür ile bildirilen, başlatılmamış bir örnek değişkeni `null` değerine sahiptir. Nullable olmayan örnek değişkenleri bildirim sırasında başlatılmalıdır.

Tüm örnek değişkenleri örtük bir getter yöntemi oluşturur. Final olmayan örnek değişkenleri ve başlatıcısı olmayan `late final` örnek değişkenleri de örtük bir setter yöntemi oluşturur. Ayrıntılar için Getter'lar ve setter'lar bölümüne bakın.

```dart
class Point {
  double? x; // Declare instance variable x, initially null.
  double? y; // Declare y, initially null.
}

void main() {
  var point = Point();
  point.x = 4; // Use the setter method for x.
  assert(point.x == 4); // Use the getter method for x.
  assert(point.y == null); // Values default to null.
}
```

`late` olmayan bir örnek değişkenini bildirildiği yerde başlatmak, değeri örnek oluşturulduğunda, constructor ve onun initializer list'i çalışmadan önce ayarlar. Sonuç olarak, `late` olmayan bir örnek değişkeninin başlatma ifadesi (`=`'den sonra gelen) `this`'e erişemez.

```dart
double initialX = 1.5;

class Point {
  // OK, can access declarations that do not depend on 'this':
  double? x = initialX;

  // ERROR, can't access 'this' in non-'late' initializer:
  double? y = this.x;

  // OK, can access 'this' in 'late' initializer:
  late double? z = this.x;

  // OK, 'this.x' and 'this.y' are parameter declarations, not expressions:
  Point(this.x, this.y);
}
```

Örnek değişkenleri `final` olabilir; bu durumda tam olarak bir kez atanmaları gerekir. `final`, `late` olmayan örnek değişkenlerini bildirim sırasında, bir constructor parametresiyle veya bir constructor'ın initializer list'ıyla başlatın:

```dart
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

Constructor gövdesi başladıktan sonra bir final örnek değişkenine değer atamanız gerekiyorsa, aşağıdakilerden birini kullanabilirsiniz:
* Değeri bir factory constructor içinde hesaplayın, ardından bunu final örnek değişkenini başlatan üretken bir constructor'a aktarın.
* `late final` kullanın, ancak dikkatli olun: başlatıcısı olmayan bir `late final`, API'ye bir setter ekler.

## Örtük arayüzler

Her sınıf, kendisinin ve uyguladığı tüm arayüzlerin tüm örnek üyelerini içeren bir arayüzü örtük olarak tanımlar. B sınıfının uygulamasını miras almadan B sınıfının API'sini destekleyen bir A sınıfı oluşturmak istiyorsanız, A sınıfı B arayüzünü uygulamalıdır.

Bir sınıf, bir veya daha fazla arayüzü bir `implements` yan tümcesinde bildirip arayüzlerin gerektirdiği API'leri sağlayarak bu arayüzleri uygular. Örneğin:

```dart
// A person. The implicit interface contains greet().
class Person {
  // In the interface, but visible only in this library.
  final String _name;

  // Not in the interface, since this is a constructor.
  Person(this._name);

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Impostor implements Person {
  String get _name => '';
  String greet(String who) => 'Hi $who. Do you know who I am?';
}

String greetBob(Person person) => person.greet('Bob');

void main() {
  print(greetBob(Person('Kathy')));
  print(greetBob(Impostor()));
}
```

Bir sınıfın birden fazla arayüzü uyguladığını belirtmeye dair bir örnek:

```dart
class Point implements Comparable, Location {
  // ...
}
```

## Sınıf değişkenleri ve yöntemleri

Sınıf genelindeki değişkenleri ve yöntemleri uygulamak için `static` anahtar sözcüğünü kullanın.

### Statik değişkenler

Statik değişkenler (sınıf değişkenleri), sınıf genelindeki durum ve sabitler için kullanışlıdır:

```dart
class Queue {
  static const initialCapacity = 16;
  // ...
}

void main() {
  assert(Queue.initialCapacity == 16);
}
```

Statik değişkenler kullanılana kadar başlatılmaz.

> **Not**
> Bu sayfa, sabit adları için lowerCamelCase tercih eden stil kılavuzu önerisine uyar.

### Statik yöntemler

Statik yöntemler (sınıf yöntemleri) bir örnek üzerinde çalışmaz ve bu nedenle `this`'e erişemez. Ancak statik değişkenlere erişebilirler. Aşağıdaki örnekte görüldüğü gibi, statik yöntemleri doğrudan bir sınıf üzerinde çağırırsınız:

```dart
import 'dart:math';

class Point {
  double x, y;
  Point(this.x, this.y);

  static double distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  var a = Point(2, 2);
  var b = Point(4, 4);
  var distance = Point.distanceBetween(a, b);
  assert(2.8 < distance && distance < 2.9);
  print(distance);
}
```

> **Not**
> Yaygın veya sık kullanılan yardımcı araçlar ve işlevler için statik yöntemler yerine üst düzey işlevler kullanmayı düşünün.

Statik yöntemleri derleme zamanı sabitleri olarak kullanabilirsiniz. Örneğin, bir statik yöntemi sabit bir constructor'a parametre olarak aktarabilirsiniz.
# Constructor'lar

Dart'ta constructor'lar kullanımıyla ilgili her şey.

Constructor'lar, sınıfların örneklerini oluşturan özel işlevlerdir.

Dart birçok constructor türü uygular. Varsayılan constructor'lar dışında, bu işlevler sınıflarıyla aynı adı kullanır.

* **Üretken (generative) constructor'lar:** Yeni örnekler oluşturur ve örnek değişkenlerini başlatır.
* **Varsayılan (default) constructor'lar:** Bir constructor belirtilmediğinde yeni bir örnek oluşturmak için kullanılır. Argüman almaz ve adı yoktur.
* **Adlandırılmış (named) constructor'lar:** Bir constructor'ın amacını netleştirir veya aynı sınıf için birden fazla constructor oluşturulmasına olanak tanır.
* **Sabit (constant) constructor'lar:** Örnekleri derleme zamanı sabitleri olarak oluşturur.
* **Factory constructor'lar:** Ya bir alt türün yeni bir örneğini oluşturur ya da önbellekten mevcut bir örneği döndürür.
* **Yönlendiren (redirecting) constructor:** Çağrıları aynı sınıftaki başka bir constructor'a yönlendirir.

## Constructor türleri

### Üretken (generative) constructor'lar

Bir sınıfın örneğini oluşturmak için üretken bir constructor kullanın.

```dart
class Point {
  // Instance variables to hold the coordinates of the point.
  double x;
  double y;

  // Generative constructor with initializing formal parameters:
  Point(this.x, this.y);
}
```

### Varsayılan constructor'lar

Bir constructor bildirmezseniz Dart varsayılan constructor'ı kullanır. Varsayılan constructor, argümanı ve adı olmayan üretken bir constructor'dır.

### Adlandırılmış constructor'lar

Bir sınıf için birden fazla constructor uygulamak veya ek netlik sağlamak için adlandırılmış bir constructor kullanın:

```dart
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  // Named constructor
  Point.origin()
      : x = xOrigin,
        y = yOrigin;
}
```

Bir alt sınıf, üst sınıfın adlandırılmış constructor'ını miras almaz. Üst sınıfta tanımlanmış adlandırılmış bir constructor'a sahip bir alt sınıf oluşturmak için o constructor'ı alt sınıfta uygulayın.

### Sabit constructor'lar

Sınıfınız değişmeyen nesneler üretiyorsa, bu nesneleri derleme zamanı sabiti yapın. Nesneleri derleme zamanı sabiti yapmak için, tüm örnek değişkenleri `final` olarak ayarlanmış bir `const` constructor tanımlayın.

```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

Sabit constructor'lar her zaman sabit oluşturmaz. `const` olmayan bir bağlamda çağrılabilirler. Daha fazla bilgi için constructor'ları kullanma bölümüne bakın.

### Yönlendiren constructor'lar

Bir constructor, aynı sınıftaki başka bir constructor'a yönlendirebilir. Yönlendiren bir constructor'ın gövdesi boştur. Constructor, iki noktadan (`:`) sonra sınıf adı yerine `this` kullanır.

```dart
class Point {
  double x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
```

### Factory constructor'lar

Bir constructor uygularken aşağıdaki iki durumdan biriyle karşılaştığınızda `factory` anahtar sözcüğünü kullanın:

* Constructor her zaman kendi sınıfının yeni bir örneğini oluşturmaz. Bir factory constructor `null` döndüremese de şunları döndürebilir:
  * yeni bir örnek oluşturmak yerine önbellekteki mevcut bir örneği
  * bir alt türün yeni bir örneğini
* Bir örnek oluşturmadan önce önemsiz olmayan bir iş yapmanız gerekiyordur. Bu, argümanları kontrol etmeyi veya initializer list içinde yapılamayan başka herhangi bir işlemi içerebilir.

> **İpucu**
> Bir final değişkeninin geç başlatılmasını `late final` ile de halledebilirsiniz (dikkatli olun!).

Aşağıdaki örnek iki factory constructor içerir. `Logger` factory constructor'ı nesneleri önbellekten döndürür. `Logger.fromJson` factory constructor'ı bir final değişkenini bir JSON nesnesinden başlatır.

```dart
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
```

> **Uyarı**
> Factory constructor'lar `this`'e erişemez.

Bir factory constructor'ı diğer constructor'lar gibi kullanın:

```dart
var logger = Logger('UI');
logger.log('Button clicked');

var logMap = {'name': 'UI'};
var loggerJson = Logger.fromJson(logMap);
```

#### Yönlendiren factory constructor'lar

Yönlendiren bir factory constructor, biri yönlendiren constructor'ı çağırdığında kullanılacak başka bir sınıfın constructor'ına yapılan çağrıyı belirtir.

```dart
factory Listenable.merge(List<Listenable> listenables) = _MergingListenable;
```

Sıradan factory constructor'lar da başka sınıfların örneklerini oluşturup döndürebildiğinden, yönlendiren factory'ler gereksiz görünebilir. Ancak yönlendiren factory'lerin birkaç avantajı vardır:
* Soyut bir sınıf, başka bir sınıfın sabit constructor'ını kullanan sabit bir constructor sağlayabilir.
* Yönlendiren bir factory constructor, ileticilerin biçimsel parametreleri ve bunların varsayılan değerlerini tekrarlama ihtiyacını ortadan kaldırır.

### Constructor tear-off'lar

Dart, bir constructor'ı çağırmadan parametre olarak vermenize olanak tanır. Tear-off olarak adlandırılan bu yapı (parantezleri koparıp attığınız için), constructor'ı aynı parametrelerle çağıran bir closure işlevi görür.

Tear-off, yöntemin kabul ettiği imza ve dönüş türüne sahip bir constructor ise, tear-off'u parametre veya değişken olarak kullanabilirsiniz.

Tear-off'lar, lambda'lardan veya anonim işlevlerden farklıdır. Lambda'lar constructor için bir sarmalayıcı görevi görürken, tear-off constructor'ın ta kendisidir.

Tear-off'lar kullanın:
```dart
// Use a tear-off for a named constructor:
var strings = charCodes.map(String.fromCharCode);

// Use a tear-off for an unnamed constructor:
var buffers = charCodes.map(StringBuffer.new);
```

Lambda kullanmayın:
```dart
// Instead of a lambda for a named constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Instead of a lambda for an unnamed constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```

## Kısa constructor söz dizimi

Dart 3.13 ve sonrasında, sınıf gövdesi içinde üretken bir constructor veya factory constructor bildirirken `new` ya da `factory` değiştiricisini doğrudan kullanarak sınıf adını atlayabilirsiniz:

* `new` veya `new named`
* `factory` veya `factory named`

Geleneksel adlandırılmış constructor'lardan (örneğin `Point.origin()`) farklı olarak, kısa adlandırılmış constructor'lar anahtar sözcük (değiştirici) ile ad arasında nokta kullanmaz.

```dart
class Point {
  double x, y;

  // Concise unnamed generative constructor.
  new(this.x, this.y);

  // Concise named generative constructor.
  new origin() : x = 0, y = 8;

  // Equivalent to 'factory Point.clone(Point other)'.
  factory clone(Point other) => Point(other.x, other.y);
}
```

Bu söz dizimi kod kalabalığını azaltır ve sınıf adlarını yeniden düzenlemeyi kolaylaştırır.

> **Not**
> Bu söz diziminde, dönüş türü olmayan (`factory() {` gibi) `factory` adlı bir yöntem, adsız bir factory constructor olarak yorumlanır.

Alanları ve constructor'ları tek bir satırda tanımladığınız daha da kısa bir söz dizimi için Primary constructor'lar bölümüne bakın.

## Örnek değişkenlerini başlatma

Dart, örnek değişkenlerini başlatmak için çeşitli yollar sunar. Bildirimde değer atayabilir, başlatan biçimsel parametreler (initializing formal parameters) kullanabilir veya bir initializer list kullanabilirsiniz.

### Örnek değişkenlerini bildirimde başlatma

Örnek değişkenlerini, değişkenleri bildirirken başlatın.

```dart
class PointA {
  double x = 1.0;
  double y = 2.0;

  // The implicit default constructor sets these variables to (1.0, 2.0)
  // PointA();

  @override
  String toString() {
    return 'PointA($x, $y)';
  }
}
```

### Başlatan biçimsel parametreleri kullanma

Bir constructor argümanını bir örnek değişkenine atama şeklindeki yaygın kalıbı basitleştirmek için Dart'ta başlatan biçimsel parametreler bulunur.

Constructor bildiriminde `this.<propertyName>` ekleyin ve gövdeyi atlayın. `this` anahtar sözcüğü mevcut örneği ifade eder.

Ad çakışması varsa `this` kullanın. Aksi halde Dart stili `this`'i atlar. Üretken constructor için bir istisna vardır: burada başlatan biçimsel parametre adının başına `this` eklemeniz gerekir.

Bu kılavuzda daha önce belirtildiği gibi, bazı constructor'lar ve constructor'ların bazı kısımları `this`'e erişemez. Bunlar şunlardır:
* Factory constructor'lar
* Bir initializer list'in sağ tarafı
* Bir üst sınıf constructor'ına verilen argümanlar

Başlatan biçimsel parametreler, null olamayan veya `final` örnek değişkenlerini başlatmanıza da olanak tanır. Bu iki değişken türü de başlatma ya da varsayılan bir değer gerektirir.

```dart
class PointB {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  PointB(this.x, this.y);

  // Initializing formal parameters can also be optional.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
```

Bu, adlandırılmış değişkenlerle de çalışır.

```dart
class PointC {
  double x; // must be set in constructor
  double y; // must be set in constructor

  // Generative constructor with initializing formal parameters
  // with default values
  PointC.named({this.x = 1.0, this.y = 1.0});

  @override
  String toString() {
    return 'PointC.named($x, $y)';
  }
}

// Constructor using named variables.
final pointC = PointC.named(x: 2.0, y: 2.0);
```

Başlatan biçimsel parametrelerden gelen tüm değişkenler hem final'dır hem de yalnızca başlatılan değişkenlerin kapsamındadır.

### Private adlandırılmış parametreler

> **Sürüm notu**
> Private adlandırılmış parametreleri başlatan biçimsel parametre olarak kullanmak için en az 3.12 dil sürümü gerekir.

Dart'ta alt çizgiyle başlayan alanlar kendi kütüphanelerine özeldir (private). Private bir alanı adlandırılmış bir parametreyle başlatmak için initializer list'te elle atama kodu yazabilirsiniz:

```dart
class Point {
  final double _x;
  Point({required double x}) : _x = x;
}
```

Private alanları doğrudan constructor parametre listesinde de başlatabilirsiniz. Adlandırılmış parametrenin başına `this._` eklediğinizde, derleyici çağıran taraf için alt çizgiyi otomatik olarak kaldırır ve temiz, public bir ad kullanmasını sağlar:

```dart
class Point {
  final double _x;
  Point({required this._x});
}
```

Her iki durumda da çağıran taraf, çağrı yerinde public ad olan `x`'i kullanır:

```dart
var p = Point(x: 1.0);
```

Normal adlandırılmış parametreler gibi, private adlandırılmış parametreleri de isteğe bağlı veya zorunlu yapabilirsiniz. Ayrıca açık varsayılan değerler de verebilirsiniz.

### Bir initializer list kullanma

Constructor gövdesi çalışmadan önce örnek değişkenlerini başlatabilirsiniz. Başlatıcıları virgülle ayırın.

```dart
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

> **Uyarı**
> Bir initializer list'in sağ tarafı `this`'e erişemez.

Geliştirme sırasında girdileri doğrulamak için initializer list'te `assert` kullanın.

```dart
Point.withAssert(this.x, this.y) : assert(x >= 0) {
  print('In Point.withAssert(): ($x, $y)');
}
```

## Constructor kalıtımı

Alt sınıflar (child classes), constructor'ları üst sınıflarından, yani doğrudan ebeveyn sınıflarından miras almaz. Bir sınıf bir constructor bildirmezse yalnızca varsayılan constructor'ı kullanabilir.

Bir sınıf, üst sınıfın parametrelerini miras alabilir. Bunlara `super` parametreleri denir.

### Varsayılan olmayan üst sınıf constructor'lar

Dart constructor'ları aşağıdaki sırayla çalıştırır:
1. Initializer list
2. üst sınıfın adsız, argümansız constructor'ı
3. ana sınıfın argümansız constructor'ı

Üst sınıfta adsız, argümansız bir constructor yoksa, üst sınıftaki constructor'lardan birini çağırın. Constructor gövdesinden (varsa) önce, iki noktadan (`:`) sonra üst sınıf constructor'ını belirtin.

```dart
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson().
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  var employee = Employee.fromJson({});
  print(employee);
  // Prints:
  // in Person
  // in Employee
}
```

Dart, üst sınıf constructor'ının argümanlarını constructor'ı çağırmadan önce değerlendirdiğinden, bir argüman işlev çağrısı gibi bir ifade olabilir.

```dart
class Employee extends Person {
  Employee() : super.fromJson(fetchDefaultData());
  // ...
}
```

> **Uyarı**
> Üst sınıf constructor'ına verilen argümanlar `this`'e erişemez. Örneğin argümanlar statik yöntemleri çağırabilir ancak örnek yöntemlerini çağıramaz.

### Super parametreleri

Her parametreyi bir constructor'ın `super` çağrısına tek tek aktarmaktan kaçınmak için, parametreleri belirtilen veya varsayılan üst sınıf constructor'ına iletmek üzere super-initializer parametrelerini kullanın. Bu özelliği yönlendiren constructor'lar ile kullanamazsınız. Super-initializer parametreleri, başlatan biçimsel parametrelere benzer söz dizimi ve anlama sahiptir.

> **Sürüm notu**
> Super-initializer parametrelerini kullanmak için en az 2.17 dil sürümü gerekir. Daha eski bir dil sürümü kullanıyorsanız tüm super constructor parametrelerini elle aktarmanız gerekir.

Super-constructor çağrısı konumsal argümanlar içeriyorsa, super-initializer parametreleri konumsal olamaz.

```dart
class Vector2d {
  final double x;
  final double y;

  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the x and y parameters to the default super constructor
  Vector3d(super.x, super.y, this.z);
}
```

Bu adlandırılmış constructor, x değerini iki kez ayarlamaya çalışır: bir kez super constructor'ında ve bir kez de konumsal bir super parametresi olarak. Her ikisi de x konumsal parametresini hedeflediğinden bu bir hataya yol açar:

```dart
// BAD
Vector3d.xAxisError(super.x) : z = 0, super(0); 
```

Super constructor'ın adlandırılmış argümanları olduğunda, bunları adlandırılmış super parametreleri ile super constructor çağrısına aktarılan adlandırılmış argümanlar arasında bölebilirsiniz:

```dart
class Vector2d {
  // ...
  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the y parameter to the named super constructor like:
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
```
# Primary constructor'lar

Parametreleri ve alanları sınıf başlığında bildirerek sınıfları kısa yoldan oluşturun.

> **Sürüm notu**
> Primary constructor'lar en az 3.13 dil sürümü gerektirir.

## Genel bakış

Primary constructor'lar, bir sınıfın alanlarını ve ana constructor'ını tek satırda bildirmenin kısa bir yolunu sunar. Alanları bildirme, parametreleri aktarma ve bunları constructor gövdesinde atama gibi tekrar eden kodu azaltır. Bu kısaltma bildirimi yazma biçiminizi değiştirir ama çalışma zamanı davranışını değiştirmez.

### Öncesi ve sonrası

İki alanı ve bir constructor'ı olan şu geleneksel sınıfı ele alalım:

```dart
// Current syntax.
class Point {
  int x;
  int y;

  Point(this.x, this.y);
}
```

Primary constructor kullanmak aynı sınıfı çok daha kısa hale getirir:

```dart
// Using a primary constructor.
class Point(var int x, var int y);
```

Primary constructor'da bir parametreyi `var` veya `final` ile bildirmek, o parametre için örtük olarak bir örnek değişkeni oluşturur.

Sınıf gövdesi içinde bildirilen diğer tüm constructor'lara gövde içi (in-body) constructor'lar denir.

Primary constructor'ın her yeni örnekte çalışmasını sağlamak için, primary constructor'a sahip bir sınıf, mixin sınıfı veya enum, yönlendirme yapmayan başka hiçbir üretken gövde içi constructor'lara sahip olamaz.

> **Not**
> Sınıf gövdesinde geleneksel constructor'ları sınıf adını tekrarlamadan daha kısa bildirmek istiyorsanız Kısa constructor söz dizimi bölümüne bakın.

## Parametrelerde alan bildirimleri

Primary constructor'larda `var` veya `final` değiştiricisine sahip parametreler, yani bildiren parametreler (declaring parameters), örtük olarak bir alan oluşturur.

Değiştiriciyi atlarsanız parametre bir alan oluşturmaz; geleneksel bir constructor'daki parametre gibi davranır.

```dart
// Declares both fields x and y.
class Point(var int x, var int y);

// Doesn't declare a field.
class User(String name);
```

Extension type'lar için primary constructor'ın tam olarak bir parametresi olmalıdır. Bu parametre, değiştiriciyi atlasanız bile her zaman bildiren bir parametredir.

Mixin sınıfları yalnızca parametresi, gövdesi veya initializer list'i olmayan bir primary constructor'a sahip olabilir.

### Yeni parametre değiştirici kısıtlamaları

Parametrelerdeki `final` ve `var` artık primary constructor'larda bildiren parametreler için ayrıldığından, bunları diğer bildirimlerdeki parametrelerde kullanamazsınız. Kod örnekleri ve geçiş rehberi için Parametre değiştirici kısıtlamaları bölümüne bakın.

## Primary constructor kapsamları

Primary constructor kullandığınızda, sınıf başlığında bildirdiğiniz parametreler sınıf bildiriminin farklı bölümlerinde kullanılabilir. Dart bunların görünürlüğünü iki ayrı kapsamla yönetir:

* **Primary başlatıcı kapsamı:** Sınıf gövdesindeki `late` olmayan alan başlatıcılarına ve primary constructor'ın initializer list'ine (`this:` 'ten sonra) uygulanır. Bu kapsamda `x` gibi bir parametre adı doğrudan constructor parametresini ifade eder.
* **Primary parametre kapsamı:** Primary constructor'ın gövde bloğuna (`{ }` içinde) uygulanır. Bu kapsamda bildiren bir parametrenin adı oluşturulan örnek değişkenini (alanı) ifade ederken, bildirmeyen bir parametrenin adı hâlâ constructor parametresini ifade eder.

Primary başlatıcı kapsamı, başlık parametrelerini late olmayan alanları başlatmak için doğrudan kullanılabilir kılar ve ayrı bir initializer list ihtiyacını ortadan kaldırır. Tıpkı geleneksel bir constructor'ın initializer list'inde değişkenleri başlatıyormuşsunuz gibi çalışır:

```dart
class DeltaPoint(final int x, int delta) {
  // Accesses 'x' and 'delta' parameters directly!
  final int y = x + delta;
}
```

Primary parametre kapsamı, örnek değişkenlerinde yapılan güncellemelerin constructor gövdesine doğru yansımasını sağlarken başlatıcıların orijinal parametrelere erişimini korur.

Aşağıdaki örnek, aynı `x` adının her kapsamda nasıl farklı çözümlendiğini gösterir:

```dart
class ScopingDemo(var String x, String suffix) {
  // In a non-late field initializer, 'x' refers to the parameter 'x'.
  final String fieldAtDeclaration = x;

  final String fieldInInitializer;

  // In the initializer list, 'x' refers to the parameter 'x'.
  this : fieldInInitializer = x {
    // Inside the body, 'x' refers to the induced instance variable,
    // so assigning to it updates the field.
    x = x.toUpperCase();

    // 'suffix' induces no field, so it still refers to the parameter.
    print('$x$suffix');
  }
}
```

Bu tutarlı davranış, geleneksel ve primary constructor'lar arasında yeniden düzenleme yapmayı daha basit ve güvenli hale getirir.

## Constructor gövdesi ekleme

Girdiyi doğrulamak veya karmaşık bir başlatma yapmak için, sınıf tanımı içinde primary constructor'a bir gövde ekleyebilirsiniz. Bu gövde `this` anahtar sözcüğünü ve ardından bir bloğu kullanır:

```dart
class Point(var int x, var int y) {
  this : assert(x >= 0 && y >= 0) {
    print('Point initialized at ($x, $y)');
  }
}
```

Blok, `this` 'ten sonra bir initializer list ve/veya bir işlev gövdesi belirtebilir. Yalnızca initializer list vermek için bloğu `this : assert(x >= 0);` gibi noktalı virgülle bitirin. Bloğa `@metadata this;` gibi metadata da ekleyebilirsiniz.

### Private alanları başlatma

Private bir alanı adlandırılmış bir parametreyle başlatmak için geleneksel bir constructor'da elle atama kodu yazabilirsiniz:

```dart
// Variant not using a private named parameter.
class User({required String name}) {
  String _name = name;
}
```

Primary constructor'lar ve private adlandırılmış parametreler özelliği sayesinde private alanı doğrudan constructor başlığında bildirebilirsiniz. Adlandırılmış bir parametre için private bir ad (başında alt çizgi olan) kullandığınızda, derleyici alt çizgiyi kaldırarak parametre adını çağıran taraf için otomatik olarak public yapar:

```dart
// Variant using a private named parameter.
class User({required var String _name});
```

Her iki durumda da çağıran taraf, çağrı yerinde public ad olan `name`'i kullanır:

```dart
User(name: 'John Doe')
```

### Boş gövdeler

Bir sınıfın, mixin sınıfının, extension'ın veya extension type'ın boş gövdesi (`{}`) noktalı virgülle (`;`) değiştirilebilir. Bu, bu bildirimler için genel olarak geçerli olsa da, tüm bildirimi tek satırda tutmak için primary constructor kullanırken özellikle yararlıdır.

```dart
class Point(var int x, var int y);
```

## Sabit primary constructor'lar

Geleneksel constructor'lar gibi, sınıf ve alanları izin veriyorsa primary constructor da sabit olabilir. Sabit bir primary constructor bildirmek için sınıf başlığında sınıf adının önüne `const` değiştiricisini koyun:

```dart
class const ConstPoint(final int x, final int y) {
  final int z;

  // A constant primary constructor can have an initializer list,
  // but can't have a body block.
  this : z = x + y;
}
```

Sabit primary constructor'lar için şu önemli kısıtlamalar geçerlidir:

* **Gövde bloğu olamaz:** Boş olsa bile bir `{ }` gövdesine sahip olmak derleme zamanı hatasıdır. Sabit bir primary constructor yalnızca ardından noktalı virgül gelen bir initializer list kullanabilir.
* **Kesin olarak başlatılmış final alanlar:** Üretken `const` constructor'ı olan her sınıfta olduğu gibi, her örnek değişkeni `final` olmalı, `late` olamaz ve bildiren bir parametre, alan başlatıcısı veya primary constructor'ın initializer list'i tarafından kesin olarak başlatılmalıdır.
* **Potansiyel olarak sabit başlatıcılar:** Her örnek değişkeninin başlatma ifadesi potansiyel olarak sabit olmalıdır. Buna alan başlatıcıları ve primary constructor'ın initializer list'indeki ifadeler dahildir.

## Adlandırılmış primary constructor'lar

Sınıf başlığında sınıf adından sonra bir nokta (`.`) ve bir ad ekleyerek primary constructor'ı adlandırılmış bir constructor olarak da bildirebilirsiniz:

```dart
// A named primary constructor.
class Point.custom(var int x, var int y);
```

Yaygın bir kalıp, doğrudan örnek oluşturmayı kısıtlayan ve çağıranları factory yöntemlerini veya diğer constructor'ları kullanmaya zorlayan private bir primary constructor (örneğin `Point._`) tanımlamaktır:

```dart
// A private named primary constructor.
class Point._(var int x, var int y);
```

## Super parametreleri

Super parametreleri geleneksel constructor'lardaki gibi çalışır ve parametreleri üst sınıf constructor'ına iletmenizi sağlar:

```dart
class Person(final String name, final int age);

class Employee(super.name, super.age, final String role) extends Person;
```

Bu, hiyerarşik sınıf yapılarında tekrar eden kodu azaltır; initializer list'leri elle yazma veya parametre bildirimlerini çoğaltma ihtiyacını ortadan kaldırır.

## Enum primary constructor'lar

Primary constructor'lar ile gelişmiş (enhanced) enum'ları çok daha kısa bildirebilirsiniz. Primary constructor kullanarak enum'un alanlarını ve constructor'ını tek satırda tanımlayabilir, alanları ve parametreleri bildirip başlatmanın alışılmış tekrar eden kodundan kurtulabilirsiniz:

```dart
enum Color(final String hex) {
  red('#FF0000'),
  green('#00FF00'),
  blue('#0000FF'),
}
```

Enum'lardaki primary constructor'lar örtük olarak sabittir. Enum adının önüne isteğe bağlı olarak `const` değiştiricisini yazabilirsiniz (`enum const Color`'da olduğu gibi), ancak bu gereksizdir ve atlanabilir.

## Kısıtlamalar ve uyumu bozan değişiklikler

Primary constructor'lar kullanırken bu kısıtlamaları ve olası hataları aklınızda bulundurun:

* **Bildiren parametreler `late` veya `external` olamaz:** Primary constructor başlığındaki parametrelerde `late` ve `external` değiştiricilerine izin verilmez. Bu değiştiricileri kullanmak için alanları her zamanki gibi sınıf gövdesinde bildirin.
* **Ad çakışmaları:** Primary constructor'da, sınıf gövdesindeki bir yöntemle veya başka bir alanla aynı ada sahip bir parametre bildirmek derleme zamanı hatasına yol açar.
* **Primary constructor parametrelerine atama yapılamaz:** Primary constructor parametreleri, primary başlatıcı kapsamında salt okunurdur. Bir alan başlatıcısında veya primary constructor'ın initializer list'inde bunlara atama yapmak (`x = 5` veya `x++` gibi) derleme zamanı hatasıdır.
* **Çift başlatma:** Alan değiştirilebilir olsa bile bir örnek değişkenini hem bildiriminde hem de primary constructor'ın initializer list'inde (veya başlatan biçimsel parametre olarak) başlatamazsınız. Bu, derleme zamanı hatasına yol açar.
* **Gövde bölümü kısıtlamaları:**
  * Primary constructor gövde bölümü (`this` bloğu) `async`, `async*` veya `sync*` değiştiricilerini kullanamaz ve ifade gövdesi ok (`=>`) söz dizimini kullanamaz.
  * Sınıf başlığı bir primary constructor bildirmiyorsa `this` bloğu yazamazsınız.
  * Bir sınıfın en fazla bir primary constructor gövde bölümü olabilir.
* **Mixin sınıfı primary constructor'ları basit olmalıdır:** Bir mixin sınıfı, yalnızca parametresi, initializer list'i ve gövdesi olmayan bir primary constructor bildirebilir.
* **Kovaryant parametreler:** `covariant` değiştiricisini bir primary constructor parametresinde yalnızca değiştirilebilir bir bildiren parametreyse (`var` değiştiricisini kullanıyorsa) kullanabilirsiniz.
* **`factory` yöntemi uç durumu:** Dönüş türü olmayan `factory` adlı bir yönteminiz varsa (örneğin `factory() {}`), derleyici bunu kısa bir factory constructor olarak ayrıştırır. Bu çakışmayı önlemek için bu tür yöntemlerin açık bir dönüş türü olduğundan emin olun (örneğin `void factory() {}`).

### Parametre değiştirici kısıtlamaları

`final` ve `var` parametre değiştiricileri yalnızca primary constructor'lardaki bildiren parametreler için ayrılmıştır. `final` veya `var`'ı, primary constructor dışındaki herhangi bir bildirimdeki (üst düzey işlevler, yöntemler, closure'lar ve gövde içi constructor'lar gibi) biçimsel parametrelerde kullanmak derleme zamanı hatası (`extraneous_modifier`) üretir.

```dart
// Valid: Primary constructor declaring parameter.
class Point(final int x, final int y);

// Compile-time error (extraneous_modifier):
void printValue(final int x) => print(x);
```

Bu hatayı düzeltmek için değiştiriciyi kaldırın veya `dart fix` çalıştırın. Değişmez parametreleri bir stil tercihi olarak zorunlu kılmak için bunun yerine `parameter_assignments` lint kuralını kullanın.
# Yöntemler

Dart'taki yöntemler hakkında bilgi edinin.

Yöntemler, bir nesneye davranış kazandıran işlevlerdir.

## Örnek yöntemleri

Nesnelerdeki örnek yöntemleri, örnek değişkenlerine ve `this`'e erişebilir. Aşağıdaki örnekteki `distanceTo()` yöntemi bir örnek yöntemidir:

```dart
import 'dart:math';

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

## Operatörler

Çoğu operatör, özel adlara sahip örnek yöntemleridir. Dart, aşağıdaki adlara sahip operatörleri tanımlamanıza olanak tanır:

`<` `+` `|` `>>>` `>` `/` `^` `[]` `<=` `~/` `&` `[]=` `>=` `*` `<<` `~` `==` `%` `>>`

> **Not**
> `!=` gibi bazı operatörlerin ad listesinde olmadığını fark etmiş olabilirsiniz. Bu operatörler örnek yöntemi değildir. Davranışları Dart'ta yerleşiktir.

Bir operatör bildirmek için yerleşik `operator` tanımlayıcısını, ardından tanımladığınız operatörü kullanın. Aşağıdaki örnek vektör toplamayı (`+`), çıkarmayı (`-`) ve eşitliği (`==`) tanımlar:

```dart
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  final v = Vector(2, 3);
  final w = Vector(2, 2);

  assert(v + w == Vector(4, 5));
  assert(v - w == Vector(0, 1));
}
```

## Getter'lar ve setter'lar

Getter'lar ve setter'lar, bir nesnenin özelliklerine okuma ve yazma erişimi sağlayan özel yöntemlerdir. Her örnek değişkeninin örtük bir getter'ı ve uygunsa bir setter'ı olduğunu hatırlayın. `get` ve `set` anahtar sözcüklerini kullanarak getter'lar ve setter'lar uygulayıp ek özellikler oluşturabilirsiniz:

```dart
/// A rectangle in a screen coordinate system,
/// where the origin (0, 0) is in the top-left corner.
class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define two calculated properties: right and bottom.
  double get right => left + width;
  set right(double value) => left = value - width;
  
  double get bottom => top + height;
  set bottom(double value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);
  assert(rect.left == 3);
  rect.right = 12;
  assert(rect.left == -8);
}
```

Getter'lar ve setter'lar sayesinde örnek değişkenleriyle başlayıp daha sonra bunları yöntemlerle sarmalayabilirsiniz; üstelik istemci kodunu hiç değiştirmeden.

> **Not**
> Artırma (`++`) gibi operatörler, bir getter açıkça tanımlanmış olsun ya da olmasın beklendiği gibi çalışır. Beklenmedik yan etkileri önlemek için operatör getter'ı tam olarak bir kez çağırır ve değerini geçici bir değişkende saklar.

## Soyut yöntemler

Örnek, getter ve setter yöntemleri soyut olabilir; bir arayüz tanımlar ancak uygulamasını diğer sınıflara bırakır. Soyut yöntemler yalnızca soyut sınıflarda veya mixin'lerde bulunabilir.

Bir yöntemi soyut yapmak için yöntem gövdesi yerine noktalı virgül (`;`) kullanın:

```dart
abstract class Doer {
  // Define instance variables and methods...

  void doSomething(); // Define an abstract method.
}

class EffectiveDoer extends Doer {
  void doSomething() {
    // Provide an implementation, so the method is not abstract here.
  }
}
```
# Bir sınıfı genişletme

Bir üst sınıftan alt sınıfların nasıl oluşturulacağını öğrenin.

Bir alt sınıf oluşturmak için `extends`, üst sınıfa başvurmak için `super` kullanın:

```dart
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // ...
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // ...
}
```

`extends`'in başka bir kullanımı için Generics sayfasındaki parametreli türler bölümüne bakın.

## Üyeleri geçersiz kılma (override)

Alt sınıflar örnek yöntemlerini (operatörler dahil), getter'lar ve setter'ları geçersiz kılabilir. Bir üyeyi bilerek geçersiz kıldığınızı belirtmek için `@override` annotation'ını kullanabilirsiniz:

```dart
class Television {
  // ...
  set contrast(int value) {
    // ...
  }
}

class SmartTelevision extends Television {
  @override
  set contrast(num value) {
    // ...
  }
  // ...
}
```

Geçersiz kılan bir yöntem bildirimi, geçersiz kıldığı yöntemle (veya yöntemlerle) birkaç açıdan eşleşmelidir:

* Dönüş türü, geçersiz kılınan yöntemin dönüş türüyle aynı (veya onun bir alt türü) olmalıdır.
* Parametre türleri, geçersiz kılınan yöntemin parametre türleriyle aynı (veya onların bir üst türü) olmalıdır. Önceki örnekte `SmartTelevision`'un `contrast` setter'ı, parametre türünü `int`'ten bir üst tür olan `num`'a değiştirir.
* Geçersiz kılınan yöntem `n` konumsal parametre kabul ediyorsa, geçersiz kılan yöntem de `n` konumsal parametre kabul etmelidir.

Generic bir yöntem generic olmayan bir yöntemi geçersiz kılamaz; generic olmayan bir yöntem de generic bir yöntemi geçersiz kılamaz.

Bazen bir yöntem parametresinin veya bir örnek değişkeninin türünü daraltmak isteyebilirsiniz. Bu normal kuralları ihlal eder ve çalışma zamanında tür hatasına yol açabilmesi bakımından aşağı dönüşüme (downcast) benzer. Yine de kod bir tür hatası oluşmayacağını garanti edebiliyorsa türü daraltmak mümkündür. Bu durumda parametre bildiriminde `covariant` anahtar sözcüğünü kullanabilirsiniz. Ayrıntılar için Dart dil belirtimine bakın.

> **Uyarı**
> `==`'i geçersiz kılarsanız, `Object`'in `hashCode` getter'ını da geçersiz kılmalısınız. `==` ve `hashCode`'u geçersiz kılma örneği için Map anahtarlarını uygulama bölümüne bakın.

## noSuchMethod()

Kodun var olmayan bir yöntemi veya örnek değişkenini kullanmaya çalıştığı durumları algılamak ya da bunlara tepki vermek için `noSuchMethod()`'u geçersiz kılabilirsiniz:

```dart
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void noSuchMethod(Invocation invocation) {
    print(
      'You tried to use a non-existent member: '
      '${invocation.memberName}',
    );
  }
}
```

Aşağıdakilerden biri doğru olmadıkça, uygulanmamış bir yöntemi çağıramazsınız:

* Alıcının statik türü `dynamic`'tir.
* Alıcının statik türü uygulanmamış yöntemi tanımlar (soyut olması sorun değildir) ve alıcının dinamik türünde, `Object` sınıfındakinden farklı bir `noSuchMethod()` uygulaması vardır.

Daha fazla bilgi için resmi olmayan noSuchMethod yönlendirme belirtimine bakın.
# Mixin'ler

Dart'ta bir sınıfa nasıl özellik ekleneceğini öğrenin.

Mixin'ler, birden fazla sınıf hiyerarşisinde yeniden kullanılabilen kod tanımlamanın bir yoludur. Üye uygulamalarını toplu halde sağlamak için tasarlanmıştır.

Bir mixin kullanmak için `with` anahtar sözcüğünü ve ardından bir veya daha fazla mixin adını yazın. Aşağıdaki örnek, mixin'leri kullanan (veya onların alt sınıfı olan) iki sınıfı gösterir:

```dart
class Musician extends Performer with Musical {
  // ...
}

class Maestro extends Person with Musical, Aggressive, Demented {
  Maestro(String maestroName) {
    name = maestroName;
    canConduct = true;
  }
}
```

Bir mixin tanımlamak için `mixin` bildirimini kullanın. Hem bir mixin hem de bir sınıf tanımlamanız gereken nadir durumlarda `mixin class` bildirimini kullanabilirsiniz.

Mixin'ler ve mixin sınıflarının `extends` yan tümcesi olamaz ve herhangi bir üretken constructor'lar bildirmemelidir.

Örneğin:

```dart
mixin Musical {
  bool canPlayPiano = false;
  bool canCompose = false;
  bool canConduct = false;

  void entertainMe() {
    if (canPlayPiano) {
      print('Playing piano');
    } else if (canConduct) {
      print('Waving hands');
    } else {
      print('Humming to self');
    }
  }
}
```

## Bir mixin'in kendi üzerinde çağırabileceği üyeleri belirtme

Bazen bir mixin, bir yöntemi çağırabilmeye veya alanlara erişebilmeye bağlıdır ancak bu üyeleri kendisi tanımlayamaz (çünkü mixin'ler, kendi alanlarını oluşturmak için constructor parametrelerini kullanamaz).

Aşağıdaki bölümler, bir mixin'in her alt sınıfının mixin'in davranışının bağlı olduğu üyeleri tanımlamasını sağlamaya yönelik farklı stratejileri ele alır.

### Mixin'de soyut üyeler tanımlama

Bir mixin'de soyut bir yöntem bildirmek, mixin'i kullanan her türü, davranışının bağlı olduğu soyut yöntemi tanımlamaya zorlar.

```dart
mixin Musician {
  void playInstrument(String instrumentName); // Abstract method.

  void playPiano() {
    playInstrument('Piano');
  }
  void playFlute() {
    playInstrument('Flute');
  }
}

class Virtuoso with Musician {
  @override
  void playInstrument(String instrumentName) { // Subclass must define
    print('Plays the $instrumentName beautifully');
  }
}
```

### Mixin'in alt sınıfındaki duruma erişme

Soyut üyeler bildirmek, mixin'de soyut olarak tanımlanan getter'ları çağırarak bir mixin'in alt sınıfındaki duruma erişmenize de olanak tanır:

```dart
/// Can be applied to any type with a [name] property and provides an
/// implementation of [hashCode] and operator == in terms of it.
mixin NameIdentity {
  String get name;

  @override
  int get hashCode => name.hashCode;

  @override
  bool operator ==(other) => other is NameIdentity && name == other.name;
}

class Person with NameIdentity {
  final String name;
  Person(this.name);
}
```

### Bir arayüz uygulama

Mixin'i soyut olarak bildirmeye benzer şekilde, arayüzü gerçekten uygulamadan mixin'e bir `implements` yan tümcesi eklemek de mixin için tüm üye bağımlılıklarının tanımlanmasını sağlar.

```dart
abstract interface class Tuner {
  void tuneInstrument();
}

mixin Guitarist implements Tuner {
  void playSong() {
    tuneInstrument();
    print('Strums guitar majestically.');
  }
}

class PunkRocker with Guitarist {
  @override
  void tuneInstrument() {
    print("Don't bother, being out of tune is punk rock.");
  }
}
```

### Bir üst sınıf bildirmek için on yan tümcesini kullanma

`on` yan tümcesi, `super` çağrılarının hangi türe göre çözümleneceğini tanımlamak için vardır. Bu yüzden onu yalnızca bir mixin içinde `super` çağrısı yapmanız gerekiyorsa kullanmalısınız.

`on` yan tümcesi, bir mixin kullanan her sınıfın aynı zamanda `on` yan tümcesindeki türün bir alt sınıfı olmasını zorunlu kılar. Mixin üst sınıftaki üyelere bağlıysa, bu, o üyelerin mixin'in kullanıldığı yerde mevcut olmasını sağlar:

```dart
class Musician {
  musicianMethod() {
    print('Playing music!');
  }
}

mixin MusicalPerformer on Musician {
  performerMethod() {
    print('Performing music!');
    super.musicianMethod();
  }
}

class SingerDancer extends Musician with MusicalPerformer { }

main() {
  SingerDancer().performerMethod();
}
```

Bu örnekte yalnızca `Musician` sınıfını genişleten sınıflar bu mixin'i kullanabilir. Bir sınıf, `MusicalPerformer`'i ancak üst sınıfı `musicianMethod()`'un somut bir uygulamasını sağlayan bir `Musician` alt türüyse mixin olarak ekleyebilir. `SingerDancer`, `Musician`'ı genişlettiği için `MusicalPerformer`'i mixin olarak ekleyebilir.

## class mixin veya mixin class?

> **Sürüm notu**
> `mixin class` bildirimi en az 3.0 dil sürümü gerektirir.

Bir `mixin` bildirimi bir mixin tanımlar. Bir `class` bildirimi bir sınıf tanımlar. Bir `mixin class` bildirimi ise aynı ad ve aynı türle hem normal bir sınıf hem de bir mixin olarak kullanılabilen bir sınıf tanımlar.

```dart
mixin class Musician {
  // ...
}

class Novice with Musician { // Use Musician as a mixin
  // ...
}

class Novice extends Musician { // Use Musician as a class
  // ...
}
```

Sınıflar veya mixin'ler için geçerli olan tüm kısıtlamalar mixin sınıfları için de geçerlidir:

* Mixin'lerin `extends` veya `with` yan tümcesi olamaz; dolayısıyla bir `mixin class`'ın da olamaz.
* Sınıfların `on` yan tümcesi olamaz; dolayısıyla bir `mixin class`'ın da olamaz.
# Numaralandırılmış türler (enumerated types)

Dart'taki enum türü hakkında bilgi edinin.

Genellikle numaralandırma veya enum'lar olarak adlandırılan numaralandırılmış türler, sabit sayıda sabit değeri temsil etmek için kullanılan özel bir sınıf türüdür.

> **Not**
> Tüm enum'lar otomatik olarak `Enum` sınıfını genişletir. Ayrıca mühürlüdürler (sealed); yani alt sınıfları oluşturulamaz, uygulanamaz, mixin olarak eklenemez veya başka bir şekilde açıkça örneklenemezler.
> 
> Soyut sınıflar ve mixin'ler `Enum`'u açıkça uygulayabilir veya genişletebilir; ancak daha sonra bir enum bildirimi tarafından uygulanmadıkça ya da ona mixin olarak eklenmedikçe, hiçbir nesne o sınıfın veya mixin'in türünü fiilen uygulayamaz.

## Basit enum'lar bildirme

Basit bir numaralandırılmış tür bildirmek için `enum` anahtar sözcüğünü kullanın ve numaralandırmak istediğiniz değerleri listeleyin:

```dart
enum Color { red, green, blue }
```

> **İpucu**
> Numaralandırılmış bir tür bildirirken kopyala-yapıştır hatalarını önlemeye yardımcı olması için sondaki virgülleri de kullanabilirsiniz.

## Gelişmiş enum'lar bildirme

> **Sürüm notu**
> Gelişmiş enum'lar en az 2.17 dil sürümü gerektirir.

Dart, enum bildirimlerinin; sabit sayıda bilinen sabit örnekle sınırlı olan, alanlar, yöntemler ve `const` constructor'lar içeren sınıflar bildirmesine de izin verir.

Gelişmiş bir enum bildirmek için normal sınıflara benzer bir söz dizimi izleyin, ancak birkaç ek gereklilik vardır:

* Mixin'ler tarafından eklenenler dahil, örnek değişkenleri `final` olmalıdır.
* Tüm üretken constructor'lar sabit olmalıdır.
* Factory constructor'lar yalnızca sabit, bilinen enum örneklerinden birini döndürebilir.
* Enum otomatik olarak genişletildiğinden başka hiçbir sınıf genişletilemez.
* `index`, `hashCode` ve eşitlik operatörü `==` geçersiz kılınamaz.
* Bir enum'da `values` adlı bir üye bildirilemez, çünkü otomatik olarak üretilen statik `values` getter'ı ile çakışır.
* Enum'un tüm örnekleri bildirimin başında bildirilmelidir ve en az bir örnek bildirilmiş olmalıdır.

Gelişmiş bir enum'daki örnek yöntemleri, mevcut enum değerine başvurmak için `this` kullanabilir.

Aşağıda birden fazla örneği, örnek değişkenleri, getter'ları ve uygulanmış bir arayüzü olan gelişmiş bir enum bildiren bir örnek verilmiştir:

```dart
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  const Vehicle({
    required this.tires,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonFootprint => (carbonPerKilometer / passengers).round();
  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
```

> **İpucu**
> Dart 3.13 ve sonrasında, primary constructor'lar kullanarak gelişmiş enum'ları daha da kısa bildirebilirsiniz:

```dart
enum Vehicle(
  final int tires,
  final int passengers,
  final int carbonPerKilometer,
) implements Comparable<Vehicle> {
  car(4, 5, 400),
  bus(6, 50, 800),
  bicycle(2, 1, 0);

  int get carbonFootprint => (carbonPerKilometer / passengers).round();
  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
```

## Enum'ları kullanma

Numaralandırılmış değerlere diğer statik değişkenler gibi erişin:

```dart
final favoriteColor = Color.blue;
if (favoriteColor == Color.blue) {
  print('Your favorite color is blue!');
}
```

Bir enum'daki her değerin, değerin enum bildirimindeki sıfırdan başlayan konumunu döndüren bir `index` getter'ı vardır. Örneğin ilk değerin indeksi 0, ikinci değerin indeksi 1'dir.

```dart
assert(Color.red.index == 0);
assert(Color.green.index == 1);
assert(Color.blue.index == 2);
```

Tüm numaralandırılmış değerlerin listesini almak için enum'un `values` sabitini kullanın.

```dart
List<Color> colors = Color.values;
assert(colors[2] == Color.blue);
```

Enum'ları switch deyimlerinde kullanabilirsiniz; enum'un tüm değerlerini işlemezseniz bir uyarı alırsınız:

```dart
var aColor = Color.blue;

switch (aColor) {
  case Color.red:
    print('Red as roses!');
  case Color.green:
    print('Green as grass!');
  default: // Without this, you see a WARNING.
    print(aColor); // 'Color.blue'
}
```

`Color.blue`'deki `'blue'` gibi numaralandırılmış bir değerin adına erişmeniz gerekiyorsa `.name` özelliğini kullanın:

```dart
print(Color.blue.name); // 'blue'
```

Bir enum değerinin üyesine normal bir nesnede olduğu gibi erişebilirsiniz:

```dart
print(Vehicle.car.carbonFootprint);
```
# Dot shorthand'lar

Dart'taki dot shorthand söz dizimi hakkında bilgi edinin.

> **Sürüm notu**
> Dot shorthand'lar en az 3.10 dil sürümü gerektirir.

## Genel bakış

Dot shorthand söz dizimi `.foo`, derleyicinin türü bağlamdan çıkarabildiği durumlarda türü atlayarak daha kısa Dart kodu yazmanızı sağlar. Bu, enum değerlerine, statik üyelere veya constructor'lara erişirken tam `ContextType.foo`'yu yazmaya temiz bir alternatif sunar.

Özünde dot shorthand'lar, bir ifadenin aşağıdakilerden biriyle başlamasına ve ardından isteğe bağlı olarak başka işlemlerin zincirlenmesine olanak tanır:

* `.Tanımlayıcı` (örn. `.myValue`)
* `.Constructor` (örn. `.new()`)
* Sabit oluşturma `const .myValue()`

İşte bir enum atamasını nasıl basitleştirdiğine kısa bir bakış:

```dart
// Use dot shorthand syntax on enums:
enum Status { none, running, stopped, paused }
Status currentStatus = .running; // Instead of Status.running

// Use dot shorthand syntax on a static method:
int port = .parse('8080'); // Instead of int.parse('8080')

// Uses dot shorthand syntax on a constructor:
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

Point origin = .origin(); // Instead of Point.origin()
```

## Bağlam türünün rolü

Dot shorthand'lar derleyicinin hangi üyeye çözümleneceğini belirlemek için `context.type`'ı kullanır.

Bağlam türü, Dart'ın bir ifadenin konumuna göre sahip olmasını beklediği türdür. Örneğin `Status currentStatus = .running`'de derleyici bir `Status` beklendiğini bilir, bu yüzden `.running`'in `Status.running` anlamına geldiğini çıkarır.

## Sözcüksel yapı ve söz dizimi

Statik üye kısaltması, başında nokta (`.`) bulunan bir ifadedir. Tür çevreleyen bağlamdan biliniyorsa bu söz dizimi statik üyelere, constructor'lara ve enum değerlerine erişmenin kısa bir yolunu sunar.

### Enum'lar

Dot shorthand'ların temel ve şiddetle önerilen kullanım alanı enum'lardır; özellikle enum türünün çok açık olduğu atamalarda ve switch deyimlerinde.

```dart
enum LogLevel { debug, info, warning, error }

/// Returns the color code to use for the specified log [level].
String colorCode(LogLevel level) {
  // Use dot shorthand syntax for enum values in switch cases:
  return switch (level) {
    .debug => 'gray', // Instead of LogLevel.debug
    .info => 'blue', // Instead of LogLevel.info
    .warning => 'orange', // Instead of LogLevel.warning
    .error => 'red', // Instead of LogLevel.error
  };
}

// Example usage:
String warnColor = colorCode(.warning); // Returns 'orange'
```

### Adlandırılmış constructor'lar

Dot shorthand'lar, adlandırılmış constructor'ları veya factory constructor'ları çağırmak için kullanışlıdır. Bu söz dizimi, generic bir sınıfın constructor'ına tür argümanları verirken de çalışır.

```dart
class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0, y = 0; // Named constructor

  // Factory constructor
  factory Point.fromList(List<double> list) {
    return Point(list[0], list[1]);
  }
}

// Use dot shorthand syntax on a named constructor:
Point origin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax on a factory constructor:
Point p1 = .fromList([1.0, 2.0]); // Instead of Point.fromList([1.0, 2.0])

// Use dot shorthand syntax on a generic class constructor:
List<int> intList = .filled(5, 0); // Instead of List<int>.filled(5, 0)
```

### Adsız constructor'lar

`.new` dot shorthand'ı, bir sınıfın adsız constructor'ını çağırmanın kısa bir yolunu sunar. Bu, türü zaten açıkça bildirilmiş alanlara veya değişkenlere atama yaparken kullanışlıdır.

Bu söz dizimi, tekrar eden sınıf alanı başlatıcılarını sadeleştirmede özellikle etkilidir. Dot shorthand'lar kullanan aşağıdaki "sonrası" örneğinde görüldüğü gibi, argümanlı ve argümansız constructor'lar için kullanılabilir. Ayrıca generic tür argümanlarını da bağlamdan çıkarır.

Dot shorthand'lar olmadan:

```dart
class _PageState extends State<Page> {
  late final AnimationController _animationController =
      AnimationController(vsync: this);

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<String, Map<String, bool>> properties = <String, Map<String, bool>>{};
  // ...
}
```

Dot shorthand'lar ile:

```dart
// Use dot shorthand syntax for calling unnamed constructors:
class _PageState extends State<Page> {
  late final AnimationController _animationController = .new(vsync: this);
  final ScrollController _scrollController = .new();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = .new();
  Map<String, Map<String, bool>> properties = .new();
  // ...
}
```

### Statik üyeler

Statik yöntemleri çağırmak veya statik alanlara/getter'lara erişmek için dot shorthand söz dizimini kullanabilirsiniz. Derleyici hedef sınıfı ifadenin bağlam türünden çıkarır.

```dart
// Use dot shorthand syntax to invoke a static method:
int httpPort = .parse('80'); // Instead of int.parse('80')

// Use dot shorthand syntax to access a static field or getter:
BigInt bigIntZero = .zero; // Instead of BigInt.zero
```

### Sabit ifadeler

Erişilen üye bir derleme zamanı sabitiyse dot shorthand'ları sabit bir bağlamda kullanabilirsiniz. Bu, enum değerleri ve const constructor'ları çağırırken yaygındır.

```dart
enum Status { none, running, stopped, paused }

class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Use dot shorthand syntax for enum value:
const Status defaultStatus = .running; // Instead of Status.running

// Use dot shorthand syntax to invoke a const named constructor:
const Point myOrigin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax in a const collection literal:
const List<Point> keyPoints = [.origin(), .new(1.0, 1.0)];
// Instead of [Point.origin(), Point(1.0, 1.0)]
```

## Kurallar ve sınırlamalar

Dot shorthand'lar açık bir bağlam türüne dayanır; bu da bilmeniz gereken birkaç özel kural ve sınırlamaya yol açar.

### Zincirlerde açık bağlam türü gerekir

Bir dot shorthand'a yöntem çağrıları veya özellik erişimleri gibi işlemler zincirleyebilirsiniz, ancak ifadenin tamamı bağlam türüne göre doğrulanır.

Derleyici önce dot shorthand'ın neye çözümlendiğini belirlemek için bağlamı kullanır. Zincirdeki sonraki tüm işlemler, aynı başlangıç bağlam türüyle eşleşen bir değer döndürmelidir.

```dart
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase();
// Instead of String.fromCharCode(72).toLowerCase()

print(lowerH); // Output: h
```

### Asimetrik eşitlik kontrolleri

Kısaltma söz dizimi bir eşitlik kontrolünün doğrudan sağ tarafında kullanıldığında, Dart kısaltmanın sınıfını veya enum'unu belirlemek için sol tarafın statik türünü kullanır.

Örneğin `myColor == .green` gibi bir ifadede, `myColor` değişkeninin türü bağlam olarak kullanılır. Bu, derleyicinin `.green`'i `Color.green` olarak yorumladığı anlamına gelir.

```dart
enum Color { red, green, blue }

// Use dot shorthand syntax for equality expressions:
void allowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // OK: 'myColor' is a 'Color', so .green is inferred as 'Color.green'.
  if (myColor == .green) {
    print('The color is green.');
  }

  // OK: Works with != as well.
  if (myColor != .blue) {
    print('The color is not blue.');
  }

  // OK: The context for the ternary is the variable 'inferredColor'
  // being assigned to, which has a type of 'Color'.
  Color inferredColor = condition ? .green : .blue;
  print('Inferred color is $inferredColor');
}
```

Dot shorthand, `==` veya `!=` operatörünün sağ tarafında olmalıdır. Koşullu ifade gibi daha karmaşık bir ifadeyle karşılaştırma yapmaya da izin verilmez.

```dart
// static analysis: failure
enum Color { red, green, blue }

void notAllowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // ERROR: The shorthand must be on the right side of '=='.
  // Dart's '==' operator is not symmetric for this feature.
  if (.red == myColor) {
    print('This will not compile.');
  }

  // ERROR: The right-hand side is a complex expression (a conditional),
  // which is not a valid target for shorthand in a comparison.
  if (myColor == (condition ? .green : .blue)) {
    print('This will not compile.');
  }

  // ERROR: The type context is lost by casting 'myColor' to 'Object'.
  // The compiler no longer knows that '.green' should refer to 'Color'.
  if ((myColor as Object) == .green) {
    print('This will not compile.');
  }
}
```

### İfade deyimleri `.` ile başlayamaz

Gelecekteki olası ayrıştırma belirsizliklerini önlemek için bir ifade deyiminin belirteciyle başlamasına izin verilmez.

```dart
// static analysis: failure
class Logger {
  static void log(String message) {
    print(message);
  }
}

void main() {
  // ERROR: An expression statement can't begin with '.'.
  // The compiler has no type context (like a variable assignment)
  // to infer that .log should refer to 'Logger.log'.
  .log('Hello');
}
```

### Birleşim (union) türlerinin sınırlı işlenmesi

Nullable türler (`T?`) ve `FutureOr<T>` için özel bir işleme bulunsa da destek sınırlıdır.

* Nullable bir tür (`T?`) için `T`'in statik üyelerine erişebilirsiniz, ancak `Null`'un statik üyelerine erişemezsiniz.
* `FutureOr<T>` için `T`'in statik üyelerine erişebilirsiniz (öncelikle `async` işlev dönüşlerini desteklemek amacıyla), ancak `Future` sınıfının kendi statik üyelerine erişemezsiniz.
# Extension method'lar

Mevcut API'lere nasıl ekleme yapılacağını öğrenin.

Extension method'lar, mevcut kütüphanelere işlevsellik ekler. Extension method'ları farkında bile olmadan kullanıyor olabilirsiniz. Örneğin bir IDE'de kod tamamlamayı kullandığınızda, normal yöntemlerin yanında extension method'lar da önerilir.

## Genel bakış

Başkasının API'sini kullanırken veya yaygın kullanılan bir kütüphane geliştirirken API'yi değiştirmek çoğu zaman pratik değildir ya da imkânsızdır. Ancak yine de bazı işlevler eklemek isteyebilirsiniz.

Örneğin, bir string'i tamsayıya dönüştüren şu kodu ele alalım:

```dart
int.parse('42')
```

Bu işlevin bunun yerine `String` üzerinde olması güzel olabilirdi; hem daha kısa hem de araçlarla kullanımı daha kolay:

```dart
'42'.parseInt()
```

Bu kodu mümkün kılmak için `String` sınıfının bir extension'ını içeren bir kütüphaneyi içe aktarabilirsiniz:

```dart
import 'string_apis.dart';

void main() {
  print('42'.parseInt()); // Use an extension method.
}
```

Extension'lar yalnızca yöntemleri değil, getter, setter'lar ve operatörler gibi diğer üyeleri de tanımlayabilir. Ayrıca extension'ların adları olabilir; bu, bir API çakışması ortaya çıktığında yararlı olabilir. String'ler üzerinde çalışan bir extension (adı `NumberParsing`) kullanarak extension method `parseInt()`'i şöyle uygulayabilirsiniz:

**lib/string_apis.dart**
```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
  // ...
}
```

Sonraki bölüm extension method'ların nasıl kullanılacağını açıklar. Ardından extension method'ları uygulamaya ilişkin bölümler gelir.

## Extension method'ları kullanma

Tüm Dart kodları gibi extension method'lar da kütüphanelerde bulunur. Bir extension method'un nasıl kullanılacağını zaten gördünüz: bulunduğu kütüphaneyi içe aktarın ve sıradan bir yöntem gibi kullanın:

```dart
// Import a library that contains an extension on String.
import 'string_apis.dart';

void main() {
  print('42'.padLeft(5)); // Use a String method.
  print('42'.parseInt()); // Use an extension method.
}
```

Extension method'ları kullanmak için genellikle bilmeniz gerekenler bu kadar. Kodunuzu yazarken extension method'ların statik türlere (`dynamic`'in aksine) nasıl bağlı olduğunu ve API çakışmalarının nasıl çözüleceğini de bilmeniz gerekebilir.

### Statik türler ve dynamic

`dynamic` türündeki değişkenler üzerinde extension method'ları çağıramazsınız. Örneğin aşağıdaki kod çalışma zamanı istisnasına yol açar:

```dart
dynamic d = '2';
print(d.parseInt()); // Runtime exception: NoSuchMethodError
```

Extension method'lar Dart'ın tür çıkarımıyla birlikte çalışır. Aşağıdaki kod sorunsuzdur, çünkü `v` değişkeninin türünün `String` olduğu çıkarılır:

```dart
var v = '2';
print(v.parseInt()); // Output: 2
```

`dynamic`'in çalışmamasının nedeni, extension method'ların alıcının statik türüne göre çözümlenmesidir. Extension method'lar statik olarak çözümlendiği için statik bir işlevi çağırmak kadar hızlıdır.

Statik türler ve `dynamic` hakkında daha fazla bilgi için Dart tür sistemi bölümüne bakın.

### API çakışmaları

Bir extension üyesi bir arayüzle veya başka bir extension üyesiyle çakışırsa birkaç seçeneğiniz vardır.

Seçeneklerden biri, çakışan extension'ı içe aktarma biçiminizi değiştirmek ve açığa çıkan API'yi sınırlamak için `show` veya `hide` kullanmaktır:

```dart
// Defines the String extension method parseInt().
import 'string_apis.dart';

// Also defines parseInt(), but hiding NumberParsing2
// hides that extension method.
import 'string_apis_2.dart' hide NumberParsing2;

void main() {
  // Uses the parseInt() defined in 'string_apis.dart'.
  print('42'.parseInt());
}
```

Diğer bir seçenek extension'ı açıkça uygulamaktır; bu da extension bir sarmalayıcı sınıfmış gibi görünen bir kodla sonuçlanır:

```dart
// Both libraries define extensions on String that contain parseInt(),
// and the extensions have different names.
import 'string_apis.dart'; // Contains NumberParsing extension.
import 'string_apis_2.dart'; // Contains NumberParsing2 extension.

void main() {
  // print('42'.parseInt()); // Doesn't work.
  print(NumberParsing('42').parseInt());
  print(NumberParsing2('42').parseInt());
}
```

Her iki extension'ların adı aynıysa, bir önek kullanarak içe aktarmanız gerekebilir:

```dart
// Both libraries define extensions named NumberParsing
// that contain the extension method parseInt(). One NumberParsing
// extension (in 'string_apis_3.dart') also defines parseNum().
import 'string_apis.dart';
import 'string_apis_3.dart' as rad;

void main() {
  // print('42'.parseInt()); // Doesn't work.
  // Use the ParseNumbers extension from string_apis.dart.
  print(NumberParsing('42').parseInt());

  // Use the ParseNumbers extension from string_apis_3.dart.
  print(rad.NumberParsing('42').parseInt());

  // Only string_apis_3.dart has parseNum().
  print('42'.parseNum());
}
```

Örnekte görüldüğü gibi, önek kullanarak içe aktarsanız bile extension method'ları örtük olarak çağırabilirsiniz. Öneki kullanmanız gereken tek durum, bir extension'ı açıkça çağırırken ad çakışmasını önlemektir.

## Extension method'ları uygulama

Bir extension oluşturmak için aşağıdaki söz dizimini kullanın:

```dart
extension <extension name>? on <type> { // <extension-name> is optional
  (<member definition>)* // Can provide one or more <member definitions>
}
```

Örneğin, `String` sınıfı üzerinde bir extension'ı şöyle uygulayabilirsiniz:

**lib/string_apis.dart**
```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }

  double parseDouble() {
    return double.parse(this);
  }
}
```

Bir extension'ın üyeleri yöntemler, getter'lar, setter'lar veya operatörler olabilir. Extension'lar ayrıca statik alanlara ve statik yardımcı yöntemlere de sahip olabilir. Statik üyelere extension bildiriminin dışından erişmek için, onları sınıf değişkenleri ve yöntemleri gibi bildirim adı üzerinden çağırın.

### Adsız extension'lar

Bir extension bildirirken adı atlayabilirsiniz. Adsız extension'lar yalnızca bildirildikleri kütüphanede görünür. Adları olmadığı için API çakışmalarını çözmek amacıyla açıkça uygulanamazlar.

```dart
extension on String {
  bool get isBlank => trim().isEmpty;
}
```

> **Not**
> Adsız bir extension'ın statik üyelerini yalnızca extension bildirimi içinde çağırabilirsiniz.

## Generic extension'ları uygulama

Extension'lar generic tür parametrelerine sahip olabilir. Örneğin, aşağıdaki kod yerleşik `List<T>` türünü bir getter, bir operatör ve bir yöntemle genişletir:

```dart
extension MyFancyList<T> on List<T> {
  int get doubleLength => length * 2;
  List<T> operator -() => reversed.toList();
  List<List<T>> split(int at) => [sublist(0, at), sublist(at)];
}
```

`T` türü, yöntemlerin çağrıldığı listenin statik türüne göre belirlenir.
# Extension type'lar

Mevcut bir tür için yalnızca statik bir arayüz yazmayı öğrenin.

Bir extension type, mevcut bir türü farklı ve yalnızca statik bir arayüzle "saran" bir derleme zamanı soyutlamasıdır. Gerçek bir sarmalayıcının maliyetine katlanmadan mevcut bir türün arayüzünü kolayca değiştirebildikleri için (her tür birlikte çalışabilirlik için kritik) statik JS interop'un temel bileşenlerinden biridir.

Extension type'lar, temsil türü (representation type) adı verilen alttaki bir türün nesnelerinin kullanabileceği işlemler kümesine (veya arayüze) disiplin getirir. Bir extension type'ın arayüzünü tanımlarken temsil türünün bazı üyelerini yeniden kullanmayı, bazılarını atlamayı, bazılarını değiştirmeyi ve yeni işlevler eklemeyi seçebilirsiniz.

Aşağıdaki örnek, yalnızca kimlik numaraları için anlamlı olan işlemlere izin veren bir extension type oluşturmak için `int` türünü sarar:

```dart
extension type IdNumber(int id) {
  // Wraps the 'int' type's '<' operator:
  bool operator <(IdNumber other) => id < other.id;
  // Doesn't declare the '+' operator, for example,
  // because addition does not make sense for ID numbers.
}

void main() {
  // Without the discipline of an extension type,
  // 'int' exposes ID numbers to unsafe operations:
  int myUnsafeId = 42424242;
  myUnsafeId = myUnsafeId + 10; // This works, but shouldn't be allowed!

  var safeId = IdNumber(42424242);
  // safeId + 10 // Compile-time error: No '+' operator.
  // myUnsafeId = safeId; // Compile-time error: Wrong type.
  myUnsafeId = safeId as int; // OK: Run-time cast to representation type.
  safeId < IdNumber(42424241); // OK: Uses wrapped '<' operator.
}
```

> **Not**
> Extension type'lar, sarmalayıcı (wrapper) sınıflarla aynı amaca hizmet eder, ancak çok sayıda nesneyi sarmanız gerektiğinde pahalıya mal olabilen ek bir çalışma zamanı nesnesi oluşturulmasını gerektirmez. Extension type'lar yalnızca statik olduğu ve çalışma zamanında derlenip ortadan kalktığı için esasen sıfır maliyetlidir.
> 
> Extension method'lar (kısaca "extension'lar" olarak da bilinir), extension type'lara benzer statik bir soyutlamadır. Ancak bir extension method, alttaki türünün her örneğine doğrudan işlevsellik ekler. Extension type'lar ise farklıdır; bir extension type'ın arayüzü yalnızca statik türü o extension type olan ifadelere uygulanır. Varsayılan olarak alttaki türlerinin arayüzünden ayrıdırlar.

## Söz dizimi

### Bildirim

`extension type` bildirimi ve bir adla yeni bir extension type tanımlayın, ardından parantez içinde temsil türü bildirimini yazın:

```dart
extension type E(int i) {
  // Define set of operations.
}
```

`(int i)` temsil türü bildirimi, extension type `E`'nin alttaki türünün `int` olduğunu ve temsil nesnesine yapılan başvurunun adının `i` olduğunu belirtir. Bildirim ayrıca şunları da tanıtır:
* Dönüş türü temsil türü olan, temsil nesnesi için örtük bir getter: `int get i`
* Örtük bir constructor: `E(int i) : i = i`

Temsil getter'ı, alttaki tür olarak türlenmiş temsil nesnesine erişim sağlar. Getter, extension type gövdesinde kapsam içindedir ve ona diğer getter'lar gibi adıyla erişebilirsiniz:
* Extension type gövdesi içinde `i` (veya `this.i`) kullanarak.
* Dışarıda, `e.i` ile özellik çıkarımı yaparak (`e`'nin statik türü extension type olduğunda).

Extension type bildirimleri de sınıflar veya extension'lar gibi tür parametreleri içerebilir:

```dart
extension type E<T>(List<T> elements) {
  // ...
}
```

### Constructor'lar

İsteğe bağlı olarak bir extension type'ın gövdesinde constructor'lar bildirebilirsiniz. Temsil bildiriminin kendisi örtük bir constructor'dır, bu yüzden varsayılan olarak extension type için adsız bir constructor'ın yerini alır. Yönlendirme yapmayan her ek üretken constructor'lar, temsil nesnesinin örnek değişkenini kendi initializer list'inde veya biçimsel parametrelerinde `this.i` kullanarak başlatmalıdır.

```dart
extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;
}

void main() {
  E(4); // Implicit unnamed constructor.
  E.n(3); // Named constructor.
  E.m(5, "Hello!"); // Named constructor with additional parameters.
}
```

Ya da temsil bildirimini constructor olarak adlandırabilirsiniz; bu durumda gövdede adsız bir constructor için yer açılır:

```dart
extension type const E._(int it) {
  E() : this._(42);
  E.otherName(this.it);
}

void main2() {
  E();
  const E._(2);
  E.otherName(3);
}
```

Yeni bir constructor tanımlamak yerine, sınıflardaki aynı private constructor söz dizimini (`_`) kullanarak onu tamamen de gizleyebilirsiniz. Örneğin, alttaki tür `int` olsa bile istemcilerin `E`'yi yalnızca bir `String` ile oluşturmasını istiyorsanız:

```dart
extension type E._(int i) {
  E.fromString(String foo) : i = int.parse(foo);
}
```

Ayrıca yönlendiren üretken constructor'lar veya factory constructor'lar da bildirebilirsiniz (bunlar alt extension type'ların constructor'larına da yönlendirebilir).

### Üyeler

Bir extension type'ın arayüzünü tanımlamak için, gövdesinde üyeleri sınıf üyelerinde yaptığınız gibi bildirin. Extension type üyeleri yöntemler, getter'lar, setter'lar veya operatörler olabilir (`external` olmayan örnek değişkenlerine ve soyut üyelere izin verilmez):

```dart
extension type NumberE(int value) {
  // Operator:
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);
  
  // Getter:
  NumberE get myNum => this;
  
  // Method:
  bool isValid() => !value.isNegative;
}
```

Temsil türünün arayüz üyeleri varsayılan olarak extension type'ın arayüz üyeleri değildir. Temsil türünün tek bir üyesini extension type'ta kullanılabilir kılmak için, `NumberE`'deki `operator +` gibi, extension type tanımında onun için bir bildirim yazmanız gerekir. Temsil türüyle ilgisi olmayan yeni üyeler de tanımlayabilirsiniz; örneğin `i` getter'ı ve `isValid` yöntemi gibi.

### Implements

İsteğe bağlı olarak `implements` yan tümcesini şunlar için kullanabilirsiniz:
* Bir extension type üzerinde alt tür ilişkisi kurmak, VE
* Temsil nesnesinin üyelerini extension type arayüzüne eklemek.

`implements` yan tümcesi, bir extension method ile onun `on` türü arasındakine benzer bir uygulanabilirlik ilişkisi kurar. Üst türe uygulanabilen üyeler, alt türde aynı üye adına sahip bir bildirim olmadığı sürece alt türe de uygulanabilir.

Bir extension type yalnızca şunları uygulayabilir:
* **Kendi temsil türü.** Bu, temsil türünün tüm üyelerini örtük olarak extension type'ta kullanılabilir kılar.
  ```dart
  extension type NumberI(int i) implements int {
    // 'NumberI' can invoke all members of 'int',
    // plus anything else it declares here.
  }
  ```
* **Temsil türünün bir üst türü.** Bu, temsil türünün tüm üyelerini olmasa da üst türün üyelerini kullanılabilir kılar.
  ```dart
  extension type Sequence<T>(List<T> _) implements Iterable<T> {
    // Better operations than List.
  }

  extension type Id(int _id) implements Object {
    // Makes the extension type non-nullable.
    static Id? tryParse(String source) => int.tryParse(source) as Id?;
  }
  ```
* **Aynı temsil türü üzerinde geçerli olan başka bir extension type.** Bu, işlemleri birden fazla extension type arasında yeniden kullanmanızı sağlar (çoklu kalıtıma benzer şekilde).
  ```dart
  extension type const Opt<T>._(({T value})? _) {
    const factory Opt(T value) = Val<T>;
    const factory Opt.none() = Non<T>;
  }

  extension type const Val<T>._(({T value}) _) implements Opt<T> {
    const Val(T value) : this._((value: value));
    T get value => _.value;
  }

  extension type const Non<T>._(Null _) implements Opt<Never> {
    const Non() : this._(null);
  }
  ```

`implements`'in farklı senaryolardaki etkisi hakkında daha fazla bilgi için Kullanım bölümünü okuyun.

### @redeclare

Bir üst türün üyesiyle aynı adı taşıyan bir extension type üyesi bildirmek, sınıflar arasındaki gibi bir geçersiz kılma (override) ilişkisi değil, yeniden bildirimdir (redeclaration). Bir extension type üye bildirimi, aynı ada sahip her üst tür üyesinin yerini tamamen alır. Aynı işlev için alternatif bir uygulama sağlamak mümkün değildir.

Bir üst tür üyesiyle aynı adı bilerek kullandığınızı derleyiciye bildirmek için `package:meta`'daki `@redeclare` annotation'ını kullanabilirsiniz. Bu aslında doğru değilse, örneğin adlardan biri yanlış yazılmışsa, analyzer sizi uyarır.

```dart
import 'package:meta/meta.dart';

extension type MyString(String) implements String {
  // Replaces 'String.operator[]'.
  @redeclare
  int operator [](int index) => codeUnitAt(index);
}
```

Bir üst arayüz üyesini gizleyen ve `@redeclare` ile işaretlenmemiş bir extension type yöntemi bildirdiğinizde uyarı almak için `annotate_redeclares` lint'ini de etkinleştirebilirsiniz.

## Kullanım

Bir extension type kullanmak için, bir sınıfta yaptığınız gibi bir constructor çağırarak örnek oluşturun:

```dart
extension type NumberE(int value) {
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);

  NumberE get next => NumberE(value + 1);
  bool isValid() => !value.isNegative;
}

void testE() {
  var num = NumberE(1);
}
```

Ardından nesne üzerinde, bir sınıf nesnesinde olduğu gibi üyeleri çağırabilirsiniz.

Extension type'lar için eşit derecede geçerli ancak birbirinden oldukça farklı iki temel kullanım senaryosu vardır:
1. Mevcut bir türe genişletilmiş bir arayüz sağlamak.
2. Mevcut bir türe farklı bir arayüz sağlamak.

> **Not**
> Her durumda, bir extension type'ın temsil türü asla onun alt türü değildir; bu yüzden extension type gereken yerde temsil türü onun yerine kullanılamaz.

### 1. Mevcut bir türe genişletilmiş bir arayüz sağlama

Bir extension type temsil türünü uyguladığında, onu "şeffaf" olarak düşünebilirsiniz, çünkü extension type'ın alttaki türü "görmesine" olanak tanır.

Şeffaf bir extension type, temsil türünün (yeniden bildirilmemiş) tüm üyelerini ve kendi tanımladığı yardımcı üyeleri çağırabilir. Bu, mevcut bir tür için yeni, genişletilmiş bir arayüz oluşturur. Yeni arayüz, statik türü extension type olan ifadeler için kullanılabilir.

Bu, (şeffaf olmayan bir extension type'ın aksine) temsil türünün üyelerini şöyle çağırabileceğiniz anlamına gelir:

```dart
extension type NumberT(int value) implements int {
  // Doesn't explicitly declare any members of 'int'.
  NumberT get i => this;
}

void main() {
  // All OK: Transparency allows invoking int members on the extension type:
  var v1 = NumberT(1); // v1 type: NumberT
  int v2 = NumberT(2); // v2 type: int
  var v3 = v1.i - v1;  // v3 type: int
  var v4 = v2 + v1;    // v4 type: int
  var v5 = 2 + v1;     // v5 type: int
  // Error: Extension type interface is not available to representation type
  // v2.i;
}
```

Üst türden belirli bir üye adını yeniden bildirerek yeni üyeler ekleyen ve diğerlerini uyarlayan "çoğunlukla şeffaf" bir extension type da oluşturabilirsiniz. Bu, örneğin bir yöntemin bazı parametrelerinde daha katı türler veya farklı varsayılan değerler kullanmanıza olanak tanır.

Çoğunlukla şeffaf bir başka extension type yaklaşımı, temsil türünün üst türü olan bir türü uygulamaktır. Örneğin temsil türü private olduğunda, ancak üst türü arayüzün istemciler için önemli olan kısmını tanımladığında.

### 2. Mevcut bir türe farklı bir arayüz sağlama

Şeffaf olmayan (temsil türünü `implement` etmeyen) bir extension type, statik olarak temsil türünden ayrı, tamamen yeni bir tür olarak ele alınır. Onu temsil türüne atayamazsınız ve temsil türünün üyelerini açığa çıkarmaz.

Örneğin Kullanım bölümünde bildirdiğimiz `NumberE` extension type'ını ele alalım:

```dart
void testE() {
  var num1 = NumberE(1);
  // int num2 = NumberE(2); // Error: Can't assign 'NumberE' to 'int'.
  
  num1.isValid(); // OK: Extension member invocation.
  // num1.isNegative(); // Error: 'NumberE' does not define 'int' member 'isNegative'.
  
  var sum1 = num1 + num1; // OK: 'NumberE' defines '+'.
  // var diff1 = num1 - num1; // Error: 'NumberE' does not define 'int' member '-'.
  var diff2 = num1.value - 2; // OK: Can access representation object with reference.
  // var sum2 = num1 + 2; // Error: Can't assign 'int' to parameter type 'NumberE'.
  
  List<NumberE> numbers = [
    NumberE(1),
    num1.next, // OK: 'next' getter returns type 'NumberE'.
    // 1, // Error: Can't assign 'int' element to list type 'NumberE'.
  ];
}
```

Bir extension type'ı bu şekilde mevcut bir türün arayüzünü değiştirmek için kullanabilirsiniz. Bu, yeni türünüzün kısıtlamalarına uygun bir arayüz modellemenizi sağlarken (girişteki `IdNumber` örneği gibi), `int` gibi basit, önceden tanımlı bir türün performansından ve kolaylığından da yararlanmanızı sağlar.

Bu kullanım, bir sarmalayıcı sınıfın tam kapsüllemesine ulaşabileceğiniz en yakın noktadır (ancak gerçekçi olarak yalnızca kısmen korunan bir soyutlamadır).

## Tür değerlendirmeleri

Extension type'lar derleme zamanında sarmalama yapan bir yapıdır. Çalışma zamanında extension type'ın hiçbir izi kalmaz. Her tür sorgusu veya benzeri çalışma zamanı işlemi temsil türü üzerinde çalışır.

Bu, extension type'ları güvensiz bir soyutlama yapar, çünkü çalışma zamanında temsil türünü her zaman öğrenebilir ve alttaki nesneye erişebilirsiniz.

Dinamik tür testleri (`e is T`), tür dönüşümleri (`e as T`) ve diğer çalışma zamanı tür sorguları (`switch (e)` veya `if (e case...)` gibi) alttaki temsil nesnesi üzerinden değerlendirilir ve o nesnenin çalışma zamanı türüne göre tür denetimi yapar. Bu, `e`'nin statik türü bir extension type olduğunda da, bir extension type'a karşı test yapılırken de geçerlidir (`case MyExtensionType():` gibi).

```dart
void main() {
  var n = NumberE(1);

  // The run-time type of 'n' is the representation type 'int'.
  if (n is int) print(n); // Prints 1.

  // Can use 'int' methods on 'n' at run time.
  if (n case int x) print(x.toRadixString(10)); // Prints 1.
  
  switch (n) {
    case int(:var isEven): 
      print("$n (${isEven ? "even" : "odd"})"); // Prints 1 (odd).
  }
}
```

Benzer şekilde, bu örnekte eşleşen değerin statik türü extension type'ın türüdür:

```dart
void main() {
  int i = 2;
  
  if (i is NumberE) print("It is"); // Prints 'It is'.
  if (i case NumberE v) print("value: ${v.value}"); // Prints 'value: 2'.
  
  switch (i) {
    case NumberE(:var value): 
      print("value: $value"); // Prints 'value: 2'.
  }
}
```

`i` bir tür dönüşümü veya desen eşleşmesi sonucunda `NumberE` statik türünü aldığında, `i` hâlâ aynı nesneyi ifade eder, `v` de `i` ile aynı nesneyi ifade eder ve nesnenin kendisi değişmez. Değişen yalnızca statik türdür (ve dolayısıyla bu nesne üzerinde çağırabileceğimiz yöntemler). Özellikle, tür değişikliği bir constructor çağrısı içermez. Bir constructor çalıştırmak istiyorsanız (örneğin bir tür doğrulama yapmak için) açık bir constructor çağrısı yazmanız gerekir (örneğin `NumberE(i)`).

Extension type'lar kullanırken bu davranışın farkında olmak önemlidir. Bir extension type'ın derleme zamanında var olduğunu ve önem taşıdığını, ancak derleme sırasında silindiğini her zaman aklınızda tutun.

Örneğin statik türü extension type `E` olan bir `e` ifadesini ele alalım. `E`'nin temsil türünün `R` olduğunu varsayalım. Bu durumda `e`'nin değerinin çalışma zamanı türü `R`'in bir alt türüdür. Türün kendisi bile silinir; çalışma zamanında `List<E>`, `List<R>` ile tamamen aynı şeydir.

Başka bir deyişle, gerçek bir sarmalayıcı sınıf sarılan nesneyi kapsülleyebilirken, bir extension type sarılan nesne üzerinde yalnızca derleme zamanında var olan bir görünümdür. Gerçek bir sarmalayıcı daha güvenli olsa da, bunun karşılığında extension type'lar sarmalayıcı nesnelerden kaçınma seçeneği sunar; bu da bazı senaryolarda performansı büyük ölçüde artırabilir.
# Çağrılabilir nesneler (Callable objects)

Dart'ta çağrılabilir nesnelerin nasıl oluşturulup kullanılacağını öğrenin.

Dart sınıfınızın bir örneğinin işlev gibi çağrılabilmesi için `call()` yöntemini uygulayın.

`call()` yöntemi, onu tanımlayan herhangi bir sınıfın örneğinin bir işlevi taklit etmesini sağlar. Bu yöntem, parametreler ve dönüş türleri gibi normal işlevlerle aynı özellikleri destekler.

Aşağıdaki örnekte `WannabeFunction` sınıfı, üç string alıp aralarına birer boşluk koyarak birleştiren ve sonuna ünlem ekleyen bir `call()` işlevi tanımlar. 

```dart
class WannabeFunction {
  String call(String a, String b, String c) => '$a $b $c!';
}

var wannabe = WannabeFunction();
var out = wannabe('Hi', 'there,', 'gang');

void main() => print(out);
```
# Sınıf değiştiricileri (Class modifiers)

Harici kütüphane erişimini denetlemek için sınıf bildirimlerinde kullanılan değiştirici anahtar sözcükler.

> **Sürüm notu:** `abstract` dışındaki sınıf değiştiricileri en az 3.0 dil sürümü gerektirir.

Sınıf değiştiricileri, bir sınıfın veya mixin'in hem kendi kütüphanesi içinden hem de tanımlandığı kütüphanenin dışından nasıl kullanılabileceğini denetler.

Değiştirici anahtar sözcükler bir sınıf veya mixin bildiriminden önce gelir. Örneğin `abstract class` yazmak soyut bir sınıf tanımlar. Bir sınıf bildiriminden önce gelebilecek değiştiricilerin tam listesi şunlardır:

*   `abstract`
*   `base`
*   `final`
*   `interface`
*   `sealed`
*   `mixin`

Bir mixin bildiriminden önce yalnızca `base` değiştiricisi gelebilir. Değiştiriciler `enum`, `typedef`, `extension` veya `extension type` gibi diğer bildirimlere uygulanmaz.

Sınıf değiştiricilerini kullanıp kullanmamaya karar verirken, sınıfın amaçlanan kullanımlarını ve sınıfın hangi davranışlara güvenebilmesi gerektiğini düşünün.

## Değiştirici yok

Herhangi bir kütüphaneden sınırsız olarak örnek oluşturmaya veya alt tür türetmeye izin vermek için değiştiricisiz bir `class` veya `mixin` bildirimi kullanın. Varsayılan olarak şunları yapabilirsiniz:

*   Bir sınıfın yeni örneklerini oluşturmak.
*   Yeni bir alt tür oluşturmak için bir sınıfı genişletmek.
*   Bir sınıfın veya mixin'in arayüzünü uygulamak.
*   Bir mixin'i veya mixin sınıfını mixin olarak eklemek.

## abstract

Arayüzünün tamamının eksiksiz, somut bir uygulamasını gerektirmeyen bir sınıf tanımlamak için `abstract` değiştiricisini kullanın.

Soyut sınıflar, ister kendi kütüphanesinden ister dış bir kütüphaneden olsun, hiçbir kütüphaneden örneklenemez. Soyut sınıfların genellikle soyut yöntemleri vardır.

**a.dart**
```dart
abstract class Vehicle {
  void moveForward(int meters);
}
```

**b.dart**
```dart
import 'a.dart';

// Error: 'Vehicle' can't be instantiated because it is marked as 'abstract'.
Vehicle myVehicle = Vehicle();

// Can be extended.
class Car extends Vehicle {
  int passengers = 4;
  
  @override
  void moveForward(int meters) {
    // ...
  }
}

// Can be implemented.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
```

Soyut sınıfınızın örneklenebilir gibi görünmesini istiyorsanız bir factory constructor tanımlayın.

## base

Bir sınıfın veya mixin'in uygulamasının miras alınmasını zorunlu kılmak için `base` değiştiricisini kullanın. Bir base sınıf, kendi kütüphanesi dışında uygulanmaya (implement) izin vermez. Bu şunları garanti eder:

*   Sınıfın bir alt türünün örneği oluşturulduğunda base sınıfın constructor'ı her zaman çağrılır.
*   Uygulanmış tüm private üyeler alt türlerde de bulunur.
*   Bir base sınıfına yeni uygulanmış bir üye eklemek alt türleri bozmaz, çünkü tüm alt türler yeni üyeyi miras alır (uyumsuz bir imza bildirilmediği sürece).

Bir base sınıfı uygulayan veya genişleten her sınıfı `base`, `final` veya `sealed` olarak işaretlemelisiniz.

**a.dart**
```dart
base class Vehicle {
  void moveForward(int meters) {
    // ...
  }
}
```

**b.dart**
```dart
import 'a.dart';

// Can be constructed.
Vehicle myVehicle = Vehicle();

// Can be extended.
base class Car extends Vehicle {
  int passengers = 4;
}

// ERROR: 'Vehicle' can't be implemented in a different library.
base class MockVehicle implements Vehicle {
  @override
  void moveForward() {
    // ...
  }
}
```

## interface

Bir arayüz tanımlamak için `interface` değiştiricisini kullanın. Arayüzün tanımlandığı kütüphanenin dışındaki kütüphaneler arayüzü uygulayabilir ama genişletemez.

**a.dart**
```dart
interface class Vehicle {
  void moveForward(int meters) {
    // ...
  }
}
```

**b.dart**
```dart
import 'a.dart';

// Can be constructed.
Vehicle myVehicle = Vehicle();

// ERROR: 'Vehicle' can't be extended in a different library.
class Car extends Vehicle {
  int passengers = 4;
}

// Can be implemented.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
```

## abstract interface

`interface` değiştiricisinin en yaygın kullanımı saf bir arayüz tanımlamaktır. Bir `abstract interface class` için `interface` ve `abstract` değiştiricilerini birleştirin.

## final

Tür hiyerarşisini kapatmak için `final` değiştiricisini kullanın. Bu, mevcut kütüphanenin dışındaki bir sınıftan alt tür türetilmesini önler. `final` sınıflar aynı kütüphane içinde genişletilebilir veya uygulanabilir. Tüm alt sınıflar da `base`, `final` veya `sealed` olarak işaretlenmelidir.

**a.dart**
```dart
final class Vehicle {
  void moveForward(int meters) {
    // ...
  }
}
```

**b.dart**
```dart
import 'a.dart';

// Can be constructed.
Vehicle myVehicle = Vehicle();

// ERROR: 'Vehicle' can't be extended in a different library.
class Car extends Vehicle {
  int passengers = 4;
}

// ERROR: 'Vehicle' can't be implemented in a different library.
class MockVehicle implements Vehicle {
  @override
  void moveForward(int meters) {
    // ...
  }
}
```

## sealed

Bilinen, sayılabilir bir alt türler kümesi oluşturmak için `sealed` değiştiricisini kullanın. Bu, statik olarak eksiksiz (exhaustive) olduğu garanti edilen bir switch oluşturmanızı sağlar. `sealed` değiştiricisi bir sınıfın kendi kütüphanesi dışında genişletilmesini veya uygulanmasını önler. Örtük olarak soyutturlar.

```dart
sealed class Vehicle {}

class Car extends Vehicle {}
class Truck implements Vehicle {}
class Bicycle extends Vehicle {}

// ERROR: 'Vehicle' can't be instantiated.
Vehicle myVehicle = Vehicle();

// Subclasses can be instantiated.
Vehicle myCar = Car();

extension VehicleSounds on Vehicle {
  String get sound {
    // ERROR: The switch does not exhaustively account for all types.
    return switch (this) {
      Car() => 'vroom',
      Truck() => 'VROOOOMM',
    };
  }
}
```

## Değiştiricileri birleştirme

Katmanlı kısıtlamalar için bazı değiştiricileri birleştirebilirsiniz. Bir sınıf bildirimi sırasıyla şunlardan oluşabilir:
1. `abstract`
2. `base`, `interface`, `final` veya `sealed`
3. `mixin`
4. `class`
# API bakımcıları için sınıf değiştiricileri

Paketinizin API'sini daha sağlam ve bakımı kolay hale getirmek için Dart 3.0'da eklenen sınıf değiştiricilerini nasıl kullanacağınız.

Dart 3.0, sınıf ve mixin bildirimlerine ekleyebileceğiniz birkaç yeni değiştirici getirir. Bir kütüphane paketinin yazarıysanız, bu değiştiriciler kullanıcıların paketinizin dışa aktardığı türlerle neler yapabileceği üzerinde size daha fazla kontrol sağlar.

## Sınıflarda mixin değiştiricisi

Farkında olunması gereken en önemli değiştirici `mixin`'dir. Dart 3.0, varsayılan olarak sınıfların mixin'ler olarak kullanılmasına izin vermez. Bunun yerine, bir `mixin class` bildirerek bu davranışı açıkça seçmeniz gerekir:

```dart
mixin class Both {}

class UseAsMixin with Both {}
class UseAsSuperclass extends Both {}
```

## interface değiştiricisi

Sınıfa `interface` değiştiricisini koyarak bunun bir arayüz olduğunu netleştirebilirsiniz. Bu, sınıfın bir `implements` yan tümcesinde kullanılmasına izin verir, ancak `extends` yan tümcesinde kullanılmasını engeller.

## base değiştiricisi

`base` değiştiricisi bir bakıma `interface`'in tersidir. Sınıfı bir `extends` yan tümcesinde kullanmanıza veya bir mixin'i ya da mixin sınıfını bir `with` yan tümcesinde kullanmanıza izin verir. Ancak sınıfın kütüphanesi dışındaki kodun sınıfı veya mixin'i bir `implements` yan tümcesinde kullanmasına izin vermez.

**a.dart**
```dart
class A {
  void _privateMethod() {
    print('I inherited from A');
  }
}

void callPrivateMethod(A a) {
  a._privateMethod();
}
```

**b.dart**
```dart
import 'a.dart';

class B implements A {
  // No implementation of _privateMethod()!
}

main() {
  callPrivateMethod(B()); // Runtime exception!
}
```
Sınıfa `base` değiştiricisini eklemek bu çalışma zamanı hatalarını önlemeye yardımcı olabilir.

## final değiştiricisi

Hem `interface` hem de `base`'in tüm kısıtlamalarını istiyorsanız, bir sınıfı veya mixin sınıfını `final` olarak işaretleyebilirsiniz. Bu, kütüphanenizin dışındaki hiç kimsenin ondan herhangi bir alt tür oluşturmasını engeller (`implements`, `extends`, `with`).

## sealed değiştiricisi

Son değiştirici olan `sealed` özeldir. Esas olarak desen eşleştirmede eksiksizlik denetimini mümkün kılmak için vardır. 

```dart
sealed class Amigo {}

class Lucky extends Amigo {}
class Dusty extends Amigo {}
class Ned extends Amigo {}

String lastName(Amigo amigo) => switch (amigo) {
  Lucky() => 'Day',
  Dusty() => 'Bottoms',
  Ned() => 'Nederlander',
};
```

Bunun sağlam olması için derleyici iki kısıtlama uygular:
1. Sealed sınıfın kendisi doğrudan örneklenemez (örtük olarak abstract'tır).
2. Sealed türün her doğrudan alt türü, sealed türün bildirildiği kütüphanede olmalıdır.

## sealed ve final karşılaştırması

*   Kullanıcıların doğrudan alt tür türetmesini istemediğiniz bir sınıfınız varsa, ne zaman `sealed`, ne zaman `final` kullanmalısınız?
*   Kullanıcıların sınıfın örneklerini doğrudan oluşturabilmesini istiyorsanız `sealed` kullanamazsınız.
*   Sınıfın kütüphanenizde alt türü yoksa `sealed` kullanmanın bir anlamı yoktur.
*   Yeni alt türleri uyumu bozmadan ekleme özgürlüğü istiyorsanız, üst türü `sealed` yerine `final` ile işaretlemeniz daha iyidir.
# Sınıf değiştiricileri başvurusu

Sınıf değiştiricilerinin izin verilen ve verilmeyen birleşimleri. Bu sayfa sınıf değiştiricileri için başvuru bilgileri içerir.

## Geçerli birleşimler

Sınıf değiştiricilerinin geçerli birleşimleri ve bunların sonucunda ortaya çıkan yetenekler şunlardır:

| Bildirim | Örnekle? | Genişlet? | Uygula? | Mixin? | Exhaustive? | 
| ----- | ----- | ----- | ----- | ----- | ----- | 
| `class` | Evet | Evet | Evet | Hayır | Hayır | 
| `base class` | Evet | Evet | Hayır | Hayır | Hayır | 
| `interface class` | Evet | Hayır | Evet | Hayır | Hayır | 
| `final class` | Evet | Hayır | Hayır | Hayır | Hayır | 
| `sealed class` | Hayır | Hayır | Hayır | Hayır | Evet | 
| `abstract class` | Hayır | Evet | Evet | Hayır | Hayır | 
| `abstract base class` | Hayır | Evet | Hayır | Hayır | Hayır | 
| `abstract interface class` | Hayır | Hayır | Evet | Hayır | Hayır | 
| `abstract final class` | Hayır | Hayır | Hayır | Hayır | Hayır | 
| `mixin class` | Evet | Evet | Evet | Evet | Hayır | 
| `base mixin class` | Evet | Evet | Hayır | Evet | Hayır | 
| `abstract mixin class` | Hayır | Evet | Evet | Evet | Hayır | 
| `abstract base mixin class` | Hayır | Evet | Hayır | Evet | Hayır | 
| `mixin` | Hayır | Hayır | Evet | Evet | Hayır | 
| `base mixin` | Hayır | Hayır | Hayır | Evet | Hayır | 

## Geçersiz birleşimler

Değiştiricilerin bazı birleşimlerine izin verilmez:

| Birleşim | Gerekçe | 
| ----- | ----- | 
| `base`, `interface` ve `final` | Hepsi aynı iki yeteneği (extend ve implement) denetler, bu yüzden birbirini dışlar. | 
| `sealed` ve `abstract` | İkisi de örneklenemez; birlikte gereksizdir. | 
| `base`, `interface` veya `final` ile `sealed` | `sealed` türler zaten başka bir kütüphaneden mixin olarak eklenemez, genişletilemez veya uygulanamaz; bu yüzden listelenen değiştiricilerle birleştirmek gereksizdir. | 
| `mixin` ve `abstract` | İkisi de örneklenemez; birlikte gereksizdir. | 
| `mixin` ile `final`, `interface` veya `sealed` | Bir mixin veya mixin class bildirimi mixin olarak eklenmek üzere tasarlanmıştır; listelenen değiştiriciler ise bunu engeller. | 
| `enum` ve herhangi bir değiştirici | `enum` bildirimleri genişletilemez, uygulanamaz, mixin olarak eklenemez ve her zaman örneklenebilir; bu yüzden `enum` bildirimlerine hiçbir değiştirici uygulanmaz. | 
| `extension type` ve herhangi bir değiştirici | `extension type` bildirimleri genişletilemez veya mixin olarak eklenemez ve yalnızca başka `extension type` bildirimleri tarafından uygulanabilir. | 
