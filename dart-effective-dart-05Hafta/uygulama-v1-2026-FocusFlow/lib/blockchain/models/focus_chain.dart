import '../core/focus_chain_network.dart';
import '../models/chain_block.dart';
import '../models/chain_transaction.dart';

/// FocusChain defterinin değişmez anlık görüntüsü.
///
/// Tüm değişiklikler yeni bir [FocusChain] nesnesi üretir. UI yalnızca
/// onaylanmış blokları ve bekleyen işlemleri okur; yazma işlemleri servis
/// katmanında yapılır.
class FocusChain {
  /// Defter anlık görüntüsünü oluşturur.
  FocusChain({
    required List<ChainBlock> blocks,
    required List<ChainTransaction> pendingTransactions,
    required this.walletAddress,
    required this.difficulty,
  }) : blocks = List<ChainBlock>.unmodifiable(blocks),
       pendingTransactions = List<ChainTransaction>.unmodifiable(
         pendingTransactions,
       );

  /// Zincirdeki bloklar; ilk eleman genesis bloğudur.
  final List<ChainBlock> blocks;

  /// Henüz bir bloğa alınmamış işlemler.
  final List<ChainTransaction> pendingTransactions;

  /// Bu yerel düğümün ödül aldığı cüzdan adresi.
  final String walletAddress;

  /// Yeni bloklar için proof-of-work zorluğu.
  final int difficulty;

  /// Zincirin toplam blok sayısı.
  int get height => blocks.length;

  /// Son bloğun indeksi.
  int get latestIndex => blocks.last.index;

  /// Son bloğun hash'i.
  String get latestHash => blocks.last.hash;

  /// Son blok.
  ChainBlock get latestBlock => blocks.last;

  /// Onaylanmış işlemlerin sayısı.
  int get confirmedTransactionCount {
    return blocks.fold<int>(
      0,
      (total, block) => total + block.transactionCount,
    );
  }

  /// Onaylanmış tüm işlemler; zincir sırasıyla.
  List<ChainTransaction> get confirmedTransactions {
    return List<ChainTransaction>.unmodifiable(
      blocks.expand((block) => block.transactions),
    );
  }

  /// Onaylanmış ve bekleyen tüm işlemler.
  List<ChainTransaction> get allTransactions {
    return List<ChainTransaction>.unmodifiable(<ChainTransaction>[
      ...confirmedTransactions,
      ...pendingTransactions,
    ]);
  }

  /// Zincirde basılmış toplam FOCUS miktarı.
  int get totalMinted {
    return confirmedTransactions
        .where((transaction) => transaction.type.isSystemMint)
        .fold<int>(0, (total, transaction) => total + transaction.amount);
  }

