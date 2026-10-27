// DART KONUSU: Classes & objects — `ConsumerWidget`, generics (family
// provider), sealed `ChainValidation` ve `AppUser` üzerinde eksiksiz switch,
// enum. Libraries & imports — `show`.

/// İki rolün de kullandığı yoklama widget'ları.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show FutureProviderFamily;
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_shell.dart'
    show ThemeToggleButton;
import 'package:sarkisla_yoklama/blockchain/blockchain.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Bir kaydın zincir makbuzu (hex hash ile).
final FutureProviderFamily<ChainReceipt?, String> receiptProvider =
    FutureProvider.family((ref, hex) async {
      await ref.watch(chainBlocksProvider.future);
      return await ref
          .read(chainRepositoryProvider)
          .receiptFor(Hash.fromHex(hex));
    });

/// Kayıt için doğrulama rozeti durumu: makbuz var + Merkle kanıtı geçerli +
/// zincirin tamamı geçerli.
VerificationState verificationOf(WidgetRef ref, Hash recordHash) {
  final receipt = ref.watch(receiptProvider(recordHash.hex));
  final chain = ref.watch(chainValidationProvider);
  return switch ((receipt, chain)) {
    (AsyncData(value: null), _) => VerificationState.pending,
    (AsyncData(value: final r?), AsyncData(value: ChainValid()))
        when r.isValid =>
      VerificationState.verified,
    (AsyncData(), AsyncData()) => VerificationState.failed,
    _ => VerificationState.pending,
  };
}

/// Zincir durumu kartı: durum noktası + başlık + ayrıntı.
final class ChainStatusCard extends ConsumerWidget {
  const ChainStatusCard({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = context.palette;
    final theme = Theme.of(context);
    final validation = ref.watch(chainValidationProvider);
    final (
      Color color,
      String title,
      String detail,
      bool broken,
    ) = switch (validation) {
      AsyncData(value: ChainValid(:final length, :final head)) => (
        p.present,
        l10n.chainValid,
        l10n.chainValidDetail(length, head.short),
        false,
      ),
      AsyncData(value: final ChainBroken broken) => (
        p.absent,
        l10n.chainBroken(broken.blockIndex),
        broken.reason,
        true,
      ),
      AsyncError(:final error) => (p.absent, l10n.genericError, '$error', true),
      _ => (p.textMuted, l10n.chainChecking, l10n.consensusName, false),
    };
    return SurfaceCard(
      onTap: onTap,
      semanticLabel: '$title. $detail',
      borderColor: broken ? p.absent.withValues(alpha: 0.5) : null,
      child: Row(
        children: [
          IconTile(
            broken ? Icons.gpp_bad_outlined : Icons.verified_user_outlined,
            color: color,
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _StatusDot(color: color, pulse: !broken),
                    const SizedBox(width: Space.sm),
                    Flexible(
                      child: Text(title, style: theme.textTheme.titleMedium),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  detail,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: Space.sm),
            const Icon(Icons.arrow_forward, size: Sizes.iconSm),
          ],
        ],
      ),
    );
  }
}

/// Canlılık noktası. Zincir sağlamken yavaşça "nefes alır".
final class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color, required this.pulse});

  final Color color;
  final bool pulse;

  @override
  Widget build(BuildContext context) {
    final dot = Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
    if (!pulse || context.reduceMotion) return dot;
    return dot
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .fade(begin: 1, end: 0.35, duration: 1400.ms, curve: Curves.easeInOut);
  }
}

/// Panel üst bölümü: mühür + uygulama adı + tema + hesap menüsü, altında
/// serif selamlama.
final class UserHeader extends ConsumerWidget {
  const UserHeader({required this.subtitle, super.key});

  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Hero(
              tag: 'school-seal',
              child: SchoolSeal(size: 30, semanticLabel: l10n.universityName),
            ),
            const SizedBox(width: Space.sm + 2),
            Expanded(
              child: Text(
                l10n.appTitle,
                style: theme.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const ThemeToggleButton(),
            _AccountMenu(user: user),
          ],
        ),
        const SizedBox(height: Space.xxl),
        Text(context.upper(subtitle), style: theme.textTheme.labelSmall),
        const SizedBox(height: Space.xs),
        Text(
          l10n.greeting(
            switch (user) {
              Instructor(:final formalName) => formalName,
              _ => user.displayName,
            },
          ),
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }
}

enum _AccountAction { signOut }

/// Avatar düğmesi → hesap menüsü (çıkış).
final class _AccountMenu extends ConsumerWidget {
  const _AccountMenu({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final detail = switch (user) {
      Instructor(:final email) => email,
      Student(:final studentNumber) => studentNumber,
    };
    return PopupMenuButton<_AccountAction>(
      tooltip: user.displayName,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: Radii.control,
        side: BorderSide(color: context.palette.border),
      ),
      color: context.palette.surface,
      onSelected: (action) async {
        switch (action) {
          case _AccountAction.signOut:
            await ref.read(authControllerProvider.notifier).signOut();
            if (context.mounted) context.go('/giris');
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                switch (user) {
                  Instructor(:final formalName) => formalName,
                  _ => user.displayName,
                },
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(detail, style: AppTheme.mono(context, size: 11.5)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _AccountAction.signOut,
          child: Row(
            children: [
              const Icon(Icons.logout, size: Sizes.iconSm),
              const SizedBox(width: Space.sm),
              Text(l10n.signOut),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(Space.xs),
        child: InitialsAvatar(user.initials, size: 36),
      ),
    );
  }
}

/// Katılım oranı halkası.
final class RateRing extends StatelessWidget {
  const RateRing({required this.rate, this.size = 48, this.color, super.key});

  final double rate;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = color ?? (rate >= 0.7 ? p.present : p.absent);
    return Semantics(
      label: '%${(rate * 100).round()}',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: rate),
              duration: context.reduceMotion
                  ? Duration.zero
                  : MotionDurations.slow * 2,
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => CircularProgressIndicator(
                value: v,
                strokeWidth: 3,
                backgroundColor: p.border,
                color: c,
                strokeCap: StrokeCap.round,
              ),
            ),
            Center(
              child: Text(
                '${(rate * 100).round()}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
