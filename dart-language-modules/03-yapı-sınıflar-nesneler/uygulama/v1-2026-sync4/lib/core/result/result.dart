// DART KONUSU: Class modifiers — `sealed class Result<T>`; Classes & objects —
// generics, redirecting factory constructor, const constructor, getter.

/// Hata yönetimi için `Result<T>` tipi.
library;

import 'package:meta/meta.dart';
import 'package:sarkisla_yoklama/core/errors/failure.dart';

/// Başarılı bir değer ([Ok]) ya da bir [Failure] ([Err]) taşır.
///
/// `sealed` olduğu için `switch` ile yalnızca iki dal yazmak yeterlidir ve
/// derleyici bunu eksiksiz kabul eder:
///
/// ```dart
/// switch (result) {
///   case Ok(:final value): ...
///   case Err(:final failure): ...
/// }
/// ```
@immutable
sealed class Result<T> {
  const Result();

  /// Redirecting factory: `Result.ok(x)` aslında `Ok<T>(x)` oluşturur.
  const factory Result.ok(T value) = Ok<T>;

  /// Redirecting factory: `Result.err(f)` aslında `Err<T>(f)` oluşturur.
  const factory Result.err(Failure failure) = Err<T>;

  /// İşlem başarılı mı?
  bool get isOk => this is Ok<T>;

  /// Başarılıysa değer, değilse `null`.
  T? get valueOrNull => switch (this) {
    Ok(:final value) => value,
    Err() => null,
  };

  /// Hatalıysa hata, değilse `null`.
  Failure? get failureOrNull => switch (this) {
    Ok() => null,
    Err(:final failure) => failure,
  };

  /// İki dalı tek ifadede işler.
  R fold<R>(R Function(T value) onOk, R Function(Failure failure) onErr) =>
      switch (this) {
        Ok(:final value) => onOk(value),
        Err(:final failure) => onErr(failure),
      };

  /// Başarılı değeri dönüştürür, hatayı olduğu gibi aktarır.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok(:final value) => Ok(transform(value)),
    Err(:final failure) => Err(failure),
  };

  /// Başarılı değerden yeni bir `Result` üreten zincirleme.
  Future<Result<R>> then<R>(Future<Result<R>> Function(T value) next) =>
      switch (this) {
        Ok(:final value) => next(value),
        Err(:final failure) => Future.value(Err(failure)),
      };
}

/// Başarılı sonuç.
final class Ok<T> extends Result<T> {
  const Ok(this.value);

  /// Sonuç değeri.
  final T value;

  @override
  bool operator ==(Object other) => other is Ok<T> && other.value == value;

  @override
  int get hashCode => Object.hash(Ok, value);

  @override
  String toString() => 'Ok($value)';
}

/// Hatalı sonuç.
final class Err<T> extends Result<T> {
  const Err(this.failure);

  /// Hata ayrıntısı.
  final Failure failure;

  @override
  bool operator ==(Object other) => other is Err<T> && other.failure == failure;

  @override
  int get hashCode => Object.hash(Err, failure);

  @override
  String toString() => 'Err($failure)';
}
