// DART KONUSU: Libraries & imports — `part of`. Bu dosya `block.dart`
// kütüphanesinin bir parçasıdır: onun import'larını ve private üyelerini
// (`Block._restored`) paylaşır, kendi import'u olamaz.

part of 'block.dart';

Map<String, Object?> _blockToJson(Block<Record> block) => {
  'index': block.index,
  'timestamp': block.timestamp.millisecondsSinceEpoch,
  'previousHash': block.previousHash.hex,
  'merkleRoot': block.merkleRoot.hex,
  'hash': block.hash.hex,
  'authority': block.authorityId,
  'signature': switch (block.signature) {
    final sig? => base64Url.encode(sig),
    null => null,
  },
  'transactions': [for (final tx in block.transactions) tx.envelope],
};

Block<T> _blockFromJson<T extends Record>(
  Map<String, Object?> json,
  RecordDecoder<T> decode,
) {
  final signature = json['signature'] as String?;
  return Block._restored(
    index: json['index']! as int,
    timestamp: (json['timestamp']! as int).asUtcDateTime,
    previousHash: Hash.fromHex(json['previousHash']! as String),
    authorityId: json['authority']! as String,
    merkleRoot: Hash.fromHex(json['merkleRoot']! as String),
    hash: Hash.fromHex(json['hash']! as String),
    signature: signature == null ? null : base64Url.decode(signature),
    transactions: [
      for (final tx in json['transactions']! as List<Object?>)
        decode(Map<String, Object?>.from(tx! as Map)),
    ],
  );
}
