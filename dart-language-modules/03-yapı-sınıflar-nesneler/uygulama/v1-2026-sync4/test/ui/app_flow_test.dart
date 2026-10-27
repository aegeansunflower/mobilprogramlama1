// Uçtan uca arayüz testleri (demo modu). Her adımda ekran görüntüsü alınır:
//   flutter test test/ui --update-goldens   → test/ui/goldens/*.png üretir
//   flutter test test/ui                    → görüntüleri karşılaştırır
@Tags(['golden'])
library;

import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sarkisla_yoklama/app/app.dart';
import 'package:sarkisla_yoklama/app/providers.dart' show biometricProvider;
import 'package:sarkisla_yoklama/app/router.dart';
import 'package:sarkisla_yoklama/auth/auth.dart'
    show DemoBiometricAuthenticator;
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/ui/ui.dart' show SchoolSeal;

Future<void> _loadFonts() async {
  Future<ByteData> load(String key) => rootBundle.load(key);
  await (FontLoader('Inter')
        ..addFont(load('assets/fonts/Inter-Regular.ttf'))
        ..addFont(load('assets/fonts/Inter-Medium.ttf'))
        ..addFont(load('assets/fonts/Inter-SemiBold.ttf'))
        ..addFont(load('assets/fonts/Inter-Bold.ttf')))
      .load();
  await (FontLoader('Newsreader')
        ..addFont(load('assets/fonts/Newsreader-Variable.ttf'))
        ..addFont(load('assets/fonts/Newsreader-Italic-Variable.ttf')))
      .load();
  await (FontLoader(
    'FiraCode',
  )..addFont(load('assets/fonts/FiraCode-Variable.ttf'))).load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(load('fonts/MaterialIcons-Regular.otf'))).load();
}

/// Animasyonları ve gecikmeli işleri ilerletir (periyodik QR zamanlayıcısı
/// nedeniyle `pumpAndSettle` kullanılamaz).
Future<void> settle(WidgetTester tester, [int ms = 1500]) async {
  for (var i = 0; i < ms ~/ 100; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Ekran görüntüsü. QR nonce'u ve saat her çalıştırmada farklı olduğu için
/// görüntüler yalnızca `--update-goldens` ile üretilir; normal çalıştırmada
/// akış `expect` ifadeleriyle doğrulanır.
Future<void> shot(WidgetTester tester, String name) async {
  if (!autoUpdateGoldenFiles) return;
  await expectLater(
    find.byType(MaterialApp),
    matchesGoldenFile('goldens/$name.png'),
  );
}

Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  ThemeMode mode = ThemeMode.light,
  Size size = const Size(1170, 2532),
  double pixelRatio = 3,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = pixelRatio;
  addTearDown(tester.view.reset);
  // Testler telefon donanımına (Face ID / parmak izi) bağlı olmamalı.
  final container = ProviderContainer(
    overrides: [
      biometricProvider.overrideWithValue(const DemoBiometricAuthenticator()),
    ],
  );
  if (mode == ThemeMode.dark) {
    container.read(themeModeProvider.notifier).toggle(currentlyDark: false);
  }
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const SarkislaApp()),
  );
  // Okul mührünü çöz: ekran görüntüsünde boş kalmasın.
  await tester.runAsync(
    () => precacheImage(
      const AssetImage(SchoolSeal.asset),
      tester.element(find.byType(MaterialApp)),
    ),
  );
  await settle(tester);
  return container;
}

