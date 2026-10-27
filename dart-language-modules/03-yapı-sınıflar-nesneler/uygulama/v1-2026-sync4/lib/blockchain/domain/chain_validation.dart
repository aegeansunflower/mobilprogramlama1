// DART KONUSU: Class modifiers — iç içe `sealed class` hiyerarşisi
// (ChainValidation → ChainBroken → somut hatalar) ve `final class` yapraklar.
// Classes & objects — `super` parametreleri, soyut getter, `toString`.

/// Zincir doğrulamasının sonucu.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// `validateChain()` sonucu.
///
/// `sealed` seçildi: kurcalama ekranı `switch` ile her sonuç türüne ayrı bir
/// açıklama ve ikon gösterir. Yeni bir hata türü eklenirse bu ekran derleme
/// hatası verir, yani hiçbir hata türü sessizce atlanamaz.
@immutable
sealed class ChainValidation {
  const ChainValidation();
}

/// Zincirin tamamı geçerli.
final class ChainValid extends ChainValidation {
  const ChainValid({required this.length, required this.head});

  /// Doğrulanan blok sayısı.
  final int length;

  /// Son bloğun hash'i.
  final Hash head;

  @override
  String toString() => 'ChainValid($length blok, head ${head.short})';
}

/// Zincirin bozulduğu ilk blok.
///
/// Bu da `sealed`: alt türler bu dosyada sabittir, ama hepsi ortak
/// [blockIndex] ve [reason] alanlarını taşır.
sealed class ChainBroken extends ChainValidation {
  const ChainBroken(this.blockIndex);

  /// Bozulmanın tespit edildiği blok.
  final int blockIndex;

  /// Türkçe açıklama.
  String get reason;

  @override
  String toString() => 'ChainBroken(#$blockIndex: $reason)';
}

/// Genesis bloğu beklenen deterministik genesis ile eşleşmiyor.
final class InvalidGenesis extends ChainBroken {
  const InvalidGenesis() : super(0);

  @override
  String get reason => 'Genesis bloğu beklenen değerle eşleşmiyor.';
}

/// Blok depodan okunamadı (JSON bozulmuş ya da alanlar eksik).
final class UnreadableBlock extends ChainBroken {
  const UnreadableBlock(super.blockIndex, {required this.error});

  final Object error;

  @override
  String get reason => 'Blok verisi okunamıyor (kayıt bozulmuş).';
}

/// Blok indeksleri ardışık değil (blok silinmiş ya da eklenmiş).
final class IndexGap extends ChainBroken {
  const IndexGap(super.blockIndex, {required this.actual});

  final int actual;

  @override
  String get reason => 'Beklenen indeks $blockIndex, bulunan $actual.';
}

/// İşlemler değiştirilmiş: yeniden hesaplanan Merkle kökü saklananla aynı
/// değil.
final class MerkleMismatch extends ChainBroken {
  const MerkleMismatch(
    super.blockIndex, {
    required this.stored,
    required this.computed,
  });

  final Hash stored;
  final Hash computed;

  @override
  String get reason =>
      'Bloktaki yoklama kayıtları değiştirilmiş (Merkle kökü uyuşmuyor).';
}

/// Blok başlığı değiştirilmiş: yeniden hesaplanan hash saklananla aynı değil.
final class HashMismatch extends ChainBroken {
  const HashMismatch(
    super.blockIndex, {
    required this.stored,
    required this.computed,
  });

  final Hash stored;
  final Hash computed;

  @override
  String get reason => 'Blok başlığı değiştirilmiş (hash uyuşmuyor).';
}

/// `previousHash` bir önceki bloğun hash'ini göstermiyor.
final class BrokenLink extends ChainBroken {
  const BrokenLink(
    super.blockIndex, {
    required this.expected,
    required this.actual,
  });

  final Hash expected;
  final Hash actual;

  @override
  String get reason =>
      'Önceki blokla bağlantı kopmuş (previousHash ${actual.short}, '
      'beklenen ${expected.short}).';
}

/// Blok zamanı bir önceki bloktan önce.
final class TimestampRegression extends ChainBroken {
  const TimestampRegression(super.blockIndex);

  @override
  String get reason => 'Blok zamanı önceki bloktan daha eski.';
}

/// Bloğu imzalayan, yetkili listesinde yok.
final class UnknownAuthority extends ChainBroken {
  const UnknownAuthority(super.blockIndex, {required this.authorityId});

  final String authorityId;

  @override
  String get reason => '"$authorityId" yetkili bir öğretim görevlisi değil.';
}

/// İmza geçersiz.
final class BadSignature extends ChainBroken {
  const BadSignature(super.blockIndex, {required this.authorityId});

  final String authorityId;

  @override
  String get reason => 'Blok imzası "$authorityId" anahtarıyla doğrulanamadı.';
}
