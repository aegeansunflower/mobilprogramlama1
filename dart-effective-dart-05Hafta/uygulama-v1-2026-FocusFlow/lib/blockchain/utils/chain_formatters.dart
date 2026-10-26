/// Zincir hash ve adreslerini kısa, okunabilir biçimde gösterir.
String shortHash(String hash, {int head = 10, int tail = 6}) {
  if (hash.length <= head + tail + 1) {
    return hash;
  }
  return '${hash.substring(0, head)}…${hash.substring(hash.length - tail)}';
}

/// `0x` ile başlayan cüzdan adresini kısaltır.
String shortAddress(String address) {
  if (address.length <= 14) {
    return address;
  }
  return '${address.substring(0, 8)}…${address.substring(address.length - 6)}';
}

/// FOCUS miktarını sembolüyle birlikte gösterir.
String formatFocusAmount(int amount) => '$amount FOCUS';

/// Pozitif bir ödül miktarını işaretli gösterir.
String formatSignedFocus(int amount) => '+$amount FOCUS';
