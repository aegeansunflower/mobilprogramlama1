import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/category.dart';

class TaskCardWidget extends StatefulWidget {
  final TaskModel task;
  final VoidCallback onToggleComplete;
  final Function(String subTaskId) onToggleSubTask;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onToggleSubTask,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends State<TaskCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = CategoryModel.getById(widget.task.categoryId);
    final priority = widget.task.priority;

    final formattedTime = widget.task.startTime.format(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (widget.task.subtasks.isNotEmpty || widget.task.description.isNotEmpty) {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  Transform.scale(
                    scale: 1.1,
                    child: Checkbox(
                      value: widget.task.isCompleted,
                      onChanged: (_) => widget.onToggleComplete(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeColor: category.color,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Main Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: widget.task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: widget.task.isCompleted
                                ? theme.textTheme.bodySmall?.color
                                : null,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Tags & Time Row
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            // Time badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.access_time, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$formattedTime (${widget.task.durationInMinutes} dk)',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),

                            // Category Chip
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: category.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(category.icon, size: 12, color: category.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    category.name,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: category.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Priority Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: priority.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                priority.displayName.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: priority.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Actions menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (val) {
                      if (val == 'edit') widget.onEdit();
                      if (val == 'delete') widget.onDelete();
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Görevi Düzenle'),
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

              // Expanded Description & Subtasks
              if (_isExpanded) ...[
                const Divider(height: 16),
                if (widget.task.description.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 8),
                    child: Text(
                      widget.task.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],

                if (widget.task.subtasks.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      'Alt Görevler (${widget.task.subtasks.where((s) => s.isCompleted).length}/${widget.task.subtasks.length})',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...widget.task.subtasks.map(
                    (sub) => InkWell(
                      onTap: () => widget.onToggleSubTask(sub.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              sub.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
                              size: 18,
                              color: sub.isCompleted ? category.color : Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                sub.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  decoration: sub.isCompleted ? TextDecoration.lineThrough : null,
                                  color: sub.isCompleted ? Colors.grey : null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}
