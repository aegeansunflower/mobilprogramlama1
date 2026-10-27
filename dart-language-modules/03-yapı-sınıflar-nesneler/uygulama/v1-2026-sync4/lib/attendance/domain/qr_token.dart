// DART KONUSU: Metadata — `@Deprecated` (eski imzasız QR biçimi). Classes &
// objects — callable class (`QrTokenValidator.call`), static metotlar,
// const constructor, mixin. Class modifiers — `final class`. Libraries &
// imports — `show`.

/// 15 saniyede bir yenilenen, imzalı QR jetonu.
library;

import 'dart:convert' show base64Url, jsonDecode, utf8;
import 'dart:math' show Random;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/blockchain/blockchain.dart'
    show AuthorityDirectory, BlockSigner, Ed25519Verifier, SignatureVerifier;
import 'package:sarkisla_yoklama/core/core.dart';

/// QR içeriği: `SYQ2.<yük>.<imza>` (base64url).
///
/// Yük: `{v, s: oturum, a: yetkili, t: zaman(ms), n: nonce}`. İmza,
/// yükün kanonik JSON baytları üzerine öğretim görevlisinin Ed25519
/// anahtarıyla atılır.
@immutable
final class QrToken with Timestamped {
  const QrToken({
    required this.sessionId,
    required this.authorityId,
    required this.timestamp,
    required this.nonce,
    this.signature,
  });

  static const String prefix = 'SYQ2';

  /// QR'ın yenilenme aralığı.
  static const Duration refreshInterval = Duration(seconds: 15);

  final String sessionId;
  final String authorityId;
  @override
  final DateTime timestamp;
  final String nonce;
  final List<int>? signature;

  Map<String, Object?> get _payload => {
    'v': 2,
    's': sessionId,
    'a': authorityId,
    't': timestamp.millisecondsSinceEpoch,
    'n': nonce,
  };

  /// İmzalanan baytlar.
  List<int> get signingBytes => canonicalBytes(_payload);

  /// Yeni, imzalı jeton üretir.
  static Future<QrToken> issue({
    required String sessionId,
    required BlockSigner signer,
    required DateTime now,
    Random? random,
  }) async {
    final rnd = random ?? Random.secure();
    final nonce = [for (var i = 0; i < 12; i++) rnd.nextInt(256)].toBase64Url;
    final unsigned = QrToken(
      sessionId: sessionId,
      authorityId: signer.authorityId,
      timestamp: now.toUtc(),
      nonce: nonce,
    );
    return QrToken(
      sessionId: sessionId,
      authorityId: signer.authorityId,
      timestamp: unsigned.timestamp,
      nonce: nonce,
      signature: await signer.sign(unsigned.signingBytes),
    );
  }

  /// QR'a yazılacak metin.
  String encode() {
    final body = base64Url.encode(utf8.encode(canonicalJson(_payload)));
    return '$prefix.$body.${(signature ?? const []).toBase64Url}';
  }

  /// QR metnini çözer.
  static Result<QrToken> decode(String raw) {
    final parts = raw.trim().split('.');
    if (parts.length != 3 || parts.first != prefix) {
      return const Err(ValidationFailure('Bu bir yoklama QR kodu değil.'));
    }
    try {
      final json = jsonDecode(
        utf8.decode(parts[1].base64UrlToBytes),
      ) as Map<String, Object?>;
      return Ok(
        QrToken(
          sessionId: json['s']! as String,
          authorityId: json['a']! as String,
          timestamp: DateTime.fromMillisecondsSinceEpoch(
            json['t']! as int,
            isUtc: true,
          ),
          nonce: json['n']! as String,
          signature: parts[2].isEmpty ? null : parts[2].base64UrlToBytes,
        ),
      );
    } on Object catch (e) {
      return Err(ValidationFailure('QR kodu okunamadı.', cause: e));
    }
  }

  /// Eski (v1) biçim: `SYQ1|oturum|zaman`. İmza taşımadığı için kolayca
  /// sahtelenebiliyordu. Yalnızca eski QR'lara anlamlı bir hata mesajı
  /// verebilmek için duruyor.
  @Deprecated(
    'v1 QR imzasızdır ve sahtelenebilir; QrToken.decode kullanın. '
    'Bir sonraki ana sürümde kaldırılacak.',
  )
  static Result<QrToken> decodeLegacyV1(String raw) {
    final parts = raw.split('|');
    if (parts.length != 3 || parts.first != 'SYQ1') {
      return const Err(ValidationFailure('v1 QR biçimi değil.'));
    }
    return Ok(
      QrToken(
        sessionId: parts[1],
        authorityId: 'bilinmiyor',
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          int.parse(parts[2]),
          isUtc: true,
        ),
        nonce: '',
      ),
    );
  }

  @override
  String toString() => 'QrToken($sessionId, $nonce)';
}

/// QR jetonunu doğrular: biçim → imza → tazelik.
///
/// Callable class: `final result = await validateQr(raw);`
final class QrTokenValidator {
  const QrTokenValidator({
    required this.directory,
    required this.clock,
    this.verifier = const Ed25519Verifier(),
    this.maxAge = QrToken.refreshInterval,
    this.clockSkew = const Duration(seconds: 5),
  });

  final AuthorityDirectory directory;
  final Clock clock;
  final SignatureVerifier verifier;
  final Duration maxAge;

  /// Öğrenci ve görevli cihazlarının saatleri arasındaki tolerans.
  final Duration clockSkew;

  Future<Result<QrToken>> call(String raw) async {
    if (raw.startsWith('SYQ1|')) {
      return const Err(
        ValidationFailure('Eski QR biçimi artık desteklenmiyor.'),
      );
    }
    final decoded = QrToken.decode(raw);
    final QrToken token;
    switch (decoded) {
      case Ok(:final value):
        token = value;
      case Err(:final failure):
        return Err(failure);
    }

    final signature = token.signature;
    if (signature == null) {
      return const Err(ValidationFailure('QR kodu imzasız.'));
    }

    final age = clock.now().difference(token.timestamp);
    if (age > maxAge + clockSkew || age < -clockSkew) {
      return const Err(
        ValidationFailure(
          'QR kodunun süresi doldu. Ekrandaki yeni kodu tarayın.',
        ),
      );
    }

    final key = await directory.publicKeyOf(token.authorityId);
    if (key == null) {
      return const Err(
        ValidationFailure('QR kodu yetkili bir görevliye ait değil.'),
      );
    }
    final valid = await verifier.verify(
      token.signingBytes,
      signature: signature,
      publicKey: key,
    );
    if (!valid) return const Err(ValidationFailure('QR imzası geçersiz.'));
    return Ok(token);
  }
}
