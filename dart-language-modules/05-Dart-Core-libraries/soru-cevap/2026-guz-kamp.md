# Dart Core Kütüphaneleri — Pekiştirme Soruları (kamp Takımı)

**Mobil Programlama I · 5. Takım (kamp)** · Konu: Dart Core Libraries (`dart:core`, `dart:async`, `dart:convert`, `dart:io`, `Iterable`, `Future`, `Stream`)

Bu dokümanda **Dart Core Kütüphaneleri** konusuyla ilgili 2 çoktan seçmeli (test) ve 2 açık uçlu pekiştirme sorusu ve cevapları yer almaktadır.

---

## 📝 Bölüm 1: Çoktan Seçmeli Sorular (Test)

### 1. Soru (Asenkron Programlama / Future Hata Yönetimi)

Dart'ta `Future` zincirinde `catchError()` metodunun `then()` metodundan sonra çağrılmasının temel nedeni aşağıdakilerden hangisidir?

A) `Future` işlemlerinin eş zamanlı çalışmasını sağlamak.  
B) Yalnızca `then()` metodunda oluşan hataları yakalamak.  
C) Hem orijinal `Future` işleminden hem de `then()` içerisindeki işlemden kaynaklanan hataları yakalamak.  
D) `Future` işlemi tamamlanmadan önce hata kontrolünü gerçekleştirmek.  
E) `then()` metodunun birden fazla kez çalışmasını önlemek.  

**Doğru Cevap:** **C**  
*Açıklama:* `catchError()`, `then()` çağrısından dönen yeni `Future` üzerine zincirlendiğinde, hem ilk asenkron işlemden gelen hataları hem de `then()` callback'i içinde fırlatılabilecek olası hataları tek bir noktada yakalar.

---

### 2. Soru (Koleksiyonlar / Iterable ve Tembel Değerlendirme)

Dart'ta `Iterable` koleksiyonları üzerinde kullanılan `map()` metodunun çalışma biçimiyle ilgili aşağıdaki ifadelerden hangisi doğrudur?

A) `map()` işlemi sırasında bütün elemanlar anında dönüştürülür, ancak sonuçlar kullanılıncaya kadar saklanmaz.  
B) `map()` metodundan dönen `Iterable`, dönüşümleri yalnızca elemanlar istendiğinde gerçekleştirir; `toList()` kullanılması tüm elemanların hemen değerlendirilmesini sağlar.  
C) `map()` metodu, dönüşüm tamamlanmadan koleksiyonun elemanlarına erişilmesini engeller.  
D) `map()` metodunun dönüşümü ertelemesi yalnızca `Set` koleksiyonlarında geçerlidir.  
E) `map()` metodunun tembel değerlendirme özelliği yalnızca asenkron işlemlerde kullanılabilir.  

**Doğru Cevap:** **B**  
*Açıklama:* `map()` tembel (lazy) olarak değerlendirilen bir `Iterable` döner. Fonksiyon, dönen nesneden eleman talep edilene kadar çalıştırılmaz. `toList()` veya `toSet()` çağrıldığında iterasyon anında zorlanır.

---

## ✍️ Bölüm 2: Açık Uçlu (Klasik) Sorular

### 3. Soru (Veri Dönüştürme / `dart:convert` JSON İşlemleri)

Dart'ta `jsonEncode()` metodu bir nesneyi doğrudan JSON formatına dönüştüremediğinde, bu nesneyi dönüştürmek için kullanılabilecek iki yöntem nedir?

**Cevap:**  
1. `jsonEncode()` metoduna ikinci parametre olarak doğrudan kodlanabilir bir nesne döndüren özel bir dönüştürme fonksiyonu verilebilir.  
2. Doğrudan kodlanamayan nesne sınıfına bir `toJson()` metodu tanımlanabilir; bu durumda `jsonEncode()` otomatik olarak nesnenin `toJson()` metodunu çağırır.

---

### 4. Soru (Reaktif Programlama / `dart:async` StreamController ve Bellek Yönetimi)

Dart'ta `StreamController` kullanılarak oluşturulan bir stream'e henüz hiçbir dinleyici abone olmamışken olay eklenirse ne olur? Bu durumun oluşturabileceği riski kısaca açıklayınız.

**Cevap:**  
Olaylar `StreamController` tarafından arabelleğe (buffer) alınır. Stream'e hiçbir dinleyici abone olmazsa, biriken olaylar bellekten temizlenemez ve bu durum bellek sızıntısına (memory leak) yol açabilir.
