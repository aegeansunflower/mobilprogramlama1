/// Cihazda saklanan yerel FocusChain cüzdanı.
///
/// Demo/yarışma sürümünde özel anahtar yalnızca cihazdaki yerel depoda tutulur.
/// Gerçek bir üretim cüzdanında özel anahtarın platform keychain'i veya
/// donanım destekli güvenli alanda saklanması gerekir.
class WalletAccount {
  /// Cüzdan alanlarıyla nesne oluşturur.
  const WalletAccount({
    required this.address,
    required this.publicKey,
    required this.privateKey,
  });

  /// `0x` ile başlayan 40 hex karakterli cüzdan adresi.
  final String address;

  /// Ed25519 açık anahtarı (base64).
  final String publicKey;

  /// Ed25519 özel anahtar tohumu (base64).
  final String privateKey;

  /// Cüzdanı JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'address': address,
      'publicKey': publicKey,
      'privateKey': privateKey,
    };
  }

  /// JSON'dan cüzdan üretir.
  factory WalletAccount.fromJson(Map<String, dynamic> json) {
    final address = json['address'];
    final publicKey = json['publicKey'];
    final privateKey = json['privateKey'];
    if (address is! String || address.trim().isEmpty) {
      throw const FormatException('Cüzdan adresi geçersiz.');
    }
    if (publicKey is! String || publicKey.trim().isEmpty) {
      throw const FormatException('Cüzdan açık anahtarı geçersiz.');
    }
    if (privateKey is! String || privateKey.trim().isEmpty) {
      throw const FormatException('Cüzdan özel anahtarı geçersiz.');
    }
    return WalletAccount(
      address: address,
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }
}
