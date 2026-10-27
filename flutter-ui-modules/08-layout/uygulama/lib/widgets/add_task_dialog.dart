import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/category.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final TaskModel? existingTask;
  final DateTime initialDate;
  final Function(TaskModel task) onSave;

  const AddTaskBottomSheet({
    super.key,
    this.existingTask,
    required this.initialDate,
    required this.onSave,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _categoryId;
  late DateTime _date;
  late TimeOfDay _startTime;
  late int _durationInMinutes;
  late TaskPriority _priority;

  List<SubTask> _subtasks = [];
  final TextEditingController _subTaskTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    _title = task?.title ?? '';
    _description = task?.description ?? '';
    _categoryId = task?.categoryId ?? CategoryModel.defaultCategories.first.id;
    _date = task?.date ?? widget.initialDate;
    _startTime = task?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    _durationInMinutes = task?.durationInMinutes ?? 30;
    _priority = task?.priority ?? TaskPriority.medium;
    _subtasks = task?.subtasks
            .map((s) => SubTask(id: s.id, title: s.title, isCompleted: s.isCompleted))
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _subTaskTextController.dispose();
    super.dispose();
  }

  void _addSubTask() {
    final text = _subTaskTextController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _subtasks.add(SubTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: text,
        ));
        _subTaskTextController.clear();
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newTask = TaskModel(
        id: widget.existingTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        categoryId: _categoryId,
        date: _date,
        startTime: _startTime,
        durationInMinutes: _durationInMinutes,
        priority: _priority,
        isCompleted: widget.existingTask?.isCompleted ?? false,
        isSkipped: widget.existingTask?.isSkipped ?? false,
        subtasks: _subtasks,
      );

      widget.onSave(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
        left: 20,
        right: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingTask == null ? 'Yeni Görev Ekle' : 'Görevi Düzenle',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title Input
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Görev Başlığı',
                  hintText: 'Örn: Mobil uygulama arayüz tasarımı',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.task_alt),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Lütfen bir başlık girin'
                    : null,
                onSaved: (val) => _title = val!.trim(),
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                initialValue: _description,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Açıklama / Notlar',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.notes),
                ),
                onSaved: (val) => _description = val?.trim() ?? '',
              ),
              const SizedBox(height: 12),

              // Category Selector
              DropdownButtonFormField<String>(
                value: _categoryId,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: CategoryModel.defaultCategories.map((cat) {
                  return DropdownMenuItem(
                    value: cat.id,
                    child: Row(
                      children: [
                        Icon(cat.icon, color: cat.color, size: 20),
                        const SizedBox(width: 8),
                        Text(cat.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _categoryId = val);
                },
              ),
              const SizedBox(height: 12),

              // Time & Duration Row
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );
                        if (picked != null) {
                          setState(() => _startTime = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Başlangıç Saati',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.access_time),
                        ),
                        child: Text(_startTime.format(context)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      value: _durationInMinutes,
                      decoration: InputDecoration(
                        labelText: 'Süre',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.timer_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(value: 15, child: Text('15 dakika')),
                        DropdownMenuItem(value: 30, child: Text('30 dakika')),
                        DropdownMenuItem(value: 45, child: Text('45 dakika')),
                        DropdownMenuItem(value: 60, child: Text('1 saat')),
                        DropdownMenuItem(value: 90, child: Text('1.5 saat')),
                        DropdownMenuItem(value: 120, child: Text('2 saat')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _durationInMinutes = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Priority Selector
              Text('Öncelik Seviyesi', style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: TaskPriority.values.map((p) {
                  final isSelected = _priority == p;
                  return ChoiceChip(
                    label: Text(p.displayName),
                    selected: isSelected,
                    selectedColor: p.color.withOpacity(0.2),
                    side: BorderSide(color: isSelected ? p.color : Colors.transparent),
                    labelStyle: TextStyle(
                      color: isSelected ? p.color : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _priority = p);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Subtasks Section
              Text('Alt Görevler', style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subTaskTextController,
                      decoration: InputDecoration(
                        hintText: 'Alt görev ekle...',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onSubmitted: (_) => _addSubTask(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: _addSubTask,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              if (_subtasks.isNotEmpty) ...[
                const SizedBox(height: 6),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    final sub = _subtasks[index];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.subdirectory_arrow_right, size: 18),
                      title: Text(sub.title),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.red),
                        onPressed: () {
                          setState(() => _subtasks.removeAt(index));
                        },
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    widget.existingTask == null ? 'Görevi Oluştur' : 'Değişiklikleri Kaydet',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
