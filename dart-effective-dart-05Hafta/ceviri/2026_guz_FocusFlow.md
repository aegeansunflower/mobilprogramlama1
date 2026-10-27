Uyarı: Bu içerik, SCÜ Şarkışla UBYO Mobil Programlama I dersi kapsamında tamamen eğitim amaçlı çevrilmiş ve derlenmiştir. Orijinal dokümantasyon kaynakları (dart.dev, docs.flutter.dev) kendi orijinal lisanslarına (BSD-3-Clause, CC-BY 4.0) tabidir. Bu çalışmanın hiçbir ticari amacı yoktur.

# Effective Dart (Türkçe)

**Çeviren:** Yusuf Gökali / Ufuk Alparslan / Hüseyin Özcan / İbrahim Arslan 
**Kaynak:** dart.dev/effective-dart (Dart ekibi)  
**Lisans:** Metin CC BY 4.0, kod örnekleri BSD-3-Clause.

---

# Effective Dart: Giriş

Son birkaç yılda çok miktarda Dart kodu yazdık ve neyin iyi çalışıp neyin çalışmadığı hakkında çok şey öğrendik. Bunu sizinle paylaşıyoruz; böylece siz de tutarlı, sağlam ve hızlı kod yazabilirsiniz. Bunun altında yatan iki temel tema vardır:

1. **Tutarlı olun.** Biçimlendirme ve büyük/küçük harf kullanımı gibi konularda hangisinin daha iyi olduğu üzerine tartışmalar öznel olduğundan çözülemez. Bildiğimiz şey ise *tutarlılığın* nesnel olarak faydalı olduğudur. İki kod parçası farklı görünüyorsa, bu ancak anlamlı bir şekilde *gerçekten farklı* oldukları için olmalıdır. Kodun bir parçası dikkat çekiyorsa, bunun nedeni faydalı bir sebep olmalıdır.
2. **Özlü olun.** Dart, tanıdık olacak şekilde tasarlandı; bu yüzden C, Java, JavaScript ve diğer dillerdeki birçok ifadeyi ve deyimi miras aldı. Ancak Dart'ı, bu dillerin sunduklarını geliştirmek için geniş bir alan olduğu için oluşturduk. Niyetinizi daha basit ve kolay ifade etmenize yardımcı olmak için, string interpolation'dan başlatıcı parametrelere (initializing formals) kadar çok sayıda özellik ekledik. Bir şeyi ifade etmenin birden fazla yolu varsa, genellikle en kısa olanını seçmelisiniz. Bu, tüm bir programı tek satıra sığdırmak için kodu bir bulmacaya çevirmeniz gerektiği anlamına gelmez. Hedef, *ekonomik* ama *yoğun* olmayan koddur.

## Rehberler

Yönergeleri, kolay sindirilebilmesi için birkaç ayrı sayfaya böldük:

- **Stil Rehberi** – Kodun düzenlenmesi ve organize edilmesi için kuralları tanımlar; ya da en azından `dart format`'ın sizin için otomatik olarak yapmadığı kısımları. Stil rehberi ayrıca tanımlayıcıların nasıl biçimlendirileceğini de belirler: `camelCase`, `using_underscores` vb.
- **Dokümantasyon Rehberi** – Yorumların içinde ne olması gerektiği hakkında bilmeniz gereken her şeyi anlatır. Hem doc yorumları hem de sıradan kod yorumları.
- **Kullanım Rehberi** – Davranışı uygulamak için dil özelliklerinden en iyi şekilde nasıl yararlanacağınızı öğretir. Bir deyimde veya ifadede yer alan her şey burada ele alınır.
- **Tasarım Rehberi** – En yumuşak ama kapsamı en geniş olan rehberdir. Kütüphaneler için tutarlı ve kullanışlı API'ler tasarlamaya dair öğrendiklerimizi kapsar. Bir tür imzasında veya bildiriminde yer alan her şey bu rehberde incelenir.

Tüm yönergelere ait bağlantılar için özete bakın.

## Rehberlerin nasıl okunacağı

Her rehber birkaç bölüme ayrılmıştır. Bölümler, yönergelerin bir listesini içerir. Her yönerge şu kelimelerden biriyle başlar:

- **DO** yönergeleri her zaman izlenmesi gereken uygulamaları tanımlar. Bunlardan sapmak için neredeyse hiçbir zaman geçerli bir neden olmaz.
- **DON'T** yönergeleri tam tersidir: neredeyse hiçbir zaman iyi bir fikir olmayan şeyler. Umarız bu tür yönergelerimiz diğer dillerdeki kadar çok değildir, çünkü tarihsel bagajımız daha azdır.
- **PREFER** yönergeleri *izlemeniz gereken* uygulamalardır. Ancak bazı durumlarda farklı davranmak mantıklı olabilir. Böyle bir durumda, yönergeyi göz ardı etmenin tüm sonuçlarını anladığınızdan emin olun.
- **AVOID** yönergeleri "prefer"ın karşıtıdır: yapmamanız gereken, ancak nadiren iyi nedenlerle yapılabilecek şeyler.
- **CONSIDER** yönergeleri, koşullara, önceki örneklere ve kendi tercihinize bağlı olarak izlemek isteyebileceğiniz ya da istemeyebileceğiniz uygulamalardır.

Bazı yönergeler, kuralın *uygulanmadığı* bir **istisna** tanımlar. Listelendiğinde istisnalar kapsamlı olmayabilir; diğer durumlarda yine de kendi muhakemenizi kullanmanız gerekebilir.

Bu, bağcıklarınızı doğru bağlamazsanız polislerin kapınızı kıracağı gibi gelebilir. Durum o kadar kötü değil. Buradaki yönergelerin çoğu sağduyuya dayanır ve hepimiz makul insanlarız. Hedef, her zamanki gibi güzel, okunabilir ve sürdürülebilir kod yazmaktır.

Dart analyzer, bu ve diğer yönergeleri izleyen iyi ve tutarlı kod yazmanıza yardımcı olmak için bir linter sağlar. Bir yönergeyi izlemenize yardımcı olabilecek bir veya daha fazla linter kuralı varsa, yönerge bu kurallara bağlantı verir. Bağlantılar şu biçimi kullanır:

Linter kuralı: unnecessary_getters_setters

Linter'ı nasıl kullanacağınızı öğrenmek için Linter kurallarını etkinleştirme ve linter kuralları listesi sayfalarına bakın.

## Sözlük

Yönergeleri kısa tutmak için, farklı Dart yapılarına atıfta bulunmak üzere birkaç kısaltılmış terim kullanıyoruz.

- Bir **kütüphane üyesi**, üst düzey bir alan, getter, setter veya fonksiyondur. Temel olarak, tür olmayan üst düzeydeki her şeydir.
- Bir **sınıf üyesi**, bir sınıf içinde bildirilen bir constructor, alan, getter, setter, fonksiyon veya operatördür. Sınıf üyeleri örnek veya statik, soyut veya somut olabilir.
- Bir **üye**, bir kütüphane üyesi veya bir sınıf üyesidir.
- Genel anlamda kullanıldığında **değişken**, üst düzey değişkenleri, parametreleri ve yerel değişkenleri ifade eder. Statik veya örnek alanları kapsamaz.
- Bir **tür**, adlandırılmış herhangi bir tür bildirimidir: bir sınıf, typedef veya enum.
- Bir **özellik**, üst düzey bir değişken, getter (sınıf içinde ya da üst düzeyde, örnek veya statik), setter (aynı şekilde) veya alandır (örnek veya statik). Kabaca, "alan benzeri" herhangi bir adlandırılmış yapıdır.

## Tüm kuralların özeti

### Stil

**Tanımlayıcılar**

- **DO** türleri `UpperCamelCase` kullanarak adlandırın.
- **DO** extension'ları `UpperCamelCase` kullanarak adlandırın.
- **DO** paketleri, dizinleri ve kaynak dosyalarını `lowercase_with_underscores` kullanarak adlandırın.
- **DO** import öneklerini `lowercase_with_underscores` kullanarak adlandırın.
- **DO** diğer tanımlayıcıları `lowerCamelCase` kullanarak adlandırın.
- **PREFER** sabit adları için `lowerCamelCase` kullanın.
- **DO** iki harften uzun kısaltmaları ve akronimleri, kelimeler gibi, büyük harfle yazın.
- **PREFER** kullanılmayan callback parametreleri için joker karakterler kullanın.
- **DON'T** private olmayan tanımlayıcılar için baştaki alt çizgi kullanmayın.
- **DON'T** önek harfleri kullanmayın.
- **DON'T** kütüphaneleri açıkça adlandırmayın.

**Sıralama**

- **DO** `dart:` import'larını diğer import'lardan önce yerleştirin.
- **DO** `package:` import'larını göreli import'lardan önce yerleştirin.
- **DO** export'ları tüm import'lardan sonra, ayrı bir bölümde belirtin.
- **DO** bölümleri alfabetik olarak sıralayın.

**Biçimlendirme**

- **DO** kodunuzu `dart format` kullanarak biçimlendirin.
- **CONSIDER** kodunuzu biçimlendiriciye daha uygun hale getirmeyi değerlendirin.
- **PREFER** satırları 80 karakter veya daha az olacak şekilde tutun.
- **DO** tüm akış kontrol ifadeleri için süslü parantez kullanın.

### Dokümantasyon

**Yorumlar**

- **DO** yorumları cümle gibi biçimlendirin.
- **DON'T** dokümantasyon için blok yorumları kullanmayın.

**Doc yorumları**

- **DO** üyeleri ve türleri belgelemek için `///` doc yorumları kullanın.
- **PREFER** herkese açık API'ler için doc yorumları yazın.
- **CONSIDER** kütüphane düzeyinde bir doc yorumu yazmayı değerlendirin.
- **CONSIDER** özel API'ler için doc yorumları yazmayı değerlendirin.
- **DO** doc yorumlarını tek cümlelik bir özetle başlatın.
- **DO** bir doc yorumunun ilk cümlesini kendi paragrafına ayırın.
- **AVOID** çevresindeki bağlamla gereksiz tekrarlardan kaçının.
- **PREFER** ana amacı bir yan etki olan fonksiyon veya metodun yorumlarını üçüncü şahıs fiilleriyle başlatın.
- **PREFER** boolean olmayan bir değişken veya özellik yorumunu bir isim öbeğiyle başlatın.
- **PREFER** boolean bir değişken veya özellik yorumunu "Whether" kelimesiyle başlatın, ardından bir isim veya gerund öbeği gelsin.
- **PREFER** ana amacı bir değer döndürmek olan fonksiyon veya metot için isim öbeği ya da emir kipi olmayan fiil öbeği kullanın.
- **DON'T** bir özelliğin hem getter'ı hem de setter'ı için dokümantasyon yazmayın.
- **PREFER** kütüphane veya tür yorumlarını isim öbekleriyle başlatın.
- **CONSIDER** doc yorumlarına kod örnekleri eklemeyi değerlendirin.
- **DO** doc yorumlarında, kapsam içindeki tanımlayıcılara atıfta bulunmak için köşeli parantez kullanın.
- **DO** parametreleri, dönüş değerlerini ve istisnaları açıklamak için düz metin kullanın.
- **DO** doc yorumlarını metadata annotation'larından önce yerleştirin.

**Markdown**

- **AVOID** markdown'u aşırı kullanmaktan kaçının.
- **AVOID** biçimlendirme için HTML kullanmaktan kaçının.
- **PREFER** kod blokları için backtick çitleri kullanın.

**Yazım**

- **PREFER** özlü yazın.
- **AVOID** açık olmadıkça kısaltmalardan ve akronimlerden kaçının.
- **PREFER** bir üyenin örneğine atıfta bulunurken "the" yerine "this" kullanın.

### Kullanım

**Kütüphaneler**

- **DO** `part of` yönergelerinde string kullanın.
- **DON'T** başka bir paketin `src` dizini içindeki kütüphaneleri import etmeyin.
- **DON'T** bir import yolunun `lib` içine veya dışına ulaşmasına izin vermeyin.
- **PREFER** göreli import yollarını kullanın.

**Null**

- **DON'T** değişkenleri açıkça `null` ile başlatmayın.
- **DON'T** açık bir varsayılan değer olarak `null` kullanmayın.
- **DON'T** eşitlik işlemlerinde `true` veya `false` kullanmayın.
- **AVOID** başlatılıp başlatılmadığını kontrol etmeniz gerekiyorsa `late` değişkenlerden kaçının.
- **CONSIDER** nullable türleri kullanmak için tip yükseltme (type promotion) veya null kontrol desenlerini değerlendirin.

**String'ler**

- **DO** string literal'lerini birleştirmek için bitişik string'ler kullanın.
- **PREFER** string'leri ve değerleri birleştirmek için interpolation kullanın.
- **AVOID** gerekmediğinde interpolation içinde süslü parantez kullanmaktan kaçının.

**Koleksiyonlar**

- **DO** mümkün olduğunda koleksiyon literal'leri kullanın.
- **DON'T** bir koleksiyonun boş olup olmadığını kontrol etmek için `.length` kullanmayın.
- **AVOID** bir fonksiyon literal'i ile `Iterable.forEach()` kullanmaktan kaçının.
- **DON'T** sonucun türünü değiştirmek istemiyorsanız `List.from()` kullanmayın.
- **DO** bir koleksiyonu türüne göre filtrelemek için `whereType()` kullanın.
- **DON'T** yakındaki bir işlem yeterli olduğunda `cast()` kullanmayın.
- **AVOID** `cast()` kullanmaktan kaçının.

**Fonksiyonlar**

- **DO** bir fonksiyonu bir isme bağlamak için fonksiyon bildirimi kullanın.
- **DON'T** tear-off yeterli olduğunda lambda oluşturmayın.

**Değişkenler**

- **DO** yerel değişkenlerde `var` ve `final` için tutarlı bir kurala uyun.
- **AVOID** hesaplayabileceğiniz değerleri saklamaktan kaçının.

**Üyeler**

- **DON'T** bir alanı gereksiz yere getter ve setter ile sarmalamayın.
- **PREFER** salt okunur bir özellik oluşturmak için `final` alan kullanın.
- **CONSIDER** basit üyeler için `=>` kullanmayı değerlendirin.
- **DON'T** bir adlandırılmış constructor'a yönlendirmek veya gölgelemeyi önlemek dışında `this.` kullanmayın.
- **DO** mümkün olduğunda alanları bildirildikleri yerde başlatın.

**Constructor'lar**

- **DO** mümkün olduğunda başlatıcı parametreleri (initializing formals) kullanın.
- **DON'T** bir constructor başlatıcı listesi yeterli olduğunda `late` kullanmayın.
- **DO** boş constructor gövdeleri için `{}` yerine `;` kullanın.
- **PREFER** kısa constructor sözdizimi kullanın.
- **DON'T** `new` kullanmayın.
- **DON'T** gereksiz yere `const` kullanmayın.

**Hata yönetimi**

- **AVOID** `on` yan tümcesi olmayan catch bloklarından kaçının.
- **DON'T** `on` yan tümcesi olmayan catch bloklarındaki hataları yok saymayın.
- **DO** `Error` arayüzünü uygulayan nesneleri yalnızca programatik hatalar için fırlatın.
- **DON'T** `Error`'u veya onu uygulayan türleri açıkça yakalamayın.
- **DO** yakalanmış bir istisnayı yeniden fırlatmak için `rethrow` kullanın.

**Asenkronluk**

- **PREFER** ham future'lar kullanmak yerine async/await kullanın.
- **DON'T** yararlı bir etkisi olmadığında `async` kullanmayın.
- **CONSIDER** bir stream'i dönüştürmek için üst düzey metotları kullanmayı değerlendirin.
- **AVOID** doğrudan `Completer` kullanmaktan kaçının.
- Tür argümanı `Object` olabilen bir `FutureOr<T>` ayrıştırılırken **DO** `Future<T>` kontrolü yapın.

### Tasarım

**İsimler**

- **DO** terimleri tutarlı biçimde kullanın.
- **AVOID** kısaltmalardan kaçının.
- **PREFER** en açıklayıcı ismi sona koyun.
- **CONSIDER** kodun bir cümle gibi okunmasını sağlamayı değerlendirin.
- Boolean olmayan bir özellik veya değişken için **PREFER** isim öbeği kullanın.
- Boolean bir özellik veya değişken için **PREFER** emir kipi olmayan fiil öbeği kullanın.
- Adlandırılmış boolean bir *parametre* için fiili atlamayı **CONSIDER** edin.
- Boolean bir özellik veya değişken için "pozitif" adı **PREFER** kullanın.
- Ana amacı bir yan etki olan fonksiyon veya metot için **PREFER** emir kipi fiil öbeği kullanın.
- Ana amacı değer döndürmek olan fonksiyon veya metot için **PREFER** isim öbeği ya da emir kipi olmayan fiil öbeği kullanın.
- Yaptığı işe dikkat çekmek istiyorsanız fonksiyon veya metot için **CONSIDER** emir kipi fiil öbeği kullanın.
- Bir fonksiyon veya metot adını `get` ile başlatmaktan **AVOID** kaçının.
- Metot, nesnenin durumunu yeni bir nesneye kopyalıyorsa **PREFER** onu `to___()` olarak adlandırın.
- Metot, orijinal nesneye dayanan farklı bir temsil döndürüyorsa **PREFER** onu `as___()` olarak adlandırın.
- Fonksiyonun veya metodun adında parametreleri tanımlamaktan **AVOID** kaçının.
- Tür parametrelerini adlandırırken mevcut mnemonik kurallarını **DO** izleyin.

**Kütüphaneler**

- **PREFER** bildirimleri private yapın.
- **CONSIDER** aynı kütüphanede birden fazla sınıf bildirmeyi değerlendirin.

**Sınıflar ve mixin'ler**

- Basit bir fonksiyon yeterli olduğunda tek üyeli soyut sınıf tanımlamaktan **AVOID** kaçının.
- Yalnızca statik üyeler içeren sınıf tanımlamaktan **AVOID** kaçının.
- Alt sınıflanması amaçlanmayan bir sınıfı genişletmekten **AVOID** kaçının.
- Sınıfınızın genişletilip genişletilemeyeceğini kontrol etmek için **DO** sınıf modifier'larını kullanın.
- Arayüz olması amaçlanmayan bir sınıfı uygulamaktan **AVOID** kaçının.
- Sınıfınızın bir arayüz olup olamayacağını kontrol etmek için **DO** sınıf modifier'larını kullanın.
- **PREFER** bir `mixin class` yerine saf bir `mixin` veya saf bir `class` tanımlayın.

**Constructor'lar**

- Sınıf destekliyorsa constructor'ınızı `const` yapmayı **CONSIDER** edin.

**Üyeler**

- **PREFER** alanları ve üst düzey değişkenleri `final` yapın.
- **DO** kavramsal olarak özelliklere erişen işlemler için getter kullanın.
- **DO** kavramsal olarak özellikleri değiştiren işlemler için setter kullanın.
- **DON'T** karşılık gelen bir getter olmadan setter tanımlamayın.
- **AVOID** overloading'i taklit etmek için çalışma zamanı tür kontrollerinden kaçının.
- Başlatıcısı olmayan public `late final` alanlardan **AVOID** kaçının.
- Nullable `Future`, `Stream` ve koleksiyon türlerini döndürmekten **AVOID** kaçının.
- Yalnızca fluent arayüz sağlamak için metotlardan `this` döndürmekten **AVOID** kaçının.

**Türler**

- Başlatıcısı olmayan değişkenlere **DO** tür açıklaması ekleyin.
- Tür açık değilse alanlara ve üst düzey değişkenlere **DO** tür açıklaması ekleyin.
- **DON'T** başlatılmış yerel değişkenlere gereksiz tür açıklaması eklemeyin.
- Fonksiyon bildirimlerinde dönüş türlerini **DO** açıkça belirtin.
- Fonksiyon bildirimlerinde parametre türlerini **DO** açıkça belirtin.
- **DON'T** fonksiyon ifadelerindeki çıkarsanan parametre türlerine tür açıklaması eklemeyin.
- **DON'T** başlatıcı parametrelerine (initializing formals) tür açıklaması eklemeyin.
- Çıkarsanmayan generic çağrılarda tür argümanlarını **DO** yazın.
- Çıkarsanan generic çağrılarda tür argümanlarını **DON'T** yazmayın.
- Eksik generic türler yazmaktan **AVOID** kaçının.
- Tür çıkarımının başarısız olmasına izin vermek yerine **DO** `dynamic` ile açıklama ekleyin.
- Fonksiyon türü açıklamalarında imzaları **PREFER** kullanın.
- Bir setter için dönüş türü **DON'T** belirtmeyin.
- Eski typedef sözdizimini **DON'T** kullanmayın.
- Typedef'ler yerine satır içi fonksiyon türlerini **PREFER** kullanın.
- Parametreler için fonksiyon türü sözdizimini **PREFER** kullanın.
- Statik denetimi devre dışı bırakmak istemediğiniz sürece `dynamic` kullanmaktan **AVOID** kaçının.
- Değer üretmeyen asenkron üyelerin dönüş türü olarak **DO** `Future<void>` kullanın.
- Dönüş türü olarak `FutureOr<T>` kullanmaktan **AVOID** kaçının.

**Parametreler**

- Konumsal boolean parametrelerden **AVOID** kaçının.
- Kullanıcının önceki parametreleri atlamak isteyebileceği durumlarda isteğe bağlı konumsal parametrelerden **AVOID** kaçının.
- Özel bir "argümansız" değeri kabul eden zorunlu parametrelerden **AVOID** kaçının.
- Bir aralığı kabul etmek için başlangıcı dahil, sonu hariç olan parametreleri **DO** kullanın.

**Eşitlik**

- `==` operatörünü override ediyorsanız `hashCode`'u **DO** override edin.
- `==` operatörünüzün eşitliğin matematiksel kurallarına uymasını **DO** sağlayın.
- Değiştirilebilir sınıflar için özel eşitlik tanımlamaktan **AVOID** kaçının.
- `==` operatörünün parametresini **DON'T** nullable yapmayın.


---

# Effective Dart: Stil

Görünüşte önemsiz olsa da iyi kodun önemli bir parçası iyi stildir. Tutarlı adlandırma, sıralama ve biçimlendirme, *aynı* olan kodların *aynı görünmesini* sağlar. Bu, çoğumuzun görme sisteminde bulunan güçlü örüntü eşleştirme donanımından yararlanır. Tüm Dart ekosisteminde tutarlı bir stil kullanırsak, hepimizin birbirimizin kodundan öğrenmesi ve ona katkıda bulunması kolaylaşır.

## Tanımlayıcılar

Dart'ta tanımlayıcılar üç biçimde gelir.

- `UpperCamelCase` adları, ilk kelime dahil her kelimenin ilk harfini büyük yazar.
- `lowerCamelCase` adları, her kelimenin ilk harfini büyük yazar; *ancak* ilk kelime hariçtir, bu kelime her zaman küçük harfle başlar, kısaltma olsa bile.
- `lowercase_with_underscores` adları, kısaltmalar dahil yalnızca küçük harf kullanır ve kelimeleri `_` ile ayırır.

### **DO** Tür adlarını `UpperCamelCase` kullanarak belirtin

Linter kuralı: camel_case_types

Sınıflar, enum türleri, typedef'ler ve tür parametreleri, ilk kelime dahil her kelimenin ilk harfini büyük yazmalı ve ayırıcı kullanmamalıdır.

```dart
class SliderMenu {
   ...
}
​
class HttpRequest {
   ...
}
​
typedef Predicate<T> = bool Function(T value);
```

Bu, meta veri anotasyonlarında kullanılmak üzere tasarlanmış sınıfları da kapsar.

```dart
class Foo {
  const Foo([Object? arg]);
}
​
@Foo(anArg)
class A {
   ...
}
​
@Foo()
class B {
   ...
}
```

Anotasyon sınıfının kurucusu parametre almıyorsa, bunun için ayrı bir `lowerCamelCase` sabiti oluşturmak isteyebilirsiniz.

```dart
const foo = Foo();
​
@foo
class C {
   ...
}
```

### **DO** Uzantı adlarını `UpperCamelCase` kullanarak belirtin

Linter kuralı: camel_case_extensions

Türlerde olduğu gibi, uzantılar da ilk kelime dahil her kelimenin ilk harfini büyük yazmalı ve ayırıcı kullanmamalıdır.

