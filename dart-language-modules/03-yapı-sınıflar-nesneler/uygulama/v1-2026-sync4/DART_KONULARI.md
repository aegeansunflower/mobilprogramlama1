# Dart Konuları — Projede Nerede Kullanıldı?

Bu belge, Dart dokümantasyonunun 4 ana başlığının projede **hangi dosyada**
ve **hangi gerçek ihtiyaç için** kullanıldığını gösterir. Her kaynak dosyanın
ilk satırında `// DART KONUSU: ...` yorumu vardır.

Kontrol komutları: `flutter analyze` (sıfır uyarı) · `flutter test` (86 test) ·
`dart run tool/check_annotations.dart`

---

## 1. Metadata (Meta veriler)

| Kullanım | Dosya | Neden |
|---|---|---|
| `pubspec.yaml` meta alanları (`name`, `description`, `version`, `environment`, `homepage`, `repository`, `issue_tracker`, `topics`) | `pubspec.yaml` | Paket kimliği ve SDK kısıtları |
| Kütüphane dokümantasyonu (`/// …` + `library;`) | Tüm `lib/**/*.dart` | Her kütüphanenin amacı, `dart doc` çıktısı |
| **Özel annotation** `@OnChainRecord(type:, schemaVersion:)` + `@Target({TargetKind.classType})` | `lib/core/annotations/on_chain_record.dart` | Zincire yazılan modelleri işaretler |
| ↳ kullanımı | `attendance/domain/attendance_record.dart`, `correction_record.dart` | |
| **Özel annotation** `@RoleRestricted(Role.instructor)` + `RoleGuard` | `lib/core/annotations/role_restricted.dart` | Yalnızca görevlinin çağırabileceği metotlar |
| ↳ kullanımı | `Blockchain.append/seal`, `BlockchainRepository.appendBlock`, `AttendanceRepository.startSession/publishNonce/closeSession`, `EndSession`, `CorrectAttendance` | |
| Annotation'ları gerçekten **denetleyen araç** | `tool/check_annotations.dart` (+ `test/tool/`) | Flutter'da yansıma olmadığı için sözleşme kaynak kod üzerinden denetlenir. İlk çalıştırmada iki depo metodunda **eksik rol denetimini yakalamıştır**. |
| `@immutable` | `Hash`, `Block`, `MerkleTree`, `ChainReceipt`, `AttendanceStatus`, `Course`, `AttendanceSession`, `AppUser`, `AuthState`, `Result`, `Failure`, `AppPalette` | Değer nesneleri; alt sınıfların da değişmez olması zorunlu |
| `@protected` + `@mustCallSuper` | `BlockBase.header()` (`blockchain/domain/block_base.dart`) | Alt sınıf başlığa alan ekleyebilir ama ana alanları silemez |
| `@visibleForTesting` | `Block.copyWith` (kurcalama testleri), `Ed25519Signer.fromSeed` | Yalnızca testlerde kullanılması gereken API'ler |
| `@Deprecated('…')` | `QrToken.decodeLegacyV1` (`attendance/domain/qr_token.dart`) | İmzasız eski QR biçimi; testte bilinçli çağrılır |
| `@override` | Tüm alt sınıflar | |
| Paket annotation'ları: `@JsonSerializable`, `@JsonKey`, `@DriftDatabase`, `@DataClassName`, `JsonConverter` sınıfları (`@StatusConverter()`) | `attendance_record.dart`, `correction_record.dart`, `json_converters.dart`, `chain_database.dart` | Kod üretimi |

## 2. Libraries & imports (Kütüphaneler ve içe aktarma)

