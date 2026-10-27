import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/check_annotations.dart';

void main() {
  test('projedeki annotation sözleşmeleri sağlanıyor', () {
    expect(checkAnnotations(Directory('lib')), isEmpty);
  });

  test('ihlaller yakalanıyor', () {
    final dir = Directory.systemTemp.createTempSync('ann');
    addTearDown(() => dir.deleteSync(recursive: true));
    File('${dir.path}/bad.dart').writeAsStringSync('''
@OnChainRecord(type: Bad.kind)
final class Bad extends Object {}

class Svc {
  @RoleRestricted(Role.instructor)
  Future<void> run() async {
    print('rol denetimi yok');
  }

  @RoleRestricted(Role.instructor)
  Future<void> declared();
}
''');
    final v = checkAnnotations(dir);
    final messages = v.map((e) => e.message).join('\n');
    expect(messages, contains('Record sınıfından türemeli'));
    expect(messages, contains('fromJson'));
    expect(messages, contains('ledger_codec'));
    expect(messages, contains('RoleGuard.ensure'));
    // Gövdesiz (arayüz) bildirim ihlal sayılmaz.
    expect(v.where((e) => e.message.contains('RoleGuard')), hasLength(1));
  });
}