```dart
extension MyFancyList<T> on List<T> {
   ...
}
​
extension SmartIterable<T> on Iterable<T> {
   ...
}
```

### **DO** Paket, dizin ve kaynak dosya adlarını `lowercase_with_underscores` kullanarak belirtin

Linter kuralları: file_names, package_names

Bazı dosya sistemleri büyük/küçük harf duyarlı değildir, bu nedenle birçok proje dosya adlarının tamamen küçük harf olmasını gerektirir. Bir ayırıcı karakter kullanmak, adların bu biçimde de okunabilir kalmasını sağlar. Ayırıcı olarak alt çizgi kullanmak, adın geçerli bir Dart tanımlayıcısı olmaya devam etmesini sağlar; bu, dilin ileride sembolik içe aktarmaları desteklemesi durumunda yararlı olabilir.

```dart
my_package
└─ lib
   └─ file_system.dart
   └─ slider_menu.dart
```

```dart
mypackage
└─ lib
   └─ file-system.dart
   └─ SliderMenu.dart
```

### **DO** İçe aktarma öneklerini `lowercase_with_underscores` kullanarak belirtin

Linter kuralı: library_prefixes

```dart
import 'dart:math' as math;
​
import 'package:angular_components/angular_components.dart' as angular_components;
import 'package:js/js.dart' as js;
```

```dart
import 'dart:math' as Math;
​
import 'package:angular_components/angular_components.dart' as angularComponents;
import 'package:js/js.dart' as JS;
```

### **DO** Diğer tanımlayıcıları `lowerCamelCase` kullanarak belirtin

Linter kuralı: non_constant_identifier_names

Sınıf üyeleri, üst düzey tanımlar, değişkenler, parametreler ve adlandırılmış parametreler, ilk kelime *hariç* her kelimenin ilk harfini büyük yazmalı ve ayırıcı kullanmamalıdır.

```dart
var count = 3;
​
HttpRequest httpRequest;
​
void align(bool clearItems) {
  // ...
}
```

### **PREFER** Sabit adları için `lowerCamelCase` kullanın

Linter kuralı: constant_identifier_names

Yeni kodda, enum değerleri dahil sabit değişkenler için `lowerCamelCase` kullanın.

```dart
const pi = 3.14;
const defaultTimeout = 1000;
final urlScheme = RegExp('^([a-z]+):');
​
class Dice {
  static final numberGenerator = Random();
}
```

```dart
const PI = 3.14;
const DefaultTimeout = 1000;
final URL_SCHEME = RegExp('^([a-z]+):');
​
class Dice {
  static final NUMBER_GENERATOR = Random();
}
```

Aşağıdaki durumlarda, mevcut kodla tutarlılık için `SCREAMING_CAPS` kullanabilirsiniz:

- `SCREAMING_CAPS` zaten kullanılan bir dosyaya veya kitaplığa kod eklerken.
- Java koduna paralel Dart kodu üretirken; örneğin protobuf'lardan üretilen enum türlerinde.

Başlangıçta sabitler için Java'nın `SCREAMING_CAPS` stilini kullanıyorduk. Birkaç nedenle bunu değiştirdik:

- `SCREAMING_CAPS`, özellikle CSS renkleri gibi şeylerin enum değerleri için birçok durumda kötü görünür.
- Sabitler sık sık const olmayan final değişkenlere dönüştürülür; bu da ad değişikliği gerektirirdi.
- Bir enum türü üzerinde tanımlanan `values` özelliği const ve küçük harflidir.

### **DO** İki harften uzun kısaltma ve akronimleri, kelimeler gibi büyük harfle yazın

Büyük harfli akronimler okunması zor olabilir ve birbirini izleyen birden fazla akronim belirsiz adlara yol açabilir. Örneğin `HTTPSFTP` tanımlayıcısı verildiğinde, okuyucu bunun `HTTPS` `FTP` mi yoksa `HTTP` `SFTP` mi anlamına geldiğini anlayamaz. Bunu önlemek için çoğu akronim ve kısaltmayı normal kelimeler gibi büyük harfle yazın. Bu tanımlayıcı birincisini kastediyorsa `HttpsFtp`, ikincisini kastediyorsa `HttpSftp` olur.

İki harfli kısaltmalar ve akronimler istisnadır. İngilizcede her iki harf de büyük yazılıyorsa, tanımlayıcıda kullanıldıklarında her ikisi de büyük kalmalıdır. Aksi halde kelime gibi büyük harfle yazın.

```dart
// İki harften uzun olduğu için her zaman kelime gibi:
Http // "hiper metin aktarım protokolü"
Nasa // "ulusal havacılık ve uzay dairesi"
Uri // "tekdüze kaynak tanımlayıcısı"
Esq // "esquire (unvan)"
Ave // "avenue (cadde)"
​
// İki harf, İngilizcede büyük harfle yazıldığı için tanımlayıcıda da büyük harfle:
ID // "tanımlayıcı"
TV // "televizyon"
UI // "kullanıcı arayüzü"
​
// İki harf, İngilizcede büyük harfle yazılmadığı için tanımlayıcıda kelime gibi:
Mr // "bay"
St // "sokak"
Rd // "yol"
```

```dart
HTTP // "hiper metin aktarım protokolü"
NASA // "ulusal havacılık ve uzay dairesi"
URI // "tekdüze kaynak tanımlayıcısı"
esq // "esquire (unvan)"
ave // "avenue (cadde)"
​
Id // "tanımlayıcı"
Tv // "televizyon"
Ui // "kullanıcı arayüzü"
​
MR // "bay"
ST // "sokak"
RD // "yol"
```

Herhangi bir kısaltma biçimi `lowerCamelCase` tanımlayıcısının başında yer aldığında, kısaltmanın tamamı küçük harf olmalıdır:

```dart
var httpConnection = connect();
var tvSet = Television();
var mrRogers = 'hello, neighbor';
```

### **PREFER** Kullanılmayan callback parametreleri için joker karakter (wildcard) kullanın

Bazen bir callback fonksiyonunun tür imzası bir parametre gerektirir, ancak callback uygulaması bu parametreyi *kullanmaz*. Bu durumda, kullanılmayan parametreyi `_` olarak adlandırmak deyimseldir; bu, bağlayıcı olmayan bir joker değişken (wildcard variable) tanımlar.

```dart
futureOfVoid.then((_) {
  print('Operation complete.');
});
```

Joker değişkenler bağlayıcı olmadığından, birden fazla kullanılmayan parametreyi `_` olarak adlandırabilirsiniz.

```dart
.onError((_, _) {
  print('Operation failed.');
});
```

Bu yönerge yalnızca hem *anonim hem de yerel* olan fonksiyonlar içindir. Bu fonksiyonlar genellikle, kullanılmayan parametrenin neyi temsil ettiğinin açık olduğu bir bağlamda hemen kullanılır. Buna karşılık, üst düzey fonksiyonlar ve metot bildirimlerinin böyle bir bağlamı yoktur; bu nedenle parametreler, kullanılmasalar bile her birinin ne için olduğu anlaşılacak şekilde adlandırılmalıdır.

Bağlayıcı olmayan joker değişkenleri bildirmek, en az 3.7 dil sürümünü gerektirir.

Daha eski dil sürümlerinde, ad çakışmalarını önlemek için `__` ve `___` gibi ek alt çizgiler kullanın. Bunların kullanımını zorunlu kılmak ve ileride joker karakterlere geçişi kolaylaştırmak için `no_wildcard_variable_uses` lint kuralını etkinleştirin.

Bu kuraldan joker değişkenlere geçişe yardımcı olmak için `unnecessary_underscores` lint kuralını etkinleştirin.

### **DON'T** Özel olmayan tanımlayıcılarda baştaki alt çizgi kullanmayın

Dart, üyeleri ve üst düzey bildirimleri özel olarak işaretlemek için tanımlayıcının başına alt çizgi koyar. Bu, kullanıcıların baştaki alt çizgiyi bu tür bildirimlerden biriyle ilişkilendirmesine yol açar. "_" gördüklerinde "özel" diye düşünürler.

Yerel değişkenler, parametreler, yerel fonksiyonlar veya kitaplık önekleri için "özel" kavramı yoktur. Bu öğelerden birinin adı alt çizgiyle başladığında, okuyucuya kafa karıştırıcı bir sinyal verir. Bunu önlemek için bu adlarda baştaki alt çizgi kullanmayın.

### **DON'T** Önek harfleri kullanmayın

Macarca notasyon ve benzeri şemalar, derleyicinin kodu anlamanıza pek yardımcı olmadığı BCPL döneminde ortaya çıktı. Dart, bildirimlerinizin türünü, kapsamını, değiştirilebilirliğini ve diğer özelliklerini size söyleyebildiğinden, bu özellikleri tanımlayıcı adlarına kodlamak için bir neden yoktur.

```dart
defaultTimeout
```

```dart
kDefaultTimeout
```

### **DON'T** Kitaplıkları açıkça adlandırmayın

`library` yönergesine bir ad eklemek teknik olarak mümkündür, ancak bu eski bir özelliktir ve önerilmez.

Dart, her kitaplık için yolu ve dosya adına dayanarak benzersiz bir etiket üretir. Kitaplığı adlandırmak bu üretilen URI'yi geçersiz kılar. URI olmadan, araçların ilgili ana kitaplık dosyasını bulması zorlaşabilir.

```dart
library my_library;
```

```dart
/// Gerçekten harika bir test kitaplığı.
@TestOn('browser')
library;
```

## Sıralama

Dosyanızın başlangıç kısmını düzenli tutmak için, yönergelerin görünmesi gereken belirlenmiş bir sıra vardır. Her "bölüm" boş bir satırla ayrılmalıdır.

Tüm sıralama yönergelerini tek bir linter kuralı yönetir: directives_ordering.

### **DO** `dart:` içe aktarmalarını diğer içe aktarmalardan önce yerleştirin

Linter kuralı: directives_ordering

```dart
import 'dart:async';
import 'dart:collection';
​
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
```

### **DO** `package:` içe aktarmalarını göreli içe aktarmalardan önce yerleştirin

Linter kuralı: directives_ordering

```dart
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
​
import 'util.dart';
```

### **DO** Dışa aktarmaları, tüm içe aktarmalardan sonra ayrı bir bölümde belirtin

Linter kuralı: directives_ordering

```dart
import 'src/error.dart';
import 'src/foo_bar.dart';
​
export 'src/error.dart';
```

```dart
import 'src/error.dart';
export 'src/error.dart';
import 'src/foo_bar.dart';
```

### **DO** Bölümleri alfabetik olarak sıralayın

Linter kuralı: directives_ordering

```dart
import 'package:bar/bar.dart';
import 'package:foo/foo.dart';
​
import 'foo.dart';
import 'foo/foo.dart';
```

```dart
import 'package:foo/foo.dart';
import 'package:bar/bar.dart';
​
import 'foo/foo.dart';
import 'foo.dart';
```

## Biçimlendirme

Birçok dil gibi Dart da boşlukları yok sayar. Ancak *insanlar* yok saymaz. Tutarlı bir boşluk stiline sahip olmak, insan okuyucuların kodu derleyicinin gördüğü gibi görmesini sağlamaya yardımcı olur.

### **DO** Kodunuzu `dart format` ile biçimlendirin

Biçimlendirme zahmetli bir iştir ve özellikle yeniden düzenleme sırasında çok zaman alır. Neyse ki bunun için endişelenmenize gerek yok. Sizin yerinize bunu yapan `dart format` adlı gelişmiş bir otomatik kod biçimlendiricisi sunuyoruz. Dart için resmi boşluk işleme kuralları *`dart format`'ın ürettiği her şeydir*. Biçimlendirici SSS sayfası, uyguladığı stil seçimleri hakkında daha fazla bilgi verebilir.

Kalan biçimlendirme yönergeleri, `dart format`'ın sizin için düzeltemediği birkaç şey içindir.

### **CONSIDER** Kodunuzu biçimlendiriciye daha uygun hale getirmeyi düşünün

Biçimlendirici, kendisine verdiğiniz kodla elinden gelenin en iyisini yapar, ancak mucizeler yaratamaz. Kodunuzda özellikle uzun tanımlayıcılar, derinlemesine iç içe ifadeler, farklı türde operatörlerin karışımı vb. varsa, biçimlendirilmiş çıktı yine de okunması zor olabilir.

Böyle bir durumda kodunuzu yeniden düzenleyin veya sadeleştirin. Yerel bir değişkenin adını kısaltmayı veya bir ifadeyi yeni bir yerel değişkene taşımayı düşünün. Başka bir deyişle, kodu elle biçimlendirip daha okunabilir hale getirmeye çalışıyor olsaydınız yapacağınız türden değişiklikleri yapın. `dart format`'ı, bazen yinelemeli olarak birlikte çalıştığınız, güzel kod üretmek için bir ortaklık olarak düşünün.

### **PREFER** Satırları 80 karakter veya daha az tutun

Linter kuralı: lines_longer_than_80_chars

Okunabilirlik çalışmaları, bir sonraki satırın başına geçerken gözün daha fazla yol kat etmesi gerektiğinden uzun metin satırlarının okunmasının daha zor olduğunu gösteriyor. Gazetelerin ve dergilerin birden fazla metin sütunu kullanmasının nedeni budur.

Gerçekten 80 karakterden uzun satırlar istediğinizi fark ederseniz, deneyimlerimize göre kodunuz muhtemelen çok ayrıntılıdır ve biraz daha kompakt olabilir. Başlıca sorun genellikle `VeryLongCamelCaseClassNames` gibi adlardır. Kendinize şunu sorun: "Bu tür adındaki her kelime bana kritik bir şey söylüyor mu veya bir ad çakışmasını önlüyor mu?" Değilse, bunu çıkarmayı düşünün.

`dart format`'ın varsayılan olarak 80 karakter veya daha az kullandığını, ancak bu varsayılanı yapılandırabileceğinizi unutmayın. Uzun metin değişmezlerini 80 sütuna sığacak şekilde bölmez; bunu elle yapmanız gerekir.

**İstisna:** Bir yorum veya metin içinde (genellikle bir içe aktarma veya dışa aktarmada) bir URI veya dosya yolu geçtiğinde, satır 80 karakteri aşsa bile bütün halde kalabilir. Bu, kaynak dosyalarda yolu aramayı kolaylaştırır.

**İstisna:** Çok satırlı metinler 80 karakterden uzun satırlar içerebilir; çünkü metin içinde satır sonları anlamlıdır ve satırları daha kısa parçalara bölmek programın davranışını değiştirebilir.

### **DO** Tüm akış kontrol ifadeleri için küme parantezi (curly braces) kullanın

Linter kuralı: curly_braces_in_flow_control_structures

Bunu yapmak, dangling else sorununu önler.

```dart
if (isWeekDay) {
  print('Bike to work!');
} else {
  print('Go dancing or read a book!');
}
```

**İstisna:** `else` yan tümcesi olmayan ve tüm `if` ifadesi tek satıra sığan bir `if` ifadeniz varsa, tercih ederseniz parantezleri atlayabilirsiniz:

```dart
if (arg == null) return defaultValue;
```

Ancak gövde bir sonraki satıra sarılırsa, parantez kullanın:

```dart
if (overflowChars != other.overflowChars) {
  return overflowChars < other.overflowChars;
}
```

```dart
if (overflowChars != other.overflowChars)
  return overflowChars < other.overflowChars;
```


---

# Effective Dart: Dokümantasyon

Kodunuzun bugün açık göründüğünü düşünmek kolaydır; ama kafanızdaki bağlama ne kadar güvendiğinizi fark etmezsiniz. Kodunuza yeni başlayan kişiler ve hatta unutkan gelecekteki benliğiniz bu bağlama sahip olmayacaktır. Özlü ve doğru bir yorum yazmak yalnızca birkaç saniye sürer, ama bu kişilerden birinin saatlerce zaman kazanmasını sağlayabilir.

Hepimiz kodun kendi kendini belgelemesi gerektiğini ve her yorumun yararlı olmadığını biliriz. Ancak gerçek şu ki çoğumuz olması gerektiği kadar yorum yazmıyoruz. Tıpkı egzersiz gibi: teknik olarak *fazla* yapabilirsiniz, ama çok daha olası olan, çok az yapıyor olmanızdır. Biraz daha çaba gösterin.

## Yorumlar

Aşağıdaki ipuçları, üretilen dokümantasyona dahil edilmesini istemediğiniz yorumlar için geçerlidir.

### **DO** Yorumları cümle gibi biçimlendirin

```dart
// Önünde herhangi bir şey gelmişse değil.
if (_chunks.isNotEmpty) return false;
```

Büyük/küçük harfe duyarlı bir identifier değilse ilk kelimenin baş harfini büyük yazın. Yorumu bir nokta ile bitirin (ya da "!" veya "?" ile; bunlar da olabilir). Bu kural tüm yorumlar için geçerlidir: doc comment'ler, satır içi yorumlar ve hatta TODO'lar. Bir cümle parçası olsa bile bu böyledir.

### **DON'T** Dokümantasyon için blok yorumları kullanmayın

```dart
void greet(String name) {
  // Geçerli bir ad olduğunu varsayıyoruz.
  print('Hi, $name!');
}
```

```dart
void greet(String name) {
  /* Geçerli bir ad olduğunu varsayıyoruz. */
  print('Hi, $name!');
}
```

Bir kod bölümünü geçici olarak devre dışı bırakmak için blok yorumu (`/* ... */`) kullanabilirsiniz; ancak diğer tüm yorumlarda `//` kullanılmalıdır.

## Doc comment'ler

Doc comment'ler özellikle kullanışlıdır, çünkü `dart doc` bunları ayrıştırır ve bunlardan güzel doküman sayfaları üretir. Doc comment, bir bildirimden önce gelen ve `dart doc`'un aradığı özel `///` sözdizimini kullanan herhangi bir yorumdur.

### **DO** Üyeleri ve türleri belgelemek için `///` doc comment'lerini kullanın

Linter kuralı: slash_for_doc_comments

Normal bir yorum yerine doc comment kullanmak, `dart doc`'un bunu bulup belgesini üretmesini sağlar.

```dart
/// Bölünmemiş hâldeyken bu parçadaki karakter sayısı.
int get length => ...
```

```dart
// Bölünmemiş hâldeyken bu parçadaki karakter sayısı.
int get length => ...
```

Tarihsel nedenlerle `dart doc`, doc comment için iki sözdizimini destekler: `///` ("C# tarzı") ve `/** ... */` ("JavaDoc tarzı"). Daha kompakt olduğu için `///` sözdizimini tercih ederiz. `/**` ve `*/` satırları, çok satırlı bir doc comment'e içeriksiz iki satır ekler. `///` sözdizimi, özellikle bir doc comment'in liste öğelerini işaretlemek için `*` kullanan madde işaretli bir liste içerdiği durumlarda okumayı kolaylaştırır.

Hâlâ JavaDoc tarzını kullanan bir kodla karşılaşırsanız, onu düzenlemeyi düşünün.

### **PREFER** Public API'ler için doc comment yazmayı tercih edin

Linter kuralı: public_member_api_docs

Her kütüphaneyi, üst düzey değişkeni, türü ve üyeyi tek tek belgelemeniz gerekmez; ancak çoğunu belgelemelisiniz.

### **CONSIDER** Kütüphane düzeyinde bir doc comment yazmayı düşünün

Sınıfın program organizasyonunun tek birimi olduğu Java gibi dillerin aksine, Dart'ta kütüphane, kullanıcıların doğrudan çalıştığı, import ettiği ve üzerine düşündüğü bir varlıktır. Bu nedenle `library` direktifi, okuyucuya kütüphanenin ana kavramlarını ve sunduğu işlevleri tanıtan dokümantasyon için harika bir yerdir. Şunları eklemeyi düşünün:

- Kütüphanenin ne işe yaradığını anlatan tek cümlelik bir özet.
- Kütüphane boyunca kullanılan terimlerin açıklamaları.
- API'nin nasıl kullanılacağını adım adım gösteren birkaç eksiksiz kod örneği.
- En önemli veya en sık kullanılan sınıf ve fonksiyonlara bağlantılar.
- Kütüphanenin ilgilendiği alan hakkında dış kaynaklara bağlantılar.

Bir kütüphaneyi belgelemek için, doc comment'i `library` direktifinin ve dosyanın başında yer alabilecek annotation'ların önüne yerleştirin.

```dart
/// Gerçekten harika bir test kütüphanesi.
@TestOn('browser')
library;
```

### **CONSIDER** Private API'ler için doc comment yazmayı düşünün

Doc comment'ler yalnızca kütüphanenizin public API'sini dışarıdan kullanan kişiler içindir değildir. Kütüphanenin diğer bölümlerinden çağrılan private üyeleri anlamak için de yardımcı olabilirler.

### **DO** Doc comment'lere tek cümlelik bir özetle başlayın

Doc comment'inizi, bir nokta ile biten kısa ve kullanıcı odaklı bir açıklamayla başlatın. Çoğu zaman bir cümle parçası yeterlidir. Okuyucunun yönünü bulması ve okumaya devam edip etmeyeceğine ya da sorununun çözümünü başka yerde arayıp aramayacağına karar vermesi için yeterli bağlamı sunun.

```dart
/// [path] konumundaki dosyayı dosya sisteminden siler.
void delete(String path) {
  ...
}
```

```dart
/// Dosya sisteminin durumuna ve kullanıcının izinlerine bağlı olarak
/// bazı işlemler mümkün olabilir veya olmayabilir. [path] konumunda bir
/// dosya yoksa ya da bu dosyaya erişilemiyorsa, bu fonksiyon sırasıyla
/// [IOError] veya [PermissionError] fırlatır. Aksi hâlde dosyayı siler.
void delete(String path) {
  ...
}
```

### **DO** Doc comment'in ilk cümlesini kendi paragrafına ayırın

İlk cümleyi kendi paragrafına ayırmak için cümlenin ardına bir boş satır ekleyin. Birden fazla açıklama cümlesi faydalıysa, geri kalanını sonraki paragraflara yerleştirin.

Bu, dokümantasyonu özetleyen sıkı bir ilk cümle yazmanıza yardımcı olur. Ayrıca `dart doc` gibi araçlar, sınıf ve üye listeleri gibi yerlerde ilk paragrafı kısa özet olarak kullanır.

```dart
/// [path] konumundaki dosyayı siler.
///
/// Dosya bulunamazsa [IOError] fırlatır. Dosya mevcut ancak silinemiyorsa
/// [PermissionError] fırlatır.
void delete(String path) {
  ...
}
```

```dart
/// [path] konumundaki dosyayı siler. Dosya bulunamazsa [IOError] fırlatır.
/// Dosya mevcut ama silinemiyorsa [PermissionError] fırlatır.
void delete(String path) {
  ...
}
```

### **AVOID** Çevresindeki bağlamla gereksiz tekrardan kaçının

Bir sınıfın doc comment'ini okuyan kişi, sınıfın adını, hangi interface'leri uyguladığını vb. açıkça görebilir. Bir üyenin dokümanını okurken imza zaten oradadır ve kapsayan sınıf bellidir. Bunların hiçbirinin doc comment'te açıkça yazılmasına gerek yoktur. Bunun yerine, okuyucunun *zaten bilmediği* şeyi açıklamaya odaklanın.

```dart
class RadioButtonWidget extends Widget {
  /// İpucu metnini [lines] olarak ayarlar.
  ///
  /// Satırlar, geçerli yazı tipine göre kelime bazında sarılmalıdır.
  void tooltip(List<String> lines) {
    ...
  }
}
```

```dart
class RadioButtonWidget extends Widget {
  /// Bu radio button widget'ının ipucunu, [lines] içindeki dizgi listesine ayarlar.
  void tooltip(List<String> lines) {
    ...
  }
}
```

Doc comment'leri yalnızca çevresindeki bağlamdan hemen anlaşılmayan bağlam, uyarı veya kullanım ayrıntılarını sunarken ekleyin.

Bu bölüm bilinçli olarak boş bırakılmıştır.

### **PREFER** Ana amacı bir yan etki olan fonksiyon ve metotların yorumlarını üçüncü tekil şahıs fiilleriyle başlatmayı tercih edin

Doc comment, kodun *ne yaptığına* odaklanmalıdır.

