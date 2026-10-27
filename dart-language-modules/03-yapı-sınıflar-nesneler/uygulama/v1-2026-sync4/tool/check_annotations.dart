// DART KONUSU: Metadata — özel annotation'ların (`@OnChainRecord`,
// `@RoleRestricted`) kaynak kod üzerinde denetlenmesi. Flutter'da yansıma
// (dart:mirrors) olmadığı için annotation'lar derleme dışı bir araçla
// anlamlı hâle getirilir. Libraries & imports — `show`.

/// Annotation sözleşmelerini denetler:
///
/// * `@OnChainRecord` sınıfı `Record`'dan türemeli, `fromJson` factory'si ve
///   `toJson()` metodu olmalı, `ledger_codec.dart` içinde çözülmeli, `type`
///   değeri tekil olmalı.
/// * `@RoleRestricted(Role.x)` ile işaretli ve gövdesi olan her metot,
///   gövdesinde `RoleGuard.ensure(Role.x, ...)` çağırmalı.
///
/// Kullanım: `dart run tool/check_annotations.dart` (hata varsa çıkış kodu 1).
library;

import 'dart:io' show Directory, File, exitCode, stdout;

/// Bir ihlal.
typedef Violation = ({String file, int line, String message});

final _onChain = RegExp(
  r'@OnChainRecord\(\s*type:\s*([\w.]+)[^)]*\)\s*(?:@\w+(?:\([^)]*\))?\s*)*'
  r'(?:final\s+|base\s+|sealed\s+)?class\s+(\w+)\s+extends\s+(\w+)',
);
final _roleRestricted = RegExp(r'@RoleRestricted\(Role\.(\w+)\)');

int _lineOf(String source, int offset) =>
    '\n'.allMatches(source.substring(0, offset)).length + 1;

/// [root] altındaki Dart dosyalarını denetler.
List<Violation> checkAnnotations(Directory root) {
  final files = root
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'));
  final sources = {for (final f in files) f.path: f.readAsStringSync()};
  final codec = sources.entries
      .where((e) => e.key.replaceAll(r'\', '/').endsWith('ledger_codec.dart'))
      .map((e) => e.value)
      .join();

  final violations = <Violation>[];
  final types = <String, String>{};

  for (final MapEntry(key: path, value: src) in sources.entries) {
    for (final m in _onChain.allMatches(src)) {
      final (typeExpr, name, parent) = (m[1]!, m[2]!, m[3]!);
      final line = _lineOf(src, m.start);
      void fail(String msg) =>
          violations.add((file: path, line: line, message: '$name: $msg'));

      if (parent != 'Record') fail('Record sınıfından türemeli ($parent).');
      if (!src.contains('factory $name.fromJson(')) {
        fail('`factory $name.fromJson` eksik.');
      }
      if (!RegExp(r'Map<String, Object\?> toJson\(\)').hasMatch(src)) {
        fail('`toJson()` eksik.');
      }
      if (!codec.contains(typeExpr)) {
        fail('ledger_codec.dart içinde `$typeExpr` çözülmüyor.');
      }
      if (types[typeExpr] case final other?) {
        fail('`$typeExpr` türü $other ile çakışıyor.');
      }
      types[typeExpr] = name;
    }

    for (final m in _roleRestricted.allMatches(src)) {
      // Annotation'dan sonraki ilk `{` ya da `;`: gövde mi, soyut bildirim mi?
      final rest = src.substring(m.end);
      final brace = rest.indexOf(RegExp(r'\)\s*(async\s*)?\{'));
      final semi = rest.indexOf(RegExp(r'\);'));
      if (brace < 0 || (semi >= 0 && semi < brace)) continue; // arayüz
      final body = rest.substring(brace, (brace + 600).clamp(0, rest.length));
      if (!body.contains('RoleGuard.ensure(Role.${m[1]}')) {
        violations.add((
          file: path,
          line: _lineOf(src, m.start),
          message:
              '@RoleRestricted(Role.${m[1]}) metodu RoleGuard.ensure '
              'çağırmıyor.',
        ));
      }
    }
  }
  return violations;
}

void main(List<String> args) {
  final root = Directory(args.isEmpty ? 'lib' : args.first);
  final violations = checkAnnotations(root);
  if (violations.isEmpty) {
    stdout.writeln('Annotation denetimi: sorun yok ✓');
    return;
  }
  for (final v in violations) {
    stdout.writeln('${v.file}:${v.line}: ${v.message}');
  }
  exitCode = 1;
}
