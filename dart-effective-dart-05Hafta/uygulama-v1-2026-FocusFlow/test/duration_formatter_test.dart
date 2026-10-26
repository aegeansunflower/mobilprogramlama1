import 'package:flutter_test/flutter_test.dart';

import 'package:focus_flow/core/utils/duration_formatter.dart';

void main() {
  group('formatClock', () {
    test('sıfır ve sınır değerlerini doğru biçimlendirir', () {
      expect(formatClock(0), '00:00');
      expect(formatClock(59), '00:59');
      expect(formatClock(60), '01:00');
      expect(formatClock(1500), '25:00');
      expect(formatClock(3661), '1:01:01');
    });

    test('negatif değeri sıfır kabul eder', () {
      expect(formatClock(-15), '00:00');
    });
  });

  group('formatHumanDuration', () {
    test('dakika ve saat metinlerini üretir', () {
      expect(formatHumanDuration(0), '0 dk');
      expect(formatHumanDuration(59), '< 1 dk');
      expect(formatHumanDuration(60), '1 dk');
      expect(formatHumanDuration(1500), '25 dk');
      expect(formatHumanDuration(3600), '1 sa');
      expect(formatHumanDuration(3900), '1 sa 5 dk');
    });

    test('negatif değeri sıfır kabul eder', () {
      expect(formatHumanDuration(-60), '0 dk');
    });
  });
}
