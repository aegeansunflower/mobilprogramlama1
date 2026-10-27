import 'package:flutter/material.dart';
import '../models/routine.dart';
import '../models/category.dart';

class RoutineCardWidget extends StatelessWidget {
  final RoutineModel routine;
  final DateTime selectedDate;
  final VoidCallback onToggleCompletion;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RoutineCardWidget({
    super.key,
    required this.routine,
    required this.selectedDate,
    required this.onToggleCompletion,
    required this.onEdit,
    required this.onDelete,
  });

  static const List<String> _turkishDayInitials = ['P', 'S', 'Ç', 'P', 'C', 'C', 'P'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDoneToday = routine.isCompletedOn(selectedDate);
    final sectionColor = routine.section.color;

    final targetTimeStr = routine.targetTime.format(context);

    final daysList = List.generate(7, (i) {
      return selectedDate.subtract(Duration(days: 6 - i));
    });

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Row(
              children: [
                // Icon avatar
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(routine.colorValue).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    IconData(routine.iconCodePoint, fontFamily: 'MaterialIcons'),
                    color: Color(routine.colorValue),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        routine.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: isDoneToday ? TextDecoration.lineThrough : null,
                          color: isDoneToday ? theme.textTheme.bodySmall?.color : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 12, color: theme.hintColor),
                          const SizedBox(width: 4),
                          Text(
                            targetTimeStr,
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (routine.streak > 0) ...[
                            const Text(
                              '🔥 ',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '${routine.streak} gün seri',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Quick Toggle Button
                IconButton.filledTonal(
                  onPressed: onToggleCompletion,
                  style: IconButton.styleFrom(
                    backgroundColor: isDoneToday
                        ? sectionColor
                        : sectionColor.withOpacity(0.12),
                    foregroundColor: isDoneToday ? Colors.white : sectionColor,
                  ),
                  icon: Icon(
                    isDoneToday ? Icons.check : Icons.add,
                  ),
                ),

                // Popup menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (val) {
                    if (val == 'edit') onEdit();
                    if (val == 'delete') onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Rutini Düzenle'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Mini 7-day completion bubbles history
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: daysList.map((d) {
                final isDone = routine.isCompletedOn(d);
                final isSelectedDay = d.year == selectedDate.year &&
                    d.month == selectedDate.month &&
                    d.day == selectedDate.day;

                final dayInitial = _turkishDayInitials[d.weekday - 1];

                return Column(
                  children: [
                    Text(
                      dayInitial,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isSelectedDay ? FontWeight.bold : FontWeight.normal,
                        color: isSelectedDay ? theme.colorScheme.primary : theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDone
                            ? sectionColor
                            : theme.colorScheme.surfaceContainerHighest,
                        border: isSelectedDay
                            ? Border.all(color: theme.colorScheme.primary, width: 2)
                            : null,
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
