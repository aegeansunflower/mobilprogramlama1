// DART KONUSU: Class modifiers — `final class`. Classes & objects — private
// alanlar, records (`({AppUser user, String password})`).

/// Firebase olmadan çalışan demo hesapları.
library;

import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/auth/domain/auth_services.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Bellek içi hesap deposu. Gerçek uygulamadaki kuralları (rol, şifre,
/// cihaz eşleştirme) aynen uygular.
final class DemoAuthRepository implements AuthRepository {
  DemoAuthRepository({
    required List<AppUser> users,
    this.password = 'demo1234',
    this.latency = const Duration(milliseconds: 500),
  }) : _users = {for (final u in users) u.uid: u};

  /// Tüm demo hesaplarının şifresi.
  final String password;

  /// Ağ gecikmesi benzetimi.
  final Duration latency;

  final Map<String, AppUser> _users;

  @override
  Future<Result<Instructor>> signInInstructor({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(latency);
    final match = _users.values.whereType<Instructor>().where(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase(),
    );
    if (match.isEmpty || password != this.password) {
      return const Err(AuthFailure('E-posta veya şifre hatalı.'));
    }
    return Ok(match.first);
  }

  @override
  Future<Result<Student>> signInStudent({
    required String studentNumber,
    required String password,
    required String deviceId,
  }) async {
    await Future<void>.delayed(latency);
    final match = _users.values.whereType<Student>().where(
      (u) => u.studentNumber == studentNumber.trim(),
    );
    if (match.isEmpty || password != this.password) {
      return const Err(AuthFailure('Okul numarası veya şifre hatalı.'));
    }
    final student = match.first;
    final bound = student.boundDeviceId;
    if (bound != null && bound != deviceId) {
      return const Err(
        AuthFailure(
          'Bu hesap başka bir cihaza bağlı. Cihaz değişikliği için bölüm '
          'sekreterliğine başvurun.',
        ),
      );
    }
    final updated = student.copyWith(boundDeviceId: deviceId);
    _users[student.uid] = updated;
    return Ok(updated);
  }

  @override
  Future<void> signOut() async {}
}
