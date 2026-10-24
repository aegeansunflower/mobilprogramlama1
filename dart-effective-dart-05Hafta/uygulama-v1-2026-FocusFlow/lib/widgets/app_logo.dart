import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// FocusFlow'un saat-yaprak marka logosu.
///
/// Logo, paket içindeki yüksek çözünürlüklü marka görselinden gösterilir.
/// Koyu temada krem zeminli küçük bir rozet gibi görünmesi için yuvarlatılmış
/// bir kapsayıcı kullanılır.
class AppLogo extends StatelessWidget {
  /// İstenen kenar uzunluğuyla logo oluşturur.
  const AppLogo({super.key, this.size = 36});

  /// Karenin kenar uzunluğu.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.035),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(
          color: AppColors.forest.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.forest.withValues(alpha: 0.18),
            blurRadius: size * 0.3,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: Image.asset(
          'assets/branding/focusflow_mark.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          semanticLabel: 'FocusFlow logosu',
        ),
      ),
    );
  }
}
