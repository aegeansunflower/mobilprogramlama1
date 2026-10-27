// DART KONUSU: Classes & objects — `abstract final class` ile yalnızca static
// üyeler taşıyan ad alanı (örneklenemez, türetilemez), const listeler.
// Class modifiers — `abstract final`.

/// Demo modu için örnek bölüm, ders ve kullanıcılar.
library;

import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Demo veri seti. Kişiler kurgusaldır.
///
/// `abstract final class` seçildi: bu sınıf yalnızca static sabitler için
/// bir ad alanıdır. `abstract` örneklenmesini, `final` türetilmesini ve
/// uygulanmasını engeller.
abstract final class DemoSeed {
  static const Instructor ademHoca = Instructor(
    uid: 'hoca-adem',
    displayName: 'ADEM KARAKAŞ',
    email: 'adem.karakas@sarkisla.edu.tr',
    title: 'Prof.Dr.',
    departments: {
      Department.informationSystems,
      Department.artificialIntelligence,
    },
  );

  static const Instructor turgutHoca = Instructor(
    uid: 'hoca-turgut',
    displayName: 'TURGUT ÖZTÜRK',
    email: 'turgut.ozturk@sarkisla.edu.tr',
    title: 'Prof.Dr.',
    departments: {
      Department.informationSystems,
      Department.artificialIntelligence,
    },
  );

  static const Instructor mesutHoca = Instructor(
    uid: 'hoca-mesut',
    displayName: 'MESUT POLATGİL',
    email: 'mesut.polatgil@sarkisla.edu.tr',
    title: 'Doç.Dr.',
    departments: {
      Department.informationSystems,
      Department.artificialIntelligence,
    },
  );

  static const Instructor abdulkerimHoca = Instructor(
    uid: 'hoca-abdulkerim',
    displayName: 'ABDULKERİM GÜLER',
    email: 'abdulkerim.guler@sarkisla.edu.tr',
    title: 'Dr.Öğr. Üyesi',
    departments: {
      Department.informationSystems,
      Department.artificialIntelligence,
    },
  );

  static const Instructor umutHoca = Instructor(
    uid: 'hoca-umut',
    displayName: 'UMUT SARAY',
    email: 'umut.saray@sarkisla.edu.tr',
    title: 'Dr.Öğr. Üyesi',
    departments: {
      Department.informationSystems,
      Department.artificialIntelligence,
    },
  );

  // Geriye dönük uyumluluk için referanslar
  static const Instructor ayseHoca = ademHoca;
  static const Instructor mehmetHoca = turgutHoca;

  static const List<Student> bstStudents = [
    Student(
      uid: 'ogr-1',
      displayName: 'Osman Ceran',
      email: '2024481004@ogrenci.sarkisla.edu.tr',
      studentNumber: '2024481004',
      department: Department.informationSystems,
    ),
    Student(
      uid: 'ogr-2',
      displayName: 'Emir Sevgili',
      email: '2024481007@ogrenci.sarkisla.edu.tr',
      studentNumber: '2024481007',
      department: Department.informationSystems,
    ),
    Student(
      uid: 'ogr-3',
      displayName: 'Eymen İşleksoy',
      email: '2024481050@ogrenci.sarkisla.edu.tr',
      studentNumber: '2024481050',
      department: Department.informationSystems,
    ),
    Student(
      uid: 'ogr-4',
      displayName: 'Samed Hırabaşoğlu',
      email: '2024481009@ogrenci.sarkisla.edu.tr',
      studentNumber: '2024481009',
      department: Department.informationSystems,
    ),
    Student(
      uid: 'ogr-5',
      displayName: 'Ömer Murat',
      email: '2024481021@ogrenci.sarkisla.edu.tr',
      studentNumber: '2024481021',
      department: Department.informationSystems,
    ),
  ];

  static const List<Student> yzStudents = [];

  static const List<Instructor> instructors = [
    ademHoca,
    turgutHoca,
    mesutHoca,
    abdulkerimHoca,
    umutHoca,
  ];

  static List<Student> get students => bstStudents;

  static List<AppUser> get users => [...instructors, ...students];

  static List<String> _ids(List<Student> s) => [for (final x in s) x.uid];

  static List<Course> get courses => [
    Course(
      id: 'bst101',
      code: 'BST101',
      name: 'Programlamaya Giriş',
      department: Department.informationSystems,
      instructorId: ademHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'bst205',
      code: 'BST205',
      name: 'Veri Tabanı Yönetim Sistemleri',
      department: Department.informationSystems,
      instructorId: turgutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'bst201',
      code: 'BST201',
      name: 'Web Programlama I',
      department: Department.informationSystems,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'bst203',
      code: 'BST203',
      name: 'Görsel Programlama',
      department: Department.informationSystems,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'bst303',
      code: 'BST303',
      name: 'Mobil Programlama I',
      department: Department.informationSystems,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'bst405',
      code: 'BST405',
      name: 'Doğal Dil İşleme',
      department: Department.informationSystems,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'bst407',
      code: 'BST407',
      name: 'Derin Öğrenme',
      department: Department.informationSystems,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'yzm101',
      code: 'YZM101',
      name: 'Yapay Zekâya Giriş',
      department: Department.artificialIntelligence,
      instructorId: abdulkerimHoca.uid,
      studentIds: const [],
    ),
    Course(
      id: 'yzm204',
      code: 'YZM204',
      name: 'Makine Öğrenmesi',
      department: Department.artificialIntelligence,
      instructorId: umutHoca.uid,
      studentIds: const [],
    ),
    Course(
      id: 'yzm305',
      code: 'YZM305',
      name: 'Doğal Dil İşleme',
      department: Department.artificialIntelligence,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
    Course(
      id: 'yzm202',
      code: 'YZM202',
      name: 'Derin Öğrenme',
      department: Department.artificialIntelligence,
      instructorId: mesutHoca.uid,
      studentIds: _ids(bstStudents),
    ),
  ];
}
