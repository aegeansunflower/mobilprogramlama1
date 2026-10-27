import 'package:flutter/material.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../services/workout_storage_service.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  final WorkoutStorageService storageService;

  const HistoryScreen({
    super.key,
    required this.storageService,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tüm Kayıtları Temizle'),
        content: const Text('Kaydedilmiş tüm setler ve hacim verileri silinecektir. Onaylıyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.storageService.clearAll();
              if (mounted) {
                Navigator.of(ctx).pop();
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.failureColor),
            child: const Text('Tümünü Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sets = widget.storageService.sets;
    final totalVol = widget.storageService.totalOverallVolume;
    final pushVol = widget.storageService.getVolumeForCategory(WorkoutCategory.push);
    final pullVol = widget.storageService.getVolumeForCategory(WorkoutCategory.pull);
    final legsVol = widget.storageService.getVolumeForCategory(WorkoutCategory.legs);
    final failureCount = widget.storageService.failureSetsCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrenman Günlüğü'),
        actions: [
          if (sets.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Tümünü Temizle',
              onPressed: _confirmClearAll,
            ),
        ],
      ),
      body: sets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center_outlined, size: 64, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz kaydedilmiş set bulunmuyor.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hesaplayıcı ekranından yaptığınız setleri ekleyebilirsiniz.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Genel Özet Kartı
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GÜNLÜK TOPLAM HACİM',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              totalVol.toStringAsFixed(0),
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF38BDF8),
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('kg Toplam Tonaj', style: TextStyle(color: Colors.white70, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFF334155)),
                        const SizedBox(height: 12),
                        // PPL Hacim Dağılım Çubukları
                        _buildVolumeProgressBar('Push (İtiş)', pushVol, totalVol, AppTheme.pushColor),
                        const SizedBox(height: 8),
                        _buildVolumeProgressBar('Pull (Çekiş)', pullVol, totalVol, AppTheme.pullColor),
                        const SizedBox(height: 8),
                        _buildVolumeProgressBar('Legs (Bacak)', legsVol, totalVol, AppTheme.legsColor),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.local_fire_department, size: 16, color: AppTheme.failureColor),
                            const SizedBox(width: 6),
                            Text(
                              'Tükenişe (Failure) Ulaşılan Set: $failureCount',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Kaydedilen Setler',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Set Listesi
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = sets[index];
                      return _buildSetCard(item);
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildVolumeProgressBar(String label, double value, double total, Color color) {
    final double ratio = total > 0 ? (value / total).clamp(0.0, 1.0) : 0.0;
    final int percent = (ratio * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text('${value.toStringAsFixed(0)} kg (%$percent)',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6,
            backgroundColor: Colors.grey.withOpacity(0.15),
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSetCard(WorkoutSet item) {
    final catColor = _getCategoryColor(item.exercise.category);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: catColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.exercise.category.name.toUpperCase(),
                      style: TextStyle(color: catColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.exercise.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  await widget.storageService.removeSet(item.id);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${item.sets} set × ${item.reps} tekrar × ${item.weight} kg',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              Text(
                '${item.totalVolume.toStringAsFixed(0)} kg Hacim',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: catColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (item.reachedFailure)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.failureColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 12, color: AppTheme.failureColor),
                      SizedBox(width: 2),
                      Text('Tükeniş (RIR 0)',
                          style: TextStyle(fontSize: 10, color: AppTheme.failureColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              Text(
                '1RM: ~${item.estimatedOneRepMax} kg',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