```dart
/// Sunucuya bağlanır ve sorgu sonuçlarını getirir.
Stream<QueryResult> fetchResults(Query query) => ...

/// Kronometre zaten çalışmıyorsa onu başlatır.
void start() => ...
```

### **PREFER** Boolean olmayan değişken veya property yorumlarına isim öbeğiyle başlamayı tercih edin

Doc comment, property'nin *ne olduğunu* vurgulamalıdır. Bu, hesaplama veya başka işler yapabilen getter'lar için de geçerlidir. Çağıran kişinin ilgilendiği şey, işin kendisi değil, bu işin *sonucudur*.

```dart
/// Haftanın geçerli günü; `0` Pazar gününü temsil eder.
int weekday;

/// Sayfadaki işaretli düğmelerin sayısı.
int get checkedCount => ...
```

### **PREFER** Boolean değişken veya property yorumlarına, bir isim veya isim-fiil öbeğinin izlediği "Whether" ile başlamayı tercih edin

Doc comment, bu değişkenin temsil ettiği durumları açıklığa kavuşturmalıdır. Bu, hesaplama veya başka işler yapabilen getter'lar için de geçerlidir. Çağıran kişinin ilgilendiği şey, işin kendisi değil, bu işin *sonucudur*.

```dart
/// Modal pencere şu anda kullanıcıya gösteriliyor mu.
bool isVisible;

/// Modal pencere, gezinme sırasında kullanıcının niyetini onaylamalı mı.
bool get shouldConfirm => ...

/// Geçerli tarayıcı penceresinin boyutu değiştirildiğinde modal pencere de boyutlandırılacak mı.
bool get canResize => ...
```

Bu kılavuz, bilerek "Whether or not" kullanımını kapsamaz. Birçok durumda "whether" ile birlikte kullanılan "or not" gereksizdir ve özellikle bu bağlamda kullanıldığında atlanabilir.

### **PREFER** Ana amacı bir değer döndürmek olan fonksiyon ve metotlar için isim öbeği veya emir olmayan fiil öbeği kullanmayı tercih edin

Bir metot *sözdizimsel olarak* metot olmakla birlikte *kavramsal olarak* bir property ise ve bu nedenle isim öbeği veya emir olmayan fiil öbeğiyle adlandırılmışsa, onu da bu şekilde belgelemelisiniz. Boolean olmayan bu tür fonksiyonlar için isim öbeği, boolean olanlar için ise "Whether" ile başlayan bir ifade kullanın; tıpkı sözdizimsel bir property veya değişkende olduğu gibi.

```dart
/// Bu iterable'ın dolaşım sırasındaki [index]. öğesi.
E elementAt(int index);

/// Bu iterable, [element] ile eşit bir öğe içeriyor mu.
bool contains(Object? element);
```

Bu kural, bildirimin kavramsal olarak bir property olarak görülüp görülmediğine göre uygulanmalıdır.

Bazen bir metodun yan etkisi yoktur ve kavramsal olarak property gibi görülebilir, ancak yine de `list.take()` gibi bir fiil öbeğiyle adlandırılması daha basittir. Bu durumda belgelemek için yine de isim öbeği kullanılmalıdır. *Örneğin `Iterable.take`, "...'in ilk [count] öğesi" şeklinde açıklanabilir.*

### **DON'T** Bir property'nin hem getter'ı hem de setter'ı için belge yazmayın

Bir property'nin hem getter'ı hem de setter'ı varsa, bunlardan yalnızca birine doc comment yazın. `dart doc`, getter ve setter'ı tek bir alan gibi ele alır; ikisinin de doc comment'i varsa, `dart doc` setter'ın doc comment'ini yok sayar.

```dart
/// Havuzdaki suyun pH düzeyi.
///
/// 0 ile 14 arasında değer alır: 0 asidik, 14 bazik, 7 ise nötrdür.
int get phLevel => ...
set phLevel(int level) => ...
```

```dart
/// Havuzdaki suyun derinliği, metre cinsinden.
int get waterDepth => ...

/// Su derinliğini toplam [meters] metre olacak şekilde günceller.
set waterDepth(int meters) => ...
```

### **PREFER** Kütüphane veya tür yorumlarına isim öbekleriyle başlamayı tercih edin

Sınıflara yazılan doc comment'ler çoğu zaman programınızdaki en önemli dokümantasyondur. Bunlar türün invariant'larını tanımlar, kullandığı terminolojiyi belirler ve sınıfın üyelerine ait diğer doc comment'lere bağlam sağlar. Burada biraz ekstra çaba harcamak, diğer tüm üyelerin belgelenmesini daha basit hâle getirebilir.

Dokümantasyon, türün bir *instance*'ını tanımlamalıdır.

```dart
/// Sert veya yumuşak bir satır sonuyla biten, bölünmeyen bir çıktı metni parçası.
///
/// ...
class Chunk {
   ...
}
```

### **CONSIDER** Doc comment'lere kod örnekleri eklemeyi düşünün

```dart
/// İki sayının küçüğü.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
```

İnsanlar örneklerden genelleme yapmakta çok iyidir; bu nedenle tek bir kod örneği bile bir API'nin öğrenilmesini kolaylaştırır.

### **DO** Kapsamdaki identifier'lara başvurmak için doc comment'lerde köşeli parantez kullanın

Linter kuralı: comment_references

Değişken, metot veya tür adları gibi öğeleri köşeli parantez içine alırsanız, `dart doc` adı arar ve ilgili API dokümanına bağlantı verir. Parantezler isteğe bağlıdır, ancak bir fonksiyona veya constructor'a başvurduğunuzu netleştirebilir. Aşağıdaki kısmi doc comment'ler, bu yorum referanslarının faydalı olabileceği birkaç durumu göstermektedir:

```dart
/// ... olduğunda [StateError] fırlatır.
///
/// [anotherMethod()] ile benzerdir, ancak ...
```

Belirli bir sınıfın bir üyesine bağlantı vermek için, sınıf adını ve üye adını bir nokta ile ayırarak kullanın:

```dart
/// [Duration.inDays] ile benzerdir, ancak kesirli günleri de işler.
```

Nokta sözdizimi, adlandırılmış constructor'lara başvurmak için de kullanılabilir. Adsız constructor için ise sınıf adının ardından `.new` kullanın:

```dart
/// Bir nokta oluşturmak için [Point.new] çağırın ya da ... amacıyla [Point.polar] kullanın.
```

Analyzer ve `dart doc`'un doc comment'lerde desteklediği referanslar hakkında daha fazla bilgi edinmek için Documentation comment references sayfasına göz atın.

### **DO** Parametreleri, dönüş değerlerini ve istisnaları açıklamak için düz metin kullanın

Diğer dillerde, bir metodun parametrelerinin ve dönüş değerlerinin neler olduğunu açıklamak için ayrıntılı etiketler ve bölümler kullanılır.

```dart
/// Verilen ad ve kısaltma ile bir bayrak tanımlar.
///
/// @param name Bayrağın adı.
/// @param abbr Bayrağın kısaltması.
/// @returns Yeni bayrak.
/// @throws ArgumentError Verilen ad veya kısaltmaya sahip bir seçenek zaten varsa.
Flag addFlag(String name, String abbreviation) => ...
```

Dart'taki kural, bunu metodun açıklamasına entegre etmek ve parametreleri köşeli parantez kullanarak vurgulamaktır.

Parametreleri açıklamak için "The [parameter]" ile başlayan bölümler kullanmayı düşünün; dönüş değeri için "Returns", istisnalar için "Throws" kullanın. Hatalar, istisnalar gibi belgelenebilir ya da fırlatılacak kesin hatayı belirtmeden, yalnızca karşılanması gereken koşullar olarak yazılabilir.

```dart
/// [name] ve [abbreviation] ile belirtilen bir bayrak tanımlar.
///
/// [name] ve [abbreviation] dizgileri boş olmamalıdır.
///
/// Yeni bir bayrak döndürür.
///
/// [name] adında bir seçenek veya [abbreviation] kısaltmasını kullanan bir seçenek
/// zaten varsa [DuplicateFlagException] fırlatır.
Flag addFlag(String name, String abbreviation) => ...
```

### **DO** Doc comment'leri metadata annotation'larından önce yazın

```dart
/// Açılıp kapatılabilen bir düğme.
@Component(selector: 'toggle')
class ToggleComponent {}
```

```dart
@Component(selector: 'toggle')
/// Açılıp kapatılabilen bir düğme.
class ToggleComponent {}
```

## Markdown

Doc comment'lerinizde markdown biçimlendirmesinin çoğunu kullanabilirsiniz; `dart doc` bunları markdown paketini kullanarak buna uygun şekilde işler.

Markdown'ı size tanıtan pek çok rehber zaten mevcut. Evrensel popülerliği, onu seçmemizin nedenidir. Desteklenen özelliklerin bir fikrini vermek için kısa bir örnek:

```dart
/// Bu, normal bir metin paragrafıdır.
///
/// Bu cümlede *iki* _vurgulu_ kelime (italik) ve **iki**
/// __kalın__ kelime (koyu) bulunur.
///
/// Boş bir satır ayrı bir paragraf oluşturur. Ayrıca `satır içi kod` içeren
/// bir bölüm de vardır; bu bölüm backtick ile çevrilmiştir.
///
/// * Sırasız listeler.
/// * ASCII madde işaretli listelere benzerler.
/// * `-` veya `+` da kullanabilirsiniz.
///
/// 1. Numaralı listeler.
/// 2. Numaralıdırlar, evet.
/// 1. Ancak değerlerin bir önemi yoktur.
///
///     * Listeleri iç içe de kullanabilirsiniz.
///     * En az 4 boşlukla girintili olmaları gerekir.
///     * (Aslında `///` sonrasındaki boşluk dahil 5 olur.)
///
/// Kod blokları üç backtick ile çevrilir:
///
/// ```dart
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// Kod dili (sözdizimi vurgulaması için) varsayılan olarak Dart'tır. Bunu,
/// açılış backtick'lerinden sonra dilin adını yazarak belirtebilirsiniz:
///
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
///
/// Bağlantılar şu şekillerde verilebilir:
///
/// * https://www.just-a-bare-url.com
/// * [URL satır içinde](https://google.com)
/// * [veya ayrı olarak][ref link]
///
/// [ref link]: https://google.com
///
/// # Bir Başlık
///
/// ## Bir alt başlık
///
/// ### Bir alt-alt başlık
///
/// #### Bu kadar çok başlık düzeyine ihtiyacınız varsa, bir şeyleri yanlış yapıyorsunuz demektir
```

### **AVOID** Markdown'ı aşırı kullanmaktan kaçının

Şüphe duyduğunuzda biçimlendirmeyi azaltın. Biçimlendirme, içeriğinizi aydınlatmak için vardır, onun yerini almak için değil. Önemli olan kelimelerdir.

### **AVOID** Biçimlendirme için HTML kullanmaktan kaçının

Tablolar gibi nadir durumlarda kullanmak *yararlı olabilir*; ancak neredeyse her durumda, Markdown ile ifade etmesi çok karmaşıksa, ifade etmemek daha iyidir.

### **PREFER** Kod blokları için backtick çitleri (fence) kullanmayı tercih edin

Markdown'da bir kod bloğunu belirtmenin iki yolu vardır: her satırı dört boşlukla girintilemek ya da üç backtick'ten oluşan bir çift "çit" (fence) satırıyla çevrelemek. İlki, girintinin zaten anlamlı olduğu Markdown listeleri gibi yerlerde kullanıldığında veya kod bloğunun kendisi girintili kod içerdiğinde kırılgandır.

Backtick sözdizimi bu girinti sorunlarından kaçınmanızı sağlar, kodun dilini belirtmenize izin verir ve satır içi kod için backtick kullanımıyla tutarlıdır.

```dart
/// [CodeBlockExample] sınıfını şu şekilde kullanabilirsiniz:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Evet."
/// ```
```

```dart
/// [CodeBlockExample] sınıfını şu şekilde kullanabilirsiniz:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Evet."
```

## Yazım

Kendimizi programcı olarak görüyoruz, ancak bir kaynak dosyadaki karakterlerin çoğu öncelikle insanların okuması için tasarlanmıştır. İngilizce, iş arkadaşlarımızın zihnini değiştirmek için kodladığımız dildir. Herhangi bir programlama dili gibi, bu dildeki yetkinliğinizi geliştirmek için çaba göstermeye değer.

Bu bölüm, dokümanlarımız için birkaç kılavuzu listeler. Teknik yazım en iyi uygulamaları hakkında genel olarak, Technical writing style gibi makalelerden daha fazla bilgi edinebilirsiniz.

### **PREFER** Kısalığı tercih edin

Açık ve kesin olun, ama aynı zamanda öz olun.

### **AVOID** Açık olmadıkları sürece kısaltma ve akronimlerden kaçının

Pek çok kişi "i.e.", "e.g." ve "et al." ifadelerinin ne anlama geldiğini bilmez. Alanınızdaki herkesin bildiğinden emin olduğunuz o akronim, düşündüğünüz kadar yaygın bilinmeyebilir.

### **PREFER** Bir üyenin instance'ına başvururken "the" yerine "this" kullanmayı tercih edin

Bir sınıfın üyesini belgelerken, çoğu zaman üyenin üzerinde çağrıldığı nesneye geri başvurmanız gerekir. "the" kullanmak belirsiz olabilir. "this" sözcüğünden sonra bir niteleyici bulundurmayı tercih edin; yalnız başına bir "this" de belirsiz olabilir.

```dart
class Box {
  /// Bu kutunun sardığı değer.
  Object? _value;

  /// Bu kutunun bir değer içerip içermediği.
  bool get hasValue => _value != null;
}
```


---

# Effective Dart: Kullanım

Bu yönergeleri Dart kodunuzun gövdesinde her gün kullanabilirsiniz. Kütüphanenizin *kullanıcıları* bu fikirleri içselleştirdiğinizi fark etmeyebilir, ama kütüphanenin *bakımcıları* kesinlikle fark eder.

## Kütüphaneler

Bu yönergeler, programınızı birden fazla dosyaya tutarlı ve sürdürülebilir bir biçimde bölmenize yardımcı olur. Yönergeleri kısa tutmak için, `import` ve `export` yönergelerini kapsamak amacıyla "import" terimini kullanıyoruz. Yönergeler her ikisi için de aynı şekilde geçerlidir.

### **DO** `part of` yönergelerinde dize kullanın

Linter kuralı: use_string_in_part_of_directives

Birçok Dart geliştiricisi `part` kullanmaktan tamamen kaçınır. Her kütüphane tek bir dosya olduğunda kodun akıl yürütülmesi daha kolay olur. Kütüphanenin bir kısmını başka bir dosyaya ayırmak için `part` kullanmaya karar verirseniz, Dart diğer dosyanın da hangi kütüphanenin parçası olduğunu belirtmesini zorunlu kılar.

Dart, `part of` yönergesinde bir kütüphanenin *adını* kullanmaya izin verir. Kütüphanelere ad vermek artık önerilmeyen eski bir özelliktir. Kütüphane adları, bir parçanın hangi kütüphaneye ait olduğunun belirlenmesinde belirsizlik yaratabilir.

Tercih edilen sözdizimi, doğrudan kütüphane dosyasını gösteren bir URI dizesi kullanmaktır. Eğer `my_library.dart` adında, şunu içeren bir kütüphaneniz varsa:

```dart
library my_library;

part 'some/other/file.dart';
```

Bu durumda parça dosyası kütüphane dosyasının URI dizesini kullanmalıdır:

```dart
part of '../../my_library.dart';
```

Kütüphane adını değil:

```dart
part of my_library;
```

### **DON'T** başka bir paketin `src` dizini içindeki kütüphaneleri içe aktarmayın

Linter kuralı: implementation_imports

`lib` altındaki `src` dizini, paketin kendi uygulamasına özel kütüphaneleri içermek üzere tanımlanmıştır. Paket bakımcıları paketlerini sürümlendirirken bu kurala göre hareket eder. `src` altındaki kodda kapsamlı değişiklikler yapabilirler ve bu, paket için kırıcı bir değişiklik sayılmaz.

Bu, başka bir paketin özel kütüphanesini içe aktarırsanız, o paketin küçük, teorik olarak kırıcı olmayan bir ara sürümünün kodunuzu bozabileceği anlamına gelir.

### **DON'T** içe aktarma yolunun `lib` dizininin içine veya dışına ulaşmasına izin vermeyin

Linter kuralı: avoid_relative_lib_imports

`package:` içe aktarması, bir paketin `lib` dizini içindeki bir kütüphaneye, paketin bilgisayarınızda nerede saklandığını düşünmeden erişmenizi sağlar. Bunun çalışması için, `lib`'in diskte diğer dosyalara göre belirli bir konumda olmasını gerektiren içe aktarmalar olmamalıdır. Başka bir deyişle, `lib` içindeki bir dosyadaki göreli içe aktarma yolu `lib` dizininin dışındaki bir dosyaya ulaşamaz ve `lib` dışındaki bir kütüphane göreli bir yolla `lib` dizinine girememelidir. Bunların herhangi biri, kafa karıştırıcı hatalara ve bozuk programlara yol açar.

Örneğin, dizin yapınızın şu şekilde olduğunu varsayın:

- my_package/lib/api.darttest/api_test.dart

Ve `api_test.dart` dosyasının `api.dart` dosyasını iki farklı şekilde içe aktardığını varsayın:

```dart
import 'package:my_package/api.dart';
import '../lib/api.dart';
```

Dart bunların birbirinden tamamen ilgisiz iki kütüphanenin içe aktarması olduğunu düşünür. Dart'ı ve kendinizi karıştırmamak için şu iki kurala uyun:

- İçe aktarma yollarında `/lib/` kullanmayın.
- `lib` dizininden çıkmak için `../` kullanmayın.

Bunun yerine, bir paketin `lib` dizinine erişmeniz gerektiğinde (aynı paketin `test` dizininden veya başka bir üst düzey dizinden bile olsa), bir `package:` içe aktarması kullanın.

```dart
import 'package:my_package/api.dart';
```

Bir paket asla `lib` dizininden *dışarı* çıkıp paketin başka yerlerindeki kütüphaneleri içe aktarmamalıdır.

### **PREFER** göreli içe aktarma yollarını tercih edin

Linter kuralı: prefer_relative_imports

Önceki kural geçerli olmadığında bu kuralı uygulayın. Bir içe aktarma `lib` dizini dışına *ulaşmadığında*, göreli içe aktarmaları tercih edin. Bunlar daha kısadır. Örneğin, dizin yapınızın şu şekilde olduğunu varsayın:

- my_package/lib/src/stuff.dartutils.dartapi.darttest/api_test.darttest_utils.dart

Kütüphanelerin birbirini nasıl içe aktarması gerektiği aşağıdaki gibidir:

```dart
import 'src/stuff.dart';
import 'src/utils.dart';
```

```dart
import '../api.dart';
import 'stuff.dart';
```

```dart
import 'package:my_package/api.dart'; // 'lib' içine girmeyin.

import 'test_utils.dart'; // 'test' içinde göreli yol uygundur.
```

## Null

### **DON'T** değişkenleri açıkça `null` ile ilklendirmeyin

Linter kuralı: avoid_init_to_null

Bir değişkenin null atanamayan bir türü varsa, kesin olarak ilklenmeden kullanmaya çalışmanız durumunda Dart derleme hatası verir. Değişken null atanabilir ise, sizin için örtük olarak `null` ile ilklenir. Dart'ta "ilklenmemiş bellek" kavramı yoktur ve "güvenli olmak" için bir değişkeni açıkça `null` ile ilklemeye gerek yoktur.

```dart
Item? bestDeal(List<Item> cart) {
  Item? bestItem;

  for (final item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
```

```dart
Item? bestDeal(List<Item> cart) {
  Item? bestItem = null;

  for (final item in cart) {
    if (bestItem == null || item.price < bestItem.price) {
      bestItem = item;
    }
  }

  return bestItem;
}
```

### **DON'T** açık bir varsayılan değer olarak `null` kullanmayın

Linter kuralı: avoid_init_to_null

Null atanabilir bir parametreyi isteğe bağlı yapıp varsayılan değer vermezseniz, dil varsayılan değer olarak örtük olarak `null` kullanır; bu yüzden yazmaya gerek yoktur.

```dart
void error([String? message]) {
  stderr.write(message ?? '\n');
}
```

```dart
void error([String? message = null]) {
  stderr.write(message ?? '\n');
}
```

### **DON'T** eşitlik işlemlerinde `true` veya `false` kullanmayın

Null atanamayan bir boolean ifadesini bir boolean sabitiyle eşitlik operatörü kullanarak değerlendirmek gereksizdir. Eşitlik operatörünü kaldırıp gerekirse tekli olumsuzlama operatörü `!` kullanmak her zaman daha basittir:

```dart
if (nonNullableBool) {
   ...
}

if (!nonNullableBool) {
   ...
}
```

```dart
if (nonNullableBool == true) {
   ...
}

if (nonNullableBool == false) {
   ...
}
```

Null atanabilir bir boolean ifadesini değerlendirmek için `??` veya açık bir `!= null` kontrolü kullanmalısınız.

```dart
// null'ın false sonucunu vermesini istiyorsanız:
if (nullableBool ?? false) {
   ...
}

// null'ın false sonucunu vermesini istiyorsanız
// ve değişkenin tür yükseltmesi yapmasını istiyorsanız:
if (nullableBool != null && nullableBool) {
   ...
}
```

```dart
// Null ise statik hata:
if (nullableBool) {
   ...
}

// null'ın false olmasını istiyorsanız:
if (nullableBool == true) {
   ...
}
```

`nullableBool == true` geçerli bir ifadedir, ancak birkaç nedenden dolayı kullanılmamalıdır:

- Kodun `null` ile ilgili bir şey yaptığını göstermez.
- `null` ile ilgili olduğu belli olmadığı için, eşitlik operatörünün gereksiz olduğu ve kaldırılabileceği null atanamayan duruma kolayca karıştırılabilir. Bu yalnızca soldaki boolean ifadesinin null üretme ihtimali olmadığında doğrudur, ama null üretebildiğinde doğru değildir.
- Boolean mantığı karışıktır. `nullableBool` null ise, `nullableBool == true` ifadesi koşulun `false` olarak değerlendirilmesi anlamına gelir.

`??` operatörü, null ile ilgili bir şeyin gerçekleştiğini açıkça belirtir; bu yüzden gereksiz bir işlemle karıştırılmaz. Mantık da çok daha nettir: ifadenin sonucunun `null` olması, boolean sabitinin değeriyle aynıdır.

Bir koşul içindeki bir değişken üzerinde `??` gibi null farkında bir operatör kullanmak, değişkeni null atanamayan bir türe yükseltmez. Değişkenin `if` gövdesinde yükseltilmesini istiyorsanız, `??` yerine açık bir `!= null` kontrolü kullanmak daha iyidir.

### **AVOID** ilklenip ilklenmediğini kontrol etmeniz gerekiyorsa `late` değişkenlerden kaçının

Dart, bir `late` değişkenin ilklenip ilklenmediğini veya ona atama yapılıp yapılmadığını anlamak için bir yol sunmaz. Ona erişirseniz, ya (varsa) ilkleyiciyi hemen çalıştırır ya da bir istisna fırlatır. Bazen tembel (lazy) ilklenen bir durumunuz vardır ve `late` uygun olabilir, ama ilklemenin gerçekleşip gerçekleşmediğini *anlamanız* da gerekir.

Değişkeni bir `late` değişkende saklayıp, değişkenin ayarlanıp ayarlanmadığını izleyen ayrı bir boolean alanı tutarak ilklemeyi tespit edebilirsiniz; ancak bu gereksizdir, çünkü Dart `late` değişkenin ilklenme durumunu *dahili olarak* tutar. Bunun yerine genellikle değişkeni `late` olmayan ve null atanabilir yapmak daha nettir. Bu durumda değişkenin ilklenip ilklenmediğini `null` kontrolü yaparak görebilirsiniz.

Elbette, `null` değişken için geçerli bir ilklenmiş değer ise, ayrı bir boolean alanı tanımlamak mantıklı olabilir.

### **CONSIDER** null atanabilir türleri kullanmak için tür yükseltmesini veya null kontrolü desenlerini değerlendirin

Null atanabilir bir değişkenin `null`'a eşit olmadığını kontrol etmek, değişkeni null atanamayan bir türe yükseltir. Bu, değişkenin üyelerine erişmenize ve onu null atanamayan bir tür bekleyen fonksiyonlara geçirmenize olanak tanır.

Ancak tür yükseltmesi yalnızca yerel değişkenler, parametreler ve özel `final` alanlar için desteklenir. Dışarıdan değiştirilebilen değerler tür olarak yükseltilemez.

Üyeleri, genel olarak önerdiğimiz gibi özel ve `final` olarak bildirmek, bu sınırlamaları aşmak için çoğu zaman yeterlidir. Ancak bu her zaman bir seçenek değildir.

Tür yükseltme sınırlamalarını aşmak için bir yol, bir null kontrolü deseni kullanmaktır. Bu, üyenin değerinin null olmadığını doğrular ve bu değeri aynı temel türde yeni bir null atanamayan değişkene bağlar.

```dart
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (this.response case var response?) {
      return 'Could not complete upload to ${response.url} '
          '(error code ${response.errorCode}): ${response.reason}.';
    }
    return 'Could not upload (no response).';
  }
}
```

Başka bir çözüm, alanın değerini bir yerel değişkene atamaktır. Bu yerel değişken üzerindeki null kontrolleri tür yükseltmesi yapar, böylece onu güvenle null atanamaz olarak kullanabilirsiniz.

```dart
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    final response = this.response;
    if (response != null) {
      return 'Could not complete upload to ${response.url} '
          '(error code ${response.errorCode}): ${response.reason}.';
    }
    return 'Could not upload (no response).';
  }
}
```

Yerel değişkeni kullanırken dikkatli olun. Alana geri yazmanız gerekiyorsa, yerel değişkene değil alana yazdığınızdan emin olun. (Yerel değişkeni `final` yapmak bu tür hataları önleyebilir.) Ayrıca, yerel değişken kapsamdayken alan değişebilirse, yerel değişken eski bir değer tutabilir.

Bazen alan üzerinde doğrudan `!` kullanmak en iyisidir. Ancak bazı durumlarda, değeri her seferinde null olmayan olarak kullanmak için `!` kullanmaktansa, yerel bir değişken veya bir null kontrolü deseni daha temiz ve güvenli olabilir:

```dart
class UploadException {
  final Response? response;

