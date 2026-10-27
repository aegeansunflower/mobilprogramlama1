/// Antrenman (Push-Pull-Legs) Hacim Hesaplayıcısı Mantık Motoru
/// 
/// Bu dosya Dart dilinin temel taşlarını içerir:
/// 1. int ve double türündeki sayısal değişkenler
/// 2. const ile tanımlanan değiştirilemez antrenman prensipleri ve dinlenme süreleri
/// 3. final ile tanımlanan çalışma anı hesaplamaları
/// 4. if / else blokları ile tükeniş (failure) ve hedef tutturma mantığı

import '../models/exercise.dart';

/// Hesaplama ve Koç Analiz Sonucu Modeli
class WorkoutEvaluation {
  final double totalVolume; // double: Set × Tekrar × Ağırlık
  final double estimatedOneRepMax; // double: Epley formülü 1RM
  final int recommendedRestSeconds; // int: Saniye cinsinden dinlenme
  final bool isGoalMet; // bool: Hedef tekrar & ağırlık tuttu mu?
  final bool reachedFailure; // bool: Tükenişe gidildi mi?
  final String statusTitle; // Başlık (örn: "MÜKEMMEL PERFORMANS")
  final String goalFeedback; // Hedef değerlendirmesi
  final String failureFeedback; // Tükeniş analizi
  final String progressiveOverloadAdvice; // Gelecek antrenman önerisi
  final String volumeTier; // Düşük / Orta / Yüksek Hacim
  final String dartCodeSnippet; // Bu sonucu üreten Dart kodu özeti

  const WorkoutEvaluation({
    required this.totalVolume,
    required this.estimatedOneRepMax,
    required this.recommendedRestSeconds,
    required this.isGoalMet,
    required this.reachedFailure,
    required this.statusTitle,
    required this.goalFeedback,
    required this.failureFeedback,
    required this.progressiveOverloadAdvice,
    required this.volumeTier,
    required this.dartCodeSnippet,
  });
}