| Kullanım | Dosya | Neden |
|---|---|---|
| **Katmanlı yapı**: `core`, `blockchain`, `auth`, `attendance`, `ui` (+ `app`) | `lib/` | Clean Architecture |
| **Barrel dosyaları** (`export`) | `core/core.dart`, `blockchain/blockchain.dart`, `auth/auth.dart`, `attendance/attendance.dart`, `ui/ui.dart` | Katman dışına tek giriş noktası |
| `export … show` | `core/core.dart` (`canonicalJson`, `canonicalBytes`), `blockchain/blockchain.dart` (yalnızca `ChainDatabase`) | Drift tablo sınıfı ve iç yardımcılar dışarı sızmaz |
| `export … hide` | `core/core.dart` → `hide EpochMillisX` | Ham `int` extension'ı yalnızca blok kodlayıcıda kullanılır (`block.dart` doğrudan import eder) |
| `import … as` (**isim çakışması**) | `package:crypto as crypto` (`Hash` çakışması: `core/crypto/hash.dart`), `cryptography as cg` (`Hash`, `Signature`: `signing.dart`), `web3dart as w3` (`Block`, `Transaction`), `cloud_firestore as fs`, `firebase_auth as fa` (`User`), `pdf/widgets as pw` (`Text`, `Table`), `dart:math as math` | |
| `import … show` | Neredeyse her dosya (`dart:convert show utf8`, `go_router show CustomTransitionPage`, `mobile_scanner show …`) | Yalnızca gerekenler |
| `import … hide` | `local_first_blockchain_repository.dart` → `chain_database.dart hide StoredBlocks` | Tablo tanımı yerine yalnızca veri sınıfı |
| **`deferred as`** (tembel yükleme) | `lib/app/router.dart`: `scanner_page.dart deferred as scanner`, `report_page.dart deferred as reports` + `DeferredPage` (`loadLibrary()`) | Kamera tarayıcısı ve grafik/PDF modülü yalnızca açıldığında yüklenir |
| **Koşullu export** (`if (dart.library.js_interop)`) | `lib/app/demo_database.dart` → `demo_database_native.dart` / `demo_database_web.dart` | Aynı kod mobilde `dart:ffi` SQLite'ı, tarayıcıda WebAssembly SQLite'ı kullanır |
| **`part` / `part of`** (elle bölünmüş) | `blockchain/domain/block.dart` ↔ `block_codec.dart` | JSON kodlayıcı ayrı dosyada; `Block._restored` gibi private üyelere erişir |
| **`part`** (kod üretimi) | `attendance_record.g.dart`, `correction_record.g.dart` (json_serializable), `chain_database.g.dart` (drift) | |
| **Kütüphane düzeyinde gizlilik** (`_`) | `canonical_json.dart` → `_sorted`, `Block._restored`, `Hash._`, `MerkleTree._leaf/_node`, `_Blob`, `_RoleCard`… | `_` ile başlayan üyeler kütüphane dışından görünmez |
| `library;` yönergesi + doküman | Tüm dosyalar | |

## 3. Classes & objects (Sınıflar ve nesneler)

