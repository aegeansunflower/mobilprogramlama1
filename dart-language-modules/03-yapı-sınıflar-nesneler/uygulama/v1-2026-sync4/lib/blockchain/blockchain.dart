// DART KONUSU: Libraries & imports — barrel dosya; `show` ile yalnızca genel
// API'nin dışa açılması (ör. drift tablo sınıfı dışarı sızmaz).

/// Blockchain katmanı: blok, zincir, Merkle ağacı, imza, PoA konsensüsü,
/// doğrulama ve depolar.
library;

export 'data/local/chain_database.dart' show ChainDatabase;
export 'data/local_first_blockchain_repository.dart';
export 'data/remote/firestore_authority_directory.dart';
export 'data/remote/firestore_chain_source.dart';
export 'data/remote/remote_chain_source.dart';
export 'data/web3/ethereum_anchored_repository.dart';
export 'domain/block.dart';
export 'domain/block_base.dart';
export 'domain/blockchain.dart';
export 'domain/blockchain_repository.dart';
export 'domain/chain_receipt.dart';
export 'domain/chain_validation.dart';
export 'domain/chain_validator.dart';
export 'domain/consensus.dart';
export 'domain/merkle_tree.dart';
export 'domain/record.dart';
export 'domain/signing.dart';