  /// Bir adresin onaylanmış bakiyesi.
  int balanceOf(String address) {
    var balance = 0;
    for (final transaction in confirmedTransactions) {
      if (transaction.toAddress == address) {
        balance += transaction.amount;
      }
      if (transaction.fromAddress == address) {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  /// Yerel cüzdanın onaylanmış bakiyesi.
  int get walletBalance => balanceOf(walletAddress);

  /// Bekleyen giden transferler düşüldükten sonra harcanabilir bakiye.
  ///
  /// Bekleyen gelen işlemler henüz onaylanmadığı için harcanabilir sayılmaz.
  int get availableBalance {
    var balance = walletBalance;
    for (final transaction in pendingTransactions) {
      if (transaction.fromAddress == walletAddress) {
        balance -= transaction.amount;
      }
    }
    return balance;
  }

  /// Bir adrese gelen toplam token miktarı.
  int totalReceivedBy(String address) {
    return confirmedTransactions
        .where((transaction) => transaction.toAddress == address)
        .fold<int>(0, (total, transaction) => total + transaction.amount);
  }

  /// Bir adresten çıkan toplam transfer miktarı.
  int totalSentBy(String address) {
    return confirmedTransactions
        .where(
          (transaction) =>
              transaction.fromAddress == address &&
              transaction.type == ChainTransactionType.transfer,
        )
        .fold<int>(0, (total, transaction) => total + transaction.amount);
  }

  /// Bir adresten transfer ve ödül kullanımıyla çıkan toplam FOCUS.
  int totalSpentBy(String address) {
    return confirmedTransactions
        .where(
          (transaction) =>
              transaction.fromAddress == address && transaction.type.isSpend,
        )
        .fold<int>(0, (total, transaction) => total + transaction.amount);
  }

  /// Belirtilen oturum için daha önce ödül üretilmiş mi?
  bool hasTransactionForSession(String sessionId) {
    return allTransactions.any(
      (transaction) =>
          transaction.type == ChainTransactionType.focusReward &&
          transaction.metadata['sessionId'] == sessionId,
    );
  }

  /// Belirtilen görev için daha önce ödül üretilmiş mi?
  bool hasTransactionForTask(String taskId) {
    return allTransactions.any(
      (transaction) =>
          transaction.type == ChainTransactionType.taskReward &&
          transaction.metadata['taskId'] == taskId,
    );
  }

  /// Zincirde basılmış rozet kimlikleri.
  Set<String> get mintedAchievementIds {
    return allTransactions
        .where(
          (transaction) =>
              transaction.type == ChainTransactionType.achievementReward,
        )
        .map((transaction) => transaction.metadata['achievementId'])
        .whereType<String>()
        .toSet();
  }

  /// Genesis bloğunu ve hoş geldin ödülünü üretir.
  factory FocusChain.createGenesis({
    required String walletAddress,
    int difficulty = FocusChainNetwork.defaultDifficulty,
    int welcomeAmount = FocusChainNetwork.welcomeBonus,
    DateTime? createdAt,
  }) {
    final timestamp = (createdAt ?? DateTime.now())
        .toUtc()
        .millisecondsSinceEpoch;
    final welcomeTransaction = ChainTransaction.create(
      type: ChainTransactionType.genesis,
      fromAddress: FocusChainNetwork.systemAddress,
      toAddress: walletAddress,
      amount: welcomeAmount,
      timestamp: timestamp,
      metadata: const <String, Object?>{'kind': 'welcome_bonus'},
    );
    final genesisBlock = ChainBlock.mine(
      index: 0,
      timestamp: timestamp,
      transactions: <ChainTransaction>[welcomeTransaction],
      previousHash: FocusChainNetwork.genesisPreviousHash,
      difficulty: difficulty,
      minerAddress: FocusChainNetwork.systemAddress,
    );

    return FocusChain(
      blocks: <ChainBlock>[genesisBlock],
      pendingTransactions: const <ChainTransaction>[],
      walletAddress: walletAddress,
      difficulty: difficulty,
    );
  }

  /// Bekleyen işlemi kuyruğa ekler.
  FocusChain addPendingTransaction(ChainTransaction transaction) {
    return FocusChain(
      blocks: blocks,
      pendingTransactions: <ChainTransaction>[
        ...pendingTransactions,
        transaction,
      ],
      walletAddress: walletAddress,
      difficulty: difficulty,
    );
  }

  /// Bekleyen işlemleri ve madenci coinbase ödülünü yeni bir bloğa yazar.
  ///
  /// Bekleyen işlem yoksa aynı defter döner; boş blok üretilmez.
  FocusChain minePendingTransactions({
    required String minerAddress,
    DateTime? createdAt,
  }) {
    if (pendingTransactions.isEmpty) {
      return this;
    }

    final timestamp = (createdAt ?? DateTime.now())
        .toUtc()
        .millisecondsSinceEpoch;
    final nextIndex = latestIndex + 1;
    final coinbase = ChainTransaction.create(
      type: ChainTransactionType.miningReward,
      fromAddress: FocusChainNetwork.systemAddress,
      toAddress: minerAddress,
      amount: FocusChainNetwork.blockReward,
      timestamp: timestamp,
      metadata: <String, Object?>{'blockIndex': nextIndex},
    );
    final blockTransactions = <ChainTransaction>[
      ...pendingTransactions,
      coinbase,
    ];
    final block = ChainBlock.mine(
      index: nextIndex,
      timestamp: timestamp,
      transactions: blockTransactions,
      previousHash: latestHash,
      difficulty: difficulty,
      minerAddress: minerAddress,
    );

    return FocusChain(
      blocks: <ChainBlock>[...blocks, block],
      pendingTransactions: const <ChainTransaction>[],
      walletAddress: walletAddress,
      difficulty: difficulty,
    );
  }

  /// Demo bütünlük testi için son bloktaki bir ödül miktarını değiştirir.
  ///
  /// Hash bilinçli olarak yeniden hesaplanmaz; doğrulayıcı bunu yakalar.
  FocusChain createTamperedCopy() {
    if (blocks.length < 2) {
      return this;
    }
    final blockIndex = blocks.length - 1;
    final block = blocks[blockIndex];
    if (block.transactions.isEmpty) {
      return this;
    }
    final transactionIndex = block.transactions.indexWhere(
      (transaction) => transaction.type != ChainTransactionType.miningReward,
    );
    if (transactionIndex < 0) {
      return this;
    }
    final transactions = List<ChainTransaction>.of(block.transactions);
    final original = transactions[transactionIndex];
    transactions[transactionIndex] = original.tamperAmount(
      original.amount + 99,
    );
    final tamperedBlock = block.copyWith(transactions: transactions);
    final blocksCopy = List<ChainBlock>.of(blocks);
    blocksCopy[blockIndex] = tamperedBlock;

    return FocusChain(
      blocks: blocksCopy,
      pendingTransactions: pendingTransactions,
      walletAddress: walletAddress,
      difficulty: difficulty,
    );
  }

  /// Defterin JSON temsili.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'version': 1,
      'walletAddress': walletAddress,
      'difficulty': difficulty,
      'blocks': blocks.map((block) => block.toJson()).toList(growable: false),
      'pendingTransactions': pendingTransactions
          .map((transaction) => transaction.toJson())
          .toList(growable: false),
    };
  }

  /// JSON'dan defter üretir.
  factory FocusChain.fromJson(Map<String, dynamic> json) {
    final walletAddress = json['walletAddress'];
    final difficulty = json['difficulty'];
    final blocksRaw = json['blocks'];
    final pendingRaw = json['pendingTransactions'];

    if (walletAddress is! String ||
        !FocusChainNetwork.isValidUserAddress(walletAddress)) {
      throw const FormatException('Defter cüzdan adresi geçersiz.');
    }
    if (difficulty is! int || difficulty < 1 || difficulty > 6) {
      throw const FormatException('Defter zorluğu geçersiz.');
    }
    if (blocksRaw is! List<dynamic> || blocksRaw.isEmpty) {
      throw const FormatException('Defter blok listesi geçersiz.');
    }

    final blocks = <ChainBlock>[];
    for (final item in blocksRaw) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Defter bloğu geçersiz.');
      }
      blocks.add(ChainBlock.fromJson(item));
    }

    final pending = <ChainTransaction>[];
    if (pendingRaw is List<dynamic>) {
      for (final item in pendingRaw) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Bekleyen işlem geçersiz.');
        }
        pending.add(ChainTransaction.fromJson(item));
      }
    }

    return FocusChain(
      blocks: blocks,
      pendingTransactions: pending,
      walletAddress: walletAddress,
      difficulty: difficulty,
    );
  }
}
