import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../widgets/date_selector.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_dialog.dart';

class DayPlannerScreen extends StatefulWidget {
  const DayPlannerScreen({super.key});

  @override
  State<DayPlannerScreen> createState() => _DayPlannerScreenState();
}

class _DayPlannerScreenState extends State<DayPlannerScreen> {
  bool _isTimelineView = false;

  void _openAddTaskBottomSheet(BuildContext context, PlannerProvider provider, [TaskModel? existing]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddTaskBottomSheet(
        existingTask: existing,
        initialDate: provider.selectedDate,
        onSave: (task) {
          if (existing == null) {
            provider.addTask(task);
          } else {
            provider.updateTask(task);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlannerProvider>(context);
    final theme = Theme.of(context);
    final tasks = provider.tasksForSelectedDate;
    final summary = provider.selectedDateSummary;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Merhaba, ${provider.userName} 👋'),
            Text(
              'Günlük zaman çizelgeni planla',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
        actions: [
          // View Mode Switcher
          IconButton(
            icon: Icon(_isTimelineView ? Icons.view_list_outlined : Icons.view_timeline_outlined),
            tooltip: _isTimelineView ? 'Liste Görünümüne Geç' : 'Zaman Çizelgesine Geç',
            onPressed: () {
              setState(() {
                _isTimelineView = !_isTimelineView;
              });
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Date Selector Header
                DateSelectorWidget(
                  selectedDate: provider.selectedDate,
                  onDateSelected: (date) => provider.setSelectedDate(date),
                ),

                // Productivity Summary Card
                ProgressCardWidget(summary: summary),

                // Category Filter Pills
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: const Text('Tüm Kategoriler'),
                          selected: provider.selectedCategoryId == null,
                          onSelected: (_) => provider.setCategoryFilter(null),
                        ),
                      ),
                      ...CategoryModel.defaultCategories.map((cat) {
                        final isSelected = provider.selectedCategoryId == cat.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.color),
                            label: Text(cat.name),
                            selected: isSelected,
                            selectedColor: cat.color,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                            onSelected: (selected) {
                              provider.setCategoryFilter(selected ? cat.id : null);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Main Tasks View (List vs Hourly Timeline)
                Expanded(
                  child: tasks.isEmpty
                      ? _buildEmptyState(context, provider)
                      : (_isTimelineView
                          ? _buildTimelineView(context, provider, tasks)
                          : _buildListView(context, provider, tasks)),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddTaskBottomSheet(context, provider),
        icon: const Icon(Icons.add),
        label: const Text('Görev Ekle'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, PlannerProvider provider) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 64, color: theme.colorScheme.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'Bu gün için planlanmış görev yok',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Zaman dilimlerinizi planlamak için "+ Görev Ekle" butonuna dokunun.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _openAddTaskBottomSheet(context, provider),
            icon: const Icon(Icons.add),
            label: const Text('Yeni Görev Oluştur'),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, PlannerProvider provider, List<TaskModel> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCardWidget(
          task: task,
          onToggleComplete: () => provider.toggleTaskCompletion(task.id),
          onToggleSubTask: (subId) => provider.toggleSubTaskCompletion(task.id, subId),
          onEdit: () => _openAddTaskBottomSheet(context, provider, task),
          onDelete: () => provider.deleteTask(task.id),
        );
      },
    );
  }

  Widget _buildTimelineView(BuildContext context, PlannerProvider provider, List<TaskModel> tasks) {
    final theme = Theme.of(context);
    final hours = List.generate(18, (i) => i + 6);

    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
      itemCount: hours.length,
      itemBuilder: (context, index) {
        final hour = hours[index];
        final formattedHour = '${hour.toString().padLeft(2, '0')}:00';

        final hourTasks = tasks.where((t) => t.startTime.hour == hour).toList();

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Time label
              SizedBox(
                width: 50,
                child: Text(
                  formattedHour,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.hintColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Timeline vertical line
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hourTasks.isNotEmpty
                          ? theme.colorScheme.primary
                          : theme.dividerColor,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.dividerColor.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),

              // Hour Tasks List
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: hourTasks.isEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Boş zaman dilimi',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: theme.hintColor.withOpacity(0.5),
                            ),
                          ),
                        )
                      : Column(
                          children: hourTasks.map((task) {
                            return TaskCardWidget(
                              task: task,
                              onToggleComplete: () => provider.toggleTaskCompletion(task.id),
                              onToggleSubTask: (subId) => provider.toggleSubTaskCompletion(task.id, subId),
                              onEdit: () => _openAddTaskBottomSheet(context, provider, task),
                              onDelete: () => provider.deleteTask(task.id),
                            );
                          }).toList(),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