/// Ağacı kaldırır ve provider'ları (periyodik zamanlayıcılarıyla) kapatır.
Future<void> disposeApp(WidgetTester tester, ProviderContainer c) async {
  await tester.pumpWidget(const SizedBox());
  c.dispose();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> signIn(WidgetTester tester, String roleLabel, String who) async {
  await tester.tap(find.text(roleLabel));
  await settle(tester);
  await tester.tap(find.text(who));
  await tester.pump();
  await tester.tap(find.text('Giriş yap'));
  await settle(tester, 2500); // şifre + biyometrik (demo gecikmeleri)
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pump();
  await tester.tap(finder);
  await settle(tester);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr');
  });

  testWidgets('masaüstü: ikiye bölünmüş giriş ve geniş panel', (tester) async {
    await tester.runAsync(_loadFonts);
    final container = await pumpApp(
      tester,
      size: const Size(1440, 900),
      pixelRatio: 1,
    );
    await settle(tester, 2000);
    expect(find.text('Hoş geldiniz'), findsOneWidget);
    await shot(tester, '00_masaustu_giris');

    await signIn(tester, 'Öğretim Görevlisi', 'Prof.Dr. ADEM KARAKAŞ');
    expect(find.textContaining('Merhaba'), findsOneWidget);
    await shot(tester, '00_masaustu_panel');
    await disposeApp(tester, container);
  });

  testWidgets('öğretim görevlisi: giriş → oturum → blok → kurcalama', (
    tester,
  ) async {
    await tester.runAsync(_loadFonts);
    final container = await pumpApp(tester);
    await shot(tester, '01_rol_secimi');

    await tester.tap(find.text('Öğretim Görevlisi'));
    await settle(tester);
    await tester.tap(find.text('Prof.Dr. ADEM KARAKAŞ'));
    await tester.pump();
    await shot(tester, '02_giris_formu');
    await tester.tap(find.text('Giriş yap'));
    await settle(tester, 2500);
    expect(find.textContaining('Merhaba'), findsOneWidget);
    await shot(tester, '03_gorevli_ana_sayfa');

    await tester.tap(find.text('Bilişim Sistemleri ve Teknolojileri'));
    await settle(tester);
    await tester.tap(find.text('Programlamaya Giriş'));
    await settle(tester);
    await shot(tester, '04_ders_detay');

    await tester.tap(find.text('Yoklama başlat'));
    await settle(tester, 2000);
    expect(find.text('Canlı yoklama'), findsOneWidget);
    await tapVisible(tester, find.text('Demo: öğrenci katılımı ekle'));
    await tapVisible(tester, find.text('Demo: öğrenci katılımı ekle'));
    await settle(tester);
    await shot(tester, '05_canli_yoklama');

    await tapVisible(tester, find.text('Oturumu bitir ve zincire yaz'));
    await tester.tap(find.text('Onayla'));
    await settle(tester, 2000);
    expect(find.text('Blok #1 zincire eklendi'), findsWidgets);
    await shot(tester, '06_blok_muhurlendi');
    await tester.tap(find.text('Kapat'));
    await settle(tester);

    // push, sayfa kapanınca tamamlanır; beklenmez.
    unawaited(container.read(routerProvider).push('/ogretim/zincir'));
    await settle(tester, 2000);
    expect(find.text('Zincir doğrulandı'), findsOneWidget);
    await shot(tester, '07_zincir_gecerli');

    await tester.tap(find.text('Demo: bir kaydı kurcala'));
    await settle(tester, 2000);
    expect(find.text('Zincir bozuk: blok #1'), findsOneWidget);
    await shot(tester, '08_zincir_kurcalandi');
    await disposeApp(tester, container);
  });

  testWidgets('öğrenci: giriş → QR → makbuz (koyu tema)', (tester) async {
    await tester.runAsync(_loadFonts);
    final container = await pumpApp(tester, mode: ThemeMode.dark);

    // Önce görevli bir oturum açar ve çıkış yapar.
    await signIn(tester, 'Öğretim Görevlisi', 'Prof.Dr. ADEM KARAKAŞ');
    await tester.tap(find.text('Bilişim Sistemleri ve Teknolojileri'));
    await settle(tester);
    await tester.tap(find.text('Programlamaya Giriş'));
    await settle(tester);
    await tester.tap(find.text('Yoklama başlat'));
    await settle(tester, 2000);
    await container.read(authControllerProvider.notifier).signOut();
    await settle(tester);

    await signIn(tester, 'Öğrenci', 'Osman Ceran');
    expect(find.textContaining('Merhaba'), findsOneWidget);
    await shot(tester, '09_ogrenci_ana_sayfa_koyu');

    await tester.tap(find.text('QR tara'));
    await settle(tester, 2000);
    await shot(tester, '10_qr_tarayici_koyu');
    await tester.tap(find.text("Demo: açık oturumun QR'ını üret"));
    await settle(tester, 2500);
    expect(find.text('Yoklamanız alındı'), findsWidgets);
    await shot(tester, '11_makbuz_koyu');
    await disposeApp(tester, container);
  });
}
