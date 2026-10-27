// DART KONUSU: Libraries & imports — `as fa` / `as fs` önekleri (Firebase
// Auth'un `User` sınıfı ile bizim kullanıcı modellerimiz karışmasın diye).
// Class modifiers — `final class`. Classes & objects — static metot.

/// Firebase Auth + Firestore rol bilgisi.
library;

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:sarkisla_yoklama/auth/domain/app_user.dart';
import 'package:sarkisla_yoklama/auth/domain/auth_services.dart';
import 'package:sarkisla_yoklama/core/core.dart';

/// Firebase tabanlı hesap yönetimi.
///
/// * Rol ve profil `users/{uid}` belgesindedir.
/// * Öğrenciler okul numarasıyla girer; Firebase Auth'ta e-postaları
///   `<numara>@ogrenci.sarkisla.edu.tr` biçimindedir.
/// * Cihaz eşleştirme bir Firestore transaction ile yapılır; böylece iki
///   cihaz aynı anda ilk girişi yapsa bile yalnızca biri hesaba bağlanır.
final class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({fa.FirebaseAuth? auth, fs.FirebaseFirestore? db})
    : _auth = auth ?? fa.FirebaseAuth.instance,
      _db = db ?? fs.FirebaseFirestore.instance;

  final fa.FirebaseAuth _auth;
  final fs.FirebaseFirestore _db;

  /// Okul numarasından Firebase Auth e-postası.
  static String studentEmail(String studentNumber) =>
      '$studentNumber@ogrenci.sarkisla.edu.tr';

  Future<Result<AppUser>> _signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      final doc = await _db.collection('users').doc(uid).get();
      final data = doc.data();
      if (data == null) {
        await _auth.signOut();
        return const Err(AuthFailure('Kullanıcı profili bulunamadı.'));
      }
      return Ok(AppUser.fromJson(uid, data));
    } on fa.FirebaseAuthException catch (e) {
      return Err(
        AuthFailure(switch (e.code) {
          'invalid-credential' ||
          'wrong-password' ||
          'user-not-found' => 'E-posta/numara veya şifre hatalı.',
          'too-many-requests' => 'Çok fazla deneme. Lütfen biraz bekleyin.',
          'network-request-failed' => 'İnternet bağlantısı yok.',
          _ => 'Giriş yapılamadı (${e.code}).',
        }, cause: e),
      );
    }
  }

  @override
  Future<Result<Instructor>> signInInstructor({
    required String email,
    required String password,
  }) async {
    final result = await _signIn(email.trim(), password);
    return switch (result) {
      Ok(value: final Instructor user) => Ok(user),
      Ok() => await _wrongRole(),
      Err(:final failure) => Err(failure),
    };
  }

  @override
  Future<Result<Student>> signInStudent({
    required String studentNumber,
    required String password,
    required String deviceId,
  }) async {
    final result = await _signIn(studentEmail(studentNumber.trim()), password);
    switch (result) {
      case Ok(value: final Student student):
        return await _bindDevice(student, deviceId);
      case Ok():
        return await _wrongRole();
      case Err(:final failure):
        return Err(failure);
    }
  }

  Future<Err<T>> _wrongRole<T>() async {
    await _auth.signOut();
    return const Err(AuthFailure('Bu hesap seçilen rol için tanımlı değil.'));
  }

  Future<Result<Student>> _bindDevice(Student student, String deviceId) async {
    final ref = _db.collection('users').doc(student.uid);
    final bound = await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      final current = snap.data()?['boundDeviceId'] as String?;
      if (current == null) {
        tx.update(ref, {'boundDeviceId': deviceId});
        return deviceId;
      }
      return current;
    });
    if (bound != deviceId) {
      await _auth.signOut();
      return const Err(
        AuthFailure(
          'Bu hesap başka bir cihaza bağlı. Cihaz değişikliği için bölüm '
          'sekreterliğine başvurun.',
        ),
      );
    }
    return Ok(student.copyWith(boundDeviceId: deviceId));
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
