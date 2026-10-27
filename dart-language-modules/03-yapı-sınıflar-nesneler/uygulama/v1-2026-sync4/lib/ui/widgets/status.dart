// DART KONUSU: Class modifiers — `sealed` hiyerarşi üzerinde eksiksiz
// `switch` (AttendanceStatus). Classes & objects — extension (`context.l10n`),
// const constructor'lar.

/// Durum rozetleri, hash metni, doğrulama rozeti, boş durum ve başlıklar.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/l10n/generated/app_localizations.dart';
import 'package:sarkisla_yoklama/ui/motion/motion.dart';
import 'package:sarkisla_yoklama/ui/theme/app_palette.dart';
import 'package:sarkisla_yoklama/ui/theme/app_theme.dart';
import 'package:sarkisla_yoklama/ui/theme/tokens.dart';

/// `context.l10n` kısayolu.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Etkin dile uygun büyük harf (Türkçede `i → İ`).
  String upper(String text) => Localizations.localeOf(this).languageCode == 'tr'
      ? text.toUpperTr
      : text.toUpperCase();
}

/// Durumun yerelleştirilmiş adı ve ikonu.
extension StatusPresentation on AttendanceStatus {
  String localized(AppLocalizations l10n) => switch (this) {
    Present() => l10n.statusPresent,
    Late(:final minutesLate) => l10n.statusLate(minutesLate),
    Absent() => l10n.statusAbsent,
    Excused() => l10n.statusExcused,
  };

  IconData get icon => switch (this) {
    Present() => Icons.check_circle_outline,
    Late() => Icons.schedule_outlined,
    Absent() => Icons.highlight_off_outlined,
    Excused() => Icons.description_outlined,
  };
}

/// Renk + ikon + metin: bilgi yalnızca renkle verilmez.
final class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {this.dense = false, super.key});

  final AttendanceStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final color = context.palette.statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 7 : Space.sm + 2,
        vertical: dense ? 2 : Space.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: Radii.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: dense ? 14 : Sizes.iconSm, color: color),
          const SizedBox(width: 5),
          Text(
            status.localized(context.l10n),
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Eş aralıklı, kısaltılmış hash. Dokununca tamamı panoya kopyalanır.
final class HashText extends StatelessWidget {
  const HashText(this.hash, {this.label, this.full = false, super.key});

  final Hash hash;
  final String? label;
  final bool full;

  @override
  Widget build(BuildContext context) {
    final text = full ? hash.hex : hash.short;
    return Semantics(
      button: true,
      label: '${label ?? ''} ${hash.short}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: Radii.control,
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: hash.hex));
          if (!context.mounted) return;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(context.l10n.copied)));
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: Sizes.minTouch),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Space.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (label != null)
                  Text(label!, style: Theme.of(context).textTheme.labelMedium),
                Row(
                  children: [
                    Flexible(child: Text(text, style: AppTheme.mono(context))),
                    const SizedBox(width: Space.xs),
                    Icon(
                      Icons.content_copy_outlined,
                      size: 14,
                      color: context.palette.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Zincir doğrulama durumu.
enum VerificationState { verified, pending, failed }

/// "Doğrulandı ✓" rozeti.
final class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge(this.state, {super.key});

  final VerificationState state;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = context.l10n;
    final (Color color, IconData icon, String text) = switch (state) {
      VerificationState.verified => (
        p.present,
        Icons.verified_outlined,
        l10n.verified,
      ),
      VerificationState.pending => (
        p.late,
        Icons.hourglass_empty_outlined,
        l10n.pendingVerification,
      ),
      VerificationState.failed => (
        p.absent,
        Icons.gpp_bad_outlined,
        l10n.notVerified,
      ),
    };
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: Sizes.iconSm, color: color),
        const SizedBox(width: Space.xs),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    ).pop(context);
  }
}

/// Bölüm başlığı: küçük, büyük harfli, geniş aralıklı etiket.
final class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0, Space.xxl, 0, Space.md),
    child: Row(
      children: [
        Expanded(
          child: Semantics(
            header: true,
            label: title,
            child: ExcludeSemantics(
              child: Text(
                context.upper(title),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// Boş durum.
final class EmptyState extends StatelessWidget {
  const EmptyState({required this.icon, required this.message, super.key});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: Space.xxl),
    child: Column(
      children: [
        Icon(icon, size: 40, color: context.palette.textMuted),
        const SizedBox(height: Space.md),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: context.palette.textMuted),
        ),
      ],
    ),
  );
}

/// Hata metnini gösteren küçük kart.
final class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {this.onRetry, super.key});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(Space.md),
      decoration: BoxDecoration(
        color: p.absent.withValues(alpha: 0.12),
        borderRadius: Radii.control,
        border: Border.all(color: p.absent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: p.absent),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(message, style: TextStyle(color: p.textPrimary)),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}