  UploadException([this.response]);

  @override
  String toString() {
    if (response != null) {
      return 'Could not complete upload to ${response!.url} '
          '(error code ${response!.errorCode}): ${response!.reason}.';
    }

    return 'Could not upload (no response).';
  }
}
```

## Dizeler

Dart'ta dizeleri oluştururken aklınızda tutmanız gereken bazı en iyi uygulamalar şunlardır.

### **DO** dize sabitlerini birleştirmek için yan yana dizeler kullanın

Linter kuralı: prefer_adjacent_string_concatenation

İki dize sabitiniz varsa (değerler değil, tırnak içindeki gerçek sabit biçimi), bunları birleştirmek için `+` kullanmanız gerekmez. C ve C++'ta olduğu gibi, yan yana koymak yeterlidir. Tek satıra sığmayan uzun bir dize oluşturmanın iyi bir yoludur.

```dart
raiseAlarm(
  'ERROR: Parts of the spaceship are on fire. Other '
  'parts are overrun by martians. Unclear which are which.',
);
```

```dart
raiseAlarm(
  'ERROR: Parts of the spaceship are on fire. Other ' +
      'parts are overrun by martians. Unclear which are which.',
);
```

### **PREFER** dizeleri ve değerleri birleştirmek için interpolasyon kullanmayı tercih edin

Linter kuralı: prefer_interpolation_to_compose_strings

Diğer dillerden geliyorsanız, sabitlerden ve diğer değerlerden bir dize oluşturmak için uzun `+` zincirleri kullanmaya alışkın olabilirsiniz. Bu Dart'ta da çalışır, ancak neredeyse her zaman interpolasyon kullanmak daha temiz ve kısadır:

```dart
'Hello, $name! You are ${year - birth} years old.';
```

```dart
'Hello, ' + name + '! You are ' + (year - birth).toString() + ' y...';
```

Bu yönergenin *birden fazla* sabiti ve değeri birleştirmeye uyduğunu unutmayın. Yalnızca tek bir nesneyi dizeye dönüştürürken `.toString()` kullanmak sorun değildir.

### **AVOID** gerekmediğinde interpolasyonda süslü parantez kullanmaktan kaçının

Linter kuralı: unnecessary_brace_in_string_interps

Hemen ardından başka alfanümerik metin gelmeyen basit bir tanımlayıcıyı interpole ediyorsanız, `{}` kullanılmamalıdır.

```dart
var greeting = 'Hi, $name! I love your ${decade}s costume.';
```

```dart
var greeting = 'Hi, ${name}! I love your ${decade}s costume.';
```

## Koleksiyonlar

Dart varsayılan olarak dört koleksiyon türünü destekler: listeler, haritalar, kuyruklar ve kümeler. Aşağıdaki en iyi uygulamalar koleksiyonlara uygulanır.

### **DO** mümkün olduğunda koleksiyon sabitleri (literal) kullanın

Linter kuralı: prefer_collection_literals

Dart'ın üç temel koleksiyon türü vardır: List, Map ve Set. Map ve Set sınıfları, çoğu sınıf gibi adsız constructor'lara sahiptir. Ancak bu koleksiyonlar çok sık kullanıldığı için, Dart bunları oluşturmak için daha güzel bir yerleşik sözdizimi sunar:

```dart
var points = <Point>[];
var addresses = <String, Address>{};
var counts = <int>{};
```

```dart
var addresses = Map<String, Address>();
var counts = Set<int>();
```

Bu yönergenin bu sınıfların *adlandırılmış* constructor'ları için geçerli olmadığını unutmayın. `List.from()`, `Map.fromIterable()` ve benzerlerinin tümünün kullanım alanları vardır. (List sınıfının da adsız bir constructor'ı vardır, ancak bu null güvenli Dart'ta yasaklanmıştır.)

Koleksiyon sabitleri Dart'ta özellikle güçlüdür, çünkü diğer koleksiyonların içeriğini eklemek için yayma (spread) operatörüne ve içerik oluştururken kontrol akışı yapmak için `if` ve `for` kullanmanıza olanak tanır:

```dart
var arguments = [
  ...options,
  command,
  ...?modeFlags,
  for (var path in filePaths)
    if (path.endsWith('.dart')) path.replaceAll('.dart', '.js'),
];
```

```dart
var arguments = <String>[];
arguments.addAll(options);
arguments.add(command);
if (modeFlags != null) arguments.addAll(modeFlags);
arguments.addAll(
  filePaths
      .where((path) => path.endsWith('.dart'))
      .map((path) => path.replaceAll('.dart', '.js')),
);
```

### **DON'T** bir koleksiyonun boş olup olmadığını anlamak için `.length` kullanmayın

Linter kuralları: prefer_is_empty, prefer_is_not_empty

Iterable sözleşmesi, bir koleksiyonun uzunluğunu bilmesini veya bunu sabit zamanda sağlayabilmesini gerektirmez. Bir koleksiyonun *herhangi bir şey* içerip içermediğini anlamak için `.length` çağırmak çok yavaş olabilir.

Bunun yerine daha hızlı ve daha okunabilir olan `.isEmpty` ve `.isNotEmpty` getter'larını kullanın. Sonucu olumsuzlamayı gerektirmeyeni kullanın.

```dart
if (lunchBox.isEmpty) return 'so hungry...';
if (words.isNotEmpty) return words.join(' ');
```

```dart
if (lunchBox.length == 0) return 'so hungry...';
if (!words.isEmpty) return words.join(' ');
```

### **AVOID** fonksiyon sabiti ile `Iterable.forEach()` kullanmaktan kaçının

Linter kuralı: avoid_function_literals_in_foreach_calls

`forEach()` fonksiyonları JavaScript'te yaygın olarak kullanılır, çünkü yerleşik `for-in` döngüsü genellikle istediğiniz şeyi yapmaz. Dart'ta bir dizi üzerinde yineleme yapmak istiyorsanız, deyimsel yol bir döngü kullanmaktır.

```dart
for (final person in people) {
  ...
}
```

```dart
people.forEach((person) {
  ...
});
```

Bu yönergenin özellikle "fonksiyon *sabiti*" dediğini unutmayın. Her öğe üzerinde *zaten var olan* bir fonksiyonu çağırmak istiyorsanız, `forEach()` kullanmak sorun değildir.

```dart
people.forEach(print);
```

Ayrıca `Map.forEach()` kullanmanın her zaman uygun olduğunu unutmayın. Haritalar yinelenebilir olmadığı için bu yönerge onlara uygulanmaz.

### **DON'T** sonucun türünü değiştirmek istemediğiniz sürece `List.from()` kullanmayın

Bir Iterable verildiğinde, aynı öğeleri içeren yeni bir List üretmenin iki belirgin yolu vardır:

```dart
var copy1 = iterable.toList();
var copy2 = List.from(iterable);
```

Bariz fark, birincisinin daha kısa olmasıdır. *Önemli* fark ise birincisinin orijinal nesnenin tür argümanını korumasıdır:

```dart
// List<int> oluşturur:
var iterable = [1, 2, 3];

// "List<int>" yazdırır:
print(iterable.toList().runtimeType);
```

```dart
// List<int> oluşturur:
var iterable = [1, 2, 3];

// "List<dynamic>" yazdırır:
print(List.from(iterable).runtimeType);
```

Türü *değiştirmek* istiyorsanız, `List.from()` çağırmak kullanışlıdır:

```dart
var numbers = [1, 2.3, 4]; // List<num> türünde.
numbers.removeAt(1); // Artık yalnızca tam sayılar içeriyor.
var ints = List<int>.from(numbers);
```

Ancak amacınız yalnızca bir Iterable'ı kopyalamak ve orijinal türünü korumaksa veya tür sizin için önemli değilse, `toList()` kullanın.

### **DO** bir koleksiyonu türüne göre filtrelemek için `whereType()` kullanın

Linter kuralı: prefer_iterable_whereType

Diyelim ki karışık nesneler içeren bir listeniz var ve içinden yalnızca tam sayıları almak istiyorsunuz. Şöyle `where()` kullanabilirsiniz:

```dart
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int);
```

Bu ayrıntılıdır, ama daha kötüsü, dönen iterable'ın büyük olasılıkla istediğiniz türde olmamasıdır. Buradaki örnekte, filtrelediğiniz tür `Iterable<int>` olmasına rağmen `Iterable<Object>` döner.

Bazen yukarıdaki hatayı `cast()` ekleyerek "düzelten" kod görürsünüz:

```dart
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.where((e) => e is int).cast<int>();
```

Bu ayrıntılıdır ve iki sarmalayıcı oluşturur; iki katman dolaylılık ve gereksiz çalışma zamanı denetimi ekler. Neyse ki, çekirdek kütüphane tam bu kullanım durumu için `whereType()` metodunu sunar:

```dart
var objects = [1, 'a', 2, 'b', 3];
var ints = objects.whereType<int>();
```

`whereType()` kullanmak kısadır, istenen türde bir Iterable üretir ve gereksiz sarmalama katmanları içermez.

### **DON'T** yakındaki bir işlem yeterli olduğunda `cast()` kullanmayın

Bir iterable veya stream ile çalışırken çoğu zaman üzerinde birkaç dönüşüm uygularsınız. Sonunda belirli bir tür argümanına sahip bir nesne üretmek istersiniz. `cast()` çağrısı eklemek yerine, mevcut dönüşümlerden birinin türü değiştirip değiştiremeyeceğine bakın.

Zaten `toList()` çağırıyorsanız, bunu istediğiniz sonuç listesinin türü olan `T` ile `List<T>.from()` çağrısıyla değiştirin.

```dart
var stuff = <dynamic>[1, 2];
var ints = List<int>.from(stuff);
```

```dart
var stuff = <dynamic>[1, 2];
var ints = stuff.toList().cast<int>();
```

`map()` çağırıyorsanız, istenen türde bir iterable üretmesi için ona açık bir tür argümanı verin. Tür çıkarımı, `map()`'e geçirdiğiniz fonksiyona göre çoğu zaman doğru türü seçer, ancak bazen açık olmanız gerekir.

```dart
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map<double>((n) => n * 2);
```

```dart
var stuff = <dynamic>[1, 2];
var reciprocals = stuff.map((n) => n * 2).cast<double>();
```

### **AVOID** `cast()` kullanmaktan kaçının

Bu, önceki kuralın daha yumuşak bir genellemesidir. Bazen bir nesnenin türünü düzeltmek için kullanabileceğiniz yakın bir işlem olmaz. Yine de mümkün olduğunda, bir koleksiyonun türünü "değiştirmek" için `cast()` kullanmaktan kaçının.

Bunun yerine şu seçeneklerden birini tercih edin:

- **Doğru türle oluşturun.** Koleksiyonun ilk oluşturulduğu kodu, doğru türe sahip olacak şekilde değiştirin.
- **Öğeleri erişimde cast edin.** Koleksiyon üzerinde hemen yineleme yapıyorsanız, her öğeyi yineleme içinde cast edin.
- **`List.from()` ile hemen cast edin.** Koleksiyondaki öğelerin çoğuna sonunda erişecekseniz ve nesnenin orijinal canlı nesne tarafından desteklenmesine ihtiyacınız yoksa, `List.from()` ile dönüştürün. `cast()` metodu, *her işlemde* öğe türünü kontrol eden tembel bir koleksiyon döndürür. Yalnızca birkaç öğe üzerinde birkaç işlem yapıyorsanız, bu tembellik iyi olabilir. Ancak çoğu durumda, tembel doğrulama ve sarmalamanın ek yükü faydalarından daha ağır basar.

**Doğru türle oluşturmaya** bir örnek:

```dart
List<int> singletonList(int value) {
  var list = <int>[];
  list.add(value);
  return list;
}
```

```dart
List<int> singletonList(int value) {
  var list = []; // List<dynamic> türünde.
  list.add(value);
  return list.cast<int>();
}
```

**Öğeleri erişimde cast etmeye** bir örnek:

```dart
void printEvens(List<Object> objects) {
  // Listenin yalnızca int içerdiğini biliyoruz.
  for (final n in objects) {
    if ((n as int).isEven) print(n);
  }
}
```

```dart
void printEvens(List<Object> objects) {
  // Listenin yalnızca int içerdiğini biliyoruz.
  for (final n in objects.cast<int>()) {
    if (n.isEven) print(n);
  }
}
```

**`List.from()` ile hemen cast etmeye** bir örnek:

```dart
int median(List<Object> objects) {
  // Listenin yalnızca int içerdiğini biliyoruz.
  var ints = List<int>.from(objects);
  ints.sort();
  return ints[ints.length ~/ 2];
}
```

```dart
int median(List<Object> objects) {
  // Listenin yalnızca int içerdiğini biliyoruz.
  var ints = objects.cast<int>();
  ints.sort();
  return ints[ints.length ~/ 2];
}
```

Bu alternatifler her zaman işe yaramaz elbette ve bazen `cast()` doğru cevaptır. Ancak bu metodu biraz riskli ve istenmeyen olarak değerlendirin; dikkatli olmazsanız yavaş olabilir ve çalışma zamanında başarısız olabilir.

## Fonksiyonlar

Dart'ta fonksiyonlar bile nesnedir. Fonksiyonlarla ilgili bazı en iyi uygulamalar şunlardır.

### **DO** bir fonksiyonu bir ada bağlamak için fonksiyon bildirimi kullanın

Linter kuralı: prefer_function_declarations_over_variables

Modern diller, yerel iç içe fonksiyonların ve closure'ların ne kadar kullanışlı olduğunu fark etti. Bir fonksiyonun başka bir fonksiyonun içinde tanımlanması yaygındır. Birçok durumda bu fonksiyon hemen bir callback olarak kullanılır ve bir ada ihtiyaç duymaz. Bu durum için bir fonksiyon ifadesi mükemmeldir.

Ancak ona bir ad vermeniz gerekiyorsa, bir lambda'yı bir değişkene bağlamak yerine bir fonksiyon bildirim deyimi kullanın.

```dart
void main() {
  void localFunction() {
    ...
  }
}
```

```dart
void main() {
  var localFunction = () {
    ...
  };
}
```

### **DON'T** tear-off yeterli olduğunda lambda oluşturmayın

Linter kuralı: unnecessary_lambdas

Bir fonksiyona, metoda veya adlandırılmış constructor'a parantez olmadan başvurduğunuzda Dart bir *tear-off* oluşturur. Bu, fonksiyonla aynı parametreleri alan ve siz çağırdığınızda temel fonksiyonu çağıran bir closure'dır. Kodunuz, closure'ın kabul ettiği parametrelerle aynı parametrelere sahip adlandırılmış bir fonksiyonu çağıran bir closure gerektiriyorsa, çağrıyı bir lambda ile sarmalamayın. Tear-off kullanın.

```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();

// Fonksiyon:
charCodes.forEach(print);

// Metot:
charCodes.forEach(buffer.write);

// Adlandırılmış constructor:
var strings = charCodes.map(String.fromCharCode);

// Adsız constructor:
var buffers = charCodes.map(StringBuffer.new);
```

```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();

// Fonksiyon:
charCodes.forEach((code) {
  print(code);
});

// Metot:
charCodes.forEach((code) {
  buffer.write(code);
});

// Adlandırılmış constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Adsız constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```

## Değişkenler

Aşağıdaki en iyi uygulamalar Dart'ta değişkenleri en iyi şekilde nasıl kullanacağınızı açıklar.

### **DO** yerel değişkenlerde `var` ve `final` için tutarlı bir kural izleyin

Yerel değişkenlerin çoğunun tür açıklaması olmamalı ve yalnızca `var` veya `final` ile bildirilmelidir. Hangisini ne zaman kullanacağınız konusunda yaygın olarak kullanılan iki kural vardır:

- Yeniden atanmayan yerel değişkenler için `final`, yeniden atananlar için `var` kullanın.
- Yeniden atanmasa bile tüm yerel değişkenler için `var` kullanın. Yerel değişkenlerde asla `final` kullanmayın. (Alanlar ve üst düzey değişkenler için `final` kullanımı yine de teşvik edilir, elbette.)

İki kuraldan biri de kabul edilebilir, ama birini seçin ve kodunuz boyunca tutarlı biçimde uygulayın. Böylece bir okuyucu `var` gördüğünde, değişkenin fonksiyonda daha sonra atanıp atanmadığını anlar.

### **AVOID** hesaplayabileceğiniz değerleri saklamaktan kaçının

Bir sınıf tasarlarken, aynı temel duruma birden fazla görünüm sunmak isteyebilirsiniz. Sık sık tüm bu görünümleri constructor'da hesaplayıp sonra saklayan kod görürsünüz:

```dart
class Circle {
  double radius;
  double area;
  double circumference;

  Circle(double radius)
    : radius = radius,
      area = pi * radius * radius,
      circumference = pi * 2.0 * radius;
}
```

Bu kodda iki sorun var. Birincisi, muhtemelen bellek israf ediyor. Alan ve çevre, kesin olarak *önbelleklerdir*. Zaten sahip olduğumuz diğer verilerden yeniden hesaplayabileceğimiz saklanmış hesaplamalardır. Artan bellek kullanımını azalan CPU kullanımıyla takas ediyorlar. Bu takasın gerekli olduğu bir performans sorunumuz olduğunu biliyor muyuz?

Daha da kötüsü, kod *yanlış*. Önbelleklerin sorunu *geçersiz kılma*dır: önbelleğin ne zaman güncel olmadığını ve yeniden hesaplanması gerektiğini nereden bileceksiniz? Burada hiçbir zaman bilmiyoruz, `radius` değiştirilebilir olmasına rağmen. Farklı bir değer atayabilirsiniz ve `area` ile `circumference` önceki, artık yanlış değerlerini korur.

Önbellek geçersiz kılmayı doğru yönetmek için şunu yapmamız gerekir:

```dart
class Circle {
  double _radius;
  double get radius => _radius;
  set radius(double value) {
    _radius = value;
    _recalculate();
  }

  double _area = 0.0;
  double get area => _area;

  double _circumference = 0.0;
  double get circumference => _circumference;

  Circle(this._radius) {
    _recalculate();
  }

  void _recalculate() {
    _area = pi * _radius * _radius;
    _circumference = pi * 2.0 * _radius;
  }
}
```

Yazılması, sürdürülmesi, hata ayıklanması ve okunması gereken çok fazla kod. Bunun yerine ilk uygulamanız şu olmalıdır:

```dart
class Circle {
  double radius;

  Circle(this.radius);

  double get area => pi * radius * radius;
  double get circumference => pi * 2.0 * radius;
}
```

Bu kod daha kısadır, daha az bellek kullanır ve hataya daha az açıktır. Dairenin temsil edilmesi için gereken en az miktarda veriyi saklar. Senkronizasyonu bozulabilecek alan yoktur, çünkü yalnızca tek bir gerçek kaynak vardır.

Bazı durumlarda yavaş bir hesaplamanın sonucunu önbelleğe almanız gerekebilir, ancak bunu yalnızca bir performans sorununuz olduğunu bildiğinizde yapın, dikkatli yapın ve optimizasyonu açıklayan bir yorum bırakın.

## Üyeler

Dart'ta nesnelerin, fonksiyon (metot) veya veri (örnek değişkenleri) olabilen üyeleri vardır. Aşağıdaki en iyi uygulamalar bir nesnenin üyelerine uygulanır.

### **DON'T** gereksiz yere bir alanı getter ve setter ile sarmalayın

Linter kuralı: unnecessary_getters_setters

Java ve C#'ta, tüm alanları getter ve setter'ların arkasına gizlemek yaygındır (C#'ta property), bu getter ve setter'lar yalnızca alana yönlendirme yapsa bile. Böylece, o üyelerde daha fazla iş yapmanız gerekirse, çağrı noktalarına dokunmadan bunu yapabilirsiniz. Bunun nedeni, Java'da getter metodu çağırmanın bir alana erişmekten farklı olması ve C#'ta property'ye erişmenin ham bir alana erişmekle ikili uyumlu olmamasıdır.

Dart'ta bu sınırlama yoktur. Alanlar ile getter/setter'lar tamamen ayırt edilemezdir. Bir sınıfta bir alanı dışa açabilir ve daha sonra onu getter ve setter ile sarmalayabilirsiniz; bu alanı kullanan hiçbir koda dokunmanız gerekmez.

```dart
class Box {
  Object? contents;
}
```

```dart
class Box {
  Object? _contents;
  Object? get contents => _contents;
  set contents(Object? value) {
    _contents = value;
  }
}
```

### **PREFER** salt okunur bir özellik oluşturmak için `final` alan kullanmayı tercih edin

Dış kodun görmesi ama atama yapamaması gereken bir alanınız varsa, birçok durumda işe yarayan basit bir çözüm, onu `final` olarak işaretlemektir.

```dart
class Box {
  final contents = [];
}
```

```dart
class Box {
  Object? _contents;
  Object? get contents => _contents;
}
```

Elbette, alanı constructor dışında dahili olarak atamanız gerekiyorsa, "özel alan, genel getter" desenini kullanmanız gerekebilir; ancak buna ihtiyaç duyana kadar başvurmayın.

### **CONSIDER** basit üyeler için `=>` kullanmayı değerlendirin

Linter kuralı: prefer_expression_function_bodies

Fonksiyon ifadeleri için `=>` kullanmanın yanı sıra, Dart üyeleri de onunla tanımlamanıza izin verir. Bu stil, yalnızca bir değer hesaplayıp döndüren basit üyeler için uygundur.

```dart
double get area => (right - left) * (bottom - top);

String capitalize(String name) =>
    '${name[0].toUpperCase()}${name.substring(1)}';
```

İnsanlar kod *yazarken* `=>` kullanmayı çok sever, ama onu kötüye kullanıp *okuması* zor kod üretmek çok kolaydır. Bildiriminiz birkaç satırdan uzunsa veya derinlemesine iç içe ifadeler içeriyorsa (zincirleme çağrılar ve koşullu operatörler sık görülen suçlulardır), kendinize ve kodunuzu okuması gereken herkese bir iyilik yapın: bir blok gövde ve birkaç deyim kullanın.

```dart
Treasure? openChest(Chest chest, Point where) {
  if (_opened.containsKey(chest)) return null;

  var treasure = Treasure(where);
  treasure.addAll(chest.contents);
  _opened[chest] = treasure;
  return treasure;
}
```

