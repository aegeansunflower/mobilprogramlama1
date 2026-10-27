// DART KONUSU: Classes & objects — `Notifier<AuthState>` kalıtımı,
// `@override build`, sealed durumlar üzerinde switch. Class modifiers —
// `final class`.

/// Oturum akışını yöneten Riverpod notifier'ı.
library;

import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sarkisla_yoklama/app/providers.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Şifre → biyometrik → oturum açık akışı.
final class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const SignedOut();

  Future<void> signInInstructor({
    required String email,
    required String password,
  }) async {
    state = const Authenticating(Role.instructor);
    final result = await ref
        .read(authRepositoryProvider)
        .signInInstructor(email: email, password: password);
    state = switch (result) {
      Ok(:final value) => AwaitingBiometric(value),
      Err(:final failure) => AuthError(failure, role: Role.instructor),
    };
  }

  Future<void> signInStudent({
    required String studentNumber,
    required String password,
  }) async {
    state = const Authenticating(Role.student);
    final deviceId = await ref.read(deviceIdentityProvider).deviceId();
    final result = await ref
        .read(authRepositoryProvider)
        .signInStudent(
          studentNumber: studentNumber,
          password: password,
          deviceId: deviceId,
        );
    state = switch (result) {
      Ok(:final value) => AwaitingBiometric(value),
      Err(:final failure) => AuthError(failure, role: Role.student),
    };
  }

  /// İkinci adım: biyometrik doğrulama. Görevli için imza anahtarı da bu
  /// adımda hazırlanır (ve yetkili dizinine kaydedilir).
  Future<void> verifyBiometric(String reason) async {
    final current = state;
    if (current is! AwaitingBiometric || current.inProgress) return;
    state = AwaitingBiometric(current.user, inProgress: true);
    final biometric = ref.read(biometricProvider);
    // Ekran kilidi olmayan cihaz: demo modunda adım atlanır; gerçek modda
    // izin verilmez (kilitsiz telefon, cihaz eşleştirmesini anlamsız kılar).
    final result = await biometric.isAvailable()
        ? await biometric.authenticate(reason)
        : ref.read(appConfigProvider).isDemo
        ? const Ok<void>(null)
        : const Err<void>(
            AuthFailure(
              'Bu cihazda ekran kilidi yok. Devam etmek için telefonda '
              'parmak izi, Face ID ya da şifre tanımlayın.',
            ),
          );
    if (!ref.mounted) return;
    switch (result) {
      case Ok():
        if (current.user case Instructor(:final uid)) {
          await ref.read(signerProvider(uid).future);
        }
        state = SignedIn(current.user);
      case Err(:final failure):
        state = AwaitingBiometric(current.user, failure: failure);
    }
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const SignedOut();
  }

  /// Hata mesajı kapatıldığında giriş formuna dönülür.
  void clearError() {
    if (state is AuthError) state = const SignedOut();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Oturumu tamamen açık kullanıcı.
final currentUserProvider = Provider<AppUser?>((ref) {
  final state = ref.watch(authControllerProvider);
  return state is SignedIn ? state.user : null;
});

/// Açık / koyu / sistem teması.
final class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void toggle({required bool currentlyDark}) =>
      state = currentlyDark ? ThemeMode.light : ThemeMode.dark;
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);
