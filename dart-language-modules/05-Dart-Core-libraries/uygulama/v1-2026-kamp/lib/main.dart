import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:convert';

void main() {
  runApp(const SiberKasaApp());
}

class AppColors {
  static const Color bgOuter = Color(0xFF090D16);
  static const Color bgMain = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color surfaceLight = Color(0xFF334155);
  static const Color codeBg = Color(0xFF0B1120);

  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF38BDF8);
  static const Color emerald = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
}

class SiberKasaApp extends StatelessWidget {
  const SiberKasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasa - Dijital Kimlik Yöneticisi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.bgMain,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
        ),
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: AppColors.bgOuter,
          body: Center(
            child: Container(
              width: 405,
              height: 845,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.bgMain,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF273549), width: 9),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x99000000),
                    blurRadius: 50,
                    spreadRadius: 5,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(41),
                child: Column(
                  children: [
                    Container(
                      height: 34,
                      color: AppColors.bgMain,
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '09:41',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Container(
                            width: 82,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color(0xFF06090F),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          const Row(
                            children: [
                              Icon(Icons.signal_cellular_alt, size: 13, color: AppColors.textPrimary),
                              SizedBox(width: 5),
                              Icon(Icons.wifi, size: 13, color: AppColors.textPrimary),
                              SizedBox(width: 5),
                              Icon(Icons.battery_full, size: 14, color: AppColors.textPrimary),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: child ?? const SizedBox.shrink()),
                    Container(
                      height: 18,
                      color: AppColors.bgMain,
                      alignment: Alignment.center,
                      child: Container(
                        width: 115,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      home: const SiberKasaAnaSayfa(),
    );
  }
}

class SiberKasaAnaSayfa extends StatefulWidget {
  const SiberKasaAnaSayfa({super.key});

  @override
  State<SiberKasaAnaSayfa> createState() => _SiberKasaAnaSayfaState();
}

class _SiberKasaAnaSayfaState extends State<SiberKasaAnaSayfa> {
  int _seciliSekme = 0;

  final TextEditingController _platformController = TextEditingController(
    text: '  github hesabım  ',
  );
  String _hamMetin = '  github hesabım  ';
  String _aktifPlatform = 'GITHUB_HESABIM';

  String _uretilenSifre = 'Kv9#mP2!xL8@qW4z';
  double _entropiSkoru = 91.4;
  double _sonSqrtDegeri = 4.0;
  int _sonRandomSayi = 42;
  int _uzunluk = 16;
  bool _sifreGizli = false;

  bool _taraniyor = false;
  String _futureDurumKodu = 'Future.Status: Beklemede';
  String _sizintiDurumu = 'Sızıntı kontrolü henüz çalıştırılmadı.';
  Color _sizintiRenk = AppColors.textSecondary;

  final List<Map<String, dynamic>> _kayitliSifreler = [
    {
      'platform': 'INSTAGRAM',
      'sifre': 'InSt@#8821!xK9_p',
      'entropi': 89.2,
      'guvenli': true,
      'tarih': 'Bugün, 09:30',
      'gizli': true,
    },
    {
      'platform': 'STEAM_OYUN',
      'sifre': 'StEaM*994#qL2!zX',
      'entropi': 94.6,
      'guvenli': true,
      'tarih': 'Bugün, 10:15',
      'gizli': true,
    },
  ];

  String _jsonCikti = '';
  String _decodeAnalizSonucu = '';

  @override
  void dispose() {
    _platformController.dispose();
    super.dispose();
  }

  void _bildirimGoster(String mesaj) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mesaj,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 1. FONKSİYON: dart:core
  void _platformuFormatla() {
    setState(() {
      _hamMetin = _platformController.text;
      String temiz = _hamMetin.trim().toUpperCase().replaceAll(' ', '_');
      _aktifPlatform = temiz.isEmpty ? 'GENEL_HESAP' : temiz;
    });
    _bildirimGoster('dart:core -> trim() ve toUpperCase() uygulandı');
  }

  // 2. FONKSİYON: dart:math
  void _gucluSifreUret() {
    const havuz = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789!@#\$%^&*';
    final rastgele = Random();
    String yeniSifre = '';
    for (int i = 0; i < _uzunluk; i++) {
      yeniSifre += havuz[rastgele.nextInt(havuz.length)];
    }

    int uretilenRandom = rastgele.nextInt(100);
    double karekokUzunluk = sqrt(_uzunluk);
    double hamGuc = karekokUzunluk * pi * 6.5;
    double normalizeSkor = (hamGuc + (uretilenRandom % 10)).clamp(15.0, 99.9);

    setState(() {
      _uretilenSifre = yeniSifre;
      _sonRandomSayi = uretilenRandom;
      _sonSqrtDegeri = karekokUzunluk;
      _entropiSkoru = normalizeSkor;
      _sizintiDurumu = 'Yeni anahtar üretildi. Tarama bekleniyor.';
      _futureDurumKodu = 'Future.Status: Hazır';
      _sizintiRenk = AppColors.amber;
    });
  }

  // 3. FONKSİYON: Future & async/await
  Future<void> _darkWebTaramasiYap() async {
    setState(() {
      _taraniyor = true;
      _futureDurumKodu = 'await Future.delayed(Duration(seconds: 2))';
      _sizintiDurumu = 'Veri tabanları asenkron taranıyor...';
      _sizintiRenk = AppColors.secondary;
    });

    await Future.delayed(const Duration(seconds: 2));

    final gecikmeMs = Random().nextInt(120) + 90;
    setState(() {
      _taraniyor = false;
      _futureDurumKodu = 'Future Tamamlandı (200 OK - $gecikmeMs ms)';
      _sizintiDurumu = 'Güvenli: Hiçbir veri sızıntısında eşleşme bulunamadı.';
      _sizintiRenk = AppColors.emerald;
    });
  }

  void _kasayaKaydet() {
    _platformuFormatla();
    setState(() {
      _kayitliSifreler.insert(0, {
        'platform': _aktifPlatform,
        'sifre': _uretilenSifre,
        'entropi': double.parse(_entropiSkoru.toStringAsFixed(1)),
        'guvenli': _sizintiDurumu.startsWith('Güvenli'),
        'tarih': 'Şimdi',
        'gizli': true,
      });
    });
    _bildirimGoster('$_aktifPlatform kasaya eklendi');
  }

  // 4. FONKSİYON: dart:convert
  void _tumKasayiJsonYap() {
    final Map<String, dynamic> yedekPaketi = {
      'kutuphane': 'dart:convert',
      'islem': 'jsonEncode()',
      'kayit_sayisi': _kayitliSifreler.length,
      'hesaplar': _kayitliSifreler
          .map((k) => {
                'etiket': k['platform'],
                'anahtar': k['sifre'],
                'guc_skoru': k['entropi'],
              })
          .toList(),
    };

    setState(() {
      _jsonCikti = const JsonEncoder.withIndent('  ').convert(yedekPaketi);
      _decodeAnalizSonucu = '';
    });
  }

  void _jsonCozumleVeAnalizEt() {
    if (_jsonCikti.isEmpty) {
      _tumKasayiJsonYap();
    }

    final Map<String, dynamic> cozulmusMap = jsonDecode(_jsonCikti);
    final List<dynamic> liste = cozulmusMap['hesaplar'];
    final String ilkEtiket = liste.isNotEmpty ? liste[0]['etiket'].toString() : 'Yok';

    setState(() {
      _decodeAnalizSonucu =
          '✓ jsonDecode() Başarılı\nString verisi tekrar Dart Map nesnesine çevrildi.\nÇözümlenen İlk Etiket: $ilkEtiket';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0x266366F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kasa',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        'Dart Kütüphaneleri Uygulaması',
                        style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceLight),
                ),
                child: Text(
                  '${_kayitliSifreler.length} Kayıt',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _seciliSekme,
        children: [
          _ureticiSekmesi(),
          _kasamSekmesi(),
          _jsonYedekSekmesi(),
          _sunumRehberiSekmesi(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.surface, width: 1)),
        ),
        child: NavigationBar(
          height: 64,
          backgroundColor: AppColors.bgMain,
          indicatorColor: const Color(0x306366F1),
          selectedIndex: _seciliSekme,
          onDestinationSelected: (index) => setState(() => _seciliSekme = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.tune_rounded, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
              label: 'Üretici',
            ),
            NavigationDestination(
              icon: Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.lock, color: AppColors.primary, size: 20),
              label: 'Kasam',
            ),
            NavigationDestination(
              icon: Icon(Icons.code_rounded, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.code_rounded, color: AppColors.primary, size: 20),
              label: 'JSON',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_rounded, size: 20, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.secondary, size: 20),
              label: 'Sunum',
            ),
          ],
        ),
      ),
    );
  }

  // 1. SEKME: ÜRETİCİ & LABORATUVAR
  Widget _ureticiSekmesi() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x596366F1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0x1AFFFFFF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _aktifPlatform,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Güvenlik Skoru: %${_entropiSkoru.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      _sifreGizli ? '•' * _uretilenSifre.length : _uretilenSifre,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _sifreGizli ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 18,
                      color: Colors.white70,
                    ),
                    onPressed: () => setState(() => _sifreGizli = !_sifreGizli),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18, color: Colors.white),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _uretilenSifre));
                      _bildirimGoster('Anahtar panoya kopyalandı');
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _entropiSkoru / 100,
                  minHeight: 5,
                  backgroundColor: Colors.black26,
                  color: AppColors.emerald,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 1. MODÜL: dart:core
        _bolumKarti(
          baslik: '1. dart:core — Metin İşleme',
          ikon: Icons.text_fields_rounded,
          ikonRenk: AppColors.secondary,
          icerik: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _platformController,
                      style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Boşluklu hesap adı girin...',
                        hintStyle: const TextStyle(color: AppColors.textSecondary),
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.bgMain,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.surfaceLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: AppColors.surfaceLight),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _platformuFormatla,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Formatla', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _canliKodKutusu(
                'Girdi : "$_hamMetin" (${_hamMetin.length} krktr)\n'
                'Metot : girdi.trim().toUpperCase()\n'
                'Çıktı : "$_aktifPlatform" (${_aktifPlatform.length} krktr)',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 2. MODÜL: dart:math
        _bolumKarti(
          baslik: '2. dart:math — Kripto & Entropi Hesabı',
          ikon: Icons.calculate_outlined,
          ikonRenk: AppColors.primary,
          icerik: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Karakter Uzunluğu:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  Text(
                    '$_uzunluk Karakter',
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary, fontSize: 12),
                  ),
                ],
              ),
              Slider(
                value: _uzunluk.toDouble(),
                min: 8,
                max: 24,
                divisions: 16,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.bgMain,
                onChanged: (val) => setState(() => _uzunluk = val.toInt()),
              ),
              _canliKodKutusu(
                'Random().nextInt(100) ➔ $_sonRandomSayi\n'
                'sqrt($_uzunluk) (Karekök)    ➔ ${_sonSqrtDegeri.toStringAsFixed(2)}\n'
                'pi Sabiti             ➔ ${pi.toStringAsFixed(4)}\n'
                'Hesaplanan Güç        ➔ %${_entropiSkoru.toStringAsFixed(1)}',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _gucluSifreUret,
                      icon: const Icon(Icons.autorenew_rounded, size: 16),
                      label: const Text('Yeni Üret', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _kasayaKaydet,
                      icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                      label: const Text('Kasaya Kaydet', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceLight,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 3. MODÜL: Future (Asenkron)
        _bolumKarti(
          baslik: '3. Future — Asenkron Sızıntı Kontrolü',
          ikon: Icons.sync,
          ikonRenk: AppColors.emerald,
          icerik: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (_taraniyor)
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.secondary),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      _sizintiDurumu,
                      style: TextStyle(fontSize: 12, color: _sizintiRenk, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _canliKodKutusu(_futureDurumKodu),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _taraniyor ? null : _darkWebTaramasiYap,
                  icon: const Icon(Icons.radar_rounded, size: 16),
                  label: const Text('Asenkron Sorguyu Başlat (2 sn)', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.surfaceLight),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 2. SEKME: KASAM
  Widget _kasamSekmesi() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _kayitliSifreler.length,
      itemBuilder: (context, index) {
        final kayit = _kayitliSifreler[index];
        final bool gizli = kayit['gizli'] == true;
        final String sifreMetni = kayit['sifre'].toString();
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.surfaceLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.key_rounded, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            kayit['platform'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x2610B981),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '%${kayit['entropi']} Güç',
                      style: const TextStyle(fontSize: 10.5, color: AppColors.emerald, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      gizli ? '••••••••••••••••' : sifreMetni,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      gizli ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => kayit['gizli'] = !gizli),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.rose),
                    onPressed: () => setState(() => _kayitliSifreler.removeAt(index)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. SEKME: dart:convert (JSON)
  Widget _jsonYedekSekmesi() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _bolumKarti(
          baslik: '4. dart:convert — JSON Serileştirme',
          ikon: Icons.data_object_rounded,
          ikonRenk: AppColors.amber,
          icerik: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kasadaki Dart Map/List nesnelerini dışa aktarmak için JSON formatına çevirin veya JSON metnini tekrar Dart nesnesine çözümleyin:',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _tumKasayiJsonYap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('1. jsonEncode()', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _jsonCozumleVeAnalizEt,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.surfaceLight),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('2. jsonDecode()', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                    ),
                  ),
                ],
              ),
              if (_decodeAnalizSonucu.isNotEmpty) ...[
                const SizedBox(height: 10),
                _canliKodKutusu(_decodeAnalizSonucu),
              ],
              if (_jsonCikti.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.codeBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.surfaceLight),
                  ),
                  child: SelectableText(
                    _jsonCikti,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.secondary, height: 1.4),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // 4. SEKME: SUNUM & KONU EŞLEŞTİRME REHBERİ
  Widget _sunumRehberiSekmesi() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0x1F6366F1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0x4D6366F1)),
          ),
          child: const Text(
            '📌 Mimari Yaklaşım:\nSoyut Dart kütüphaneleri, gerçek bir "Şifre & Kimlik Yöneticisi" senaryosu içinde birleştirilerek her kütüphanenin gerçek dünyadaki görevi modellenmiştir.',
            style: TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
          ),
        ),
        const SizedBox(height: 12),
        _rehberKarti(
          konu: '1. dart:core (String Metotları)',
          kullanimYeri: 'Kullanıcının girdiği hesap etiketindeki boşlukları temizlemek ve büyük harf standardına dönüştürmek için kullanıldı.',
          kodOrnegi: 'girdi.trim().toUpperCase()',
          renk: AppColors.secondary,
        ),
        _rehberKarti(
          konu: '2. dart:math (Matematik Kütüphanesi)',
          kullanimYeri: 'Rastgele karakter seçimi ve şifre uzunluğunun karekökü ile Pi sabiti üzerinden güvenlik skoru hesaplamak için kullanıldı.',
          kodOrnegi: 'Random().nextInt(), sqrt(n), pi',
          renk: AppColors.primary,
        ),
        _rehberKarti(
          konu: '3. Future & async/await',
          kullanimYeri: 'Kullanıcı arayüzünü dondurmadan arka planda 2 saniyelik sunucu sızıntı sorgusu simülasyonu yapmak için kullanıldı.',
          kodOrnegi: 'await Future.delayed(Duration(seconds: 2))',
          renk: AppColors.emerald,
        ),
        _rehberKarti(
          konu: '4. dart:convert (JSON Dönüşümü)',
          kullanimYeri: 'Kasadaki şifre listesini (Map/List) JSON metnine dönüştürmek ve tekrar Dart nesnesine çözümlemek için kullanıldı.',
          kodOrnegi: 'jsonEncode(map) & jsonDecode(jsonStr)',
          renk: AppColors.amber,
        ),
      ],
    );
  }

  Widget _canliKodKutusu(String metin) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.codeBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Text(
        metin,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          color: AppColors.secondary,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _rehberKarti({
    required String konu,
    required String kullanimYeri,
    required String kodOrnegi,
    required Color renk,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: renk, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  konu,
                  style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(kullanimYeri, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35)),
          const SizedBox(height: 8),
          _canliKodKutusu(kodOrnegi),
        ],
      ),
    );
  }

  Widget _bolumKarti({
    required String baslik,
    required IconData ikon,
    required Color ikonRenk,
    required Widget icerik,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(ikon, color: ikonRenk, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: AppColors.surfaceLight),
          ),
          icerik,
        ],
      ),
    );
  }
}