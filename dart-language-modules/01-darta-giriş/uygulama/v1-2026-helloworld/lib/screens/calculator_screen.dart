import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../services/workout_calculator.dart';
import '../services/workout_storage_service.dart';
import '../widgets/rest_timer_dialog.dart';
import '../theme/app_theme.dart';

class CalculatorScreen extends StatefulWidget {
  final WorkoutStorageService storageService;

  const CalculatorScreen({
    super.key,
    required this.storageService,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  WorkoutCategory _selectedCategory = WorkoutCategory.push;
  late Exercise _selectedExercise;

  // int türündeki değişkenler
  int _sets = 3;
  int _reps = 10;
  int _targetReps = 10;

  // double türündeki değişkenler
  double _weight = 60.0;
  double _targetWeight = 60.0;

  // bool türündeki değişken
  bool _reachedFailure = false;

  bool _showCodeSnippet = false;

  @override
  void initState() {
    super.initState();
    _updateDefaultExercise();
  }

  void _updateDefaultExercise() {
    _selectedExercise = defaultExercises.firstWhere(
      (e) => e.category == _selectedCategory,
      orElse: () => defaultExercises.first,
    );
  }

  Color _getCategoryColor(WorkoutCategory category) {
    switch (category) {
      case WorkoutCategory.push:
        return AppTheme.pushColor;
      case WorkoutCategory.pull:
        return AppTheme.pullColor;
      case WorkoutCategory.legs:
        return AppTheme.legsColor;
    }
  }

  void _saveSet(WorkoutEvaluation evaluation) async {
    final set = WorkoutSet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exercise: _selectedExercise,
      sets: _sets,
      reps: _reps,
      targetReps: _targetReps,
      weight: _weight,
      targetWeight: _targetWeight,
      reachedFailure: _reachedFailure,
      timestamp: DateTime.now(),
      evaluationNote: evaluation.goalFeedback,
      recommendedRestSeconds: evaluation.recommendedRestSeconds,
    );

    await widget.storageService.addSet(set);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedExercise.name} (${set.totalVolume.toStringAsFixed(0)} kg hacim) günlüğe kaydedildi!'),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _openRestTimer(int seconds) {
    showDialog(
      context: context,
      builder: (ctx) => RestTimerDialog(
        initialSeconds: seconds,
        title: '${_selectedExercise.name} Dinlenmesi',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableExercises =
        defaultExercises.where((e) => e.category == _selectedCategory).toList();

    // final: Hesaplama anlık olarak çalıştırılır ve sonucu alınır
    final evaluation = WorkoutCalculator.calculate(
      exercise: _selectedExercise,
      sets: _sets,
      reps: _reps,
      targetReps: _targetReps,
      weight: _weight,
      targetWeight: _targetWeight,
      reachedFailure: _reachedFailure,
    );

    final catColor = _getCategoryColor(_selectedCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.fitness_center, size: 24),
            SizedBox(width: 10),
            Text('PPL Hacim Hesaplayıcı'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. PPL Kategori Seçici (Push / Pull / Legs)
            _buildCategorySelector(),
            const SizedBox(height: 16),

            // 2. Egzersiz Seçici
            _buildExerciseSelector(availableExercises, catColor),
            const SizedBox(height: 20),

            // 3. Veri Giriş Kartları (int ve double değişkenleri)
            _buildInputSection(catColor),
            const SizedBox(height: 20),

            // 4. Anlık Hesaplanan Hacim ve Özet Kartı
            _buildVolumeResultCard(evaluation, catColor),
            const SizedBox(height: 16),

            // 5. Koç Değerlendirmesi & if/else Karar Analizi
            _buildCoachEvaluationCard(evaluation),
            const SizedBox(height: 20),

            // 6. Seti Günlüğe Kaydet Butonu
            ElevatedButton.icon(
              onPressed: () => _saveSet(evaluation),
              icon: const Icon(Icons.bookmark_add),
              label: const Text('Bu Seti Antrenman Günlüğüne Ekle'),
              style: ElevatedButton.styleFrom(
                backgroundColor: catColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      children: [
        Expanded(
          child: _buildCategoryTab(
            category: WorkoutCategory.push,
            title: 'Push',
            subtitle: 'İtiş',
            icon: Icons.upload,
            color: AppTheme.pushColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCategoryTab(
            category: WorkoutCategory.pull,
            title: 'Pull',
            subtitle: 'Çekiş',
            icon: Icons.download,
            color: AppTheme.pullColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCategoryTab(
            category: WorkoutCategory.legs,
            title: 'Legs',
            subtitle: 'Bacak',
            icon: Icons.directions_walk,
            color: AppTheme.legsColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab({
    required WorkoutCategory category,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _updateDefaultExercise();
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : Colors.grey.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 24),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected ? color : null,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSelector(List<Exercise> exercises, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Exercise>(
          value: exercises.contains(_selectedExercise) ? _selectedExercise : exercises.first,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: color),
          items: exercises.map((e) {
            return DropdownMenuItem<Exercise>(
              value: e,
              child: Row(
                children: [
                  Icon(
                    e.isCompound ? Icons.fitness_center : Icons.adjust,
                    size: 18,
                    color: color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          e.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${e.primaryMuscle} • ${e.isCompound ? "Bileşik" : "İzolasyon"}',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newExercise) {
            if (newExercise != null) {
              setState(() => _selectedExercise = newExercise);
            }
          },
        ),
      ),
    );
  }

  Widget _buildInputSection(Color color) {
    return Column(
      children: [
        // Set ve Tekrar Sayacı (int)
        Row(
          children: [
            Expanded(
              child: _buildNumberCounter(
                title: 'Set Sayısı (int)',
                value: '$_sets',
                onDecrement: () => setState(() => _sets = (_sets > 1 ? _sets - 1 : 1)),
                onIncrement: () => setState(() => _sets++),
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberCounter(
                title: 'Yapılan Tekrar (int)',
                value: '$_reps',
                onDecrement: () => setState(() => _reps = (_reps > 1 ? _reps - 1 : 1)),
                onIncrement: () => setState(() => _reps++),
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Hedef Tekrar ve Ağırlık (int & double)
        Row(
          children: [
            Expanded(
              child: _buildNumberCounter(
                title: 'Hedef Tekrar (int)',
                value: '$_targetReps',
                onDecrement: () =>
                    setState(() => _targetReps = (_targetReps > 1 ? _targetReps - 1 : 1)),
                onIncrement: () => setState(() => _targetReps++),
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildWeightCounter(
                title: 'Ağırlık (double)',
                weight: _weight,
                onChanged: (newW) => setState(() => _weight = newW),
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Hedef Ağırlık & Tükeniş Toggle (double & bool)
        Row(
          children: [
            Expanded(
              child: _buildWeightCounter(
                title: 'Hedef Ağırlık (double)',
                weight: _targetWeight,
                onChanged: (newW) => setState(() => _targetWeight = newW),
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Tükeniş (Failure) Switch Kutusu
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _reachedFailure
                ? AppTheme.failureColor.withOpacity(0.12)
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _reachedFailure
                  ? AppTheme.failureColor
                  : Colors.grey.withOpacity(0.2),
              width: _reachedFailure ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: _reachedFailure ? AppTheme.failureColor : Colors.grey,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tükenişe (Failure / RIR 0) Ulaşıldı mı?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _reachedFailure ? AppTheme.failureColor : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _reachedFailure
                          ? 'Evet (Son tekrarda pozitif tükeniş gerçekleşti)'
                          : 'Hayır (Rezervde 1-2 tekrar bırakıldı)',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _reachedFailure,
                activeColor: AppTheme.failureColor,
                onChanged: (val) => setState(() => _reachedFailure = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberCounter({
    required String title,
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: onDecrement,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: onIncrement,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: color.withOpacity(0.15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightCounter({
    required String title,
    required double weight,
    required ValueChanged<double> onChanged,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () {
                  final newW = weight > 2.5 ? weight - 2.5 : 0.0;
                  onChanged(double.parse(newW.toStringAsFixed(1)));
                },
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Text(
                '${weight.toStringAsFixed(1)} kg',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () {
                  final newW = weight + 2.5;
                  onChanged(double.parse(newW.toStringAsFixed(1)));
                },
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: color.withOpacity(0.15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolumeResultCard(WorkoutEvaluation eval, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.18),
            Theme.of(context).cardColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'HESAPLANAN TOPLAM HACİM',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.8),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_sets} Set × ${_reps} Tekrar',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                eval.totalVolume.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'kg Tonaj',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Tahmini 1RM (Epley)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Text(
                      '${eval.estimatedOneRepMax} kg',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Önerilen Dinlenme', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${eval.recommendedRestSeconds} sn',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => _openRestTimer(eval.recommendedRestSeconds),
                          child: Icon(Icons.timer_outlined, size: 20, color: color),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoachEvaluationCard(WorkoutEvaluation eval) {
    final statusColor = eval.isGoalMet ? AppTheme.successColor : AppTheme.warningColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                eval.isGoalMet ? Icons.check_circle : Icons.info_outline,
                color: statusColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  eval.statusTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            eval.goalFeedback,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.bolt, size: 18, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    eval.failureFeedback,
                    style: const TextStyle(fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.pullColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.trending_up, size: 18, color: AppTheme.pullColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    eval.progressiveOverloadAdvice,
                    style: const TextStyle(fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => setState(() => _showCodeSnippet = !_showCodeSnippet),
            child: Row(
              children: [
                Icon(
                  _showCodeSnippet ? Icons.keyboard_arrow_up : Icons.code,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  _showCodeSnippet ? 'Dart Kodunu Gizle' : 'Dart Mantığını Gör (if/else & const/final)',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          if (_showCodeSnippet) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                eval.dartCodeSnippet,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
                  color: Color(0xFF38BDF8),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