class WorkoutCalculator {
  /// Antrenman hacmini ve performansını hesaplayan ana fonksiyon
  /// int: sets, reps, targetReps
  /// double: weight, targetWeight
  /// bool: reachedFailure
  static WorkoutEvaluation calculate({
    required Exercise exercise,
    required int sets,
    required int reps,
    required int targetReps,
    required double weight,
    required double targetWeight,
    required bool reachedFailure,
  }) {
    // 1. TEMEL HACİM HESAPLAMASI (double)
    // final: Değer bir kez hesaplanır ve bu fonksiyonda asla yeniden atanamaz.
    final double totalVolume = sets * reps * weight;

    // 2. 1RM (TEK TEKRAR MAKSİMUMU) TAHMİNİ (double)
    final double estimatedOneRepMax;
    if (reps == 1) {
      estimatedOneRepMax = weight;
    } else {
      // Epley Formülü: Ağırlık × (1 + Tekrar / 30.0)
      final double calculated1RM = weight * (1.0 + (reps / 30.0));
      estimatedOneRepMax = double.parse(calculated1RM.toStringAsFixed(1));
    }

    // 3. DİNLENME SÜRESİ HESAPLAMASI (int ve const kullanımı)
    // if / else if / else ile egzersiz kategorisine göre taban dinlenme belirlenir:
    int baseRestSeconds;
    if (exercise.category == WorkoutCategory.legs) {
      // Bacak antrenmanları büyük kas kütlesi içerdiği için daha uzun dinlenme gerektirir
      baseRestSeconds = TrainingPrinciples.defaultRestLegs; // const int: 120 sn
    } else if (exercise.isCompound) {
      // Bench Press, Barbell Row gibi bileşik itiş/çekiş egzersizleri
      baseRestSeconds = TrainingPrinciples.defaultRestPushPull; // const int: 90 sn
    } else {
      // Lateral raise, Biceps curl gibi izolasyon hareketleri
      baseRestSeconds = 60; // 60 saniye
    }

    // 4. TÜKENİŞ (FAILURE) KONTROLÜ (if / else)
    int calculatedRestSeconds = baseRestSeconds;
    String failureFeedback;
    if (reachedFailure) {
      // Tükenişe ulaşıldıysa merkezi sinir sisteminin toparlanması için ek dinlenme verilir
      calculatedRestSeconds += TrainingPrinciples.failureBonusRestSeconds; // +30 saniye
      failureFeedback =
          'Tükenişe (RIR 0) ulaşıldı! Maksimum mekanik gerilim sağlandı. Toparlanma için dinlenme süresi '
          '+${TrainingPrinciples.failureBonusRestSeconds} sn artırılarak $calculatedRestSeconds sn olarak güncellendi. '
          'Bir sonraki sette aşırı yorgunluğu önlemek için ağırlığı %5-10 azaltmayı (back-off seti) düşünebilirsiniz.';
    } else {
      failureFeedback =
          'Tükenişe gidilmedi (Rezervde tekrar bırakıldı / RIR 1-2). '
          'Bu yöntem hacim biriktirmek ve sakatlık riskini minimumda tutmak için idealdir. '
          'Önerilen dinlenme süresi: $calculatedRestSeconds sn.';
    }

    // 5. HEDEF TUTTURULDU MU KONTROLÜ (if / else if / else)
    bool isGoalMet = false;
    String statusTitle;
    String goalFeedback;
    String progressiveOverloadAdvice;

    if (reps >= targetReps && weight >= targetWeight) {
      // Hedef tekrar ve ağırlık tam tuttu veya aşıldı!
      isGoalMet = true;
      statusTitle = 'HEDEF BAŞARIYLA TAMAMLANDI! 🔥';
      goalFeedback =
          'Tebrikler! Hem hedef tekrarı ($reps/$targetReps) hem de hedef ağırlığı '
          '($weight kg / $targetWeight kg) eksiksiz tamamladınız.';
      
      // Progressive Overload önerisi: Bir sonraki seans ağırlığı artır
      final double nextWeight = weight + TrainingPrinciples.progressiveOverloadStepKg;
      progressiveOverloadAdvice =
          'Aşırı Yüklenme (Progressive Overload) Kuralı: Bir sonraki antrenmanda '
          'ağırlığı $nextWeight kg (+${TrainingPrinciples.progressiveOverloadStepKg} kg) yapmayı deneyin.';
    } else if (reps >= targetReps && weight < targetWeight) {
      // Tekrar sayısı tamam ama ağırlık hedefin altında
      isGoalMet = false;
      statusTitle = 'TEKRAR TAMAM, AĞIRLIK ARTIRILABİLİR ⚡';
      goalFeedback =
          'Hedef tekrara ulaştınız ($reps/$targetReps), ancak ağırlık hedefin ($targetWeight kg) gerisinde kaldı.';
      progressiveOverloadAdvice =
          'Bir sonraki sette tekrarı koruyarak ağırlığı $targetWeight kg seviyesine çıkarmayı hedefleyin.';
    } else if (reps < targetReps && weight >= targetWeight) {
      // Ağırlık iyi ama hedeflenen tekrar çıkmadı
      isGoalMet = false;
      final int missingReps = targetReps - reps;
      statusTitle = 'HEDEFİN $missingReps TEKRAR GERİSİNDE KALINDI ⚠️';
      goalFeedback =
          'Ağırlık hedefi sağlandı ancak hedeflenen tekrara ($reps/$targetReps) ulaşılamadı.';
      progressiveOverloadAdvice =
          'Ağırlığı artırmayın! Bu ağırlıkta ($weight kg) kalarak önce $targetReps tekrar hedefini tutturmaya çalışın.';
    } else {
      // Hem tekrar hem ağırlık hedefin altında
      isGoalMet = false;
      statusTitle = 'HEDEF TUTTURULAMADI 📉';
      goalFeedback =
          'Hem tekrar sayısı ($reps/$targetReps) hem de ağırlık ($weight/$targetWeight kg) hedefin altında kaldı.';
      progressiveOverloadAdvice =
          'Toparlanma, uyku ve beslenmenizi gözden geçirin. Formu bozmadan kontrollü tekrarlarla devam edin.';
    }

    // 6. HACİM KADEMESİ DEĞERLENDİRMESİ (if / else if / else)
    String volumeTier;
    if (totalVolume >= 4000.0) {
      volumeTier = 'Ağır / Yüksek Hacim (Hipertrofi + Dayanıklılık)';
    } else if (totalVolume >= 1500.0) {
      volumeTier = 'Optimal Hacim (Kas Gelişimi İçin İdeal Bölge)';
    } else {
      volumeTier = 'Düşük / Başlangıç Hacmi (Isınma veya Giriş Seviyesi)';
    }

    // 7. Dart Kod Özeti (Kullanıcının mantığı görmesi için)
    final String dartCodeSnippet = '''
// Dart Mantığı Özeti:
int sets = $sets;
int reps = $reps;
double weight = $weight;
final double totalVolume = sets * reps * weight; // $totalVolume kg

const int baseRest = ${exercise.category == WorkoutCategory.legs ? "TrainingPrinciples.defaultRestLegs" : "TrainingPrinciples.defaultRestPushPull"};
if (reachedFailure == true) {
  // Tükenişe ulaşıldı: dinlenme süresini artır
  restTime = baseRest + TrainingPrinciples.failureBonusRestSeconds; // $calculatedRestSeconds sn
}

if (reps >= targetReps && weight >= targetWeight) {
  // Hedef tutturuldu: Progressive overload uygula
  nextWeight = weight + TrainingPrinciples.progressiveOverloadStepKg; // +${TrainingPrinciples.progressiveOverloadStepKg} kg
}
''';

    return WorkoutEvaluation(
      totalVolume: totalVolume,
      estimatedOneRepMax: estimatedOneRepMax,
      recommendedRestSeconds: calculatedRestSeconds,
      isGoalMet: isGoalMet,
      reachedFailure: reachedFailure,
      statusTitle: statusTitle,
      goalFeedback: goalFeedback,
      failureFeedback: failureFeedback,
      progressiveOverloadAdvice: progressiveOverloadAdvice,
      volumeTier: volumeTier,
      dartCodeSnippet: dartCodeSnippet,
    );
  }
}
