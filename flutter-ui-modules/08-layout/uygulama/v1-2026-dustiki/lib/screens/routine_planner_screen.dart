import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../models/routine.dart';
import '../widgets/routine_card.dart';
import '../widgets/add_routine_dialog.dart';
import '../widgets/date_selector.dart';

class RoutinePlannerScreen extends StatelessWidget {
  const RoutinePlannerScreen({super.key});

  void _openAddRoutineBottomSheet(BuildContext context, PlannerProvider provider, [RoutineModel? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddRoutineBottomSheet(
        existingRoutine: existing,
        onSave: (routine) {
          if (existing == null) {
            provider.addRoutine(routine);
          } else {
            provider.updateRoutine(routine);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlannerProvider>(context);
    final theme = Theme.of(context);
    final scheduledRoutines = provider.routinesForSelectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinler ve Alışkanlıklar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task),
            tooltip: 'Rutin Ekle',
            onPressed: () => _openAddRoutineBottomSheet(context, provider),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DateSelectorWidget(
                  selectedDate: provider.selectedDate,
                  onDateSelected: (date) => provider.setSelectedDate(date),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: scheduledRoutines.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.repeat_one_outlined, size: 64, color: theme.colorScheme.primary.withOpacity(0.4)),
                              const SizedBox(height: 16),
                              Text(
                                'Bu gün için planlanmış rutin yok',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Sabah, öğle ve akşam için sağlıklı alışkanlıklar edinin!',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () => _openAddRoutineBottomSheet(context, provider),
                                icon: const Icon(Icons.add),
                                label: const Text('Yeni Rutin Oluştur'),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.only(bottom: 80),
                          children: RoutineSection.values.map((section) {
                            final sectionRoutines = scheduledRoutines.where((r) => r.section == section).toList();
                            if (sectionRoutines.isEmpty) return const SizedBox.shrink();

                            final doneCount = sectionRoutines.where((r) => r.isCompletedOn(provider.selectedDate)).length;
                            final progress = doneCount / sectionRoutines.length;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section Header
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(section.icon, color: section.color, size: 22),
                                      const SizedBox(width: 8),
                                      Text(
                                        section.displayName,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '$doneCount/${sectionRoutines.length} tamamlandı',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: section.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Mini Section Progress Bar
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 4,
                                      backgroundColor: section.color.withOpacity(0.15),
                                      color: section.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Routine Cards
                                ...sectionRoutines.map((routine) {
                                  return RoutineCardWidget(
                                    routine: routine,
                                    selectedDate: provider.selectedDate,
                                    onToggleCompletion: () => provider.toggleRoutineCompletion(routine.id, provider.selectedDate),
                                    onEdit: () => _openAddRoutineBottomSheet(context, provider, routine),
                                    onDelete: () => provider.deleteRoutine(routine.id),
                                  );
                                }),
                                const SizedBox(height: 12),
                              ],
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddRoutineBottomSheet(context, provider),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Rutin'),
      ),
    );
  }
}