```dart
Treasure? openChest(Chest chest, Point where) => _opened.containsKey(chest)
    ? null
    : _opened[chest] = (Treasure(where)..addAll(chest.contents));
```

`=>` kullanımını bir değer döndürmeyen üyelerde de kullanabilirsiniz. Bir setter küçük ise ve `=>` kullanan bir getter'a karşılık geliyorsa, bu deyimseldir.

```dart
num get x => center.x;
set x(num value) => center = Point(value, center.y);
```

### **DON'T** adlandırılmış bir constructor'a yönlendirmek veya gölgelemeyi önlemek dışında `this.` kullanmayın

Linter kuralı: unnecessary_this

JavaScript, o anda çalışan metodun ait olduğu nesnenin üyelerine başvurmak için açık bir `this.` gerektirir. Ancak Dart, C++, Java ve C# gibi, bu sınırlamaya sahip değildir.

`this.` kullanmanız gereken yalnızca iki durum vardır. Biri, erişmek istediğiniz üyeyi aynı adlı bir yerel değişkenin gölgelemesi durumudur:

```dart
class Box {
  Object? value;

  void clear() {
    this.update(null);
  }

  void update(Object? value) {
    this.value = value;
  }
}
```

```dart
class Box {
  Object? value;

  void clear() {
    update(null);
  }

  void update(Object? value) {
    this.value = value;
  }
}
```

Diğer durum, adlandırılmış bir constructor'a yönlendirirken `this.` kullanmanızdır:

```dart
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // Bu ayrıştırılamaz veya derlenemez!
  // ShadeOfGray.alsoBlack() : black();
}
```

```dart
class ShadeOfGray {
  final int brightness;

  ShadeOfGray(int val) : brightness = val;

  ShadeOfGray.black() : this(0);

  // Ama şimdi derlenir!
  ShadeOfGray.alsoBlack() : this.black();
}
```

Constructor parametrelerinin, constructor başlatıcı listelerindeki alanları asla gölgelemediğini unutmayın:

```dart
class Box extends BaseBox {
  Object? value;

  Box(Object? value) : value = value, super(value);
}
```

Bu şaşırtıcı görünür, ama istediğiniz gibi çalışır. Neyse ki, ilkleyici formal parametreler ve super başlatıcılar sayesinde bu tür kod nadirdir.

### **DO** mümkün olduğunda alanları bildirildikleri yerde ilklendirin

Bir alan hiçbir constructor parametresine bağlı değilse, bildirildiği yerde ilklenebilir ve ilklenmelidir. Bu daha az kod gerektirir ve sınıf birden fazla constructor'a sahip olduğunda tekrarı önler.

```dart
class ProfileMark {
  final String name;
  final DateTime start;

  ProfileMark(this.name) : start = DateTime.now();
  ProfileMark.unnamed() : name = '', start = DateTime.now();
}
```

```dart
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

Bazı alanlar, örneğin diğer alanları kullanmak veya metot çağırmak için `this`'e başvurmaları gerektiğinden bildirimlerinde ilklenemez. Ancak alan `late` olarak işaretlenmişse, ilkleyici `this`'e erişebilir.

Elbette, bir alan constructor parametrelerine bağlıysa veya farklı constructor'lar tarafından farklı şekilde ilkleniyorsa, bu yönerge geçerli değildir.

## Constructor'lar

Aşağıdaki en iyi uygulamalar bir sınıf için constructor tanımlamaya uygulanır.

### **DO** mümkün olduğunda ilkleyici formal parametreler kullanın

Linter kuralı: prefer_initializing_formals

Birçok alan, doğrudan bir constructor parametresinden ilklenir, örneğin:

```dart
class Point {
  double x, y;
  Point(double x, double y) : x = x, y = y;
}
```

Burada bir alan tanımlamak için `x`'i *dört* kez yazmamız gerekiyor. Daha iyisini yapabiliriz:

```dart
class Point {
  double x, y;
  Point(this.x, this.y);
}
```

Constructor parametresinin önündeki bu `this.` sözdizimine "ilkleyici formal parametre" denir. Her zaman kullanamazsınız. Bazen, ilklediğiniz alanın adıyla eşleşmeyen adlandırılmış bir parametre istersiniz. Ama ilkleyici formal parametreleri *kullanabildiğiniz* zaman, kullanmanız *gerekir*.

### **DON'T** constructor başlatıcı listesi yeterli olduğunda `late` kullanmayın

Dart, null atanamayan alanların okunmadan önce ilklenmesini zorunlu kılar. Alanlar constructor gövdesinde okunabildiğinden, bu, gövde çalışmadan önce null atanamayan bir alanı ilklemezseniz bir hata alacağınız anlamına gelir.

Alanı `late` olarak işaretleyerek bu hatayı kaldırabilirsiniz. Bu, alan ilklenmeden önce erişirseniz derleme zamanı hatasını *çalışma zamanı* hatasına dönüştürür. Bazı durumlarda ihtiyacınız olan budur, ancak çoğu zaman doğru çözüm, alanı constructor başlatıcı listesinde ilklemektir:

```dart
class Point {
  double x, y;
  Point.polar(double theta, double radius)
    : x = cos(theta) * radius,
      y = sin(theta) * radius;
}
```

```dart
class Point {
  late double x, y;
  Point.polar(double theta, double radius) {
    x = cos(theta) * radius;
    y = sin(theta) * radius;
  }
}
```

Başlatıcı listesi, constructor parametrelerine erişmenizi sağlar ve alanlar okunmadan önce ilklemenize olanak tanır. Bu nedenle, başlatıcı listesi kullanmak mümkünse, alanı `late` yapıp biraz statik güvenlikten ve performanstan ödün vermekten daha iyidir.

### **DO** boş constructor gövdeleri için `{}` yerine `;` kullanın

Linter kuralı: empty_constructor_bodies

Dart'ta boş gövdeye sahip bir constructor yalnızca noktalı virgülle sonlandırılabilir. (Aslında const constructor'lar için bu zorunludur.)

```dart
class Point {
  double x, y;
  Point(this.x, this.y);
}
```

```dart
class Point {
  double x, y;
  Point(this.x, this.y) {}
}
```

### **PREFER** kısa constructor sözdizimini kullanmayı tercih edin

Linter kuralı: unnecessary_type_name_in_constructor

Sınıf gövdesi içinde constructor bildirirken, sınıf adını tekrarlamak yerine kısa constructor sözdizimini kullanın. Factory constructor'lar için `factory`, diğer tüm constructor'lar için `new` kullanın.

Kısa sözdizimi biçimlerinin tam bir başvurusu için kısa constructor sözdizimi tablosuna bakın.

Bu yönerge yalnızca, kısa constructor sözdiziminin mevcut olduğu 3.13 veya üzeri bir dil sürümüne sahip kütüphaneler için geçerlidir.

```dart
class Logger {
  final String name;

  factory(String name) => _cache[name] ??= Logger._internal(name);

  new _internal(this.name);
  new fromJson(Map<String, Object?> json) : name = json['name'] as String;

  static final Map<String, Logger> _cache = {};
}
```

```dart
class Logger {
  final String name;

  factory Logger(String name) => _cache[name] ??= Logger._internal(name);

  Logger._internal(this.name);
  Logger.fromJson(Map<String, Object?> json) : name = json['name'] as String;

  static final Map<String, Logger> _cache = {};
}
```

Sınıf adını tekrarlamak gereksizdir ve sınıf yeniden adlandırılırsa yeniden düzenlemeyi zorlaştırır. `new` ve `factory` kullanmak constructor bildirimlerini kısa ve tutarlı tutar.

Bu yönerge yalnızca constructor *bildirimlerine* uygulanır. Constructor *çağrıları* için, `new` kullanmayın yönergesine bakın.

### **DON'T** `new` kullanmayın

Linter kuralı: unnecessary_new

Bir constructor çağırırken `new` anahtar sözcüğü isteğe bağlıdır. Anlamı açık değildir, çünkü factory constructor'lar nedeniyle bir `new` çağrısı aslında yeni bir nesne döndürmeyebilir.

Dil hâlâ `new` kullanımına izin verir, ancak bunu artık kullanılmayan (deprecated) kabul edin ve kodunuzda kullanmaktan kaçının.

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      RaisedButton(child: Text('Increment')),
      Text('Click!'),
    ],
  );
}
```

```dart
Widget build(BuildContext context) {
  return new Row(
    children: [
      new RaisedButton(child: new Text('Increment')),
      new Text('Click!'),
    ],
  );
}
```

### **DON'T** `const` anahtar sözcüğünü gereksiz yere kullanmayın

Linter kuralı: unnecessary_const

Bir ifadenin *mutlaka* sabit olması gereken bağlamlarda `const` anahtar sözcüğü örtüktür, yazılmasına gerek yoktur ve yazılmamalıdır. Bu bağlamlar şunların içindeki herhangi bir ifadedir:

- Bir const koleksiyon sabiti.
- Bir const constructor çağrısı.
- Bir metadata açıklaması (annotation).
- Bir const değişken bildiriminin ilkleyicisi.
- Bir switch case ifadesi: `case`'den sonra ve `:`'den önceki kısım, case gövdesi değil.

