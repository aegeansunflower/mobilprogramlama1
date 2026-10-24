import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Uygulama genelinde kullanılan snackbar tonları.
enum SnackBarTone {
  /// Başarılı işlem.
  success,

  /// Başarısız işlem veya doğrulama hatası.
  error,

  /// Bilgilendirme.
  info,
}

/// Tutarlı görünümde, isteğe bağlı eylem içeren bir snackbar gösterir.
void showAppSnackBar(
  BuildContext context,
  String message, {
  SnackBarTone tone = SnackBarTone.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();

  final (Color background, IconData icon) = switch (tone) {
    SnackBarTone.success => (AppColors.forest, Icons.check_circle_outline),
    SnackBarTone.error => (AppColors.danger, Icons.error_outline),
    SnackBarTone.info => (const Color(0xFF2D5A49), Icons.info_outline),
  };

  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: background,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: AppColors.mint,
              onPressed: onAction,
            )
          : null,
    ),
  );
}
