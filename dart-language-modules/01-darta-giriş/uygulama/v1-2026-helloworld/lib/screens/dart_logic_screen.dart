import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../theme/app_theme.dart';

class DartLogicScreen extends StatelessWidget {
  const DartLogicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dart Programlama Mimarisi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Giriş Bilgisi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined, size: 28, color: Color(0xFF38BDF8)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PPL Hacim Hesaplayıcısı & Dart Mantığı',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bu uygulama, spor bilimi formüllerini Dart dilinin temel veri türleri (int, double), sabit yapıları (const, final) ve mantıksal karar mekanizmaları (if/else) üzerine inşa eder.',
                          style: TextStyle(fontSize: 12, height: 1.4, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // 1. KONSEPT: int ve double Veri Tipleri
            _buildConceptCard(
              title: '1. int ve double Veri Türleri',
              subtitle: 'Sayısal verilerin ayrımı ve tonaj hesabı',
              icon: Icons.numbers,
              iconColor: const Color(0xFF38BDF8),
              description:
                  'Tam sayı sayımları için int (set, tekrar, dinlenme süresi), ondalık hassasiyet gerektiren '
                  'ölçümler için double (ağırlık kg, toplam tonaj, 1RM tahmini) kullanılır.',
              codeSnippet: '''
// int: Tam sayı değerler
int sets = 3;               // Yapılan set
int reps = 10;              // Tekrar sayısı
int targetReps = 10;        // Hedeflenen tekrar
int restSeconds = 90;       // Dinlenme süresi (sn)

// double: Ondalıklı değerler
double weight = 72.5;       // Ağırlık (kg)
double targetWeight = 75.0; // Hedef ağırlık (kg)

// Hacim (Tonaj) Formülü:
// int * int * double çarpımı otomatik double üretir
double totalVolume = sets * reps * weight; // 2175.0 kg
''',
            ),
            const SizedBox(height: 16),

            // 2. KONSEPT: final ve const Yapıları
            _buildConceptCard(
              title: '2. const ve final Sabitleri',
              subtitle: 'Değiştirilemez kurallar ve çalışma zamanı değerleri',
              icon: Icons.lock_outline,
              iconColor: const Color(0xFFF97316),
              description:
                  'const: Derleme anında (compile-time) sabit, evrensel antrenman prensipleri ve dinlenme standartları.\n'
                  'final: Çalışma anında (runtime) bir kez hesaplanan ve bir daha değiştirilemeyen anlık kayıtlar.',
              codeSnippet: '''
// const: Derleme zamanı antrenman prensipleri (Asla değişmez)
class TrainingPrinciples {
  static const int defaultRestPushPull = 90;
  static const int defaultRestLegs = 120;
  static const int failureBonusRestSeconds = 30;
  static const double progressiveOverloadStepKg = 2.5;
  static const String principleOverload = 
      "Aşırı Yüklenme: Hacim zamanla planlı artırılmalıdır.";
}

// final: Çalışma anında hesaplanan tek seferlik sabitler
final double sessionVolume = sets * reps * weight;
final DateTime recordedAt = DateTime.now();
final double estimated1RM = weight * (1.0 + (reps / 30.0));
''',
            ),
            const SizedBox(height: 16),

            // 3. KONSEPT: if / else ile Tükeniş (Failure) ve Hedef Kontrolü
            _buildConceptCard(
              title: '3. if / else Karar Blokları',
              subtitle: 'Tükeniş analizi ve hedef tutturma mantığı',
              icon: Icons.alt_route,
              iconColor: const Color(0xFF10B981),
              description:
                  'Antrenman sonucunu analiz eden akıllı koç mantığı if/else ve if/else if blokları ile kurulur.',
              codeSnippet: '''
// 1. Tükeniş (Failure) ve Dinlenme Mantığı:
int restTime = baseRest;
if (reachedFailure == true) {
  // Tükenişe gidildiyse sinir sistemi toparlanması için ek süre
  restTime += TrainingPrinciples.failureBonusRestSeconds;
  print("Tükenişe ulaşıldı! Dinlenme +30 sn uzatıldı.");
} else {
  print("Tükenişe gidilmedi, toparlanma hızlı kalacak.");
}

// 2. Hedef Başarı ve Progressive Overload Mantığı:
if (reps >= targetReps && weight >= targetWeight) {
  print("Hedef tamamlandı! Sonraki antrenman ağırlığı +2.5 kg artır.");
} else if (reps >= targetReps && weight < targetWeight) {
  print("Tekrar tamamlandı, ağırlığı hedef seviyeye çıkarın.");
} else {
  print("Hedefin gerisinde kalındı. Aynı ağırlıkla devam edin.");
}
''',
            ),
            const SizedBox(height: 16),

            // 4. PPL Prensip Sözlüğü
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Uygulamadaki Değiştirilemez Prensipler (const)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildPrincipleRow('Aşırı Yüklenme', TrainingPrinciples.principleOverload),
                  const SizedBox(height: 8),
                  _buildPrincipleRow('Tükeniş (Failure)', TrainingPrinciples.principleFailure),
                  const SizedBox(height: 8),
                  _buildPrincipleRow('Bileşik Dinlenme', TrainingPrinciples.principleRestCompound),
                  const SizedBox(height: 8),
                  _buildPrincipleRow('İzolasyon Dinlenme', TrainingPrinciples.principleRestIsolation),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required String description,
    required String codeSnippet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                      Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFFCBD5E1)),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              codeSnippet.trim(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                color: Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrincipleRow(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title:',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8)),
        ),
        const SizedBox(height: 2),
        Text(
          content,
          style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.3),
        ),
      ],
    );
  }
}
