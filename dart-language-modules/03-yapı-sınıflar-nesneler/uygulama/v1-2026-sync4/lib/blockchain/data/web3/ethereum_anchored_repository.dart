// DART KONUSU: Libraries & imports — `as w3` (web3dart'ın `Transaction`,
// `Block` gibi adları bizim `Block` sınıfımızla çakışır), `show`. Class
// modifiers — `final class` dekoratör, `abstract interface` sözleşmesini
// uygular. Classes & objects — generics, static const.

/// Ethereum / Polygon testnet'e blok hash'i çapalayan dekoratör.
library;

import 'dart:typed_data' show Uint8List;

import 'package:http/http.dart' as http;
import 'package:sarkisla_yoklama/blockchain/domain/block.dart';
import 'package:sarkisla_yoklama/blockchain/domain/blockchain_repository.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_receipt.dart';
import 'package:sarkisla_yoklama/blockchain/domain/chain_validation.dart';
import 'package:sarkisla_yoklama/blockchain/domain/record.dart';
import 'package:sarkisla_yoklama/blockchain/domain/signing.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:wallet/wallet.dart' show EthereumAddress;
import 'package:web3dart/web3dart.dart' as w3;

/// Başka bir [BlockchainRepository] deposunu sarar. O depoya eklenen her
/// bloğun hash'ini ve Merkle kökünü `contracts/AttendanceLedger.sol`
/// sözleşmesine yazar.
///
/// Uygulamanın geri kalanı yalnızca `BlockchainRepository` arayüzünü bildiği
/// için genel ağa geçmek, Riverpod'da tek bir provider'ı değiştirmekten
/// ibarettir.
final class EthereumAnchoredRepository<T extends Record>
    implements BlockchainRepository<T> {
  EthereumAnchoredRepository({
    required this._inner,
    required String rpcUrl,
    required String contractAddress,
    required String privateKeyHex,
    this.chainId = polygonAmoyChainId,
    http.Client? httpClient,
  }) : _client = w3.Web3Client(rpcUrl, httpClient ?? http.Client()),
       _credentials = w3.EthPrivateKey.fromHex(privateKeyHex),
       _contract = w3.DeployedContract(
         w3.ContractAbi.fromJson(_abi, 'AttendanceLedger'),
         EthereumAddress.fromHex(contractAddress),
       );

  /// Polygon Amoy testnet zincir kimliği.
  static const int polygonAmoyChainId = 80002;

  static const String _abi = '''
[
  {"type":"function","name":"anchor","stateMutability":"nonpayable",
   "inputs":[{"name":"index","type":"uint256"},
             {"name":"blockHash","type":"bytes32"},
             {"name":"merkleRoot","type":"bytes32"}],
   "outputs":[]},
  {"type":"function","name":"anchorOf","stateMutability":"view",
   "inputs":[{"name":"index","type":"uint256"}],
   "outputs":[{"name":"blockHash","type":"bytes32"},
              {"name":"merkleRoot","type":"bytes32"},
              {"name":"authority","type":"address"},
              {"name":"anchoredAt","type":"uint64"}]}
]''';

  final BlockchainRepository<T> _inner;
  final w3.Web3Client _client;
  final w3.Credentials _credentials;
  final w3.DeployedContract _contract;

  /// İşlemlerin gönderildiği ağ.
  final int chainId;

  @override
  Stream<List<Block<T>>> watchBlocks() => _inner.watchBlocks();

  @override
  Future<List<Block<T>>> currentBlocks() => _inner.currentBlocks();

  @override
  Future<Result<int>> sync() => _inner.sync();

  @override
  Future<ChainValidation> validate() => _inner.validate();

  @override
  Future<ChainReceipt?> receiptFor(Hash recordHash) =>
      _inner.receiptFor(recordHash);

  @override
  @RoleRestricted(Role.instructor)
  Future<Result<Block<T>>> appendBlock(
    List<T> transactions, {
    required BlockSigner signer,
    required Role actor,
  }) async {
    final denied = RoleGuard.ensure(Role.instructor, actor);
    if (denied != null) return Err(denied);
    final result = await _inner.appendBlock(
      transactions,
      signer: signer,
      actor: actor,
    );
    if (result case Ok(:final value)) {
      try {
        await _anchor(value);
      } on Exception catch (e) {
        // Yerel zincir geçerli kalır; çapalama sonradan tekrar denenebilir.
        return Err(NetworkFailure('Blok ağa çapalanamadı.', cause: e));
      }
    }
    return result;
  }

  Future<String> _anchor(Block<T> block) => _client.sendTransaction(
    _credentials,
    w3.Transaction.callContract(
      contract: _contract,
      function: _contract.function('anchor'),
      parameters: [
        BigInt.from(block.index),
        Uint8List.fromList(block.hash.bytes),
        Uint8List.fromList(block.merkleRoot.bytes),
      ],
    ),
    chainId: chainId,
  );

  /// Ağdaki çapa, yerel bloğun hash'iyle aynı mı?
  Future<bool> isAnchored(Block<T> block) async {
    final out = await _client.call(
      contract: _contract,
      function: _contract.function('anchorOf'),
      params: [BigInt.from(block.index)],
    );
    final onChain = out.first as Uint8List;
    return Hash.fromHex(onChain.toHex) == block.hash;
  }
}
