/// PPL (Push - Pull - Legs) Antrenman Egzersiz Modeli ve Sabit Prensipleri
/// Bu dosyada Dart dilinin 'const' anahtar kelimesi ile değiştirilemez prensipleri,
/// egzersiz tanımları ve kategorileri yer alır.

enum WorkoutCategory {
  push, // İtiş (Göğüs, Ön/Yan Omuz, Triceps)
  pull, // Çekiş (Sırt, Arka Omuz, Biceps)
  legs, // Bacak (Ön Bacak, Arka Bacak, Kalça, Kalf)
}

class Exercise {
  final String id;
  final String name;
  final WorkoutCategory category;
  final String primaryMuscle;
  final bool isCompound; // Bileşik egzersiz mi (Squat, Bench) yoksa izolasyon mu (Curl, Fly)

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.primaryMuscle,
    this.isCompound = false,
  });

  String get categoryName {
    switch (category) {
      case WorkoutCategory.push:
        return 'Push (İtiş)';
      case WorkoutCategory.pull:
        return 'Pull (Çekiş)';
      case WorkoutCategory.legs:
        return 'Legs (Bacak)';
    }
  }
}

/// Değiştirilemez Antrenman Prensipleri (const)
class TrainingPrinciples {
  // const: Derleme zamanında (compile-time) belirlenen ve asla değişmeyen sabitler
  static const String principleOverload =
      'Aşırı Yüklenme (Progressive Overload): Kas gelişimi için antrenman hacmi (set × tekrar × ağırlık) zamanla planlı olarak artırılmalıdır.';

  static const String principleFailure =
      'Tükeniş (Failure) Prensibi: Son tekrarda formu bozmadan ağırlığı hareket ettirememek kas liflerini tam uyarır. Ancak toparlanma maliyeti yüksek olduğu için kontrollü uygulanmalıdır.';

  static const String principleRestCompound =
      'Bileşik Egzersiz Dinlenmesi: Squat, Bench Press, Deadlift gibi büyük hareketlerde en az 120-180 saniye dinlenilmelidir.';

  static const String principleRestIsolation =
      'İzolasyon Dinlenmesi: Lateral Raise, Biceps Curl gibi küçük kas grubu hareketlerinde 60-90 saniye dinlenme yeterlidir.';

  // Sabit Dinlenme Süreleri (saniye cinsinden int)
  static const int defaultRestPushPull = 90; // İtiş ve çekiş standart dinlenme
  static const int defaultRestLegs = 120; // Bacak için standart dinlenme
  static const int failureBonusRestSeconds = 30; // Tükenişe ulaşıldığında eklenen dinlenme

  // Sabit Hacim Eşikleri (double)
  static const double progressiveOverloadStepKg = 2.5; // Önerilen ağırlık artışı (kg)
  static const double minRecommendedReps = 6.0; // Hipertrofi alt sınır
  static const double maxRecommendedReps = 12.0; // Hipertrofi üst sınır
}

/// Hazır PPL Egzersiz Veritabanı
const List<Exercise> defaultExercises = [
  // PUSH (İtiş)
  Exercise(
    id: 'bench_press',
    name: 'Barbell Bench Press',
    category: WorkoutCategory.push,
    primaryMuscle: 'Göğüs (Pectoralis)',
    isCompound: true,
  ),
  Exercise(
    id: 'overhead_press',
    name: 'Overhead Press (OHP)',
    category: WorkoutCategory.push,
    primaryMuscle: 'Omuz (Deltoid)',
    isCompound: true,
  ),
  Exercise(
    id: 'incline_dumbbell_press',
    name: 'Incline Dumbbell Press',
    category: WorkoutCategory.push,
    primaryMuscle: 'Üst Göğüs',
    isCompound: true,
  ),
  Exercise(
    id: 'dips',
    name: 'Chest / Triceps Dips',
    category: WorkoutCategory.push,
    primaryMuscle: 'Göğüs & Triceps',
    isCompound: true,
  ),
  Exercise(
    id: 'lateral_raise',
    name: 'Dumbbell Lateral Raise',
    category: WorkoutCategory.push,
    primaryMuscle: 'Yan Omuz',
    isCompound: false,
  ),
  Exercise(
    id: 'triceps_pushdown',
    name: 'Triceps Cable Pushdown',
    category: WorkoutCategory.push,
    primaryMuscle: 'Arka Kol (Triceps)',
    isCompound: false,
  ),

  // PULL (Çekiş)
  Exercise(
    id: 'deadlift',
    name: 'Conventional Deadlift',
    category: WorkoutCategory.pull,
    primaryMuscle: 'Tüm Arka Zincir & Sırt',
    isCompound: true,
  ),
  Exercise(
    id: 'barbell_row',
    name: 'Barbell Bent-Over Row',
    category: WorkoutCategory.pull,
    primaryMuscle: 'Kanat & Sırt (Latissimus)',
    isCompound: true,
  ),
  Exercise(
    id: 'pull_up',
    name: 'Pull-Up (Barfiks)',
    category: WorkoutCategory.pull,
    primaryMuscle: 'Kanat & Biceps',
    isCompound: true,
  ),
  Exercise(
    id: 'lat_pulldown',
    name: 'Lat Pulldown',
    category: WorkoutCategory.pull,
    primaryMuscle: 'Kanat',
    isCompound: false,
  ),
  Exercise(
    id: 'face_pull',
    name: 'Rope Face Pull',
    category: WorkoutCategory.pull,
    primaryMuscle: 'Arka Omuz & Trapez',
    isCompound: false,
  ),
  Exercise(
    id: 'biceps_curl',
    name: 'Barbell / DB Biceps Curl',
    category: WorkoutCategory.pull,
    primaryMuscle: 'Ön Kol (Biceps)',
    isCompound: false,
  ),

  // LEGS (Bacak)
  Exercise(
    id: 'barbell_squat',
    name: 'Barbell Back Squat',
    category: WorkoutCategory.legs,
    primaryMuscle: 'Ön Bacak & Kalça (Quad/Glute)',
    isCompound: true,
  ),
  Exercise(
    id: 'romanian_deadlift',
    name: 'Romanian Deadlift (RDL)',
    category: WorkoutCategory.legs,
    primaryMuscle: 'Arka Bacak & Kalça (Hamstrings)',
    isCompound: true,
  ),
  Exercise(
    id: 'leg_press',
    name: 'Leg Press',
    category: WorkoutCategory.legs,
    primaryMuscle: 'Ön Bacak (Quadriceps)',
    isCompound: true,
  ),
  Exercise(
    id: 'leg_extension',
    name: 'Leg Extension',
    category: WorkoutCategory.legs,
    primaryMuscle: 'Ön Bacak İzolasyon',
    isCompound: false,
  ),
  Exercise(
    id: 'leg_curl',
    name: 'Lying Leg Curl',
    category: WorkoutCategory.legs,
    primaryMuscle: 'Arka Bacak (Hamstrings)',
    isCompound: false,
  ),
  Exercise(
    id: 'calf_raise',
    name: 'Standing Calf Raise',
    category: WorkoutCategory.legs,
    primaryMuscle: 'Baldır (Calf)',
    isCompound: false,
  ),
];
