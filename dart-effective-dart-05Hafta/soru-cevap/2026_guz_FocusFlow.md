# Mobil Programlama Sunumu: Effective Dart Soruları

Bu doküman, **Effective Dart** rehberi temel alınarak hazırlanmış 2 adet çoktan seçmeli ve kısa cevaplı 2 adet klasik soruyu içermektedir.

---

## Çoktan Seçmeli Sorular

### Soru 1 (Stil Rehberi)
**Effective Dart: Stil** rehberine göre, Dart dilinde tanımlayıcıların (identifiers) adlandırılmasıyla ilgili aşağıdaki eşleştirmelerden hangisi **yanlıştır**?

A) Sınıf (Class) ve enum tür adları -> `UpperCamelCase` (Örn: `SliderMenu`)  
B) Paket, dizin ve kaynak dosya adları -> `lowercase_with_underscores` (Örn: `slider_menu.dart`)  
C) İçe aktarma önekleri (import prefixes) -> `lowerCamelCase` (Örn: `as angularComponents;`)  
D) Sabit (const) değişken adları -> `lowerCamelCase` (Örn: `const defaultTimeout = 1000;`)  
E) İki harften uzun kısaltma ve akronimler -> Kelimeler gibi yalnızca ilk harfi büyük (Örn: `HttpRequest`)  

> **Doğru Cevap:** **C**  
> **Açıklama:** İçe aktarma önekleri `lowerCamelCase` değil, `lowercase_with_underscores` formatında yazılmalıdır (Örn: `as angular_components;`).

---

### Soru 2 (Kullanım Rehberi)
**Effective Dart: Kullanım** rehberine göre koleksiyonlar ve hata yönetimi ile ilgili aşağıdaki ifadelerden hangisi **doğrudur**?

A) Bir koleksiyonun boş olup olmadığını kontrol etmek için `.length == 0` kullanılmalıdır.  
B) Karışık türdeki nesneleri filtrelemek için `.where((e) => e is T).cast<T>()` yerine `.whereType<T>()` kullanılmalıdır.  
C) Yakalanan bir istisnayı yeniden fırlatmak için `rethrow` yerine `throw e;` kullanılmalıdır.  
D) Bir iterable üzerinde döngü kurarken anonim fonksiyonlarla `.forEach()` kullanmak, `for-in` döngüsünden daha yaygındır.  
E) Boş bir liste oluştururken `[]` yerine `List()` constructor'ı tercih edilmelidir.

> **Doğru Cevap:** **B**  
> **Açıklama:** `whereType<T>()` metodu kısadır, ek sarmalama katmanı oluşturmaz ve doğrudan istenen türde bir `Iterable<T>` üretir.

---

## Klasik (Açık Uçlu) Sorular

### Soru 3 (Kullanım Rehberi - Hesaplanan Değerler)
**Soru:** *Effective Dart* rehberine göre, mevcut verilerden hesaplanabilecek değerleri (örn. yarıçaptan alanı) sınıf içinde ayrı birer değişken olarak saklamak yerine neden **getter** kullanarak hesaplamalıyız? İki temel nedeni nedir?

> **Cevap:**
> 1. **Bellek İsrafı:** Zaten mevcut verilerden hesaplanabilecek değerleri ayrı alanlarda tutmak gereksiz bellek tüketir.
> 2. **Önbellek Geçersiz Kılma (Cache Invalidation) Sorunu:** Temel veri değiştiğinde saklanan alan eski (yanlış) değerini korur ve senkronizasyon hatalarına yol açar. Getter kullanmak her zaman güncel ve doğru sonuç verir.

---

### Soru 4 (Tasarım Rehberi - Eşitlik Operatörü)
**Soru:** Dart dilinde bir sınıf için `==` operatörünü override ederken dikkat edilmesi gereken en önemli iki kural nedir?

> **Cevap:**
> 1. **`hashCode` Override Edilmelidir:** Eşit olan iki nesnenin aynı hash koduna sahip olması gerekir; aksi takdirde `Map` ve `Set` gibi hash tabanlı koleksiyonlar nesneleri tanıyamaz.
> 2. **Parametre `nullable` Olmamalıdır:** `==` operatörünün parametresi `Object?` değil `Object` olmalıdır, çünkü Dart dilinde `null` yalnızca kendisine eşittir ve kontrolü dil tarafından otomatik yapılır.