# Soru & Cevap Dokümanı: Dart Anatomisi (01-dart-anatomy)

> **Takım:** `helloworld`  
> **Dönem:** 2026-Güz  
> **Ders:** Mobil Programlama I  

---

### Soru 1: Dart dilinde `main()` fonksiyonunun görevi nedir ve neden zorunludur?
**Cevap:**  
`main()` fonksiyonu tüm Dart programlarının başlangıç (entry point) noktasıdır. Program yürütülmeye başladığında işletim sistemi veya Dart sanal makinesi (VM) ilk olarak bu fonksiyonu çağırır. Fonksiyon genellikle `void main()` şeklinde tanımlanır ve opsiyonel olarak komut satırı argümanları (`List<String> args`) alabilir.

---

### Soru 2: Dart'ta `int` ve `double` türleri arasındaki temel fark nedir?
**Cevap:**  
- **`int`**: Ondalık kısmı olmayan 64-bit tam sayı değerleridir (örn: `3`, `10`, `-5`). Set, tekrar sayıları ve döngü sayaçlarında kullanılır.  
- **`double`**: 64-bit IEEE 754 standardına uygun ondalıklı kayan noktalı sayılardır (örn: `72.5`, `3.14`). Ağırlık, koordinat ve hassas tonaj hesaplamalarında kullanılır.  
Her ikisi de `num` soyut sınıfından türetilmiştir.

---

### Soru 3: `final` ile `const` arasındaki fark nedir? Hangi durumlarda hangisi tercih edilmelidir?
**Cevap:**  
- **`const` (Compile-time sabit):** Değeri kod derlenirken kesin olarak bilinmek zorundadır. Bellekte tek bir kopya olarak tutulur (kanonikleştirme). Uygulamanın değişmez kuralları, sabit dinlenme süreleri veya matematiksel sabitler için kullanılır.  
- **`final` (Runtime sabit):** Değeri program çalışırken (runtime) bir kez atanır ve sonrasında asla değiştirilemez. Kullanıcı girdisiyle hesaplanan değerler (`sets * reps * weight`), API yanıtları veya `DateTime.now()` gibi çalışma zamanı verileri için tercih edilir.

---

### Soru 4: Dart'ta `num` türü yerine doğrudan `int` veya `double` belirtmenin avantajı nedir?
**Cevap:**  
Dart güçlü tipli (strongly typed) bir dildir. Doğrudan `int` veya `double` kullanmak:
1. Derleyicinin tip kontrolü yapmasını sağlayarak mantıksal hataları (örn. set sayısına ondalıklı sayı girilmesi) derleme anında yakalar.
2. Kodun okunabilirliğini ve dokümantasyon kalitesini artırır.
3. AOT (Ahead-of-Time) derlemede optimizasyon sağlayarak performansı yükseltir.

---

### Soru 5: Dart'ta bir `int` ile `double` çarpıldığında sonuç hangi türde olur?
**Cevap:**  
Sonuç otomatik olarak `double` türünde olur. Örneğin:
```dart
int sets = 3;
int reps = 10;
double weight = 60.5;
double totalVolume = sets * reps * weight; // 1815.0 (double)
```
Çünkü Dart tip hiyerarşisinde ondalıklı veri kaybını önlemek için işlem sonucu daha geniş kapsama sahip olan `double` türüne yükseltilir (type promotion).

---

### Soru 6: `if / else if / else` karar bloklarında kısa devre değerlendirmesi (short-circuit evaluation) nedir?
**Cevap:**  
Mantıksal operatörlerde (`&&` ve `||`) ilk ifadenin sonucu tüm şartı belirlemeye yetiyorsa ikinci ifade çalıştırılmaz:
- `&&` (VE) işleminde ilk şart `false` ise, ikinci şarta bakılmaz; sonuç doğrudan `false` olur.
- `||` (VEYA) işleminde ilk şart `true` ise, ikinci şarta bakılmaz; sonuç doğrudan `true` olur.

---

### Soru 7: Geliştirdiğiniz uygulamada tükenişe (failure) ulaşılması dinlenme süresini nasıl etkilemektedir?
**Cevap:**  
Uygulama mantığında `reachedFailure == true` olduğunda `if` bloğu devreye girer:
```dart
if (reachedFailure) {
  calculatedRestSeconds += TrainingPrinciples.failureBonusRestSeconds; // +30 saniye
}
```
Merkezi sinir sistemi (CNS) yüksek yorgunluğa maruz kaldığı için `const int failureBonusRestSeconds = 30;` sabiti taban dinlenme süresine eklenerek sporcunun toparlanması güvenceye alınır.

---

### Soru 8: Progressive Overload (Aşırı Yüklenme) ilkesi kodda nasıl modellenmiştir?
**Cevap:**  
`if (reps >= targetReps && weight >= targetWeight)` koşulu sağlandığında sporcunun hedefe ulaştığı tespit edilir ve bir sonraki antrenman için ağırlığa `TrainingPrinciples.progressiveOverloadStepKg` (+2.5 kg) eklenmesi önerilir. Böylece adaptasyon ve kas gelişimi programatik olarak teşvik edilir.

---

### Soru 9: Dart'ta `toStringAsFixed(1)` metodu ne işe yarar?
**Cevap:**  
Bir `double` sayıyı virgülden sonra belirtilen basamak sayısına (örnekte 1 basamak) yuvarlayarak `String` formatına dönüştürür. Örneğin: `75.467.toStringAsFixed(1)` ifadesi `"75.5"` metnini döndürür. Ağırlık ve 1RM gösterimlerinde temiz UI için kullanılır.

---

### Soru 10: Neden Flutter UI bileşenlerinde `const` kurucular (constructors) tercih edilmelidir?
**Cevap:**  
Flutter'da `const` ile oluşturulan widget'lar (örn. `const SizedBox(height: 16)`), widget ağacı yeniden çizildiğinde (rebuild) tekrar belleğe tahsis edilmez. Aynı bellek adresi yeniden kullanılır. Bu sayede gereksiz bellek tüketimi önlenir ve 60/120 FPS akıcı render performansı elde edilir.
