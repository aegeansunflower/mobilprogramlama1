import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:focus_flow/blockchain/achievements/achievement_engine.dart';
import 'package:focus_flow/blockchain/core/focus_chain_network.dart';
import 'package:focus_flow/blockchain/core/focus_reward_calculator.dart';
import 'package:focus_flow/blockchain/models/chain_transaction.dart';
import 'package:focus_flow/blockchain/models/focus_chain.dart';
import 'package:focus_flow/blockchain/models/wallet_account.dart';
import 'package:focus_flow/blockchain/repositories/focus_chain_repository.dart';
import 'package:focus_flow/blockchain/repositories/wallet_repository.dart';
import 'package:focus_flow/blockchain/services/chain_validator.dart';
import 'package:focus_flow/blockchain/services/wallet_service.dart';
import 'package:focus_flow/blockchain/state/focus_chain_service.dart';
import 'package:focus_flow/data/local_storage_service.dart';
import 'package:focus_flow/models/focus_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WalletService walletService;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final preferences = await SharedPreferences.getInstance();
    final storage = LocalStorageService(preferences);
    walletService = WalletService(WalletRepository(storage));
  });

  Future<WalletAccount> createWallet() => walletService.createWallet();

  Future<ChainValidator> validator() async => ChainValidator(walletService);

  FocusSession completedFocusSession({
    String id = 'session_1',
    int seconds = 25 * 60,
    DateTime? completedAt,
  }) {
    final start = (completedAt ?? DateTime.now()).subtract(
      Duration(seconds: seconds),
    );
    return FocusSession(
      id: id,
      type: SessionType.focus,
      plannedDurationSeconds: seconds,
      actualDurationSeconds: seconds,
      startedAt: start,
      completedAt: completedAt ?? DateTime.now(),
      isCompleted: true,
    );
  }

  test('genesis zinciri geçerli ve hoş geldin ödülü içerir', () async {
    final wallet = await createWallet();
    final chain = FocusChain.createGenesis(walletAddress: wallet.address);
    final result = await (await validator()).validate(chain);

    expect(result.isValid, isTrue);
    expect(chain.height, 1);
    expect(chain.walletBalance, FocusChainNetwork.welcomeBonus);
    expect(
      chain.blocks.first.transactions.first.type,
      ChainTransactionType.genesis,
    );
  });

  test('odak ödülü bloklaştırılır ve bakiye artar', () async {
    final wallet = await createWallet();
    final chain = FocusChain.createGenesis(walletAddress: wallet.address);
    final reward = ChainTransaction.create(
      type: ChainTransactionType.focusReward,
      fromAddress: FocusChainNetwork.systemAddress,
      toAddress: wallet.address,
      amount: 5,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      metadata: const <String, Object?>{'sessionId': 'session_1'},
    );
    final mined = chain
        .addPendingTransaction(reward)
        .minePendingTransactions(minerAddress: wallet.address);
    final result = await (await validator()).validate(mined);

    expect(result.isValid, isTrue);
    expect(mined.height, 2);
    expect(mined.walletBalance, FocusChainNetwork.welcomeBonus + 5 + 1);
    expect(mined.blocks.last.transactions.length, 2);
    expect(mined.pendingTransactions, isEmpty);
  });

  test('kurcalanan blok doğrulamada yakalanır', () async {
    final wallet = await createWallet();
    final chain = FocusChain.createGenesis(walletAddress: wallet.address);
    final reward = ChainTransaction.create(
      type: ChainTransactionType.focusReward,
      fromAddress: FocusChainNetwork.systemAddress,
      toAddress: wallet.address,
      amount: 5,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      metadata: const <String, Object?>{'sessionId': 'session_1'},
    );
    final mined = chain
        .addPendingTransaction(reward)
        .minePendingTransactions(minerAddress: wallet.address);
    final tampered = mined.createTamperedCopy();
    final result = await (await validator()).validate(tampered);

    expect(result.isValid, isFalse);
    expect(result.message, contains('hash'));
  });

  test('imzalı transfer doğrulanır ve bakiyeler güncellenir', () async {
    final sender = await createWallet();
    final receiver = await createWallet();
    final chain = FocusChain.createGenesis(walletAddress: sender.address);
    final transfer = ChainTransaction.create(
      type: ChainTransactionType.transfer,
      fromAddress: sender.address,
      toAddress: receiver.address,
      amount: 4,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      metadata: const <String, Object?>{'memo': 'test'},
    );
    final signature = await walletService.sign(
      wallet: sender,
      payload: transfer.signingPayload,
    );
    final signed = transfer.withSignature(
      signature: signature,
      senderPublicKey: sender.publicKey,
    );
    final mined = chain
        .addPendingTransaction(signed)
        .minePendingTransactions(minerAddress: sender.address);
    final result = await (await validator()).validate(mined);

    expect(result.isValid, isTrue);
    expect(
      mined.balanceOf(sender.address),
      FocusChainNetwork.welcomeBonus + 1 - 4,
    );
    expect(mined.balanceOf(receiver.address), 4);
  });

  test('yetersiz bakiye transferi doğrulamada reddedilir', () async {
    final sender = await createWallet();
    final receiver = await createWallet();
    final chain = FocusChain.createGenesis(walletAddress: sender.address);
    final transfer = ChainTransaction.create(
      type: ChainTransactionType.transfer,
      fromAddress: sender.address,
      toAddress: receiver.address,
      amount: 999,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    final signature = await walletService.sign(
      wallet: sender,
      payload: transfer.signingPayload,
    );
    final signed = transfer.withSignature(
      signature: signature,
      senderPublicKey: sender.publicKey,
    );
    final pending = chain.addPendingTransaction(signed);
    final result = await (await validator()).validate(pending);

    expect(result.isValid, isFalse);
    expect(result.message, contains('yetersiz bakiye'));
  });

  test('rozet motoru ilk odak rozetini hesaplar', () async {
    final wallet = await createWallet();
    final chain = FocusChain.createGenesis(walletAddress: wallet.address);
    final session = completedFocusSession();

    final eligible = AchievementEngine.eligible(
      sessions: <FocusSession>[session],
      tasks: const [],
      chain: chain,
    );

    expect(eligible, contains(AchievementId.firstFocus));
  });

  test('ödül hesaplayıcı beş dakikalık birimleri kullanır', () {
    expect(FocusRewardCalculator.forSeconds(0), 0);
    expect(FocusRewardCalculator.forSeconds(4 * 60), 1);
    expect(FocusRewardCalculator.forMinutes(25), 5);
    expect(FocusRewardCalculator.forMinutes(50), 10);
  });

  test('zincir servisi oturumu ödüllendirir ve kalıcıdır', () async {
    final preferences = await SharedPreferences.getInstance();
    final storage = LocalStorageService(preferences);
    final service = FocusChainService(
      chainRepository: FocusChainRepository(storage),
      walletRepository: WalletRepository(storage),
    );
    await service.initialize();

    final session = completedFocusSession();
    final reward = await service.recordFocusReward(
      session: session,
      sessions: <FocusSession>[session],
      tasks: const [],
    );

    expect(reward, isNotNull);
    expect(reward!.isConfirmed, isTrue);
    expect(service.lastAchievements, contains(AchievementId.firstFocus));
    expect(service.balance, greaterThan(FocusChainNetwork.welcomeBonus));
    expect(service.chainHeight, greaterThanOrEqualTo(3));

    final restored = FocusChainService(
      chainRepository: FocusChainRepository(storage),
      walletRepository: WalletRepository(storage),
    );
    await restored.initialize();
    expect(restored.balance, service.balance);
    expect(restored.chainHeight, service.chainHeight);
  });

  test('FOCUS ödül kullanımı bakiyeyi düşürür ve deftere yazılır', () async {
    final preferences = await SharedPreferences.getInstance();
    final storage = LocalStorageService(preferences);
    final service = FocusChainService(
      chainRepository: FocusChainRepository(storage),
      walletRepository: WalletRepository(storage),
    );
    await service.initialize();

    final session = completedFocusSession();
    await service.recordFocusReward(
      session: session,
      sessions: <FocusSession>[session],
      tasks: const [],
    );
    final before = service.balance;

    final reward = await service.redeemReward(
      rewardId: 'coffee_break',
      title: 'Kahve Molası',
      cost: 10,
    );

    expect(reward, isNotNull);
    expect(reward!.isConfirmed, isTrue);
    expect(reward.transaction.type, ChainTransactionType.rewardRedemption);
    expect(reward.transaction.amount, 10);
    expect(reward.transaction.toAddress, FocusChainNetwork.burnAddress);
    expect(reward.transaction.metadata['rewardId'], 'coffee_break');
    expect(service.balance, before - 10 + FocusChainNetwork.blockReward);
    expect(service.rewardRedemptions, hasLength(1));
    expect(service.lastValidation?.isValid, isTrue);

    final tooExpensive = await service.redeemReward(
      rewardId: 'rest_day',
      title: 'Dinlenme Günü',
      cost: service.balance + 1,
    );
    expect(tooExpensive, isNull);
    expect(service.error, contains('yeterli FOCUS'));
  });

  test('kurcalama demosu cüzdan bakiyesini bozmaz', () async {
    final preferences = await SharedPreferences.getInstance();
    final storage = LocalStorageService(preferences);
    final service = FocusChainService(
      chainRepository: FocusChainRepository(storage),
      walletRepository: WalletRepository(storage),
    );
    await service.initialize();

    final session = completedFocusSession();
    await service.recordFocusReward(
      session: session,
      sessions: <FocusSession>[session],
      tasks: const [],
    );
    final healthyBalance = service.balance;
    final healthyHeight = service.chainHeight;

    expect(await service.simulateTamper(), isTrue);
    expect(service.isTampered, isTrue);
    expect(service.balance, healthyBalance);
    expect(service.lastValidation?.isValid, isFalse);

    await service.restoreAfterTamper();
    expect(service.isTampered, isFalse);
    expect(service.balance, healthyBalance);
    expect(service.chainHeight, healthyHeight);
    expect(service.lastValidation?.isValid, isTrue);
  });
}
