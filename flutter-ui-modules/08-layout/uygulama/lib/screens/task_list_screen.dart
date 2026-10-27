import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/planner_provider.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import '../widgets/add_task_dialog.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isMatrixView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      final provider = Provider.of<PlannerProvider>(context, listen: false);
      if (_tabController.index == 0) {
        provider.setCompletedStatusFilter(null);
      } else if (_tabController.index == 1) {
        provider.setCompletedStatusFilter(false);
      } else {
        provider.setCompletedStatusFilter(true);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
    final tasks = provider.filteredAllTasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Görev Yöneticisi'),
        actions: [
          IconButton(
            icon: Icon(_isMatrixView ? Icons.format_list_bulleted : Icons.grid_view),
            tooltip: _isMatrixView ? 'Liste Görünümü' : 'Eisenhower Öncelik Matrisi',
            onPressed: () {
              setState(() {
                _isMatrixView = !_isMatrixView;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tüm Görevler'),
            Tab(text: 'Bekleyenler'),
            Tab(text: 'Tamamlananlar'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Priority Filter Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Görevlerde ara...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                provider.setSearchQuery('');
                              },
                            )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (val) => provider.setSearchQuery(val),
                  ),
                ),
                const SizedBox(width: 8),

                // Priority Filter Dropdown
                DropdownButton<TaskPriority?>(
                  value: provider.selectedPriority,
                  hint: const Text('Öncelik'),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.filter_list),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Tüm Öncelikler')),
                    ...TaskPriority.values.map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(
                          p.displayName,
                          style: TextStyle(color: p.color, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                  onChanged: (p) => provider.setPriorityFilter(p),
                ),
              ],
            ),
          ),

          // Content view: Eisenhower Matrix or List
          Expanded(
            child: _isMatrixView
                ? _buildEisenhowerMatrix(context, provider, tasks)
                : (tasks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: theme.hintColor),
                            const SizedBox(height: 12),
                            Text(
                              'Eşleşen görev bulunamadı',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
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
                      )),
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

  Widget _buildEisenhowerMatrix(BuildContext context, PlannerProvider provider, List<TaskModel> tasks) {
    final urgent = tasks.where((t) => t.priority == TaskPriority.urgent).toList();
    final high = tasks.where((t) => t.priority == TaskPriority.high).toList();
    final medium = tasks.where((t) => t.priority == TaskPriority.medium).toList();
    final low = tasks.where((t) => t.priority == TaskPriority.low).toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _matrixBox(context, provider, 'HEMEN YAP (Acil)', urgent, Colors.red)),
                Expanded(child: _matrixBox(context, provider, 'PLANLA (Yüksek)', high, Colors.orange)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _matrixBox(context, provider, 'DEVRET (Orta)', medium, Colors.green)),
                Expanded(child: _matrixBox(context, provider, 'ERTELE / YAPMA (Düşük)', low, Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _matrixBox(BuildContext context, PlannerProvider provider, String title, List<TaskModel> quadrantTasks, Color color) {
    final theme = Theme.of(context);
    return Card(
      color: color.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1.5),
      ),
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
                Text(
                  '${quadrantTasks.length}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const Divider(height: 12),
            Expanded(
              child: quadrantTasks.isEmpty
                  ? Center(
                      child: Text(
                        'Boş',
                        style: TextStyle(fontSize: 11, color: theme.hintColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: quadrantTasks.length,
                      itemBuilder: (context, index) {
                        final t = quadrantTasks[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => provider.toggleTaskCompletion(t.id),
                                child: Icon(
                                  t.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                                  size: 16,
                                  color: color,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  t.title,
                                  style: TextStyle(
                                    fontSize: 11,
                                    decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
