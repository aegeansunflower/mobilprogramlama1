// DART KONUSU: Classes & objects — `ConsumerStatefulWidget` + `State`,
// `late final` controller'lar, `@override dispose` (`@mustCallSuper` uyumu),
// sealed `AuthState` üzerinde switch. Class modifiers — `final class`.

/// E-posta/okul numarası + şifre, ardından biyometrik doğrulama.
library;

import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/app/demo_seed.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_shell.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Rol bazlı giriş ekranı.
final class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({required this.role, super.key});

  final Role role;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _id = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  bool _obscure = true;

  bool get _isInstructor => widget.role == Role.instructor;

  @override
  void dispose() {
    _id.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    final auth = ref.read(authControllerProvider.notifier);
    if (_isInstructor) {
      await auth.signInInstructor(email: _id.text, password: _password.text);
    } else {
      await auth.signInStudent(
        studentNumber: _id.text,
        password: _password.text,
      );
    }
  }

  void _fillDemo(AppUser user) => setState(() {
    _id.text = switch (user) {
      Instructor(:final email) => email,
      Student(:final studentNumber) => studentNumber,
    };
    _password.text = 'demo1234';
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(authControllerProvider);

    // Şifre doğrulanınca biyometrik pencere otomatik açılır.
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AwaitingBiometric &&
          previous is! AwaitingBiometric &&
          next.failure == null) {
        unawaited(
          ref
              .read(authControllerProvider.notifier)
              .verifyBiometric(l10n.biometricReason),
        );
      }
    });

    return AuthShell(
      leading: TextButton.icon(
        onPressed: () {
          ref.read(authControllerProvider.notifier).clearError();
          context.go('/giris');
        },
        icon: const Icon(Icons.arrow_back, size: Sizes.iconSm),
        label: Text(l10n.backToRoles),
      ),
      child: AnimatedSwitcher(
        duration: context.reduceMotion ? Duration.zero : MotionDurations.medium,
        child: switch (state) {
          AwaitingBiometric() => _BiometricStep(
            key: const ValueKey('bio'),
            state: state,
          ),
          SignedOut() ||
          Authenticating() ||
          AuthError() ||
          SignedIn() => _buildForm(context, state),
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context, AuthState state) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final busy = state is Authenticating;
    final isDemo = ref.watch(appConfigProvider).isDemo;
    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          key: const ValueKey('form'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isInstructor
                  ? l10n.instructorLoginTitle
                  : l10n.studentLoginTitle,
              style: theme.textTheme.displaySmall,
            ).enter(context),
            const SizedBox(height: Space.sm),
            Text(
              _isInstructor
                  ? l10n.instructorLoginSubtitle
                  : l10n.studentLoginSubtitle,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: context.palette.textMuted,
              ),
            ).enter(context),
            const SizedBox(height: Space.xxl),
            TextFormField(
              controller: _id,
              enabled: !busy,
              keyboardType: _isInstructor
                  ? TextInputType.emailAddress
                  : TextInputType.number,
              textInputAction: TextInputAction.next,
              autofillHints: [
                if (_isInstructor)
                  AutofillHints.email
                else
                  AutofillHints.username,
              ],
              decoration: InputDecoration(
                labelText: _isInstructor
                    ? l10n.emailLabel
                    : l10n.studentNumberLabel,
                prefixIcon: Icon(
                  _isInstructor ? Icons.mail_outline : Icons.badge_outlined,
                  size: Sizes.iconMd,
                ),
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (_isInstructor) {
                  return value.contains('@') && value.contains('.')
                      ? null
                      : l10n.emailInvalid;
                }
                return value.isValidStudentNumber
                    ? null
                    : l10n.studentNumberInvalid;
              },
            ).enter(context, index: 1),
            const SizedBox(height: Space.md),
            TextFormField(
              controller: _password,
              enabled: !busy,
              obscureText: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: l10n.passwordLabel,
                prefixIcon: const Icon(Icons.lock_outline, size: Sizes.iconMd),
                suffixIcon: IconButton(
                  tooltip: _obscure ? l10n.showPassword : l10n.hidePassword,
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: Sizes.iconMd,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) =>
                  (v?.length ?? 0) >= 6 ? null : l10n.passwordTooShort,
            ).enter(context, index: 2),
            if (state case AuthError(:final failure)) ...[
              const SizedBox(height: Space.md),
              ErrorBanner(failure.message),
            ],
            const SizedBox(height: Space.xl),
            PrimaryButton(
              label: l10n.signIn,
              loading: busy,
              onPressed: _submit,
            ).enter(context, index: 3),
            if (isDemo) ...[
              SectionHeader(l10n.demoAccounts),
              for (final (i, user)
                  in DemoSeed.users
                      .where((u) => u.role == widget.role)
                      .indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: Space.sm),
                  child: _DemoAccountRow(
                    user: user,
                    onTap: busy ? null : () => _fillDemo(user),
                  ).enter(context, index: 4 + i),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Demo hesabı satırı: avatar + ad + giriş bilgisi.
final class _DemoAccountRow extends StatelessWidget {
  const _DemoAccountRow({required this.user, required this.onTap});

  final AppUser user;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final id = switch (user) {
      Instructor(:final email) => email,
      Student(:final studentNumber) => studentNumber,
    };
    return SurfaceCard(
      onTap: onTap,
      semanticLabel: user.displayName,
      padding: const EdgeInsets.symmetric(
        horizontal: Space.md,
        vertical: Space.sm + 2,
      ),
      child: Row(
        children: [
          InitialsAvatar(user.initials, size: 34),
          const SizedBox(width: Space.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  switch (user) {
                    Instructor(:final formalName) => formalName,
                    _ => user.displayName,
                  },
                  style: theme.textTheme.bodyMedium,
                ),
                Text(id, style: AppTheme.mono(context, size: 11.5)),
              ],
            ),
          ),
          const Icon(Icons.north_west, size: Sizes.iconSm),
        ],
      ),
    );
  }
}

/// İkinci adım: biyometrik doğrulama.
final class _BiometricStep extends ConsumerWidget {
  const _BiometricStep({required this.state, super.key});

  final AwaitingBiometric state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final p = context.palette;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: p.accentSoft,
              borderRadius: Radii.card,
            ),
            child: Icon(Icons.fingerprint, size: 34, color: p.accent),
          ).pop(context),
        ),
        const SizedBox(height: Space.xl),
        Text(l10n.biometricTitle, style: theme.textTheme.displaySmall),
        const SizedBox(height: Space.sm),
        Text(
          l10n.biometricBody,
          style: theme.textTheme.bodyLarge?.copyWith(color: p.textMuted),
        ),
        const SizedBox(height: Space.xl),
        SurfaceCard(
          padding: const EdgeInsets.all(Space.md),
          child: Row(
            children: [
              InitialsAvatar(state.user.initials, size: 36),
              const SizedBox(width: Space.md),
              Expanded(
                child: Text(
                  state.user.displayName,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ),
        if (state.failure case final failure?) ...[
          const SizedBox(height: Space.md),
          ErrorBanner(failure.message),
        ],
        const SizedBox(height: Space.xl),
        PrimaryButton(
          label: l10n.biometricAction,
          icon: Icons.fingerprint,
          loading: state.inProgress,
          onPressed: () => ref
              .read(authControllerProvider.notifier)
              .verifyBiometric(l10n.biometricReason),
        ),
        const SizedBox(height: Space.sm),
        PrimaryButton(
          label: l10n.cancel,
          variant: ButtonVariant.secondary,
          onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
        ),
      ],
    );
  }
}
