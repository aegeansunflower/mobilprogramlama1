import 'dart:async';   // Future, Stream, StreamController, StreamSubscription
import 'dart:convert'; // jsonEncode, jsonDecode, utf8, LineSplitter
import 'dart:io';      // File, Directory (Native mobil/masaüstü dosya işlemleri)
import 'dart:math';    // Random, max, sin, pi (Matematik ve rastgelelik)
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChainPulseMobileApp());
}

class ChainPulseMobileApp extends StatelessWidget {
  const ChainPulseMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChainPulse Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00F5D4),
          secondary: Color(0xFF7B2CBF),
          surface: Color(0xFF131B2E),
        ),
      ),
      // Bilgisayarda/Web'de açıldığında otomatik olarak Telefon Çerçevesi içine alır!
      builder: (context, child) {
        return PhoneFrameWrapper(child: child ?? const SizedBox());
      },
      home: const MobileHomeShell(),
    );
  }
}

// ============================================================================
// GERÇEKÇİ AKILLI TELEFON ÇERÇEVESİ (Masaüstü & Web'de Mobil Görünüm Sağlar)
// ============================================================================

class PhoneFrameWrapper extends StatelessWidget {
  final Widget child;
  const PhoneFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Eğer ekran genişliği 500 pikselden küçükse zaten gerçek telefondadır, çerçeve gösterme.
    if (size.width < 500) return child;

