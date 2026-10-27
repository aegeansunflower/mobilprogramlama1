// DART KONUSU: Metadata — özel annotation (`@RoleRestricted`) ve onu çalışma
// zamanında uygulayan yardımcı.

/// Yalnızca belirli bir rolün çağırabileceği metotları işaretler.
library;

import 'package:meta/meta_meta.dart';
import 'package:sarkisla_yoklama/core/constants/role.dart';
import 'package:sarkisla_yoklama/core/errors/failure.dart';

/// Metodun yalnızca [role] rolündeki kullanıcı tarafından çağrılabileceğini
/// belirtir.
///
/// Flutter'da yansıma (mirrors) olmadığı için annotation tek başına çalışma
/// zamanında bir şey yapmaz. Bu yüzden:
/// * İşaretli her metot gövdesinin başında [RoleGuard.ensure] çağırır.
/// * `tool/check_annotations.dart` bu çağrının unutulmadığını denetler.
@Target({TargetKind.method, TargetKind.function, TargetKind.constructor})
final class RoleRestricted {
  /// Annotation'ı oluşturur.
  const RoleRestricted(this.role);

  /// Gerekli rol.
  final Role role;
}

/// `@RoleRestricted` metotlarının çalışma zamanı denetimi.
abstract final class RoleGuard {
  /// [actual] rol [required] değilse [PermissionFailure] döndürür,
  /// uygunsa `null` döndürür.
  static PermissionFailure? ensure(Role required, Role? actual) {
    if (actual == required) return null;
    return PermissionFailure(
      'Bu işlem yalnızca "${required.label}" rolü için izinlidir.',
    );
  }
}
