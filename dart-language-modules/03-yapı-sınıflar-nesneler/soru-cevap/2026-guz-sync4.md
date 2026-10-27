# DART KODLAMA MİMARİSİ SORULARI

---

### Soru 1
**Soru:** Bir geliştirici; yazdığı kodda çalışma zamanında `is` operatörü ile dinamik tür testleri (*type checking*) yapacaksa ve çalışma zamanındaki bu tür güvenliği onun için kritikse, metindeki "Tür değerlendirmeleri" bölümüne göre hangi yapıyı kullanmalıdır?

**Cevap:** Geliştirici geleneksel sarmalayıcı (*wrapper*) sınıf kullanmalıdır.
> **Neden?** Extension type'lar yalnızca derleme zamanında (*compile-time*) var olan, sıfır maliyetli ve şeffaf soyutlamalardır. Derleme bittiğinde extension type'ın "hiçbir izi kalmaz" (tür silinir). Bu nedenle çalışma zamanında yapılan `is` (tür testi) veya `as` (tür dönüşümü) gibi dinamik kontroller, extension type'ın kendisine değil, onun sardığı alttaki temsil nesnesine (*representation type*) uygulanır.

---

### Soru 2
**Soru:** Normal constructor ile `factory` constructor arasındaki temel fark nedir?

**Cevap:** Normal constructor genellikle yeni bir nesne oluşturur. `factory` constructor ise yeni bir nesne oluşturabilir veya önceden oluşturulmuş bir nesneyi döndürebilir.
> **Neden?** Çünkü `factory`, nesnenin nasıl oluşturulacağına karar verme esnekliği sağlar. Örneğin, aynı nesneyi tekrar kullanabilir.

---

### Soru 3
**Soru:** Dart dilinde iki farklı kütüphanede aynı isimde sınıflar varsa isim karışıklığını önlemek için hangisi kullanılabilir?

- A) `@override`
- **B) `as`**
- C) `factory`
- D) `const`
- E) `return`

**Doğru Cevap:** **B) as**
> **Neden?** `as`, kütüphaneye bir takma ad (*prefix*) vermemizi sağlar. Böylece aynı isimli sınıfları birbirinden ayırabiliriz.

---

### Soru 4
**Soru:** "Sınıf değiştiricileri başvurusu (Geçersiz birleşimler)" bölümüne göre, Dart'ta `mixin` anahtar kelimesi ile `final`, `interface` veya `base` değiştiricilerinin birlikte kullanılamamasının (geçersiz olmasının) temel gerekçesi aşağıdakilerden hangisidir?

- A) Mixin'lerin yalnızca `abstract` sınıflarla birlikte kullanılabilmesi ve bu değiştiricilerin `abstract` yapısını bozması.
- B) `final`, `interface` ve `base` değiştiricilerinin sınıfların örneklenmesini (*instantiate*) engellemesi.
- **C) Bir mixin bildiriminin temel amacının "mixin olarak eklenmek" olması, ancak belirtilen bu üç değiştiricinin sınıfların mixin olarak eklenmesini (`with` kullanımını) engellemesi.**
- D) Dart 3.0 ile birlikte mixin'lerin artık başka kütüphanelerde hiçbir şekilde kullanılamayacak olması.
- E) Bu değiştiricilerin `sealed` hiyerarşisi dışında kullanıldığında çalışma zamanı hatasına yol açması.

**Doğru Cevap:** **C) Bir mixin bildiriminin temel amacının "mixin olarak eklenmek" olması, ancak belirtilen bu üç değiştiricinin sınıfların mixin olarak eklenmesini (`with` kullanımını) engellemesi.**
> **Neden?** Dart dilinde mixin yapısı, doğası gereği başka sınıflara özellik kazandırmak (yani `with` kelimesiyle başka sınıflara "eklenmek") için yaratılır. Ancak `final`, `interface` ve `base` değiştiricileri, eklendikleri sınıfın başka kütüphanelerde mixin olarak kullanılmasını kesinlikle yasaklar.

---

### Kaynaklar ve Bağlantılar
- **Video:** [YouTube Video](https://youtu.be/8D1UK3hq8U8)
- **Haber:** [Flutter & Dart 2026 Roadmap](https://flutter.dev/blog/flutter-darts-2026-roadmap)

---

### Hazırlayanlar
*İncelediğiniz için teşekkürler.*

- Osman Ceran
- Murat Polat
- Emir Sevgili
- Eymen İşleksoy
