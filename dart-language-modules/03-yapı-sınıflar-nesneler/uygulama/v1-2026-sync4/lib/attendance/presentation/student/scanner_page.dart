// DART KONUSU: Libraries & imports — bu kütüphane router'da
// `deferred as scanner` ile tembel (lazy) yüklenir. Kamera eklentisi ve
// tarayıcı arayüzü yalnızca öğrenci "QR tara"ya bastığında yüklenir.
// Classes & objects — `ConsumerStatefulWidget`, `late final`, `dispose`.

/// QR tarayıcı (ağır modül).
library;

import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart'
    show
        BarcodeCapture,
        BarcodeFormat,
        DetectionSpeed,
        MobileScanner,
        MobileScannerController,
        MobileScannerErrorCode;
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Kamera ile QR tarama + (demo modunda) QR üretme / yapıştırma.
final class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ScannerPage> createState() => _ScannerPageState();
}

final class _ScannerPageState extends ConsumerState<ScannerPage> {
  late final MobileScannerController _camera = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  late final TextEditingController _manual = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    if (!kIsWeb) unawaited(_camera.dispose());
    _manual.dispose();
    super.dispose();
  }

  Future<void> _submit(String raw) async {
    if (_busy) return;
    final user = ref.read(currentUserProvider);
    if (user is! Student) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final deviceId = await ref.read(deviceIdentityProvider).deviceId();
    final result = await ref
        .read(checkInProvider)
        .call(rawQr: raw, student: user, deviceId: deviceId);
    if (!mounted) return;
    switch (result) {
      case Ok(:final value):
        context.pushReplacement('/ogrenci/makbuz', extra: value);
      case Err(:final failure):
        setState(() {
          _busy = false;
          _error = failure.message;
        });
    }
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw != null) unawaited(_submit(raw));
  }

  Future<void> _demoQr() async {
    final user = ref.read(currentUserProvider);
    if (user is! Student) return;
    final qr = await DemoActions.openSessionQr(ref, user);
    if (!mounted) return;
    if (qr == null) {
      setState(() => _error = context.l10n.noOpenSession);
      return;
    }
    _manual.text = qr;
    await _submit(qr);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final p = context.palette;
    final isDemo = ref.watch(appConfigProvider).isDemo;
    return AppScaffold(
      title: l10n.scanQr,
      body: ListView(
        padding: const EdgeInsets.all(Space.lg),
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: Radii.card,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Telefonda kamera demo modunda da açılır. Web'de kamera
                  // kullanılmaz (yerel ağ adresleri "güvenli bağlam"
                  // sayılmadığı için tarayıcı izin vermez).
                  if (kIsWeb)
                    _CameraPlaceholder(message: l10n.cameraWebHint)
                  else
                    MobileScanner(
                      controller: _camera,
                      onDetect: _onDetect,
                      errorBuilder: (context, error) => _CameraPlaceholder(
                        message:
                            error.errorCode ==
                                MobileScannerErrorCode.permissionDenied
                            ? l10n.cameraPermissionDenied
                            : l10n.cameraUnavailable,
                      ),
                    ),
                  // Hizalama çerçevesi.
                  Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.7,
                      heightFactor: 0.7,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: Radii.card,
                          border: Border.all(color: p.accent, width: 3),
                        ),
                      ),
                    ),
                  ),
                  if (_busy)
                    ColoredBox(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: Space.md),
                            Text(
                              l10n.checkingIn,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Space.md),
          Text(
            l10n.scannerHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: p.textMuted),
          ),
          if (_error != null) ...[
            const SizedBox(height: Space.md),
            ErrorBanner(_error!),
          ],
          if (isDemo) ...[
            const SizedBox(height: Space.lg),
            PrimaryButton(
              label: l10n.demoQr,
              icon: Icons.science_outlined,
              loading: _busy,
              onPressed: _demoQr,
            ),
          ],
          const SizedBox(height: Space.lg),
          TextField(
            controller: _manual,
            decoration: InputDecoration(
              labelText: l10n.pasteQr,
              suffixIcon: IconButton(
                tooltip: l10n.submit,
                icon: const Icon(Icons.send_outlined),
                onPressed: () => _submit(_manual.text),
              ),
            ),
            onSubmitted: _submit,
          ),
        ],
      ),
    );
  }
}

/// Kamera kullanılamadığında tarayıcı alanında görünen bilgi.
final class _CameraPlaceholder extends StatelessWidget {
  const _CameraPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.black,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(Space.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography_outlined,
              size: 40,
              color: Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(height: Space.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