| Kavram | Örnek | Dosya |
|---|---|---|
| Generative constructor | `Block({required super.index, …})` | `blockchain/domain/block.dart` |
| Named constructor | `Block._restored`, `Hash.fromHex`, `MerkleTree.fromRecords` | `block.dart`, `hash.dart`, `merkle_tree.dart` |
| `const` constructor | `Hash.zero`, `Present()`, `OnChainRecord`, `Course`, `Clock()`, tüm `Failure`'lar | |
| Factory constructor | `Block.genesis()`, `Block.fromJson()`, `AttendanceRecord.fromJson()`, `AttendanceStatus.fromJson()`, `AppUser.fromJson()`, `CourseReport.build()`, `AppPalette.of()` | |
| **Redirecting** constructor | `Block.next(previous, …) : this(...)` (generative); `const factory Result.ok(T) = Ok<T>` (factory) | `block.dart`, `result.dart` |
| Initializer list | `Block(...) : transactions = List.unmodifiable(...), merkleRoot = MerkleTree.fromRecords(...).root`; `BlockBase(...) : assert(...)`; `Course(...) : assert(...)` | |
| `super` parametreleri | `Block({required super.index, …})`, `AuthFailure(super.message, {super.cause})`, `MerkleMismatch(super.blockIndex, …)` | |
| Private named initializing formals | `LocalFirstBlockchainRepository({required this._database, …})` | |
| `final` alanlar, `late final` | `Block._computedHash` (tembel hash), `SuccessCheck._controller` | |
| Getter / setter | `Block.hash`, `AttendanceSummary.rate/isNearLimit`, `Hash.short`, `FixedClock.current` | |
| Static üyeler | `Hash.zero`, `Block.genesisTime`, `QrToken.refreshInterval`, `Role.tryParse`, `Department.fromCode` | |
| `operator ==` / `hashCode` | `Hash`, `Block`, `Ok/Err`, `AttendanceStatus` (kanonik JSON ile), `Course`, `ChainReceipt`, `AppUser` | |
| Kalıtım / `extends` / `super` | `Block extends BlockBase`, `AttendanceRecord extends Record`, `Failure` alt türleri | |
| **Mixin** | `Hashable` (içerik hash'i), `Timestamped` (tazelik), `EventEmitter` (olay), `Signed` (imza doğrulama) | `core/crypto/hashable.dart`, `core/mixins/`, `block_base.dart` |
| `on` kısıtlı mixin | `base mixin Signed on BlockBase` | `block_base.dart` |
| **Extension methods** | `DateTimeX.isWithin/trDateTime`, `StringX.sha256Hex/shortened/isValidStudentNumber`, `BytesX.toHex`, `AttendanceLedgerX.summaryFor/effectiveFor` (`Iterable<Record>` üzerine), `StatusPresentation`, `EntranceX.enter()` (`Widget` üzerine) | `core/extensions/`, `attendance_ledger.dart`, `ui/` |
| **Generics** | `Blockchain<T extends Record>`, `Block<T extends Record>`, `BlockchainRepository<T>`, `Result<T>`, `RecordDecoder<T>`, `AsyncValueView<T>`, `ThemeExtension<AppPalette>` | |
| `toString` | `Block`, `Hash`, `Result`, `Failure`, `ChainBroken`, `AttendanceRecord`… | |
| `copyWith` | `Block.copyWith`, `AttendanceRecord.copyWith`, `AttendanceSession.copyWith`, `Student.copyWith`, `AppPalette.copyWith`, `LiveQrState.copyWith` | |
| **Callable class** (`call`) | `ChainValidator`, `QrTokenValidator`, `CheckIn`, `EndSession`, `CorrectAttendance`, `Clock` | `validator(blocks)`, `checkIn(rawQr: …)` |
| Enhanced enum | `Role`, `Department`, `Backend` | `core/constants/` |
| Records ve pattern matching | `({Block<T> block, T record})`, `EndSessionSummary`, `SessionTally`, `switch` desenleri | |

## 4. Class modifiers (Sınıf değiştiricileri)

Her kullanımın yanında, neden o değiştiricinin seçildiği koda yorum olarak yazılmıştır.

| Değiştirici | Sınıf(lar) | Neden |
|---|---|---|
| `abstract class` | `Record` | Ortak davranış (`recordHash`, `envelope`) ve sözleşme (`toJson`) bir arada; doğrudan örneklenemez |
| `interface class` | `Clock` | Somut ve örneklenebilir (`const Clock()`); başka kütüphaneler yalnızca `implements` edebilir (`FixedClock`), `extends` edemez |
| `abstract interface class` | `BlockchainRepository`, `AttendanceRepository`, `AuthRepository`, `BlockSigner`, `SignatureVerifier`, `ConsensusStrategy`, `AuthorityDirectory`, `RemoteChainSource`, `KeyValueStore`, `BiometricAuthenticator`, `DeviceIdentity`, `LocationProvider` | Saf sözleşmeler; ortak kod yok |
| `base class` (`abstract base`) | `BlockBase` | Dışarıdan `implements` edilemez, hash mantığı atlanamaz; yalnızca `extends`. Alt sınıflar `base`/`final`/`sealed` olmak zorunda |
| `final class` | `Block`, `Hash`, `MerkleTree`, `ProofOfAuthority`, `Ed25519Signer`, `Blockchain`, `ChainValidator`, `AttendanceRecord`, `Course`, tüm widget'lar… | Genişletilemez; güvenlik açısından kritik kurallar delinemez |
| `sealed class` | `AttendanceStatus` (Present, Late, Absent, Excused), `AuthState` (SignedOut, Authenticating, AwaitingBiometric, SignedIn, AuthError), `Result<T>` (Ok, Err), `Failure`, `ChainValidation` → `sealed ChainBroken` (iç içe), `AppUser` (Instructor, Student) | Kapalı hiyerarşi; `switch` derleyici tarafından **eksiksiz** denetlenir (ör. `chain_page.dart`, `status.dart`, `router.dart`, testlerdeki `switch`'ler) |
| `mixin class` | `EventEmitter<E>` | Hem `Blockchain with EventEmitter<Block>` (mixin) hem `EventEmitter<String>()` (tek başına sınıf, `test/core/result_test.dart`) olarak kullanılır |
| `abstract mixin class` | `Hashable`, `Timestamped` | Soyut üye (`hashPayload`, `timestamp`) + ortak davranış; hem `with` hem `extends` ile kullanılabilir |
| `base mixin` | `Signed on BlockBase` | `base` bir sınıfa (`on BlockBase`) bağlı mixin'in `base` olması zorunlu |
| `abstract final class` | `DemoSeed`, `Space`, `Radii`, `Sizes`, `MotionDurations`, `Motion`, `AppTheme`, `RoleGuard`, `DemoActions` | Yalnızca static üyeler taşıyan ad alanları; örneklenemez, türetilemez |

> **Not — `final mixin`:** Görev tanımında geçen `final mixin`, Dart'ta geçerli
> bir bildirim değildir. Mixin'lere yalnızca `base` değiştiricisi
> uygulanabilir. Bu yüzden projede `base mixin` (`Signed`) ve
> `abstract final class` birleşimi kullanıldı.
>
> **Not — `interface class AttendanceRepository`:** Düz `interface class`
> içindeki her metodun gövdesi olmalıdır. Bir depo sözleşmesi için bu uygun
> değildir; bu yüzden `AttendanceRepository` `abstract interface class` yapıldı.
> Düz `interface class` örneği olarak somut `Clock` sınıfı seçildi.
