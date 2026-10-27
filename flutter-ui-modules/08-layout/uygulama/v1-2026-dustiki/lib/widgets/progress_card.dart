import 'package:flutter/material.dart';
import '../models/daily_summary.dart';

class ProgressCardWidget extends StatelessWidget {
  final DailySummary summary;

  const ProgressCardWidget({
    super.key,
    required this.summary,
  });

  String _getMotivationalMessage(int percentage) {
    if (summary.totalItems == 0) {
      return 'Bugün için planlanmış madde bulunmuyor.';
    }
    if (percentage == 100) {
      return 'Mükemmel! Bütün günlük hedefler tamamlandı! 🎉';
    } else if (percentage >= 75) {
      return 'Harika ilerliyorsun! Bitirmeye çok az kaldı! 💪';
    } else if (percentage >= 50) {
      return 'Yarıyı geçtin! Temponu koru ve devam et! 🔥';
    } else if (percentage > 0) {
      return 'İyi bir başlangıç! Adım adım hedefe ulaş. ✨';
    } else {
      return 'Bugünkü hedeflerini tamamlamaya hazır mısın? Başlayalım! 🚀';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = summary.productivityScore;
    final progressVal = summary.completionPercentage;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.12),
              theme.colorScheme.secondary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            // Circular Progress Indicator
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 68,
                  height: 68,
                  child: CircularProgressIndicator(
                    value: progressVal,
                    strokeWidth: 7,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                    color: theme.colorScheme.primary,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '%$percentage',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Daily Stats & Quote
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getMotivationalMessage(percentage),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildChip(
                        context,
                        Icons.check_circle_outline,
                        '${summary.completedTasks}/${summary.totalTasks} Görev',
                        theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        context,
                        Icons.loop,
                        '${summary.completedRoutines}/${summary.totalRoutines} Rutin',
                        Colors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