    return Scaffold(
      backgroundColor: const Color(0xFF04060A),
      body: Stack(
        children: [
          // Arka plan ambiyans ışıkları
          Positioned(
            top: -100,
            left: size.width * 0.25,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7B2CBF).withOpacity(0.18),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: size.width * 0.25,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00F5D4).withOpacity(0.12),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 392,
              height: min(852, size.height * 0.94),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(52),
                border: Border.all(
                  color: const Color(0xFF2E384D),
                  width: 10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.85),
                    blurRadius: 50,
                    spreadRadius: 10,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: const Color(0xFF00F5D4).withOpacity(0.12),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(42),
                child: Column(
                  children: [
                    // iOS / Android Üst Durum Çubuğu ve Dynamic Island (Kamera Çentiği)
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      color: const Color(0xFF090D16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '21:42',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          // Dynamic Island (Kamera Adası)
                          Container(
                            width: 105,
                            height: 25,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white10, width: 0.8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00F5D4),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade900,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.signal_cellular_alt_rounded, size: 15, color: Colors.white),
                              SizedBox(width: 4),
                              Icon(Icons.wifi_rounded, size: 15, color: Colors.white),
                              SizedBox(width: 4),
                              Icon(Icons.battery_full_rounded, size: 17, color: Color(0xFF00F5D4)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Mobil Uygulama Ekranı
                    Expanded(
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          size: const Size(372, 760),
                        ),
                        child: child,
                      ),
                    ),
                    // Alt Ana Ekran Çubuğu (iPhone Home Indicator)
                    Container(
                      height: 20,
                      color: const Color(0xFF0F1626),
                      alignment: Alignment.center,
                      child: Container(
                        width: 130,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// VERİ MODELİ VE DART:CORE (Comparable, ==, hashCode) - Slayt 22 & 30
// ============================================================================

class Transaction implements Comparable<Transaction> {
  final String id;
  final String sender;
  final String receiver;
  final double amount;
  final double gasFee;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.gasFee,
    required this.timestamp,
  });

  // Slayt 22 & 30: Comparable arayüzü ile işlemleri tutara göre sıralama
  @override
  int compareTo(Transaction other) => other.amount.compareTo(amount);

  // Slayt 22 & 30: Set içinde mükerrer işlemleri engellemek için == ve hashCode
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Transaction && other.id == id);

  @override
  int get hashCode => id.hashCode;

  // Slayt 44: dart:convert için JSON dönüşümü
  Map<String, dynamic> toJson() => {
        'id': id,
        'sender': sender,
        'receiver': receiver,
        'amount': amount,
        'gasFee': gasFee,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json['id'] as String,
        sender: json['sender'] as String,
        receiver: json['receiver'] as String,
        amount: (json['amount'] as num).toDouble(),
        gasFee: (json['gasFee'] as num?)?.toDouble() ?? 1.2,
        timestamp: DateTime.parse(json['timestamp'] as String), // Slayt 21
      );
}

// ============================================================================
// MOBİL ANA İSKELET VE KOLEKSİYONLAR (List, Set, Map) - Slayt 16, 17, 18
// ============================================================================

class MobileHomeShell extends StatefulWidget {
  const MobileHomeShell({super.key});

  @override
  State<MobileHomeShell> createState() => _MobileHomeShellState();
}

class _MobileHomeShellState extends State<MobileHomeShell> {
  int _currentIndex = 0;

  // Slayt 16-18: Koleksiyonlar
  final Set<Transaction> _mempool = {}; // Benzersiz işlem havuzu (Set)
  final List<Map<String, dynamic>> _blockchain = []; // Sıralı bloklar (List)
  final List<String> _virtualDiskLines = []; // Web'de çalışırken dart:io simülasyonu için
  final Map<String, double> _balances = {
    '0xBenimCuzdanim': 1250.75,
    '0xVitalik': 840.00,
    '0xSatoshi': 5420.50,
    '0xAhmet': 190.25,
  }; // Cüzdan -> Bakiye (Map)

  void _addTxToPool(Transaction tx) {
    HapticFeedback.lightImpact();
    setState(() {
      _mempool.add(tx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LiveExplorerTab(
        mempoolCount: _mempool.length,
        onAddPool: _addTxToPool,
      ),
      WalletTransferTab(
        balances: _balances,
        onTxCreated: _addTxToPool,
      ),
      MiningLedgerTab(
        mempool: _mempool,
        blockchain: _blockchain,
        virtualDiskLines: _virtualDiskLines,
        onBlockMined: (block, rawJsonLine) {
          HapticFeedback.heavyImpact();
          setState(() {
            _blockchain.insert(0, block);
            _virtualDiskLines.add(rawJsonLine);
            _mempool.clear();
          });
        },
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 68,
        decoration: BoxDecoration(
          color: const Color(0xFF0F1626),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
          ),
        ),
        child: NavigationBar(
          height: 68,
          backgroundColor: Colors.transparent,
          indicatorColor: const Color(0xFF00F5D4).withOpacity(0.18),
          selectedIndex: _currentIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          onDestinationSelected: (i) {
            HapticFeedback.selectionClick();
            setState(() => _currentIndex = i);
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.sensors_outlined, size: 22),
              selectedIcon: Icon(Icons.sensors, color: Color(0xFF00F5D4), size: 22),
              label: 'Canlı Ağ',
            ),
            const NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined, size: 22),
              selectedIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF00F5D4), size: 22),
              label: 'Cüzdan',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: _mempool.isNotEmpty,
                label: Text('${_mempool.length}'),
                backgroundColor: const Color(0xFF00F5D4),
                textColor: Colors.black,
                child: const Icon(Icons.bolt_outlined, size: 22),
              ),
              selectedIcon: Badge(
                isLabelVisible: _mempool.isNotEmpty,
                label: Text('${_mempool.length}'),
                backgroundColor: const Color(0xFF00F5D4),
                textColor: Colors.black,
                child: const Icon(Icons.bolt, color: Color(0xFF00F5D4), size: 22),
              ),
              label: 'Madencilik',
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 1. SEKME: CANLI AĞ İZLEYİCİ (Stream, listen, where, pause/resume)
// ============================================================================

class LiveExplorerTab extends StatefulWidget {
  final int mempoolCount;
  final void Function(Transaction) onAddPool;

  const LiveExplorerTab({
    super.key,
    required this.mempoolCount,
    required this.onAddPool,
  });

  @override
  State<LiveExplorerTab> createState() => _LiveExplorerTabState();
}

class _LiveExplorerTabState extends State<LiveExplorerTab> {
  // Slayt 37 & 56: Broadcast StreamController
  final StreamController<Transaction> _controller =
      StreamController<Transaction>.broadcast();
  StreamSubscription<Transaction>? _subscription;
  Timer? _timer;

  final List<Transaction> _events = [];
  bool _isPaused = false;
  bool _whaleFilter = false;
  double _networkLoad = 0.65;

  @override
  void initState() {
    super.initState();
    _startMockNetwork();
    _bindStream();
  }

  void _startMockNetwork() {
    final rnd = Random(); // Slayt 40-42: dart:math
    final wallets = ['0x71C..89A', '0x99B..12F', '0x34E..01C', '0xA4D..77E', '0xF12..99B'];

    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_controller.isClosed) return;
      final amount = (rnd.nextDouble() * 320 + 5);
      // Slayt 41: pi ve sin() ile dalgalanan ağ yükü hesabı
      _networkLoad = (sin(timer.tick * pi / 8) + 1) / 2;

      final tx = Transaction(
        id: '0x${rnd.nextInt(999999).toRadixString(16).padLeft(6, '0').toUpperCase()}',
        sender: wallets[rnd.nextInt(wallets.length)],
        receiver: wallets[rnd.nextInt(wallets.length)],
        amount: amount,
        gasFee: (rnd.nextDouble() * 4 + 0.5),
        timestamp: DateTime.now(),
      );
      _controller.add(tx);
    });
  }

  void _bindStream() {
    _subscription?.cancel();
    Stream<Transaction> stream = _controller.stream;

    // Slayt 38: Stream.where() ile filtreleme
    if (_whaleFilter) {
      stream = stream.where((tx) => tx.amount >= 150.0);
    }

    // Slayt 35: Stream.listen()
    _subscription = stream.listen((tx) {
      setState(() {
        _events.insert(0, tx);
        if (_events.length > 20) _events.removeLast();
      });
    });
  }

  void _toggleStreamState() {
    if (_subscription == null) return;
    HapticFeedback.mediumImpact();
    setState(() {
      if (_isPaused) {
        _subscription!.resume(); // Slayt 57
      } else {
        _subscription!.pause(); // Slayt 57
      }
      _isPaused = !_isPaused;
    });
  }

  @override
  void dispose() {
    // Slayt 18 & 57: Memory leak önlemek için cancel()
    _timer?.cancel();
    _subscription?.cancel();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Üst Başlık ve Canlı Durum Rozeti
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ChainPulse Radar',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                  ),
                  Text(
                    'Broadcast Stream & math.sin(π)',
                    style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _toggleStreamState,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isPaused
                        ? Colors.orange.withOpacity(0.15)
                        : const Color(0xFF00F5D4).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isPaused ? Colors.orange : const Color(0xFF00F5D4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        size: 16,
                        color: _isPaused ? Colors.orange : const Color(0xFF00F5D4),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isPaused ? 'DEVAM ET' : 'DURAKLAT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _isPaused ? Colors.orange : const Color(0xFF00F5D4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Mobil Kompakt Ağ İstatistik Kartı
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A243B), Color(0xFF111827)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Ağ Yükü (sin π)', '%${(_networkLoad * 100).toInt()}'),
                    _buildStatItem('Havuz (Set)', '${widget.mempoolCount} İşlem'),
                    _buildStatItem('Stream', _isPaused ? 'Paused' : 'Active'),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _networkLoad,
                    minHeight: 5,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00F5D4)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Balina Filtresi Çipi (stream.where)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                '🐋 Balina Filtresi (where >= 150 CP)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Küçük transferleri akıştan gizler',
                style: TextStyle(fontSize: 11, color: Colors.white54),
              ),
              activeColor: const Color(0xFF00F5D4),
              value: _whaleFilter,
              onChanged: (v) {
                setState(() => _whaleFilter = v);
                _bindStream();
              },
            ),
          ),
          const SizedBox(height: 10),

          // İşlem Listesi
          Expanded(
            child: _events.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(color: Color(0xFF00F5D4)),
                        const SizedBox(height: 12),
                        Text(
                          'Blok zinciri dinleniyor...',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final tx = _events[index];
                      final isWhale = tx.amount >= 150;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131B2E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isWhale
                                ? Colors.amber.withOpacity(0.5)
                                : Colors.white.withOpacity(0.05),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: isWhale
                                    ? Colors.amber.withOpacity(0.15)
                                    : const Color(0xFF00F5D4).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isWhale ? Icons.auto_awesome : Icons.swap_horiz_rounded,
                                color: isWhale ? Colors.amber : const Color(0xFF00F5D4),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        tx.id,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          fontFamily: 'monospace',
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (isWhale) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: const Text(
                                            'WHALE',
                                            style: TextStyle(
                                              fontSize: 8,
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${tx.sender} → ${tx.receiver}',
                                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Slayt 10: toStringAsFixed(2)
                                Text(
                                  '${tx.amount.toStringAsFixed(2)} CP',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF00F5D4),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                InkWell(
                                  onTap: () {
                                    widget.onAddPool(tx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color(0xFF1E293B),
                                        behavior: SnackBarBehavior.floating,
                                        content: Text('${tx.id} havuza (Set) eklendi!'),
                                        duration: const Duration(milliseconds: 800),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      '+ Havuza Al',
                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

// ============================================================================
// 2. SEKME: CÜZDAN & TRANSFER (Future, Future.wait, RegExp, tryParse, try-catch)
// ============================================================================

class WalletTransferTab extends StatefulWidget {
  final Map<String, double> balances;
  final void Function(Transaction) onTxCreated;

  const WalletTransferTab({
    super.key,
    required this.balances,
    required this.onTxCreated,
  });

  @override
  State<WalletTransferTab> createState() => _WalletTransferTabState();
}

class _WalletTransferTabState extends State<WalletTransferTab> {
  final _receiverCtrl = TextEditingController(text: '0xVitalik');
  final _amountCtrl = TextEditingController(text: '75.50');
  bool _isSending = false;
  String? _feedbackText;
  bool _isError = false;

  Future<void> _executeTransfer() async {
    FocusScope.of(context).unfocus();
    // Slayt 12-14: String metotları (trim, startsWith, isEmpty)
    final address = _receiverCtrl.text.trim();
    final amountStr = _amountCtrl.text.trim();

    // Slayt 15: RegExp ile 0x cüzdan kontrolü
    final walletRegex = RegExp(r'^0x[a-zA-Z0-9]{3,}$');

    // Slayt 10: double.tryParse()
    final parsedAmount = double.tryParse(amountStr);

    setState(() {
      _isSending = true;
      _feedbackText = 'Ağ düğümlerinden (Future.wait) onay bekleniyor...';
      _isError = false;
    });

    try {
      if (address.isEmpty || !address.startsWith('0x') || !walletRegex.hasMatch(address)) {
        throw const FormatException('Adres "0x" ile başlamalı ve özel karakter içermemelidir!');
      }
      if (parsedAmount == null || parsedAmount <= 0) {
        throw ArgumentError('Geçerli bir sayısal tutar girin (tryParse null döndü).');
      }

      final myBalance = widget.balances['0xBenimCuzdanim'] ?? 0.0;
      if (parsedAmount > myBalance) {
        throw Exception('Bakiye yetersiz! Mevcut: ${myBalance.toStringAsFixed(2)} CP');
      }

      // Slayt 28: Future.wait() ile paralel asenkron doğrulama
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 600)), // İmza kontrolü
        Future.delayed(const Duration(milliseconds: 900)), // Akıllı kontrat kontrolü
      ]);

      final tx = Transaction(
        id: '0xUSR${Random().nextInt(9999)}',
        sender: '0xBenimCuzdanim',
        receiver: address,
        amount: parsedAmount,
        gasFee: 1.5,
        timestamp: DateTime.now(),
      );

      widget.balances['0xBenimCuzdanim'] = myBalance - parsedAmount;
      widget.balances[address] = (widget.balances[address] ?? 0.0) + parsedAmount;
      widget.onTxCreated(tx);

      setState(() {
        _isError = false;
        _feedbackText = '✅ Transfer imzalandı ve Madencilik Havuzuna eklendi!';
      });
    } catch (e) {
      // Slayt 30: try-catch bloğu
      HapticFeedback.vibrate();
      setState(() {
        _isError = true;
        _feedbackText = '❌ İstisna Yakalandı:\n$e';
      });
    } finally {
      // Slayt 32: whenComplete / finally temizlik aşaması
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final myBalance = widget.balances['0xBenimCuzdanim'] ?? 0.0;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Web3 Cüzdanım',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            'Map, String, RegExp, tryParse & Future.wait',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 12),

          // Modern Mobil Kripto Kartı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7B2CBF), Color(0xFF0096C7), Color(0xFF00F5D4)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F5D4).withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.28),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '0xBenimCuzdanim',
                        style: TextStyle(fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                    const Icon(Icons.contactless_rounded, color: Colors.white, size: 24),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'TOPLAM BAKİYE',
                  style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: Colors.white70),
                ),
                const SizedBox(height: 2),
                Text(
                  '${myBalance.toStringAsFixed(2)} CP',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Hızlı Alıcı Seçimi (Map koleksiyonundan)
          const Text(
            'Hızlı Alıcı Seç (Map<String, double>)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.balances.entries
                  .where((e) => e.key != '0xBenimCuzdanim')
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: ActionChip(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: const Color(0xFF131B2E),
                          label: Text(
                            '${entry.key} (${entry.value.toStringAsFixed(0)})',
                            style: const TextStyle(fontSize: 11),
                          ),
                          onPressed: () => setState(() => _receiverCtrl.text = entry.key),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Transfer Formu
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _receiverCtrl,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Alıcı Adresi (RegExp & startsWith)',
                    prefixIcon: const Icon(Icons.qr_code_2_rounded, color: Color(0xFF00F5D4), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _amountCtrl,
                  style: const TextStyle(fontSize: 14),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'Gönderilecek Miktar (double.tryParse)',
                    prefixIcon: const Icon(Icons.toll_rounded, color: Color(0xFF00F5D4), size: 20),
                    suffixText: 'CP',
                    filled: true,
                    fillColor: const Color(0xFF090D16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF00F5D4),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isSending ? null : _executeTransfer,
                    icon: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.black),
                          )
                        : const Icon(Icons.rocket_launch_rounded, size: 18),
                    label: Text(
                      _isSending ? 'DOĞRULANIYOR...' : 'TRANSFERİ BAŞLAT (Future.wait)',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_feedbackText != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isError
                    ? Colors.redAccent.withOpacity(0.15)
                    : const Color(0xFF00F5D4).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isError ? Colors.redAccent : const Color(0xFF00F5D4),
                ),
              ),
              child: Text(
                _feedbackText!,
                style: TextStyle(
                  fontSize: 12,
                  color: _isError ? Colors.redAccent.shade100 : const Color(0xFF00F5D4),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// 3. SEKME: MADENCİLİK & VERİ BORU HATTI (dart:math, dart:convert, dart:io)
// ============================================================================

class MiningLedgerTab extends StatefulWidget {
  final Set<Transaction> mempool;
  final List<Map<String, dynamic>> blockchain;
  final List<String> virtualDiskLines;
  final void Function(Map<String, dynamic>, String) onBlockMined;

  const MiningLedgerTab({
    super.key,
    required this.mempool,
    required this.blockchain,
    required this.virtualDiskLines,
    required this.onBlockMined,
  });

  @override
  State<MiningLedgerTab> createState() => _MiningLedgerTabState();
}

class _MiningLedgerTabState extends State<MiningLedgerTab> {
  String _pipelineOutput = 'Blok kazıldığında JSON olarak diske kaydedilir.';
  bool _isMining = false;

  String get _ledgerPath => '${Directory.systemTemp.path}/chainpulse_mobile_ledger.jsonl';

  // Slayt 42, 44, 47: Random.secure(), jsonEncode(), File
  Future<void> _mineNewBlock() async {
    if (widget.mempool.isEmpty) {
      setState(() {
        _pipelineOutput = '⚠️ Havuz (Set) boş! 1. veya 2. sekmeden işlem ekleyin.';
      });
      return;
    }

    setState(() => _isMining = true);
    final start = DateTime.now(); // Slayt 21

    // Slayt 22: Comparable (compareTo) ile işlemleri büyükten küçüğe sıralama
    final sortedTxs = widget.mempool.toList()..sort();

    await Future.delayed(const Duration(milliseconds: 450));

    // Slayt 42: Random.secure() ile kriptografik Nonce üretimi
    final secRnd = Random.secure();
    int nonce = 0;
    while (nonce < 75000) {
      nonce = secRnd.nextInt(100000);
    }

    final elapsed = DateTime.now().difference(start); // Slayt 21: Duration

    final blockData = {
      'index': widget.blockchain.length + 1,
      'hash': '0000${nonce.toRadixString(16).toUpperCase()}',
      'nonce': nonce,
      'txCount': sortedTxs.length,
      'durationMs': elapsed.inMilliseconds,
      'timestamp': DateTime.now().toIso8601String(),
      'transactions': sortedTxs.map((e) => e.toJson()).toList(),
    };

    final jsonLine = jsonEncode(blockData);

    try {
      // Slayt 44 & 47: dart:convert (jsonEncode) + dart:io (File)
      if (!kIsWeb) {
        final file = File(_ledgerPath);
        await file.writeAsString('$jsonLine\n', mode: FileMode.append);
      }
      widget.onBlockMined(blockData, jsonLine);

      setState(() {
        _pipelineOutput = '⛏️ BLOK #${blockData['index']} KAZILDI!\n'
            '• Nonce (Random.secure): $nonce\n'
            '• Süre (Duration): ${elapsed.inMilliseconds} ms\n'
            '• Kayıt: JSON satırı olarak kaydedildi.';
      });
    } catch (e) {
      setState(() => _pipelineOutput = 'Dosya Hatası: $e');
    } finally {
      setState(() => _isMining = false);
    }
  }

  // Slayt 6 & 58: BİRLEŞİK VERİ BORU HATTI (openRead -> utf8.decoder -> LineSplitter -> jsonDecode)
  Stream<Map<String, dynamic>> _readLedgerStream() async* {
    Stream<List<int>> byteStream;

    if (!kIsWeb) {
      final file = File(_ledgerPath);
      if (!await file.exists()) return;
      byteStream = file.openRead(); // Gerçek dart:io okuma akışı
    } else {
      // Web'de sunum yaparken bile utf8.encode -> utf8.decoder -> LineSplitter boru hattını çalıştırır!
      final rawContent = widget.virtualDiskLines.join('\n');
      byteStream = Stream.fromIterable([utf8.encode(rawContent)]);
    }

    final lines = byteStream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (line.trim().isNotEmpty) {
        yield jsonDecode(line) as Map<String, dynamic>;
      }
    }
  }

  Future<void> _runUnifiedPipeline() async {
    int count = 0;
    await for (final _ in _readLedgerStream()) {
      count++;
    }
    HapticFeedback.mediumImpact();
    setState(() {
      _pipelineOutput = '🚀 BİRLEŞİK VERİ BORU HATTI ÇALIŞTI!\n'
          'Stream<List<int>> ➔ utf8.decoder ➔ LineSplitter ➔ jsonDecode\n'
          'Toplam $count blok satır satır okunup doğrulandı.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Madencilik & Defter',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          Text(
            'dart:math • dart:convert • dart:io Pipeline',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 12),

          // Madencilik Kontrol Kartı
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131B2E),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF00F5D4).withOpacity(0.25)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bekleyen Havuz (Set)', style: TextStyle(color: Colors.white60, fontSize: 11)),
                        const SizedBox(height: 2),
                        Text(
                          '${widget.mempool.length} Benzersiz İşlem',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00F5D4).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.memory_rounded, color: Color(0xFF00F5D4), size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF00F5D4),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _isMining ? null : _mineNewBlock,
                        icon: _isMining
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                              )
                            : const Icon(Icons.bolt_rounded, size: 18),
                        label: const Text('BLOK KAZ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF00F5D4),
                          side: const BorderSide(color: Color(0xFF00F5D4)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _runUnifiedPipeline,
                        icon: const Icon(Icons.storage_rounded, size: 16),
                        label: const Text('PIPELINE OKU', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Terminal Konsol Çıktısı
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF060911),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              _pipelineOutput,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF00F5D4),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),

          const Text(
            'Onaylanmış Blok Zinciri (List)',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const SizedBox(height: 6),

          Expanded(
            child: widget.blockchain.isEmpty
                ? Center(
                    child: Text(
                      'Henüz blok kazılmadı.\nHavuzdaki işlemleri bloklamak için "BLOK KAZ" butonuna basın.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: widget.blockchain.length,
                    itemBuilder: (context, index) {
                      final block = widget.blockchain[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF131B2E),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withOpacity(0.06)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B2CBF).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '#${block['index']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFFE0AAFF),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hash: ${block['hash']}',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${block['txCount']} İşlem • Nonce: ${block['nonce']} • ${block['durationMs']} ms',
                                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.verified_rounded, color: Color(0xFF00F5D4), size: 18),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}