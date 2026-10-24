import 'dart:convert';

import '../core/focus_chain_network.dart';
import '../models/chain_transaction.dart';
import '../models/chain_validation_result.dart';
import '../models/focus_chain.dart';
import '../services/wallet_service.dart';

/// FocusChain defterini hash, proof-of-work, imza ve bakiye açısından doğrular.
class ChainValidator {
  /// Cüzdan servisiyle doğrulayıcıyı oluşturur.
  const ChainValidator(this._walletService);

  final WalletService _walletService;

  /// Tüm zinciri ve bekleyen işlemleri doğrular.
  Future<ChainValidationResult> validate(FocusChain chain) async {
    final now = DateTime.now();
    final blocks = chain.blocks;
    var checkedTransactions = 0;

    if (blocks.isEmpty) {
      return ChainValidationResult(
        isValid: false,
        message: 'Defterde genesis bloğu bulunamadı.',
        checkedBlocks: 0,
        checkedTransactions: 0,
        checkedAt: now,
      );
    }

    final genesis = blocks.first;
    if (genesis.index != 0) {
      return _failure(
        now,
        'Genesis bloğu sıfır indeksli değil.',
        blocksChecked: 0,
        transactionsChecked: 0,
        blockIndex: genesis.index,
      );
    }
    if (genesis.previousHash != FocusChainNetwork.genesisPreviousHash) {
      return _failure(
        now,
        'Genesis bloğunun önceki hash değeri geçersiz.',
        blocksChecked: 0,
        transactionsChecked: 0,
        blockIndex: 0,
      );
    }

    final balances = <String, int>{};
    final seenTransactionIds = <String>{};
    final seenAchievements = <String>{};

    for (
      var blockPosition = 0;
      blockPosition < blocks.length;
      blockPosition++
    ) {
      final block = blocks[blockPosition];
      if (block.index != blockPosition) {
        return _failure(
          now,
          'Blok #${block.index} sırası beklenen indeksle uyuşmuyor.',
          blocksChecked: blockPosition,
          transactionsChecked: checkedTransactions,
          blockIndex: block.index,
        );
      }
      if (blockPosition > 0) {
        final previous = blocks[blockPosition - 1];
        if (block.previousHash != previous.hash) {
          return _failure(
            now,
            'Blok #${block.index} önceki blokla bağlantılı değil.',
            blocksChecked: blockPosition,
            transactionsChecked: checkedTransactions,
            blockIndex: block.index,
          );
        }
      }
      if (block.hash != block.calculateHash()) {
        return _failure(
          now,
          'Blok #${block.index} hash değeri içerikle uyuşmuyor.',
          blocksChecked: blockPosition,
          transactionsChecked: checkedTransactions,
          blockIndex: block.index,
        );
      }
      if (!block.hash.startsWith(block.target)) {
        return _failure(
          now,
          'Blok #${block.index} proof-of-work hedefini karşılamıyor.',
          blocksChecked: blockPosition,
          transactionsChecked: checkedTransactions,
          blockIndex: block.index,
        );
      }
      if (block.transactions.isEmpty) {
        return _failure(
          now,
          'Blok #${block.index} en az bir işlem içermeli.',
          blocksChecked: blockPosition,
          transactionsChecked: checkedTransactions,
          blockIndex: block.index,
        );
      }

      for (final transaction in block.transactions) {
        checkedTransactions++;
        final error = await _validateTransaction(
          transaction: transaction,
          balances: balances,
          seenTransactionIds: seenTransactionIds,
          seenAchievements: seenAchievements,
        );
        if (error != null) {
          return _failure(
            now,
            'Blok #${block.index}: $error',
            blocksChecked: blockPosition,
            transactionsChecked: checkedTransactions,
            blockIndex: block.index,
          );
        }
      }
    }

    for (var index = 0; index < chain.pendingTransactions.length; index++) {
      final transaction = chain.pendingTransactions[index];
      checkedTransactions++;
      final error = await _validateTransaction(
        transaction: transaction,
        balances: balances,
        seenTransactionIds: seenTransactionIds,
        seenAchievements: seenAchievements,
      );
      if (error != null) {
        return _failure(
          now,
          'Bekleyen işlem ${index + 1}: $error',
          blocksChecked: blocks.length,
          transactionsChecked: checkedTransactions,
          blockIndex: blocks.length - 1,
        );
      }
    }

    return ChainValidationResult(
      isValid: true,
      message:
          '${blocks.length} blok ve $checkedTransactions işlem doğrulandı.',
      checkedBlocks: blocks.length,
      checkedTransactions: checkedTransactions,
      checkedAt: now,
    );
  }