(Varsayılan değerler bu listeye dahil edilmemiştir, çünkü Dart'ın gelecek sürümleri const olmayan varsayılan değerleri destekleyebilir.)

Temel olarak, `const` yerine `new` yazmanın hata olacağı her yerde Dart, `const` anahtar sözcüğünü yazmanıza gerek bırakmaz.

```dart
const primaryColors = [
  Color('red', [255, 0, 0]),
  Color('green', [0, 255, 0]),
  Color('blue', [0, 0, 255]),
];
```

```dart
const primaryColors = const [
  const Color('red', const [255, 0, 0]),
  const Color('green', const [0, 255, 0]),
  const Color('blue', const [0, 0, 255]),
];
```

## Hata yönetimi

Dart, programınızda bir hata oluştuğunda istisnaları kullanır. Aşağıdaki en iyi uygulamalar istisnaları yakalama ve fırlatma ile ilgilidir.

### **AVOID** `on` yan tümcesi olmayan catch bloklarından kaçının

Linter kuralı: avoid_catches_without_on_clauses

`on` niteleyicisi olmayan bir catch yan tümcesi, try bloğundaki kodun fırlattığı *her şeyi* yakalar. Pokémon tarzı istisna yönetimi muhtemelen istediğiniz şey değildir. Kodunuz StackOverflowError veya OutOfMemoryError'ı doğru işliyor mu? O try bloğunda bir metoda yanlış argüman verirseniz, hata ayıklayıcınızın hatayı göstermesini mi istersiniz, yoksa yardımcı ArgumentError'ın yutulmasını mı istersiniz? Yakaladığınız AssertionError'lar nedeniyle o koddaki `assert()` ifadelerinin etkili biçimde yok olmasını ister misiniz?

Cevap muhtemelen "hayır"dır; bu durumda yakaladığınız türleri filtrelemelisiniz. Çoğu durumda, bildiğiniz ve doğru işlediğiniz çalışma zamanı hatalarının türüyle sınırlayan bir `on` yan tümcesi kullanmalısınız.

Nadir durumlarda, herhangi bir çalışma zamanı hatasını yakalamak isteyebilirsiniz. Bu genellikle, keyfi uygulama kodunu sorunlara yol açmaktan yalıtmaya çalışan framework veya düşük seviyeli kodda olur. Bu durumda bile, genellikle tüm türleri yakalamaktansa Exception yakalamak daha iyidir. Exception, tüm *çalışma zamanı* hatalarının temel sınıfıdır ve kodda *programatik* hataları gösteren hataları hariç tutar.

### **DON'T** `on` yan tümcesi olmayan catch bloklarındaki hataları yok saymayın

Kodun bir bölgesinden fırlatılabilecek *her şeyi* gerçekten yakalamanız gerektiğini düşünüyorsanız, yakaladığınızla *bir şey yapın*. Kaydedin (log), kullanıcıya gösterin veya yeniden fırlatın, ama sessizce yok saymayın.

### **DO** yalnızca programatik hatalar için `Error` arayüzünü uygulayan nesneleri fırlatın

Error sınıfı, *programatik* hatalar için temel sınıftır. Bu türde veya ArgumentError gibi alt arayüzlerinden birinde bir nesne fırlatıldığında, kodunuzda bir *hata* olduğu anlamına gelir. API'niz bir çağırana yanlış kullanıldığını bildirmek istediğinde, bir Error fırlatmak bu sinyali açıkça iletir.

Tersine, istisna kodda bir hata göstermeyen bir tür çalışma zamanı arızasıysa, Error fırlatmak yanıltıcıdır. Bunun yerine, çekirdek Exception sınıflarından birini veya başka bir türü fırlatın.

### **DON'T** `Error` veya onu uygulayan türleri açıkça yakalamayın

Linter kuralı: avoid_catching_errors

Bu, yukarıdakinden çıkar. Bir Error kodunuzdaki bir hatayı gösterdiği için, tüm çağrı yığınını sonlandırmalı, programı durdurmalı ve hatayı bulup düzeltebilmeniz için bir yığın izlemesi (stack trace) yazdırmalıdır.

Bu türdeki hataları yakalamak bu süreci bozar ve hatayı gizler. Bu istisnayı sonradan ele almak için hata işleme kodu *eklemek* yerine, onu fırlatılmasına neden olan kodu bulup düzeltin.

### **DO** yakalanan bir istisnayı yeniden fırlatmak için `rethrow` kullanın

Linter kuralı: use_rethrow_when_possible

Bir istisnayı yeniden fırlatmaya karar verirseniz, aynı istisna nesnesini `throw` ile fırlatmak yerine `rethrow` deyimini kullanmayı tercih edin. `rethrow`, istisnanın özgün yığın izlemesini korur. `throw` ise yığın izlemesini son fırlatılma konumuna sıfırlar.

```dart
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) throw e;
  handle(e);
}
```

```dart
try {
  somethingRisky();
} catch (e) {
  if (!canHandle(e)) rethrow;
  handle(e);
}
```

## Eşzamansızlık

Dart, eşzamansız programlamayı desteklemek için çeşitli dil özelliklerine sahiptir. Aşağıdaki en iyi uygulamalar eşzamansız kodlamaya uygulanır.

### **PREFER** ham Future'lar kullanmak yerine async/await tercih edin

Eşzamansız kod, Future gibi güzel bir soyutlama kullanılsa bile okunması ve hata ayıklanması bilinen şekilde zor bir koddur. `async`/`await` sözdizimi okunabilirliği artırır ve eşzamansız kodunuzun içinde tüm Dart kontrol akışı yapılarını kullanmanıza olanak tanır.

```dart
Future<int> countActivePlayers(String teamName) async {
  try {
    var team = await downloadTeam(teamName);
    if (team == null) return 0;

    var players = await team.roster;
    return players.where((player) => player.isActive).length;
  } on DownloadException catch (e) {
    log.error(e);
    return 0;
  }
}
```

```dart
Future<int> countActivePlayers(String teamName) {
  return downloadTeam(teamName)
      .then((team) {
        if (team == null) return Future.value(0);

        return team.roster.then((players) {
          return players.where((player) => player.isActive).length;
        });
      })
      .onError<DownloadException>((e, _) {
        log.error(e);
        return 0;
      });
}
```

### **DON'T** faydalı bir etkisi olmadığında `async` kullanmayın

Eşzamansızlıkla ilgili herhangi bir şey yapan her fonksiyona `async` eklemek bir alışkanlık haline gelebilir. Ancak bazı durumlarda bu gereksizdir. Fonksiyonun davranışını değiştirmeden `async`'i çıkarabiliyorsanız, çıkarın.

```dart
Future<int> fastestBranch(Future<int> left, Future<int> right) {
  return Future.any([left, right]);
}
```

```dart
Future<int> fastestBranch(Future<int> left, Future<int> right) async {
  return Future.any([left, right]);
}
```

`async`'in *gerçekten* yararlı olduğu durumlar şunları içerir:

- `await` kullanıyorsunuz. (Bu en bariz olanıdır.)
- Hatayı eşzamansız olarak döndürüyorsunuz. `async` ve ardından `throw`, `return Future.error(...)`'dan daha kısadır.
- Bir değer döndürüyorsunuz ve bunun örtük olarak bir future içinde sarmalanmasını istiyorsunuz. `async`, `Future.value(...)`'dan daha kısadır.

```dart
Future<void> usesAwait(Future<String> later) async {
  print(await later);
}

Future<void> asyncError() async {
  throw 'Error!';
}

Future<String> asyncValue() async => 'value';
```

### **CONSIDER** bir Stream'i dönüştürmek için üst düzey (higher-order) metotları kullanmayı değerlendirin

Bu, yukarıdaki iterable önerisine paraleldir. Stream'ler, aynı metotların çoğunu destekler ve hataların iletilmesi, kapatma vb. işlemleri de doğru şekilde yönetir.

### **AVOID** `Completer`'ı doğrudan kullanmaktan kaçının

Eşzamansız programlamaya yeni başlayan birçok kişi, bir future üreten kod yazmak ister. Future'ın constructor'ları ihtiyaçlarına uymuyor gibi görünür, bu yüzden sonunda Completer sınıfını bulur ve onu kullanırlar.

```dart
Future<bool> fileContainsBear(String path) {
  var completer = Completer<bool>();

  File(path).readAsString().then((contents) {
    completer.complete(contents.contains('bear'));
  });

  return completer.future;
}
```

Completer, iki tür düşük seviyeli kod için gereklidir: yeni eşzamansız ilkeller ve future kullanmayan eşzamansız kodla arayüz oluşturma. Diğer çoğu kod, daha açık olduğu ve hata yönetimini kolaylaştırdığı için async/await veya `Future.then()` kullanmalıdır.

```dart
Future<bool> fileContainsBear(String path) {
  return File(path).readAsString().then((contents) {
    return contents.contains('bear');
  });
}
```

```dart
Future<bool> fileContainsBear(String path) async {
  var contents = await File(path).readAsString();
  return contents.contains('bear');
}
```

### **DO** tür argümanı `Object` olabilen bir `FutureOr<T>`'yi ayırt ederken `Future<T>` için test edin

Bir `FutureOr<T>` ile anlamlı bir şey yapabilmeden önce, genellikle bir `Future<T>` mi yoksa çıplak bir `T` mi olduğunu görmek için bir `is` kontrolü yapmanız gerekir. Tür argümanı `FutureOr<int>` gibi belirli bir tür ise, `is int` veya `is Future<int>` kullanmanızın bir önemi yoktur. İkisi de çalışır, çünkü bu iki tür ayrıktır.

Ancak değer türü `Object` veya `Object` ile somutlaştırılabilecek bir tür parametresi ise, iki dal çakışır. `Future<Object>` kendisi `Object`'i uygular; bu yüzden `is Object` veya `T`'nin `Object` ile somutlaştırılabilen bir tür parametresi olduğu `is T`, nesne bir future olsa bile true döner. Bunun yerine, `Future` durumunu açıkça test edin:

```dart
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is Future<T>) {
    var result = await value;
    print(result);
    return result;
  } else {
    print(value);
    return value;
  }
}
```

```dart
Future<T> logValue<T>(FutureOr<T> value) async {
  if (value is T) {
    print(value);
    return value;
  } else {
    var result = await value;
    print(result);
    return result;
  }
}
```

Kötü örnekte, `Future<Object>` verirseniz, bunu yanlışlıkla çıplak, senkron bir değer gibi ele alır.


---

# Effective Dart: Tasarım

Aşağıda, library'ler için tutarlı ve kullanışlı API'ler yazmaya yönelik bazı yönergeler yer almaktadır.

## İsimlendirme

İsimlendirme, okunabilir ve bakımı kolay kod yazmanın önemli bir parçasıdır. Aşağıdaki en iyi uygulamalar bu hedefe ulaşmanıza yardımcı olabilir.

### **DO** terimleri tutarlı kullanın

Kodunuzun her yerinde aynı şey için aynı ismi kullanın. API'nizin dışında, kullanıcıların muhtemelen bildiği bir kalıp (precedent) zaten varsa, bu kalıbı izleyin.

```dart
pageCount         // Bir alan.
updatePageCount() // pageCount ile tutarlı.
toSomething()     // Iterable'ın toList() metodu ile tutarlı.
asSomething()     // List'in asMap() metodu ile tutarlı.
Point             // Tanıdık bir kavram.
```

```dart
renumberPages()      // pageCount ile karıştırılacak kadar farklı.
convertToSomething() // toX() kalıbıyla tutarsız.
wrappedAsSomething() // asX() kalıbıyla tutarsız.
Cartesian            // Çoğu kullanıcının aşina olmadığı bir kavram.
```

Amaç, kullanıcının zaten bildiklerinden yararlanmaktır. Bu; problem alanına ilişkin bilgilerini, core library'lerin kurallarını ve API'nizin diğer bölümlerini kapsar. Bunların üzerine inşa ederek, verimli çalışmaya başlamadan önce kullanıcının edinmesi gereken yeni bilgi miktarını azaltırsınız.

### **AVOID** kısaltmalardan kaçının

Kısaltma, kısaltılmamış terimden daha yaygın değilse kısaltmayın. Kısaltma yaparsanız, büyük ve küçük harfleri doğru kullanın.

```dart
pageCount
buildRectangles
IOStream
HttpRequest
```

```dart
numPages    // "Num", "number (of)" ifadesinin kısaltmasıdır.
buildRects
InputOutputStream
HypertextTransferProtocolRequest
```

### **PREFER** en açıklayıcı ismi sona koymayı tercih edin

Son kelime, neyin ne olduğunu en iyi tanımlayan kelime olmalıdır. Öğeyi daha ayrıntılı tarif etmek için başına sıfat gibi başka kelimeler de ekleyebilirsiniz.

```dart
pageCount             // Bir sayı (sayfa sayısı).
ConversionSink        // Dönüşüm yapmak için bir sink.
ChunkedConversionSink // Parçalı bir ConversionSink.
CssFontFaceRule       // CSS'te yazı tipi yüzleri için bir kural.
```

```dart
numPages                  // Sayfa koleksiyonu değil.
CanvasRenderingContext2D  // "2D" değil.
RuleFontFaceCss           // CSS değil.
```

### **CONSIDER** kodun bir cümle gibi okunmasını sağlamayı düşünün

Adlandırma konusunda emin değilseniz, API'nizi kullanan bir kod yazın ve onu bir cümle gibi okumaya çalışın.

```dart
// "Eğer errors boşsa..."
if (errors.isEmpty) {
  // ...
}

// "Hey, subscription, iptal et!"
subscription.cancel();

// "Pençesi olan canavarları getir."
monsters.where((monster) => monster.hasClaws);
```

```dart
// errors'a kendini boşaltmasını mı söylüyoruz, yoksa boş olup olmadığını mı soruyoruz?
if (errors.empty) {
  // ...
}

// Neyi değiştiriyor? Neye?
subscription.toggle();

// Pençesi olan canavarları *dışarıda* mı bırakıyor, yoksa *yalnızca* onları mı içeriyor?
monsters.filter((monster) => monster.hasClaws);
```

API'nizi deneyip kodda nasıl "okunduğunu" görmek faydalıdır, ancak bunu abartabilirsiniz. İsimlerinizin dilbilgisi açısından doğru bir cümle gibi *kelimesi kelimesine* okunması için edatlar ve diğer sözcük türlerini eklemek yardımcı olmaz.

```dart
if (theCollectionOfErrors.isEmpty) {
  // ...
}

monsters.producesANewSequenceWhereEach((monster) => monster.hasClaws);
```

### **PREFER** boolean olmayan özellikler ve değişkenler için isim öbeği kullanmayı tercih edin

Okuyucunun odağı, özelliğin *ne* olduğudur. Kullanıcı, özelliğin *nasıl* belirlendiğini daha çok önemsiyorsa, bu muhtemelen fiil öbeği ismi taşıyan bir metot olmalıdır.

```dart
list.length
context.lineWidth
quest.rampagingSwampBeast
```

```dart
list.deleteItems
```

### **PREFER** boolean özellikler ve değişkenler için emir kipinde olmayan fiil öbeği kullanmayı tercih edin

Boolean isimler çoğunlukla kontrol akışında koşul olarak kullanılır; bu yüzden orada iyi okunan bir isim istersiniz. Karşılaştırın:

```dart
if (window.closeable) ...  // Sıfat.
if (window.canClose) ...   // Fiil.
```

İyi isimler genellikle birkaç tür fiille başlar:

- "Olmak" fiilinin bir biçimi: `isEnabled`, `wasShown`, `willFire`. Bunlar açık ara en yaygın olanlardır.
- Yardımcı fiil: `hasElements`, `canClose`, `shouldConsume`, `mustSave`.
- Etken fiil: `ignoresInput`, `wroteFile`. Bunlar genellikle belirsiz olduklarından nadirdir. `loggedResult` kötü bir isimdir; çünkü "bir sonucun loglanıp loglanmadığı" veya "loglanan sonuç" anlamına gelebilir. Benzer şekilde `closingConnection`, "bağlantının kapanıp kapanmadığı" veya "kapanmakta olan bağlantı" anlamına gelebilir. Etken fiillere, isim *yalnızca* bir predicate olarak okunabiliyorsa izin verilir.

Bu fiil öbeklerini metot isimlerinden ayıran şey, *emir kipinde* olmamalarıdır. Boolean bir isim, nesneye bir şeyi yapması için verilen bir komut gibi okunmamalıdır; çünkü bir özelliğe erişmek nesneyi değiştirmez. (Özellik nesneyi anlamlı bir şekilde *değiştiriyorsa*, bir metot olmalıdır.)

```dart
isEmpty
hasElements
canClose
closesWindow
canShowPopup
hasShownPopup
```

```dart
empty         // Sıfat mı, fiil mi?
withElements  // Öğe tutuyormuş gibi görünüyor.
closeable     // Bir arayüz gibi görünüyor.
              // "canClose" cümle olarak daha iyi okunuyor.
closingWindow // Bir bool mu, yoksa bir window mu döndürüyor?
showPopup     // Açılır pencereyi gösteriyormuş gibi görünüyor.
```

### **CONSIDER** adlandırılmış boolean *parametre* için fiili atmayı düşünün

Bu, önceki kuralı daha da inceltir. Boolean olan adlandırılmış parametrelerde fiil olmadan da isim genellikle yeterince açıktır ve kod çağrı noktasında daha iyi okunur.

```dart
Isolate.spawn(entryPoint, message, paused: false);
var copy = List.from(elements, growable: true);
var regExp = RegExp(pattern, caseSensitive: false);
```

### **PREFER** boolean bir özellik veya değişken için "olumlu" adı tercih edin

Çoğu boolean ismin kavramsal olarak "olumlu" ve "olumsuz" biçimleri vardır. Olumlu olan temel kavramdır, olumsuz olan ise onun olumsuzlamasıdır: "open" ve "closed", "enabled" ve "disabled" gibi. Çoğu zaman olumsuz isim, olumlu olanı olumsuzlayan bir önek taşır: "visible" ve "*in*-visible", "connected" ve "*dis*-connected", "zero" ve "*non*-zero".

`true` değerinin temsil ettiği iki durumdan hangisinin seçileceğine ve dolayısıyla özelliğin hangi duruma göre adlandırılacağına karar verirken olumlu veya daha temel olanı tercih edin. Boolean üyeler sıklıkla olumsuzlama operatörleri dahil mantıksal ifadelerin içinde kullanılır. Özelliğiniz kendisi bir olumsuzlama gibi okunuyorsa, okuyucunun çifte olumsuzlamayı zihninde çözüp kodun ne anlama geldiğini kavraması zorlaşır.

```dart
if (socket.isConnected && database.hasData) {
  socket.write(database.read());
}
```

```dart
if (!socket.isDisconnected && !database.isEmpty) {
  socket.write(database.read());
}
```

Bazı özelliklerin açık bir olumlu biçimi yoktur. Diske yazılmış bir belge "kaydedilmiş" mi yoksa "değiştirilmemiş" mi sayılmalıdır? Diske yazılmamış bir belge "kaydedilmemiş" mi yoksa "değiştirilmiş" mi? Belirsiz durumlarda, kullanıcıların olumsuzlamasının daha az olası olduğu veya daha kısa isme sahip seçeneğe yönelin.

**İstisna:** Bazı özelliklerde, kullanıcıların büyük çoğunlukla ihtiyaç duyduğu biçim olumsuz olanıdır. Olumlu durumu seçmek, kullanıcıları özelliği her yerde `!` ile olumsuzlamaya zorlardı. Bu durumda, o özellik için olumsuz durumu kullanmak daha iyi olabilir.

### **PREFER** temel amacı yan etki olan fonksiyon ve metotlar için emir kipinde fiil öbeği tercih edin

Çağrılabilir üyeler çağırana bir sonuç döndürebilir ve başka işler veya yan etkiler de gerçekleştirebilir. Dart gibi emirsel bir dilde üyeler çoğunlukla yan etkileri için çağrılır: bir nesnenin iç durumunu değiştirebilir, çıktı üretebilir ya da dış dünyayla iletişim kurabilirler.

Bu tür üyeler, yaptıkları işi açıklayan emir kipinde bir fiil öbeğiyle adlandırılmalıdır.

```dart
list.add('element');
queue.removeFirst();
window.refresh();
```

Bu sayede bir çağrı, o işi yapması için verilmiş bir komut gibi okunur.

### **PREFER** temel amacı bir değer döndürmek olan fonksiyon ve metotlar için isim öbeği veya emir kipinde olmayan fiil öbeği tercih edin

Diğer çağrılabilir üyelerin yan etkileri azdır, ancak çağırana yararlı bir sonuç döndürürler. Üye bunu yapmak için parametreye ihtiyaç duymuyorsa, genellikle getter olmalıdır. Ancak mantıksal bir "özellik" bazen birtakım parametreler gerektirebilir. Örneğin `elementAt()` bir koleksiyondan bir veri parçası döndürür, ancak *hangi* veriyi döndüreceğini bilmek için bir parametreye ihtiyaç duyar.

Bu, üyenin *sözdizimsel olarak* bir metot, ama *kavramsal olarak* bir özellik olduğu anlamına gelir; bu nedenle döndürdüğü *şeyi* tarif eden bir ifadeyle öyle adlandırılmalıdır.

```dart
var element = list.elementAt(3);
var first = list.firstWhere(test);
var char = string.codeUnitAt(4);
```

Bu yönerge, öncekine göre bilerek daha yumuşaktır. Bazen bir metot yan etki üretmez ama yine de `list.take()` veya `string.split()` gibi bir fiil öbeğiyle adlandırmak daha basittir.

### **CONSIDER** yaptığı işe dikkat çekmek istiyorsanız fonksiyon veya metot için emir kipinde fiil öbeği kullanmayı düşünün

Bir üye, yan etki olmadan bir sonuç ürettiğinde, genellikle getter veya döndürdüğü sonucu tarif eden isim öbeğine sahip bir metot olmalıdır. Ancak bazen o sonucu üretmek için yapılan iş önemlidir. Çalışma zamanı hatalarına açık olabilir ya da ağ veya dosya G/Ç gibi ağır kaynaklar kullanabilir. Bu gibi durumlarda, çağıranın üyenin yaptığı işi düşünmesini istiyorsanız, üyeye o işi tarif eden bir fiil öbeği ismi verin.

```dart
var table = database.downloadData();
var packageVersions = packageGraph.solveConstraints();
```

Ancak bu yönergenin, önceki iki kurala göre daha yumuşak olduğunu unutmayın. Bir işlemin gerçekleştirdiği iş çoğu zaman çağıran için önemsiz bir uygulama ayrıntısıdır ve performans ile sağlamlık sınırları zamanla değişir. Çoğu durumda üyelerinizi, bunu *nasıl* yaptıklarına göre değil, çağırana *ne* yaptıklarına göre adlandırın.

### **AVOID** fonksiyon veya metot adını `get` ile başlatmaktan kaçının

Çoğu durumda metot veya fonksiyon, isminden `get` çıkarılmış bir getter olmalıdır. Örneğin `getBreakfastOrder()` adlı bir metot yerine `breakfastOrder` adlı bir getter tanımlayın.

Üye bir argüman aldığı veya getter için uygun olmadığı için yine de metot olması gerekiyorsa, `get` kullanmaktan kaçının. Önceki yönergelerde belirtildiği gibi, şunlardan birini yapın:

- Çağıranın esas olarak metodun döndürdüğü değeri önemsemesi durumunda `get` ifadesini atın ve `breakfastOrder()` gibi bir isim öbeği kullanın.
- Çağıran yapılan işi önemsiyorsa, `get`'ten daha kesin bir işi anlatan fiil öbeği kullanın; örneğin `create`, `download`, `fetch`, `calculate`, `request`, `aggregate` gibi.

### **PREFER** nesnenin durumunu yeni bir nesneye kopyalayan metodu `to___()` olarak adlandırmayı tercih edin

Linter kuralı: use_to_and_as_if_applicable

*Dönüştürme* metodu, alıcının durumunun neredeyse tamamını içeren yeni bir nesne döndüren metottur; ancak genellikle farklı bir biçimde veya temsilde olur. Core library'lerde bu metotların `to` ile başlayıp ardından sonucun türü gelerek adlandırılması kuralı vardır.

Kendi dönüştürme metodunuzu tanımlıyorsanız, bu kurala uymak faydalıdır.

```dart
list.toSet();
stackTrace.toString();
dateTime.toLocal();
```

### **PREFER** orijinal nesneye dayanan farklı bir temsil döndüren metodu `as___()` olarak adlandırmayı tercih edin

Linter kuralı: use_to_and_as_if_applicable

Dönüştürme metotları "anlık görüntülerdir". Ortaya çıkan nesne, orijinal nesnenin durumunun kendi kopyasına sahiptir. Bunların yanında, *görünüm* (view) döndüren dönüştürme benzeri metotlar da vardır; bunlar yeni bir nesne sağlar, ama bu nesne orijinaline geri referans verir. Orijinal nesnede sonradan yapılan değişiklikler görünümde yansır.

Takip etmeniz gereken core library kuralı `as___()` biçimidir.

```dart
var map = table.asMap();
var list = bytes.asFloat32List();
var future = subscription.asFuture();
```

### **AVOID** fonksiyon veya metodun adında parametreleri tarif etmekten kaçının

Kullanıcı argümanı çağrı noktasında zaten görür; bu yüzden isimde ayrıca ona atıfta bulunmak genellikle okunabilirliğe katkı sağlamaz.

```dart
list.add(element);
map.remove(key);
```

```dart
list.addElement(element)
map.removeKey(key)
```

Ancak, farklı türler alan benzer adlı metotlardan ayırt etmek için bir parametreyi belirtmek faydalı olabilir:

```dart
map.containsKey(key);
map.containsValue(value);
```

### **DO** tür parametrelerini adlandırırken mevcut mnemonik kurallarını izleyin

Tek harfli isimler pek açıklayıcı değildir, ancak neredeyse tüm generic türler bunları kullanır. Neyse ki çoğunlukla tutarlı ve mnemonik bir biçimde kullanırlar. Kurallar şunlardır:

- `E`, bir koleksiyondaki **öğe** türü için kullanılır:
  ```dart
  class IterableBase<E> {}
  class List<E> {}
  class HashSet<E> {}
  class RedBlackTree<E> {}
  ```
- `K` ve `V`, bir ilişkisel koleksiyondaki **anahtar** ve **değer** türleri için kullanılır:
  ```dart
  class Map<K, V> {}
  class Multimap<K, V> {}
  class MapEntry<K, V> {}
  ```
- `R`, bir fonksiyonun veya class metotlarının **dönüş** türü olarak kullanılan tür için kullanılır. Bu çok yaygın değildir, ancak bazen typedef'lerde ve visitor pattern'ini uygulayan class'larda görülür:
  ```dart
  abstract class ExpressionVisitor<R> {
    R visitBinary(BinaryExpression node);
    R visitLiteral(LiteralExpression node);
    R visitUnary(UnaryExpression node);
  }
  ```
- Aksi durumda, tek bir tür parametresi olan ve çevreleyen türün anlamını açık hale getirdiği generic'ler için `T`, `S` ve `U` kullanın. Burada birden fazla harf olması, çevreleyen bir ismi gölgelemeden iç içe kullanıma izin verir. Örneğin:
  ```dart
  class Future<T> {
    Future<S> then<S>(FutureOr<S> onValue(T value)) => ...
  }
  ```
  Burada generic metot `then<S>()`, `Future<T>` üzerindeki `T`'yi gölgelememek için `S` kullanır.

Yukarıdaki durumların hiçbiri uygun değilse, başka bir tek harfli mnemonik isim veya açıklayıcı bir isim de kabul edilebilir:

```dart
class Graph<N, E> {
  final List<N> nodes = [];
  final List<E> edges = [];
}

class Graph<Node, Edge> {
  final List<Node> nodes = [];
  final List<Edge> edges = [];
}
```

Pratikte, mevcut kurallar çoğu tür parametresini kapsar.

## Library'ler

Başta bir alt çizgi karakteri (`_`), bir üyenin library'sine özel (private) olduğunu belirtir. Bu sadece bir gelenek değil, doğrudan dilin kendisine yerleşik bir kuraldır.

### **PREFER** tanımları private yapmayı tercih edin

Bir library içindeki public bir tanım (ister top level olsun ister bir class içinde), diğer library'lerin o üyeye erişebileceğini ve erişmesi gerektiğini gösterir. Bu aynı zamanda library'nizin bunu desteklemesi ve bu durumda doğru davranması için bir taahhüttür.

Bunu amaçlamıyorsanız, küçük bir `_` ekleyin ve rahat olun. Dar public arayüzler sizin bakımınızı kolaylaştırır, kullanıcılar için de öğrenmesi daha kolaydır. Ayrıca güzel bir bonus olarak, analyzer kullanılmayan private tanımları size bildirir; böylece ölü kodu silebilirsiniz. Üye public ise bunu yapamaz, çünkü görünüm alanının dışındaki hiçbir kodun onu kullanıp kullanmadığını bilemez.

### **CONSIDER** aynı library içinde birden fazla class tanımlamayı düşünün

Java gibi bazı dillerde dosyaların organizasyonu class'ların organizasyonuna bağlıdır; her dosya yalnızca tek bir top level class tanımlayabilir. Dart'ta böyle bir kısıt yoktur. Library'ler, class'lardan ayrı varlıklardır. Mantıksal olarak birlikte ait oldukları sürece, tek bir library'nin birden fazla class'ı, top level değişkeni ve fonksiyonu olması tamamen uygundur.

Birden fazla class'ı aynı library'de bir araya getirmek, bazı yararlı kalıplara olanak tanır. Dart'ta private erişim class seviyesinde değil library seviyesinde çalıştığından, bu yöntem C++'ta olduğu gibi "friend" class'lar tanımlamanın bir yoludur. Aynı library'de tanımlanan her class, birbirlerinin private üyelerine erişebilir; ancak o library'nin dışındaki kod erişemez.

Elbette bu yönerge, tüm class'larınızı devasa tek bir monolitik library'ye koymanız gerektiği anlamına gelmez; yalnızca tek bir library'de birden fazla class yerleştirmenize izin verildiğini söyler.

## Class'lar ve mixin'ler

Dart, tüm nesnelerin class'ların örnekleri olduğu anlamında "saf" bir nesne yönelimli dildir. Ancak Dart, tüm kodun bir class içinde tanımlanmasını zorunlu kılmaz; prosedürel veya fonksiyonel bir dilde olduğu gibi top-level değişkenleri, sabitleri ve fonksiyonları tanımlayabilirsiniz.

### **AVOID** basit bir fonksiyon yeterliyken tek üyeli soyut bir class tanımlamaktan kaçının

Linter kuralı: one_member_abstracts

Java'dan farklı olarak Dart'ta birinci sınıf fonksiyonlar, closure'lar ve bunları kullanmak için hafif bir sözdizimi vardır. İhtiyacınız olan şey bir callback gibiyse, sadece bir fonksiyon kullanın. Bir class tanımlıyorsanız ve bu class `call` veya `invoke` gibi anlamsız bir isme sahip tek bir soyut üyeye sahipse, büyük ihtimalle aslında bir fonksiyon istiyorsunuzdur.

```dart
typedef Predicate<E> = bool Function(E element);
```

```dart
abstract class Predicate<E> {
  bool test(E element);
}
```

### **AVOID** yalnızca statik üyeler içeren bir class tanımlamaktan kaçının

Linter kuralı: avoid_classes_with_only_static_members

Java ve C#'ta her tanımın *mutlaka* bir class içinde olması gerekir; bu yüzden yalnızca statik üyeleri barındırmak için var olan "class"lara sıkça rastlanır. Diğer class'lar ise bir ad alanı (namespace) olarak kullanılır; yani birbiriyle ilişkili birçok üyeye ortak bir önek vermek veya isim çakışmasını önlemek için kullanılır.

Dart'ta top-level fonksiyonlar, değişkenler ve sabitler olduğu için bir şeyi tanımlamak adına bir class'a *ihtiyacınız* yoktur. Ad alanı istiyorsanız bir library daha uygundur. Library'ler import önekleri ile show/hide birleştiricilerini destekler. Bunlar, kodunuzu kullanan tarafın isim çakışmalarını *kendi* için en uygun şekilde yönetmesine olanak tanıyan güçlü araçlardır.

Bir fonksiyon veya değişken mantıksal olarak bir class'a bağlı değilse, onu top level'da tutun. İsim çakışmalarından endişe ediyorsanız, daha kesin bir isim verin ya da onu bir önekle import edilebilecek ayrı bir library'ye taşıyın.

```dart
DateTime mostRecent(List<DateTime> dates) {
  return dates.reduce((a, b) => a.isAfter(b) ? a : b);
}

const _favoriteMammal = 'weasel';
```

```dart
class DateUtils {
  static DateTime mostRecent(List<DateTime> dates) {
    return dates.reduce((a, b) => a.isAfter(b) ? a : b);
  }
}

class _Favorites {
  static const mammal = 'weasel';
}
```

Deyimsel Dart'ta class'lar *nesne türlerini* tanımlar. Hiç örneklenmeyen bir tür, bir kod kokusudur (code smell).

Ancak bu kesin bir kural değildir. Örneğin sabitler ve enum benzeri türlerle, bunları bir class içinde gruplamak doğal olabilir.

```dart
class Color {
  static const red = '#f00';
  static const green = '#0f0';
  static const blue = '#00f';
  static const black = '#000';
  static const white = '#fff';
}
```

### **AVOID** alt sınıf olarak kullanılmak üzere tasarlanmamış bir class'ı genişletmekten kaçının

Bir constructor generative constructor'dan factory constructor'a değiştirilirse, o constructor'ı çağıran herhangi bir alt sınıf constructor'ı bozulur. Ayrıca bir class, `this` üzerinde kendi metotlarından hangilerini çağırdığını değiştirirse, bu da o metotları override eden ve belirli noktalarda çağrılmasını bekleyen alt sınıfları bozabilir.

Bu iki durum da bir class'ın alt sınıflamaya izin verip vermeyeceği konusunda bilinçli olması gerektiğini gösterir. Bu bir doc comment ile veya `IterableBase` gibi açık bir isim vererek iletilebilir. Class'ın yazarı bunu yapmıyorsa, class'ı genişletmemeniz en iyisidir. Aksi halde, sonraki değişiklikler kodunuzu bozabilir.

### **DO** class'ınızın genişletilip genişletilemeyeceğini kontrol etmek için class modifier'larını kullanın

`final`, `interface` veya `sealed` gibi class modifier'ları, bir class'ın nasıl genişletilebileceğini kısıtlar. Örneğin, mevcut library dışında genişletilmeyi önlemek için `final class A {}` veya `interface class B {}` kullanın. Niyetinizi dokümantasyona güvenmek yerine iletmek için bu modifier'ları kullanın.

### **AVOID** arayüz olarak kullanılmak üzere tasarlanmamış bir class'ı implement etmekten kaçının

Örtük arayüzler (implicit interfaces), bir sözleşmenin implementasyonunun imzalarından kolayca çıkarılabildiği durumlarda, o sözleşmeyi tekrar tekrar yazma zorunluluğunu ortadan kaldıran güçlü bir Dart aracıdır.

Ancak bir class'ın arayüzünü implement etmek, o class'a çok sıkı bir bağımlılık oluşturur. Bu, arayüzünü implement ettiğiniz class'ta *neredeyse her* değişikliğin implementasyonunuzu bozabileceği anlamına gelir. Örneğin, bir class'a yeni bir üye eklemek genellikle güvenli, kırıcı olmayan bir değişikliktir. Ama o class'ın arayüzünü implement ediyorsanız, artık class'ınızda o yeni metot için implementasyon bulunmadığı için statik bir hata oluşur.

Library bakımcılarının, mevcut class'ları kullanıcıları bozmadan geliştirebilmesi gerekir. Kullanıcıların serbestçe implement edebileceği bir arayüzü her class'ın sunduğunu kabul ederseniz, bu class'ları değiştirmek çok zorlaşır. Bu zorluk da bağımlı olduğunuz library'lerin daha yavaş büyümesine ve yeni ihtiyaçlara daha yavaş uyum sağlamasına yol açar.

Class'ların yazarlarına daha fazla esneklik tanımak için, açıkça implement edilmek üzere tasarlanmış class'lar dışında örtük arayüzleri implement etmekten kaçının. Aksi halde, yazarın istemediği bir bağımlılık oluşturabilirsiniz ve onlar bunu fark etmeden kodunuzu bozabilirler.

### **DO** class'ınızın bir arayüz olup olamayacağını kontrol etmek için class modifier'larını kullanın

Bir library tasarlarken, amaçlanan kullanımı zorunlu kılmak için `final`, `base` veya `sealed` gibi class modifier'larını kullanın. Örneğin, mevcut library dışında implementasyonu önlemek için `final class C {}` veya `base class D {}` kullanın. Tüm library'lerin tasarım niyetini zorunlu kılmak için bu modifier'ları kullanması ideal olsa da, geliştiriciler bunların uygulanmadığı durumlarla hâlâ karşılaşabilir. Bu tür durumlarda, istenmeyen implementasyon sorunlarına karşı dikkatli olun.

### **PREFER** bir `mixin class` yerine saf bir `mixin` veya saf bir `class` tanımlamayı tercih edin

Linter kuralı: prefer_mixin

Dart, daha önce (dil sürümleri 2.12 ile 2.19 arasında) belirli kısıtlamaları karşılayan her class'ın (varsayılan dışında bir constructor olmayan, üst sınıfı olmayan vb.) başka class'lara mixin olarak eklenmesine izin veriyordu. Class'ın yazarı onun mixin olarak eklenmesini amaçlamamış olabileceği için bu durum kafa karıştırıcıydı.

Dart 3.0.0 ile artık, başka class'lara mixin olarak eklenmesi ve normal bir class gibi de kullanılması amaçlanan her türün, `mixin class` bildirimiyle açıkça belirtilmesi gerekir.

Ancak hem mixin hem de class olması gereken türler nadir bir durumdur. `mixin class` bildirimi çoğunlukla, 3.0.0 öncesinde mixin olarak kullanılan class'ları daha açık bir bildirime geçirmeye yardımcı olmak için tasarlanmıştır. Yeni kod, bildirimlerinin davranışını ve amacını yalnızca saf `mixin` veya saf `class` bildirimleri kullanarak açıkça tanımlamalı ve mixin class'ların belirsizliğinden kaçınmalıdır.

`mixin` ve `mixin class` bildirimleri hakkında daha fazla bilgi için "Migrating classes as mixins" başlıklı belgeyi okuyun.

## Constructor'lar

Dart constructor'ları, class ile aynı ada sahip bir fonksiyon bildirilerek ve isteğe bağlı olarak ek bir tanımlayıcı eklenerek oluşturulur. Bunlara *adlandırılmış constructor'lar* denir.

### **CONSIDER** class destekliyorsa constructor'ınızı `const` yapmayı düşünün

Tüm field'ları final olan ve constructor'ı yalnızca bunları başlatan bir class'ınız varsa, bu constructor'ı `const` yapabilirsiniz. Bu, kullanıcıların sabitlerin gerektiği yerlerde — daha büyük sabitlerin içinde, switch case'lerde, varsayılan parametre değerlerinde vb. — class'ınızın örneklerini oluşturmasına olanak tanır.

Açıkça `const` yapmazsanız, kullanıcılar bunu yapamaz.

Ancak `const` constructor'ın public API'nizde bir taahhüt olduğunu unutmayın. Constructor'ı sonradan non-`const` yaparsanız, sabit ifadelerde onu çağıran kullanıcılar bozulur. Bu taahhüdü vermek istemiyorsanız, `const` yapmayın. Pratikte `const` constructor'lar en çok basit, değiştirilemez, değer benzeri türlerde işe yarar.

## Üyeler

Bir üye bir nesneye aittir ve metot veya örnek değişkeni olabilir.

### **PREFER** field'ları ve top-level değişkenleri `final` yapmayı tercih edin

Linter kuralı: prefer_final_fields

Zaman içinde değişmeyen, yani *değiştirilemeyen* durum, programcıların üzerinde akıl yürütmesini kolaylaştırır. Üzerinde çalıştıkları değiştirilebilir durumu en aza indiren class'lar ve library'ler genellikle bakımı daha kolay olur. Elbette değiştirilebilir veri çoğu zaman kullanışlıdır. Ancak ihtiyacınız yoksa, mümkün olduğunda field'ları ve top-level değişkenleri `final` yapmak varsayılanınız olmalıdır.

Bazen bir örnek field'ı ilk değer atandıktan sonra değişmez, ama örnek oluşturulana kadar başlatılamaz. Örneğin `this` veya örnek üzerindeki başka bir field'a referans vermesi gerekebilir. Böyle durumlarda field'ı `late final` yapmayı düşünün. Bunu yaptığınızda, field'ı bildirildiği yerde başlatabilirsiniz.

### **DO** kavramsal olarak özelliklere erişen işlemler için getter kullanın

Bir üyenin getter mı yoksa metot mu olması gerektiğine karar vermek, iyi API tasarımının ince ama önemli bir parçasıdır; bu yüzden bu çok uzun bir yönerge. Bazı dillerin kültürleri getter kullanmaktan kaçınır. Yalnızca işlem neredeyse bir field gibi olduğunda, yani tamamen nesnenin üzerinde duran duruma çok küçük bir hesaplama uygulandığında kullanırlar. Bundan daha karmaşık veya ağır olan her şeyin adından sonra `()` alması gerekir; çünkü `.` sonrasındaki çıplak bir isim "field" anlamına gelir.

Dart öyle değildir. Dart'ta *tüm* noktalı isimler, hesaplama yapabilen üye çağrılarıdır. Field'lar özeldir: dilin implementasyonunu sağladığı getter'lardır. Başka bir deyişle, Dart'ta getter'lar "özellikle yavaş field'lar" değildir; field'lar "özellikle hızlı getter'lardır".

Yine de bir metot yerine getter seçmek, çağırana önemli bir sinyal verir. Bu sinyal kabaca şudur: işlem "field benzeri"dir. İşlem, çağıranın bildiği kadarıyla en azından prensipte bir field kullanılarak da uygulanabilirdi. Bu da şunları ima eder:

- **İşlem hiçbir argüman almaz ve bir sonuç döndürür.**
- **Çağıran büyük ölçüde sonuçla ilgilenir.** Çağıranın sonucun üretilme *biçimini* sonucun kendisinden daha fazla düşünmesini istiyorsanız, işleme işi tarif eden bir fiil ismi verin ve bir metot yapın. Bu, işlemin bir getter olabilmesi için özellikle hızlı olması gerektiği anlamına *gelmez*. `IterableBase.length` `O(n)`'dir ve bu sorun değildir. Bir getter'ın önemli bir hesaplama yapması uygundur. Ancak *şaşırtıcı* derecede çok iş yapıyorsa, dikkatini çekmek için onu, ne yaptığını tarif eden bir fiil olan bir metot yapmak isteyebilirsiniz.

  ```dart
  connection.nextIncomingMessage; // Ağ G/Ç işlemi yapar.
  expression.normalForm; // Hesaplaması üstel olabilir.
  ```

- **İşlemin kullanıcıya görünür bir yan etkisi yoktur.** Gerçek bir field'a erişmek nesneyi veya programdaki başka herhangi bir durumu değiştirmez. Çıktı üretmez, dosya yazmaz vb. Getter da bunları yapmamalıdır.

  "Kullanıcıya görünür" kısmı önemlidir. Getter'ların gizli durumu değiştirmesi veya kapsam dışı yan etkiler üretmesi sorun değildir. Getter'lar sonucu tembel (lazy) olarak hesaplayıp saklayabilir, bir cache'e yazabilir, log tutabilir vb. Çağıran yan etkiyi *önemsemediği* sürece genellikle sorun yoktur.

  ```dart
  stdout.newline; // Çıktı üretir.
  list.clear; // Nesneyi değiştirir.
  ```

- **İşlem *idempotent*tir.** Bu bağlamda "idempotent" kelimesi, durum açıkça değiştirilmedikçe işlemi birden fazla çağırmanın her seferinde aynı sonucu vermesi anlamına gelir. (Açıkça, `list.length` çağrılar arasında listeye bir öğe eklerseniz farklı sonuçlar üretir.)

  "Aynı sonuç" burada, bir getter'ın ardışık çağrılarda kelimesi kelimesine aynı nesneyi üretmesi gerektiği anlamına gelmez. Bunu şart koşmak, birçok getter'ı kırılgan önbelleğe almaya zorlardı; bu da getter kullanmanın tüm amacını ortadan kaldırır. Her çağrıda yeni bir future veya liste döndürmek yaygın ve tamamen uygundur. Önemli olan, future'ın aynı değere tamamlanması ve listenin aynı öğeleri içermesidir.

  Başka bir deyişle, sonuç değeri *çağıranın önemsediği yönlerden* aynı olmalıdır.

  ```dart
  DateTime.now; // Her seferinde yeni bir sonuç.
  ```

- **Ortaya çıkan nesne, orijinal nesnenin tüm durumunu açığa çıkarmaz.** Bir field, bir nesnenin yalnızca bir parçasını açığa çıkarır. İşleminizin sonucu orijinal nesnenin tüm durumunu açığa çıkarıyorsa, muhtemelen bir `to___()` veya `as___()` metodu olmalıdır.

Yukarıdakilerin tümü işleminizi tarif ediyorsa, bu bir getter olmalıdır. Bu kapıdan çok az üyenin geçeceği gibi görünse de, şaşırtıcı biçimde birçok üye geçer. Birçok işlem, bazı durumlar üzerinde basit bir hesaplama yapar; bunların çoğu getter olabilir ve olmalıdır.

```dart
rectangle.area;
collection.isEmpty;
button.canShow;
dataSet.minimumValue;
```

### **DO** kavramsal olarak özellikleri değiştiren işlemler için setter kullanın

Linter kuralı: use_setters_to_change_properties

Bir setter ile metot arasında karar vermek, bir getter ile metot arasında karar vermeye benzer. Her iki durumda da işlem "field benzeri" olmalıdır.

Bir setter için "field benzeri" şu anlama gelir:

- **İşlem tek bir argüman alır ve bir sonuç değeri üretmez.**
- **İşlem nesnedeki bazı durumları değiştirir.**
- **İşlem idempotent'tir.** Aynı setter'ı aynı değerle iki kez çağırmak, çağıranın açısından ikinci çağrıda bir şey yapmamalıdır. İçeride bazı önbellek geçersiz kılma veya loglama işlemleriniz olabilir; bu sorun değildir. Ancak çağıranın bakış açısından ikinci çağrı hiçbir şey yapmıyor gibi görünmelidir.

```dart
rectangle.width = 3;
button.visible = false;
```

### **DON'T** karşılık gelen bir getter olmadan setter tanımlamayın

Linter kuralı: avoid_setters_without_getters

Kullanıcılar getter ve setter'ları bir nesnenin görünür özellikleri olarak düşünür. Yazılabilen ama görülemeyen bir "dropbox" özelliği kafa karıştırır ve özelliklerin nasıl çalıştığına dair sezgilerini bozar. Örneğin, getter'ı olmayan bir setter, onu değiştirmek için `=` kullanabileceğiniz, ancak `+=` kullanamayacağınız anlamına gelir.

Bu yönerge, istediğiniz setter'ı ekleyebilmek için bir getter eklemeniz gerektiği anlamına *gelmez*. Nesneler genellikle ihtiyaç duyduğundan fazla durumu açığa çıkarmamalıdır. Bir nesnenin değiştirilebilen ama aynı şekilde açığa çıkarılmayan bir durum parçası varsa, bunun yerine bir metot kullanın.

### **AVOID** overloading'i taklit etmek için çalışma zamanı tür testleri kullanmaktan kaçının

Bir API'nin farklı türdeki parametreler üzerinde benzer işlemleri desteklemesi yaygındır. Bu benzerliği vurgulamak için bazı diller *overloading* destekler; bu da aynı isme ama farklı parametre listelerine sahip birden fazla metot tanımlamanıza olanak tanır. Derleme zamanında derleyici, hangi metodun çağrılacağını belirlemek için gerçek argüman türlerine bakar.

Dart'ta overloading yoktur. Tek bir metot tanımlayıp gövdesinde argümanların çalışma zamanı türlerine bakmak için `is` tür testleri kullanarak overloading gibi görünen bir API tanımlayabilirsiniz. Ancak overloading'i bu şekilde taklit etmek, *derleme zamanındaki* metot seçimini *çalışma zamanında* yapılan bir seçime dönüştürür.

Çağıranlar genellikle hangi türe sahip olduklarını ve hangi belirli işlemi istediklerini biliyorlarsa, doğru işlemi seçmelerine izin vermek için farklı isimlere sahip ayrı metotlar tanımlamak daha iyidir. Bu, daha iyi statik tür denetimi sağlar ve çalışma zamanı tür testlerinden kaçındığı için daha hızlıdır.

Ancak kullanıcılar bilinmeyen bir türde nesneye sahip olabiliyorsa ve API'nin doğru işlemi seçmek için dahili olarak `is` kullanmasını *istiyorsa*, desteklenen tüm türlerin üst türü olan parametreye sahip tek bir metot makul olabilir.

### **AVOID** ilk değer ataması olmayan public `late final` field'lardan kaçının

Diğer `final` field'ların aksine, ilk değer ataması olmayan bir `late final` field *bir* setter tanımlar. Field public ise, setter de public olur. Bu genellikle istenen bir durum değildir. Field'lar genellikle `late` olarak işaretlenir, böylece örneğin yaşam döngüsünün bir noktasında, çoğunlukla constructor gövdesinde *dahili olarak* başlatılabilir.

Kullanıcıların setter'ı çağırmasını *istemediğiniz* sürece, aşağıdaki çözümlerden birini seçmek daha iyidir:

- `late` kullanmayın.
- `final` field değerlerini hesaplamak için bir factory constructor kullanın.
- `late` kullanın, ama `late` field'ı bildirildiği yerde başlatın.
- `late` kullanın, ama `late` field'ı private yapıp ona public bir getter tanımlayın.

### **AVOID** nullable `Future`, `Stream` ve koleksiyon türleri döndürmekten kaçının

Bir API bir container türü döndürdüğünde, veri olmadığını belirtmenin iki yolu vardır: boş bir container döndürebilir ya da `null` döndürebilir. Kullanıcılar genellikle "veri yok" anlamı için boş bir container kullanmanızı varsayar ve bunu tercih eder. Böylece `isEmpty` gibi metotları çağırabilecekleri gerçek bir nesneye sahip olurlar.

API'niz sağlayacak veri olmadığını belirtmek için, boş bir koleksiyon, nullable türde bir değeri olan nullable olmayan bir future veya hiçbir değer yaymayan bir stream döndürmeyi tercih edin.

**İstisna:** `null` döndürmek, boş bir container döndürmekten *farklı bir anlam taşıyorsa*, nullable bir tür kullanmak mantıklı olabilir.

### **AVOID** yalnızca akıcı bir arayüz (fluent interface) sağlamak için metotlardan `this` döndürmekten kaçının

Linter kuralı: avoid_returning_this

Metot cascade'leri, metot çağrılarını zincirlemek için daha iyi bir çözümdür.

```dart
var buffer =
    StringBuffer()
      ..write('one')
      ..write('two')
      ..write('three');
```

```dart
var buffer =
    StringBuffer()
        .write('one')
        .write('two')
        .write('three');
```

## Türler

Programınızda bir tür yazdığınızda, kodunuzun farklı bölümlerine akan değerlerin türlerini kısıtlarsınız. Türler iki tür yerde görünebilir: bildirimler üzerindeki *tür açıklamaları* (type annotations) ve *generic çağrılara* (generic invocations) verilen tür argümanları.

Tür açıklamaları, "statik türler" denilince aklınıza gelen şeylerdir. Bir değişkene, parametreye, field'a veya dönüş türüne tür açıklaması ekleyebilirsiniz. Aşağıdaki örnekte `bool` ve `String` tür açıklamalarıdır. Kodun statik bildirim yapısına bağlıdırlar ve çalışma zamanında "çalıştırılmazlar".

```dart
bool isEmpty(String parameter) {
  bool result = parameter.isEmpty;
  return result;
}
```

Generic bir çağrı; bir koleksiyon literal'i, generic bir class'ın constructor'ına yapılan çağrı veya generic bir metodun çağrısıdır. Bir sonraki örnekte `num` ve `int`, generic çağrılardaki tür argümanlarıdır. Tür olsalar bile, çalışma zamanında somutlaştırılan ve çağrıya geçirilen birinci sınıf varlıklardır.

```dart
var lists = <num>[1, 2];
lists.addAll(List<num>.filled(3, 4));
lists.cast<int>();
```

Burada "generic çağrı" kısmını vurguluyoruz, çünkü tür argümanları *ayrıca* tür açıklamalarında da görünebilir:

```dart
List<int> ints = [1, 2];
```

Burada `int` bir tür argümanıdır, ancak bir generic çağrı içinde değil, bir tür açıklaması içinde yer alır. Bu ayrımı genellikle önemsemeniz gerekmez; ancak birkaç yerde, bir türün generic çağrıda kullanıldığı durum ile tür açıklamasında kullanıldığı durum için farklı yönergelerimiz vardır.

#### Tür çıkarımı

Dart'ta tür açıklamaları isteğe bağlıdır. Birini atlarsanız, Dart yakın bağlama göre bir tür çıkarmaya çalışır. Bazen tam bir tür çıkarmak için yeterli bilgisi olmaz. Bu olduğunda Dart bazen hata bildirir, ancak genellikle eksik kısımları sessizce `dynamic` ile doldurur. Örtük `dynamic`, *çıkarılmış ve güvenli* gibi görünen ama aslında tür denetimini tamamen devre dışı bırakan kod üretir. Aşağıdaki kurallar, çıkarım başarısız olduğunda türleri zorunlu kılarak bundan kaçınmanızı sağlar.

Dart'ta hem tür çıkarımının hem de `dynamic` türünün olması, kodun "türsüz" olmasının ne anlama geldiği konusunda karışıklığa yol açar. Kod dinamik olarak mı türlendirilmiştir, yoksa türünü siz *yazmadınız* mı? Bu karışıklıktan kaçınmak için "türsüz" ifadesini kullanmıyoruz ve bunun yerine aşağıdaki terminolojiyi kullanıyoruz:

- Kod *tür açıklamalıysa*, tür kodda açıkça yazılmıştır.
- Kod *çıkarılmışsa*, tür açıklaması yazılmamıştır ve Dart türü kendi başına başarıyla belirlemiştir. Çıkarım başarısız olabilir; bu durumda yönergeler bunu çıkarılmış saymaz.
- Kod *dinamikse*, statik türü özel `dynamic` türüdür. Kod açıkça `dynamic` olarak açıklanmış olabilir veya çıkarılmış olabilir.

Başka bir deyişle, bir kodun tür açıklamalı mı yoksa çıkarılmış mı olduğu, onun `dynamic` mi yoksa başka bir tür mü olduğundan bağımsızdır.

Çıkarım; açık veya ilgisiz türleri yazma ve okuma zahmetinden sizi kurtaran güçlü bir araçtır. Okuyucunun dikkatini kodun davranışının kendisine odaklı tutar. Açık türler de sağlam, sürdürülebilir kodun önemli bir parçasıdır. Bir API'nin statik yapısını tanımlarlar ve programın farklı bölümlerine hangi değer türlerinin ulaşabileceğini belgeleyip zorunlu kılan sınırlar oluştururlar.

Tabii ki çıkarım sihir değildir. Bazen çıkarım başarılı olur ve bir tür seçer, ancak istediğiniz tür bu olmaz. Yaygın durum, değişkene sonradan başka türden değerler atamayı planlarken, değişkenin ilk değer atamasından aşırı kesin bir tür çıkarmasıdır. Bu durumlarda türü açıkça yazmanız gerekir.

Burada verilen yönergeler, kısalık ile kontrol, esneklik ile güvenlik arasında bulduğumuz en iyi dengeyi sağlar. Tüm durumları kapsayan belirli yönergeler vardır; ancak kabaca özet şudur:

- Çıkarım yeterli bağlama sahip olmadığında tür açıklaması yapın; istediğiniz tür `dynamic` bile olsa.
- Yerel değişkenlerde ve generic çağrılarda, gerekmedikçe tür açıklaması yapmayın.
- İlk değer atamasından tür açıkça anlaşılmıyorsa, top-level değişkenlere ve field'lara tür açıklaması yapmayı tercih edin.

### **DO** ilk değer atanmamış değişkenlere tür açıklaması ekleyin

Linter kuralı: prefer_typing_uninitialized_variables

Bir değişkenin türü (top-level, yerel, statik field veya örnek field'ı olsun) çoğu zaman ilk değer atamasından çıkarılabilir. Ancak ilk değer ataması yoksa çıkarım başarısız olur.

```dart
List<AstNode> parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
```

```dart
var parameters;
if (node is Constructor) {
  parameters = node.signature;
} else if (node is Method) {
  parameters = node.parameters;
}
```

### **DO** tür açık değilse field'lara ve top-level değişkenlere tür açıklaması ekleyin

Linter kuralı: type_annotate_public_apis

Tür açıklamaları, bir library'nin nasıl kullanılması gerektiğine dair önemli belgelerdir. Bunlar, bir tür hatasının kaynağını izole etmek için programın bölgeleri arasında sınır oluştururlar. Şunu düşünün:

```dart
install(id, destination) => ...
```

Burada `id`'nin ne olduğu belirsiz. Bir string mi? Peki `destination` nedir? Bir string mi yoksa bir `File` nesnesi mi? Bu metot senkron mu asenkron mu? Bu daha açık:

```dart
Future<bool> install(PackageId id, String destination) => ...
```

Ancak bazı durumlarda tür o kadar açıktır ki yazmak anlamsızdır:

```dart
const screenWidth = 640; // int olarak çıkarılır.
```

"Açık" kavramı kesin olarak tanımlanmamıştır, ancak bunların hepsi iyi adaylardır:

- Literal'ler.
- Constructor çağrıları.
- Açıkça türlendirilmiş diğer sabitlere referanslar.
- Sayılar ve string'ler üzerinde basit ifadeler.
- `int.parse()`, `Future.wait()` gibi, okuyucuların aşina olmasının beklendiği factory metotları.

İlk değer ifadesi, ne olursa olsun, yeterince açıksa açıklamayı atlayabilirsiniz. Ama açıklama eklemenin kodu daha net hale getirdiğini düşünüyorsanız, bir tane ekleyin.

Emin değilseniz, tür açıklaması ekleyin. Açık türleri de açıkça açıklayabilirsiniz. Çıkarılan tür, başka library'lerdeki değerlere veya bildirimlere bağlıysa, diğer library'deki bir değişikliğin farkında olmadan kendi API'nizin türünü sessizce değiştirmemesi için *kendi* bildiriminize tür açıklaması eklemek isteyebilirsiniz.

Bu kural hem public hem de private bildirimler için geçerlidir. API'lerdeki tür açıklamaları kodunuzun *kullanıcılarına* yardımcı olduğu gibi, private üyelerdeki türler de *bakımcılara* yardımcı olur.

### **DON'T** ilk değeri atanmış yerel değişkenlere gereksiz yere tür açıklaması eklemeyin

Linter kuralı: omit_local_variable_types

Yerel değişkenler, özellikle fonksiyonların küçük olma eğiliminde olduğu modern kodda, çok dar bir kapsama sahiptir. Türü atlamak, okuyucunun dikkatini değişkenin daha önemli *ismine* ve atanan değerine odaklar.

```dart
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  var desserts = <List<Ingredient>>[];
  for (final recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
```

```dart
List<List<Ingredient>> possibleDesserts(Set<Ingredient> pantry) {
  List<List<Ingredient>> desserts = <List<Ingredient>>[];
  for (final List<Ingredient> recipe in cookbook) {
    if (pantry.containsAll(recipe)) {
      desserts.add(recipe);
    }
  }

  return desserts;
}
```

Bazen çıkarılan tür, değişkenin sahip olmasını istediğiniz tür değildir. Örneğin, daha sonra başka türlerde değerler atamayı planlıyor olabilirsiniz. Bu durumda değişkeni istediğiniz türle açıklayın.

```dart
Widget build(BuildContext context) {
  Widget result = Text('You won!');
  if (applyPadding) {
    result = Padding(padding: EdgeInsets.all(8.0), child: result);
  }
  return result;
}
```

### **DO** fonksiyon bildirimlerinde dönüş türlerini açıklayın

Dart, bazı diğer dillerin aksine, bir fonksiyon bildiriminin dönüş türünü gövdesinden genellikle çıkarmaz. Bu, dönüş türü için bir tür açıklamasını kendiniz yazmanız gerektiği anlamına gelir.

```dart
String makeGreeting(String who) {
  return 'Hello, $who!';
}
```

```dart
makeGreeting(String who) {
  return 'Hello, $who!';
}
```

Bu yönergenin yalnızca *yerel olmayan* fonksiyon bildirimleri için geçerli olduğunu unutmayın: top-level, statik ve örnek metotlar ile getter'lar. Yerel fonksiyonlar ve isimsiz fonksiyon ifadeleri dönüş türünü gövdelerinden çıkarır. Aslında isimsiz fonksiyon sözdizimi dönüş türü açıklamasına bile izin vermez.

### **DO** fonksiyon bildirimlerinde parametre türlerini açıklayın

Bir fonksiyonun parametre listesi, dış dünyayla sınırını belirler. Parametre türlerini açıklamak bu sınırı net biçimde tanımlar. Varsayılan parametre değerlerinin değişken ilk değer atamalarına benzediğini, ancak Dart'ın isteğe bağlı bir parametrenin türünü varsayılan değerinden çıkarmadığını unutmayın.

```dart
void sayRepeatedly(String message, {int count = 2}) {
  for (var i = 0; i < count; i++) {
    print(message);
  }
}
```

```dart
void sayRepeatedly(message, {count = 2}) {
  for (var i = 0; i < count; i++) {
    print(message);
  }
}
```

**İstisna:** Fonksiyon ifadeleri ve başlatılan formal'lar, bir sonraki iki yönergede açıklandığı gibi farklı tür açıklaması kurallarına sahiptir.

### **DON'T** fonksiyon ifadelerinde çıkarılabilen parametre türlerini açıklamayın

Linter kuralı: avoid_types_on_closure_parameters

İsimsiz fonksiyonlar neredeyse her zaman hemen belirli bir türde callback alan bir metoda geçirilir. Bir fonksiyon ifadesi türlendirilmiş bir bağlamda oluşturulduğunda, Dart beklenen türe dayanarak fonksiyonun parametre türlerini çıkarmaya çalışır. Örneğin, bir fonksiyon ifadesini `Iterable.map()`'e geçirdiğinizde, fonksiyonunuzun parametre türü, `map()`'in beklediği callback türüne göre çıkarılır:

```dart
var names = people.map((person) => person.name);
```

```dart
var names = people.map((Person person) => person.name);
```

Dil, bir fonksiyon ifadesindeki parametre için istediğiniz türü çıkarabiliyorsa, açıklama yapmayın. Nadir durumlarda, çevreleyen bağlam bir veya daha fazla parametre için tür sağlayacak kadar kesin olmayabilir. Bu durumlarda tür açıklaması yapmanız gerekebilir. (Fonksiyon hemen kullanılmıyorsa, genellikle onu adlandırılmış bir bildirim yapmak daha iyidir.)

### **DON'T** initializing formal'lara tür açıklaması eklemeyin

Linter kuralı: type_init_formals

Bir constructor parametresi, bir field'ı başlatmak için `this.` kullanıyorsa veya bir süper parametreyi iletmek için `super.` kullanıyorsa, parametrenin türü sırasıyla field'ın veya süper constructor parametresinin türüyle aynı olarak çıkarılır.

```dart
class Point {
  double x, y;
  Point(this.x, this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
}
```

```dart
class Point {
  double x, y;
  Point(double this.x, double this.y);
}

class MyWidget extends StatelessWidget {
  MyWidget({Key? super.key});
}
```

### **DO** çıkarılamayan generic çağrılarda tür argümanlarını yazın

Dart, generic çağrılardaki tür argümanlarını çıkarmada oldukça akıllıdır. İfadenin geçtiği yerdeki beklenen türe ve çağrıya geçirilen değerlerin türlerine bakar. Ancak bazen bunlar bir tür argümanını tamamen belirlemek için yeterli olmaz. Bu durumda, tür argümanı listesinin tamamını açıkça yazın.

```dart
var playerScores = <String, int>{};
final events = StreamController<Event>();
```

```dart
var playerScores = {};
final events = StreamController();
```

Bazen çağrı bir değişken bildiriminde ilk değer ataması olarak yer alır. Değişken yerel *değilse*, tür argüman listesini çağrının kendisine yazmak yerine bildirime bir tür açıklaması koyabilirsiniz:

```dart
class Downloader {
  final Completer<String> response = Completer();
}
```

```dart
class Downloader {
  final response = Completer();
}
```

Değişkeni açıklamak, tür argümanlarının artık çıkarılmasını sağladığı için bu yönergeyi de karşılar.

### **DON'T** çıkarılabilen generic çağrılarda tür argümanlarını yazmayın

Bu, önceki kuralın tersidir. Bir çağrının tür argüman listesi istediğiniz türlerle doğru biçimde çıkarılıyorsa, türleri atlayın ve işi Dart'a bırakın.

```dart
class Downloader {
  final Completer<String> response = Completer();
}
```

```dart
class Downloader {
  final Completer<String> response = Completer<String>();
}
```

Burada field üzerindeki tür açıklaması, ilk değer atamasındaki constructor çağrısının tür argümanını çıkarmak için çevresel bağlam sağlar.

```dart
var items = Future.value([1, 2, 3]);
```

```dart
var items = Future<List<int>>.value(<int>[1, 2, 3]);
```

Burada koleksiyonun ve örneğin türleri, öğelerinden ve argümanlarından aşağıdan yukarıya çıkarılabilir.

### **AVOID** eksik generic türler yazmaktan kaçının

Bir tür açıklaması veya tür argümanı yazmanın amacı, eksiksiz bir türü belirlemektir. Ancak bir generic türün adını yazıp tür argümanlarını atlarsanız, türü tam olarak belirtmemiş olursunuz. Java'da bunlara "raw types" denir. Örneğin:

```dart
List numbers = [1, 2, 3];
var completer = Completer<Map>();
```

Burada `numbers` bir tür açıklamasına sahip, ancak açıklama generic `List`'e bir tür argümanı sağlamıyor. Benzer şekilde, `Completer`'daki `Map` tür argümanı tam olarak belirtilmemiş. Bu gibi durumlarda Dart, çevresel bağlamı kullanarak türün geri kalanını sizin için *doldurmaya çalışmaz*. Bunun yerine, eksik tür argümanlarını sessizce `dynamic` ile (veya class'ın bir sınırı varsa o sınırla) doldurur. Bu nadiren istediğiniz şeydir.

Bunun yerine, bir tür açıklamasında veya bir çağrının içinde tür argümanı olarak generic bir tür yazıyorsanız, eksiksiz bir tür yazdığınızdan emin olun:

```dart
List<num> numbers = [1, 2, 3];
var completer = Completer<Map<String, int>>();
```

### **DO** çıkarım başarısız olmasına izin vermek yerine `dynamic` ile açıklama yapın

Çıkarım bir türü doldurmadığında, genellikle `dynamic` varsayılır. `dynamic` istediğiniz tür ise, bu teknik olarak onu elde etmenin en kısa yoludur. Ancak en *açık* yol değildir. Kodunuzu okuyan biri açıklamanın eksik olduğunu gördüğünde, `dynamic` olmasını mı amaçladığınızı, başka bir türün çıkarılmasını mı beklediğinizi yoksa açıklamayı unuttunuzu mu bilemez.

`dynamic` istediğiniz tür olduğunda, niyetinizi açık hale getirmek ve bu kodun daha az statik güvenliğe sahip olduğunu vurgulamak için bunu açıkça yazın.

```dart
dynamic mergeJson(dynamic original, dynamic changes) => ...
```

```dart
mergeJson(original, changes) => ...
```

Dart `dynamic`'i *başarıyla* çıkardığında türü atlamanın sorun olmadığını unutmayın.

```dart
Map<String, dynamic> readJson() => ...

void printUsers() {
  var json = readJson();
  var users = json['users'];
  print(users);
}
```

Burada Dart, `json` için `Map<String, dynamic>` çıkarır ve bundan `users` için `dynamic` çıkarır. `users` için tür açıklaması olmadan bırakmak sorun değildir. Ayrım biraz inceliklidir: Çıkarımın, başka bir yerdeki `dynamic` tür açıklamasından gelen `dynamic`'i kodunuz boyunca *yaymasına* izin vermek sorun değildir; ancak kodunuzun belirtmediği bir yere `dynamic` tür açıklaması enjekte etmesini istemezsiniz.

Dart'ın güçlü tür sistemi ve tür çıkarımıyla, kullanıcılar Dart'ın çıkarımla statik olarak türlendirilen bir dil gibi davranmasını bekler. Bu zihinsel modelle, kodun bir bölgesinin statik türlerin tüm güvenliğini ve performansını sessizce kaybettiğini fark etmek hoş olmayan bir sürprizdir.

**İstisna**: Kullanılmayan parametrelerdeki (`_`) tür açıklamaları atlanabilir.

### **PREFER** fonksiyon tür açıklamalarında imzaları tercih edin

Dönüş türü veya parametre imzası olmadan tek başına kullanılan `Function` tanımlayıcısı, özel Function türünü ifade eder. Bu tür, `dynamic` kullanmaktan yalnızca biraz daha yararlıdır. Açıklama yapacaksanız, fonksiyonun parametrelerini ve dönüş türünü içeren tam bir fonksiyon türünü tercih edin.

```dart
bool isValid(String value, bool Function(String) test) => ...
```

```dart
bool isValid(String value, Function test) => ...
```

**İstisna:** Bazen birden fazla farklı fonksiyon türünün birleşimini temsil eden bir tür istersiniz. Örneğin, bir parametre alan veya iki parametre alan bir fonksiyonu kabul edebilirsiniz. Union türlerimiz olmadığı için bunu kesin olarak türlendirmenin bir yolu yoktur ve normalde `dynamic` kullanmanız gerekir. `Function` bundan biraz daha yardımcıdır:

```dart
void handleError(void Function() operation, Function errorHandler) {
  try {
    operation();
  } catch (err, stack) {
    if (errorHandler is Function(Object)) {
      errorHandler(err);
    } else if (errorHandler is Function(Object, StackTrace)) {
      errorHandler(err, stack);
    } else {
      throw ArgumentError('errorHandler has wrong signature.');
    }
  }
}
```

### **DON'T** setter için dönüş türü belirtmeyin

Linter kuralı: avoid_return_types_on_setters

Dart'ta setter'lar her zaman `void` döndürür. Bu kelimeyi yazmak anlamsızdır.

```dart
void set foo(Foo value) {
   ...
}
```

```dart
set foo(Foo value) {
   ...
}
```

`[]=` operatörü, dönüş türleri açısından bir setter gibi davranır; bu nedenle bu yönerge ona da uygulanır:

```dart
void operator []=(K key, V value) {
   ...
}
```

```dart
operator []=(K key, V value) {
   ...
}
```

### **DON'T** eski typedef sözdizimini kullanmayın

Linter kuralı: prefer_generic_function_type_aliases

Dart'ta bir fonksiyon türü için adlandırılmış bir typedef tanımlamanın iki gösterimi vardır. Özgün sözdizimi şöyle görünür:

```dart
typedef int Comparison<T>(T a, T b);
```

Bu sözdiziminin birkaç sorunu vardır:

- *Generic* bir fonksiyon türüne ad vermenin bir yolu yoktur. Yukarıdaki örnekte typedef'in kendisi generic'tir. Kodunuzda tür argümanı olmadan `Comparison`'a referans verirseniz, örtük olarak `int Function<T>(T, T)` değil, `int Function(dynamic, dynamic)` fonksiyon türünü elde edersiniz. Bu pratikte sık karşılaşılan bir durum değildir, ancak belirli köşe durumlarda önemlidir.
- Bir parametredeki tek bir tanımlayıcı, parametrenin *türü* değil *adı* olarak yorumlanır. Şu örneği ele alın:

  ```dart
  typedef bool TestNumber(num);
  ```

  Çoğu kullanıcı bunun bir `num` alıp `bool` döndüren bir fonksiyon türü olmasını bekler. Oysa aslında *herhangi bir* nesneyi (`dynamic`) alıp `bool` döndüren bir fonksiyon türüdür. Parametrenin *adı* (typedef içinde belgelendirme dışında hiçbir şey için kullanılmayan) "num"dır. Bu, Dart'ta uzun süredir hataların kaynağı olmuştur.

Yeni sözdizimi şöyle görünür:

```dart
typedef Comparison<T> = int Function(T, T);
```

Parametrenin adını da eklemek isterseniz, bunu da yapabilirsiniz:

```dart
typedef Comparison<T> = int Function(T a, T b);
```

Yeni sözdizimi, eski sözdiziminin ifade edebildiği her şeyi ifade edebilir ve daha fazlasını da yapabilir. Ayrıca, tek bir tanımlayıcının parametrenin türü yerine adı olarak yorumlanmasına neden olan, hataya açık bir yanlış özelliğe sahip değildir. Typedef'te `=`'den sonraki aynı fonksiyon türü sözdizimi, bir tür açıklamasının görülebildiği her yerde de kullanılabilir; böylece programın her yerinde fonksiyon türlerini yazmak için tek ve tutarlı bir yöntem elde ederiz.

Eski typedef sözdizimi, mevcut kodu bozmamak için hâlâ desteklenmektedir, ancak kullanımdan kaldırılmıştır (deprecated).

### **PREFER** typedef'ler yerine satır içi fonksiyon türlerini tercih edin

Linter kuralı: avoid_private_typedef_functions

Dart'ta bir field, değişken veya generic tür argümanı için fonksiyon türü kullanmak istiyorsanız, fonksiyon türü için bir typedef tanımlayabilirsiniz. Ancak Dart, tür açıklamasının izin verildiği her yerde kullanılabilen satır içi (inline) bir fonksiyon türü sözdizimini de destekler:

```dart
class FilteredObservable {
  final bool Function(Event) _predicate;
  final List<void Function(Event)> _observers;

  FilteredObservable(this._predicate, this._observers);

  void Function(Event)? notify(Event event) {
    if (!_predicate(event)) return null;

    void Function(Event)? last;
    for (final observer in _observers) {
      observer(event);
      last = observer;
    }

    return last;
  }
}
```

Fonksiyon türü özellikle uzunsa veya sık kullanılıyorsa, yine de bir typedef tanımlamak mantıklı olabilir. Ancak çoğu durumda kullanıcılar, fonksiyon türünün tam olarak ne olduğunu kullanıldığı yerde görmek ister ve fonksiyon türü sözdizimi bu netliği sağlar.

### **PREFER** parametreler için fonksiyon türü sözdizimini kullanmayı tercih edin

Linter kuralı: use_function_type_syntax_for_parameters

Dart, türü bir fonksiyon olan bir parametre tanımlarken özel bir sözdizimine sahiptir. Bir bakıma C'dekine benzer biçimde, parametrenin adını fonksiyonun dönüş türü ve parametre imzasıyla çevrelersiniz:

```dart
Iterable<T> where(bool predicate(T element)) => ...
```

Dart fonksiyon türü sözdizimini eklemeden önce, bu bir typedef tanımlamadan bir parametreye fonksiyon türü vermenin tek yoluydu. Artık Dart'ın fonksiyon türleri için genel bir gösterimi olduğuna göre, bunu fonksiyon türündeki parametreler için de kullanabilirsiniz:

```dart
Iterable<T> where(bool Function(T) predicate) => ...
```

Yeni sözdizimi biraz daha ayrıntılıdır, ancak yeni sözdizimini kullanmak zorunda olduğunuz diğer konumlarla tutarlıdır.

### **AVOID** statik kontrolü devre dışı bırakmak istemiyorsanız `dynamic` kullanmaktan kaçının

Bazı işlemler herhangi bir olası nesneyle çalışır. Örneğin, bir `log()` metodu herhangi bir nesneyi alıp üzerinde `toString()` çağırabilir. Dart'ta tüm değerlere izin veren iki tür vardır: `Object?` ve `dynamic`. Ancak farklı şeyler ifade ederler. Yalnızca tüm nesnelere izin verdiğinizi belirtmek istiyorsanız `Object?` kullanın. `null` *hariç* tüm nesnelere izin vermek istiyorsanız `Object` kullanın.

`dynamic` türü yalnızca tüm nesneleri kabul etmekle kalmaz, aynı zamanda tüm *işlemlere* de izin verir. `dynamic` türündeki bir değer üzerinde yapılan her üye erişimi derleme zamanında kabul edilir, ancak çalışma zamanında başarısız olup bir istisna fırlatabilir. Tam olarak bu riskli ama esnek dinamik dispatch'i istiyorsanız, `dynamic` doğru türdür.

Aksi halde `Object?` veya `Object` kullanmayı tercih edin. Erişmek istediğiniz üyeyi destekleyip desteklemediğini, değerin çalışma zamanı türüne bakarak `is` kontrolleri ve tür yükseltme (type promotion) ile doğrulayın.

```dart
/// [arg] için bir Boolean temsili döndürür; bu değer
/// bir String veya bool olmalıdır.
bool convertToBool(Object arg) {
  if (arg is bool) return arg;
  if (arg is String) return arg.toLowerCase() == 'true';
  throw ArgumentError('Cannot convert $arg to a bool.');
}
```

Bu kuralın ana istisnası, özellikle generic bir tür içinde `dynamic` kullanan mevcut API'lerle çalışmaktır. Örneğin, JSON nesneleri `Map<String, dynamic>` türündedir ve kodunuzun aynı türü kabul etmesi gerekir. Yine de bu API'lerden birindeki bir değeri kullanırken, üyelerine erişmeden önce onu daha kesin bir türe cast etmek çoğu zaman iyi bir fikirdir.

### **DO** değer üretmeyen asenkron üyelerin dönüş türü olarak `Future<void>` kullanın

Değer döndürmeyen senkron bir fonksiyonunuz olduğunda, dönüş türü olarak `void` kullanırsınız. Değer üretmeyen ama çağıranın await etmesi gerekebilecek bir metot için asenkron karşılığı `Future<void>`'dir.

Dart'ın eski sürümleri `void`'in tür argümanı olarak kullanılmasına izin vermediği için, bunun yerine `Future` veya `Future<Null>` kullanan kod görebilirsiniz. Artık bu mümkün olduğundan, `void` kullanmalısınız. Bunu yapmak, benzer bir senkron fonksiyonu nasıl türlendireceğinizle daha doğrudan örtüşür ve çağıranlar için ve fonksiyonun gövdesinde daha iyi hata denetimi sağlar.

Anlamlı bir değer döndürmeyen ve çağıranların asenkron işi beklemesinin veya asenkron bir hatayı ele almasının gerekmediği asenkron fonksiyonlar için dönüş türü olarak `void` kullanın.

### **AVOID** dönüş türü olarak `FutureOr<T>` kullanmaktan kaçının

Bir metot `FutureOr<int>` kabul ediyorsa, kabul ettikleri konusunda cömerttir. Kullanıcılar metodu `int` veya `Future<int>` ile çağırabilir; bu yüzden zaten açacağınız bir `Future` içine `int`'i sarmak zorunda kalmazlar.

Bir `FutureOr<int>` *döndürürseniz*, kullanıcılar kullanışlı bir şey yapmadan önce `int` mi yoksa `Future<int>` mi aldıklarını kontrol etmek zorunda kalır. (Ya da değeri sadece `await` ederler, bu da onu etkin olarak her zaman bir `Future` gibi ele alır.) `Future<int>` döndürün; daha temizdir. Bir fonksiyonun her zaman asenkron mu yoksa her zaman senkron mu olduğunu anlamak kullanıcılar için daha kolaydır; ama ikisinden biri olabilen bir fonksiyonu doğru kullanmak zordur.

```dart
Future<int> triple(FutureOr<int> value) async => (await value) * 3;
```

```dart
FutureOr<int> triple(FutureOr<int> value) {
  if (value is int) return value * 3;
  return value.then((v) => v * 3);
}
```

Bu yönergenin daha kesin ifadesi, *`FutureOr<T>`'yi yalnızca kontravaryant konumlarda kullanmaktır.* Parametreler kontravaryanttır, dönüş türleri ise kovaryanttır. İç içe fonksiyon türlerinde bu durum tersine döner: parametresinin türü kendisi bir fonksiyon olan bir parametreniz varsa, callback'in dönüş türü artık kontravaryant konumdadır ve callback'in parametreleri kovaryanttır. Bu, *bir callback'in* türünün `FutureOr<T>` döndürmesinin uygun olduğu anlamına gelir:

```dart
Stream<S> asyncMap<T, S>(
  Iterable<T> iterable,
  FutureOr<S> Function(T) callback,
) async* {
  for (final element in iterable) {
    yield await callback(element);
  }
}
```

## Parametreler

Dart'ta isteğe bağlı parametreler konumsal veya adlandırılmış olabilir, ancak ikisi birden olamaz.

### **AVOID** konumsal boolean parametrelerden kaçının

Linter kuralı: avoid_positional_boolean_parameters

Diğer türlerden farklı olarak boolean'lar genellikle literal biçimde kullanılır. Sayılar gibi değerler genellikle adlandırılmış sabitlerle sarılır, ancak `true` ve `false`'ı genellikle doğrudan geçiririz. Boolean'ın neyi temsil ettiği açık değilse, bu çağrı noktalarını okunamaz hale getirebilir:

```dart
new Task(true);
new Task(false);
new ListBox(false, true, true);
new Button(false);
```

Bunun yerine, çağrının ne yaptığını netleştirmek için adlandırılmış argümanlar, adlandırılmış constructor'lar veya adlandırılmış sabitler kullanmayı tercih edin.

```dart
Task.oneShot();
Task.repeating();
ListBox(scroll: true, showScrollbars: true);
Button(ButtonState.enabled);
```

Bunun setter'lar için geçerli olmadığını unutmayın; çünkü setter'larda isim, değerin neyi temsil ettiğini zaten açıkça gösterir:

```dart
listBox.canScroll = true;
button.isEnabled = false;
```

### **AVOID** kullanıcı önceki parametreleri atlamak isteyebiliyorsa isteğe bağlı konumsal parametrelerden kaçının

İsteğe bağlı konumsal parametreler mantıksal bir sırayı izlemelidir; öyle ki önceki parametreler sonrakilerden daha sık geçirilsin. Kullanıcıların sonraki bir konumsal argümanı geçirmek için önceki bir konumsal argümanı atlamak amacıyla açıkça bir "boşluk" geçirmesi neredeyse hiç gerekmemelidir. Bunun için adlandırılmış argümanlar kullanmak daha iyidir.

```dart
String.fromCharCodes(Iterable<int> charCodes, [int start = 0, int? end]);

DateTime(
  int year, [
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
]);

Duration({
  int days = 0,
  int hours = 0,
  int minutes = 0,
  int seconds = 0,
  int milliseconds = 0,
  int microseconds = 0,
});
```

### **AVOID** özel bir "argüman yok" değeri kabul eden zorunlu parametrelerden kaçının

Kullanıcı bir parametreyi mantıksal olarak atlıyorsa, `null`, boş bir string veya "geçirilmedi" anlamına gelen başka özel bir değer geçirmeye zorlamak yerine, parametreyi isteğe bağlı yaparak gerçekten atlamasına izin vermeyi tercih edin.

Parametreyi atlamak daha kısadır ve kullanıcı gerçek bir değer verdiğini düşünürken `null` gibi bir sentinel değerin yanlışlıkla geçirildiği hataları önlemeye yardımcı olur.

```dart
var rest = string.substring(start);
```

```dart
var rest = string.substring(start, null);
```

### **DO** bir aralığı kabul etmek için başlangıç dahil, bitiş hariç parametreler kullanın

Kullanıcının integer ile indekslenmiş bir diziden öğe veya eleman aralığı seçmesine izin veren bir metot veya fonksiyon tanımlıyorsanız, ilk öğeye referans veren bir başlangıç indeksi ve son öğenin indeksinden bir fazla olan (muhtemelen isteğe bağlı) bir bitiş indeksi alın.

Bu, aynı şeyi yapan core library'lerle tutarlıdır.

```dart
[0, 1, 2, 3].sublist(1, 3) // [1, 2]
'abcd'.substring(1, 3) // 'bc'
```

Burada tutarlılık özellikle önemlidir, çünkü bu parametreler genellikle adsızdır. API'niz bitiş noktası yerine uzunluk alıyorsa, fark çağrı noktasında hiç görünmez.

## Eşitlik

Bir class için özel eşitlik davranışı uygulamak zor olabilir. Kullanıcıların, nesnelerinizin uyması gereken eşitliğin nasıl çalıştığına dair derin bir sezgisi vardır; hash tablosu gibi koleksiyon türlerinin de öğelerin uymasını beklediği ince sözleşmeleri vardır.

### **DO** `==` operatörünü override ediyorsanız `hashCode`'u da override edin

Linter kuralı: hash_and_equals

Varsayılan hash code uygulaması bir *kimlik* (identity) hash'i sağlar; iki nesne genellikle yalnızca tamamen aynı nesneyse aynı hash code'a sahiptir. Benzer şekilde, `==` için varsayılan davranış da kimliktir.

`==`'yi override ediyorsanız, class'ınızın "eşit" saydığı farklı nesnelerin olabileceği anlamına gelir. **Eşit olan herhangi iki nesnenin aynı hash code'a sahip olması gerekir.** Aksi halde map'ler ve diğer hash tabanlı koleksiyonlar, iki nesnenin eşdeğer olduğunu tanıyamaz.

### **DO** `==` operatörünüzün eşitliğin matematiksel kurallarına uymasını sağlayın

Bir denklik ilişkisi şunları sağlamalıdır:

- **Yansıyan (Reflexive)**: `a == a` her zaman `true` döndürmelidir.
- **Simetrik (Symmetric)**: `a == b`, `b == a` ile aynı sonucu döndürmelidir.
- **Geçişken (Transitive)**: `a == b` ve `b == c` ikisi de `true` dönerse, `a == c` de `true` dönmelidir.

Kullanıcılar ve `==` kullanan kod, bu kuralların tümünün uygulanmasını bekler. Class'ınız bu kurallara uyamıyorsa, `==` ifade etmeye çalıştığınız işlem için doğru isim değildir.

### **AVOID** değiştirilebilir class'lar için özel eşitlik tanımlamaktan kaçının

Linter kuralı: avoid_equals_and_hash_code_on_mutable_classes

`==` tanımladığınızda, `hashCode`'u da tanımlamanız gerekir. İkisi de nesnenin field'larını hesaba katmalıdır. Bu field'lar *değişirse*, nesnenin hash code'unun da değişebileceği anlamına gelir.

Çoğu hash tabanlı koleksiyon bunu beklemez; bir nesnenin hash code'unun sonsuza kadar aynı kalacağını varsayarlar ve bu doğru değilse öngörülemez davranabilirler.

### **DON'T** `==` operatörünün parametresini nullable yapmayın

Linter kuralı: avoid_null_checks_in_equality_operators

Dil, `null`'ın yalnızca kendisine eşit olduğunu ve `==` metodunun yalnızca sağ taraf `null` değilse çağrıldığını belirtir.

```dart
class Person {
  final String name;

  // ···

  bool operator ==(Object other) => other is Person && name == other.name;
}
```

```dart
class Person {
  final String name;

  // ···

  bool operator ==(Object? other) =>
      other != null && other is Person && name == other.name;
}
```


---

