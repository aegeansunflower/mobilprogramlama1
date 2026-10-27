// DART KONUSU: Classes & objects — `ConsumerWidget` kalıtımı, private widget
// sınıfı, const constructor'lar. Class modifiers — `final class`.

/// Rol seçimi: Öğretim Görevlisi / Öğrenci.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_shell.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

export 'package:sarkisla_yoklama/auth/presentation/auth_shell.dart'
    show ThemeToggleButton;

/// Açılış ekranı.
final class RoleSelectPage extends ConsumerWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDemo = ref.watch(appConfigProvider).isDemo;
    return AuthShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.welcomeTitle,
            style: theme.textTheme.displaySmall,
          ).enter(context, index: 1),
          const SizedBox(height: Space.sm),
          Text(
            l10n.welcomeSubtitle,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: context.palette.textMuted,
            ),
          ).enter(context, index: 1),
          const SizedBox(height: Space.xxl),
          _RoleOption(
            role: Role.instructor,
            title: l10n.roleInstructor,
            hint: l10n.roleInstructorHint,
            icon: Icons.co_present_outlined,
            onTap: () => context.go('/giris/ogretim'),
          ).enter(context, index: 2),
          const SizedBox(height: Space.md),
          _RoleOption(
            role: Role.student,
            title: l10n.roleStudent,
            hint: l10n.roleStudentHint,
            icon: Icons.qr_code_scanner_outlined,
            onTap: () => context.go('/giris/ogrenci'),
          ).enter(context, index: 3),
          if (isDemo) ...[
            const SizedBox(height: Space.xl),
            _DemoNotice(text: l10n.demoModeBanner('demo1234'))
                .enter(context, index: 4),
          ],
        ],
      ),
    );
  }
}

/// Rol seçeneği. İkon kutusu rolün kendi renginde: kullanıcı, girişten önce
/// rolün renk dilini görür.
final class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.role,
    required this.title,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  final Role role;
  final String title;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final roleColor = AppPalette.of(Theme.of(context).brightness, role).accent;
    final theme = Theme.of(context);
    return SurfaceCard(
      onTap: onTap,
      semanticLabel: '$title. $hint',
      child: Row(
        children: [
          IconTile(icon, size: 44, color: roleColor),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(hint, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          const Icon(Icons.arrow_forward, size: Sizes.iconSm),
        ],
      ),
    );
  }
}

final class _DemoNotice extends StatelessWidget {
  const _DemoNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.sm + 2,
      ),
      decoration: BoxDecoration(
        color: p.surfaceMuted,
        borderRadius: Radii.control,
        border: Border.all(color: p.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: Sizes.iconSm),
          const SizedBox(width: Space.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
