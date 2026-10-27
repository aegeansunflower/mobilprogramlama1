import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../models/category.dart';
import '../models/daily_summary.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static const List<String> _turkishDayNames = [
    'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlannerProvider>(context);
    final theme = Theme.of(context);

    final allTasks = provider.allTasks;
    final allRoutines = provider.allRoutines;

    final completedTasks = allTasks.where((t) => t.isCompleted).length;
    final totalTasks = allTasks.length;
    final taskRate = totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();

    final now = DateTime.now();
    final pastWeek = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      return DailySummary.calculate(date, allTasks, allRoutines);
    });

    int topStreak = 0;
    String topStreakName = 'Yok';
    for (var r in allRoutines) {
      if (r.streak > topStreak) {
        topStreak = r.streak;
        topStreakName = r.title;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verimlilik Analizi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Highlights Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildMetricCard(
                  context,
                  'Görev Tamamlama',
                  '%$taskRate',
                  '$completedTasks / $totalTasks görev bitti',
                  Icons.check_circle_outline,
                  theme.colorScheme.primary,
                ),
                _buildMetricCard(
                  context,
                  'En İyi Seri',
                  '$topStreak Gün',
                  topStreakName,
                  Icons.local_fire_department_outlined,
                  Colors.orange,
                ),
                _buildMetricCard(
                  context,
                  'Aktif Rutinler',
                  '${allRoutines.length}',
                  'Günlük alışkanlık',
                  Icons.autorenew,
                  Colors.teal,
                ),
                _buildMetricCard(
                  context,
                  'Toplam Planlanan',
                  '${totalTasks + allRoutines.length}',
                  'Görev ve Rutinler',
                  Icons.leaderboard_outlined,
                  Colors.indigo,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Past 7 Days Productivity Trend Chart
            Text(
              'Haftalık Verimlilik Trendi',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: pastWeek.map((summary) {
                          final score = summary.productivityScore;
                          final heightFactor = (score / 100).clamp(0.08, 1.0);
                          final dayStr = _turkishDayNames[summary.date.weekday - 1];

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '%$score',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 22,
                                height: 110 * heightFactor,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                dayStr,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Breakdown Progress Bars
            Text(
              'Kategori Dağılımı',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: CategoryModel.defaultCategories.map((cat) {
                    final catTasks = allTasks.where((t) => t.categoryId == cat.id).toList();
                    final catCompleted = catTasks.where((t) => t.isCompleted).length;
                    final ratio = catTasks.isEmpty ? 0.0 : (catCompleted / catTasks.length);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(cat.icon, size: 16, color: cat.color),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cat.name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '${catTasks.length} görev',
                                style: TextStyle(fontSize: 12, color: theme.hintColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 6,
                              backgroundColor: cat.color.withOpacity(0.15),
                              color: cat.color,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: theme.hintColor, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: theme.hintColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
