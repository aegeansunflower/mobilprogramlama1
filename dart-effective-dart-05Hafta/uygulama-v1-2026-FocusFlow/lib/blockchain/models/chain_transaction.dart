import '../core/focus_chain_network.dart';
import '../utils/canonical_json.dart';

/// FocusChain üzerinde kaydedilebilen işlem türleri.
enum ChainTransactionType {
  /// Yeni cüzdana hoş geldin ödülü.
  genesis,

  /// Tamamlanan odak oturumu karşılığı.
  focusReward,

  /// Tamamlanan görev karşılığı.
  taskReward,

  /// Zincir üzerinde basılan başarı rozeti (NFT) ödülü.
  achievementReward,

  /// Blok üreten madenciye verilen coinbase ödülü.
  miningReward,

  /// Cüzdanlar arası token transferi.
  transfer,

  /// FOCUS karşılığında yerel bir ödülün kullanılması.
  rewardRedemption,
}

/// İşlem türlerinin kullanıcıya gösterilen adları.
extension ChainTransactionTypeDetails on ChainTransactionType {
  /// İşlem türünün Türkçe etiketi.
  String get label => switch (this) {
    ChainTransactionType.genesis => 'Hoş geldin ödülü',
    ChainTransactionType.focusReward => 'Odak ödülü',
    ChainTransactionType.taskReward => 'Görev ödülü',
    ChainTransactionType.achievementReward => 'Rozet ödülü',
    ChainTransactionType.miningReward => 'Blok ödülü',
    ChainTransactionType.transfer => 'Transfer',
    ChainTransactionType.rewardRedemption => 'Ödül kullanımı',
  };

  /// Sistem tarafından token basan işlem mi?
  bool get isSystemMint => switch (this) {
    ChainTransactionType.genesis ||
    ChainTransactionType.focusReward ||
    ChainTransactionType.taskReward ||
    ChainTransactionType.achievementReward ||
    ChainTransactionType.miningReward => true,
    ChainTransactionType.transfer ||
    ChainTransactionType.rewardRedemption => false,
  };

  /// Cüzdandan FOCUS çıkaran bir harcama mı?
  bool get isSpend =>
      this == ChainTransactionType.transfer ||
      this == ChainTransactionType.rewardRedemption;

  /// Cüzdana gelir olarak yansıyan bir ödül mü?
  bool get isReward => !isSpend;
}

/// FocusChain'e yazılan değişmez bir işlem.
///
/// [id], işlem gövdesinin kanonik JSON özetidir. Kullanıcı transferlerinde
/// ayrıca Ed25519 [signature] ve göndericinin [senderPublicKey] değeri
/// saklanır. Sistem ödüllerinde imza aranmaz.
class ChainTransaction {
  /// Var olan alanlardan işlem nesnesi oluşturur.
  const ChainTransaction({
    required this.id,
    required this.type,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
    required this.timestamp,
    this.metadata = const <String, Object?>{},
    this.signature,
    this.senderPublicKey,
  });