  Future<String?> _validateTransaction({
    required ChainTransaction transaction,
    required Map<String, int> balances,
    required Set<String> seenTransactionIds,
    required Set<String> seenAchievements,
  }) async {
    if (!seenTransactionIds.add(transaction.id)) {
      return 'aynı işlem kimliği birden fazla kez kullanılmış.';
    }
    if (transaction.amount <= 0) {
      return 'işlem miktarı sıfırdan büyük olmalı.';
    }

    final isSpend = transaction.type.isSpend;
    if (isSpend) {
      final label = transaction.type == ChainTransactionType.transfer
          ? 'transfer'
          : 'ödül kullanımı';
      if (!FocusChainNetwork.isValidUserAddress(transaction.fromAddress)) {
        return '$label gönderici adresi geçersiz.';
      }
      final isRewardSink =
          transaction.type == ChainTransactionType.rewardRedemption &&
          transaction.toAddress == FocusChainNetwork.burnAddress;
      if (!FocusChainNetwork.isValidUserAddress(transaction.toAddress) &&
          !isRewardSink) {
        return '$label alıcı adresi geçersiz.';
      }
      final signature = transaction.signature;
      final publicKey = transaction.senderPublicKey;
      if (signature == null || publicKey == null) {
        return '$label imzası eksik.';
      }
      final derivedAddress = WalletService.addressFromPublicKey(
        _decodePublicKey(publicKey),
      );
      if (derivedAddress != transaction.fromAddress) {
        return '$label açık anahtarı gönderici adresiyle eşleşmiyor.';
      }
      final verified = await _walletService.verify(
        payload: transaction.signingPayload,
        signature: signature,
        publicKey: publicKey,
      );
      if (!verified) {
        return '$label imzası geçersiz.';
      }
      if (transaction.type == ChainTransactionType.rewardRedemption) {
        final rewardId = transaction.metadata['rewardId'];
        if (rewardId is! String || rewardId.trim().isEmpty) {
          return 'ödül kullanımı rewardId içermiyor.';
        }
      }
    } else {
      if (!transaction.type.isSystemMint) {
        return 'bilinmeyen sistem işlemi.';
      }
      if (transaction.fromAddress != FocusChainNetwork.systemAddress) {
        return 'sistem ödülü yalnızca sistem adresinden üretilebilir.';
      }
      if (!FocusChainNetwork.isValidUserAddress(transaction.toAddress)) {
        return 'ödül alıcı adresi geçersiz.';
      }
    }

    if (transaction.type == ChainTransactionType.achievementReward) {
      final achievementId = transaction.metadata['achievementId'];
      if (achievementId is! String || achievementId.trim().isEmpty) {
        return 'rozet işlemi achievementId içermiyor.';
      }
      if (!seenAchievements.add(achievementId)) {
        return 'aynı rozet birden fazla kez basılmış.';
      }
    }

    final currentBalance = balances[transaction.fromAddress] ?? 0;
    if (isSpend && currentBalance < transaction.amount) {
      return 'yetersiz bakiye.';
    }

    if (isSpend) {
      balances[transaction.fromAddress] = currentBalance - transaction.amount;
    }
    balances[transaction.toAddress] =
        (balances[transaction.toAddress] ?? 0) + transaction.amount;

    return null;
  }

  List<int> _decodePublicKey(String publicKey) {
    try {
      return const Base64Decoder().convert(publicKey);
    } on FormatException {
      return const <int>[];
    }
  }

  ChainValidationResult _failure(
    DateTime checkedAt,
    String message, {
    required int blocksChecked,
    required int transactionsChecked,
    int? blockIndex,
  }) {
    return ChainValidationResult(
      isValid: false,
      message: message,
      checkedBlocks: blocksChecked,
      checkedTransactions: transactionsChecked,
      checkedAt: checkedAt,
      invalidBlockIndex: blockIndex,
    );
  }
}
