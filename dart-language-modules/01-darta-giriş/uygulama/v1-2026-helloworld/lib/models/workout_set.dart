/// Antrenman Set Modeli
/// Bu modelde int ve double veri türleri ile set, tekrar ve ağırlık tutulur.
/// final anahtar kelimesi ile oluşturulduktan sonra değişmeyen çalışma zamanı değerleri saklanır.

import 'exercise.dart';

class WorkoutSet {
  // final: Çalışma anında bir kez atanır ve daha sonra değiştirilemez
  final String id;
  final Exercise exercise;
  
  // int türündeki değişkenler
  final int sets; // Yapılan set sayısı
  final int reps; // Set başına tekrar sayısı
  final int targetReps; // Hedeflenen tekrar sayısı
  
  // double türündeki değişkenler
  final double weight; // Kullanılan ağırlık (kg)
  final double targetWeight; // Hedef ağırlık (kg)
  
  // bool türündeki değişkenler
  final bool reachedFailure; // Tükenişe ulaşıldı mı?
  
  // Zaman damgası
  final DateTime timestamp;
  
  // Koç değerlendirmesi ve geri bildirimi
  final String evaluationNote;
  final int recommendedRestSeconds;

  const WorkoutSet({
    required this.id,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.targetReps,
    required this.weight,
    required this.targetWeight,
    required this.reachedFailure,
    required this.timestamp,
    required this.evaluationNote,
    required this.recommendedRestSeconds,
  });

  /// Hacim (Tonaj) Hesabı: Set × Tekrar × Ağırlık (double)
  double get totalVolume {
    final double volume = sets * reps * weight;
    return volume;
  }

  /// Epley Formülü ile Tahmini 1RM (Tek Tekrar Maksimumu) (double)
  double get estimatedOneRepMax {
    if (reps == 1) {
      return weight;
    }
    // Formül: Ağırlık × (1 + Tekrar / 30)
    final double oneRm = weight * (1.0 + (reps / 30.0));
    return double.parse(oneRm.toStringAsFixed(1));
  }

  /// Hedefin tutturulup tutturulmadığı kontrolü (bool)
  bool get isGoalMet {
    return reps >= targetReps && weight >= targetWeight;
  }

  /// JSON Dönüşümü (Kalıcı hafıza için)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exerciseId': exercise.id,
      'exerciseName': exercise.name,
      'category': exercise.category.name,
      'primaryMuscle': exercise.primaryMuscle,
      'isCompound': exercise.isCompound,
      'sets': sets,
      'reps': reps,
      'targetReps': targetReps,
      'weight': weight,
      'targetWeight': targetWeight,
      'reachedFailure': reachedFailure,
      'timestamp': timestamp.toIso8601String(),
      'evaluationNote': evaluationNote,
      'recommendedRestSeconds': recommendedRestSeconds,
    };
  }

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    WorkoutCategory category;
    switch (json['category']) {
      case 'push':
        category = WorkoutCategory.push;
        break;
      case 'pull':
        category = WorkoutCategory.pull;
        break;
      case 'legs':
      default:
        category = WorkoutCategory.legs;
        break;
    }

    final exercise = Exercise(
      id: json['exerciseId'] as String? ?? 'custom',
      name: json['exerciseName'] as String? ?? 'Özel Egzersiz',
      category: category,
      primaryMuscle: json['primaryMuscle'] as String? ?? 'Genel',
      isCompound: json['isCompound'] as bool? ?? false,
    );

    return WorkoutSet(
      id: json['id'] as String,
      exercise: exercise,
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num).toInt(),
      targetReps: (json['targetReps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      reachedFailure: json['reachedFailure'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp'] as String),
      evaluationNote: json['evaluationNote'] as String? ?? '',
      recommendedRestSeconds: (json['recommendedRestSeconds'] as num?)?.toInt() ?? 90,
    );
  }
}