  /// İşlem gövdesinden deterministik kimlik üretir.
  factory ChainTransaction.create({
    required ChainTransactionType type,
    required String fromAddress,
    required String toAddress,
    required int amount,
    required int timestamp,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final payload = _payloadOf(
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      timestamp: timestamp,
      metadata: metadata,
    );
    return ChainTransaction(
      id: sha256Hex(canonicalJsonEncode(payload)),
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      timestamp: timestamp,
      metadata: Map<String, Object?>.unmodifiable(metadata),
    );
  }

  /// İşlemin zincirdeki benzersiz kimliği.
  final String id;

  /// İşlem türü.
  final ChainTransactionType type;

  /// Tokenların çıktığı adres.
  final String fromAddress;

  /// Tokenların gittiği adres.
  final String toAddress;

  /// Transfer edilen FOCUS miktarı; her zaman pozitiftir.
  final int amount;

  /// İşlemin oluşturulma zamanı (Unix milisaniye).
  final int timestamp;

  /// İşlemle ilişkili oturum, görev veya rozet bilgileri.
  final Map<String, Object?> metadata;

  /// Kullanıcı transferlerinde Ed25519 imzası (base64).
  final String? signature;

  /// İmzayı doğrulamak için göndericinin açık anahtarı (base64).
  final String? senderPublicKey;

  /// İşlemin kullanıcıya gösterilen zamanı.
  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();

  /// İşlem sistem tarafından mı üretildi?
  bool get isSystemTransaction =>
      fromAddress == FocusChainNetwork.systemAddress;

  /// İmzalanacak kanonik gövde.
  String get signingPayload {
    return canonicalJsonEncode(
      _payloadOf(
        type: type,
        fromAddress: fromAddress,
        toAddress: toAddress,
        amount: amount,
        timestamp: timestamp,
        metadata: metadata,
      ),
    );
  }

  /// Aynı gövdeyi koruyarak imza bilgisi eklenmiş yeni işlem döndürür.
  ChainTransaction withSignature({
    required String signature,
    required String senderPublicKey,
  }) {
    return ChainTransaction(
      id: id,
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      timestamp: timestamp,
      metadata: metadata,
      signature: signature,
      senderPublicKey: senderPublicKey,
    );
  }

  /// Demo bütünlük testi için miktarı değiştirilmiş bir kopya üretir.
  ///
  /// Kimlik yeniden hesaplanır ancak eski imza korunur. Böylece blok hash'i
  /// ve imza doğrulaması değişikliği yakalayabilir.
  ChainTransaction tamperAmount(int newAmount) {
    final payload = _payloadOf(
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: newAmount,
      timestamp: timestamp,
      metadata: metadata,
    );
    return ChainTransaction(
      id: sha256Hex(canonicalJsonEncode(payload)),
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: newAmount,
      timestamp: timestamp,
      metadata: metadata,
      signature: signature,
      senderPublicKey: senderPublicKey,
    );
  }

  /// İşlemi JSON'a dönüştürür.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'amount': amount,
      'timestamp': timestamp,
      'metadata': metadata,
      'signature': signature,
      'senderPublicKey': senderPublicKey,
    };
  }

  /// JSON'dan işlem üretir; kimlik gövdeyle uyuşmuyorsa kaydı reddeder.
  factory ChainTransaction.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final typeRaw = json['type'];
    final fromAddress = json['fromAddress'];
    final toAddress = json['toAddress'];
    final amount = json['amount'];
    final timestamp = json['timestamp'];

    if (id is! String || id.trim().isEmpty) {
      throw const FormatException('İşlem kimliği geçersiz.');
    }
    final type = _parseType(typeRaw);
    if (type == null) {
      throw const FormatException('İşlem türü geçersiz.');
    }
    if (fromAddress is! String || fromAddress.trim().isEmpty) {
      throw const FormatException('Gönderici adresi geçersiz.');
    }
    if (toAddress is! String || toAddress.trim().isEmpty) {
      throw const FormatException('Alıcı adresi geçersiz.');
    }
    if (amount is! int || amount <= 0) {
      throw const FormatException('İşlem miktarı geçersiz.');
    }
    if (timestamp is! int || timestamp <= 0) {
      throw const FormatException('İşlem zamanı geçersiz.');
    }

    final metadataRaw = json['metadata'];
    final metadata = metadataRaw is Map<String, dynamic>
        ? Map<String, Object?>.unmodifiable(metadataRaw)
        : const <String, Object?>{};

    final payload = _payloadOf(
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      timestamp: timestamp,
      metadata: metadata,
    );
    if (sha256Hex(canonicalJsonEncode(payload)) != id) {
      throw const FormatException('İşlem kimliği gövdeyle uyuşmuyor.');
    }

    final signature = json['signature'];
    final senderPublicKey = json['senderPublicKey'];
    return ChainTransaction(
      id: id,
      type: type,
      fromAddress: fromAddress,
      toAddress: toAddress,
      amount: amount,
      timestamp: timestamp,
      metadata: metadata,
      signature: signature is String ? signature : null,
      senderPublicKey: senderPublicKey is String ? senderPublicKey : null,
    );
  }

  static Map<String, Object?> _payloadOf({
    required ChainTransactionType type,
    required String fromAddress,
    required String toAddress,
    required int amount,
    required int timestamp,
    required Map<String, Object?> metadata,
  }) {
    return <String, Object?>{
      'type': type.name,
      'fromAddress': fromAddress,
      'toAddress': toAddress,
      'amount': amount,
      'timestamp': timestamp,
      'metadata': metadata,
    };
  }

  static ChainTransactionType? _parseType(Object? value) {
    if (value is! String) {
      return null;
    }
    for (final type in ChainTransactionType.values) {
      if (type.name == value) {
        return type;
      }
    }
    return null;
  }
}
