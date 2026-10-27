import 'package:flutter/material.dart';
import '../models/routine.dart';

class AddRoutineBottomSheet extends StatefulWidget {
  final RoutineModel? existingRoutine;
  final Function(RoutineModel routine) onSave;

  const AddRoutineBottomSheet({
    super.key,
    this.existingRoutine,
    required this.onSave,
  });

  @override
  State<AddRoutineBottomSheet> createState() => _AddRoutineBottomSheetState();
}

class _AddRoutineBottomSheetState extends State<AddRoutineBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late RoutineSection _section;
  late TimeOfDay _targetTime;
  late List<int> _daysOfWeek;
  late String _categoryId;
  late int _iconCodePoint;
  late int _colorValue;

  final List<IconData> _iconOptions = [
    Icons.wb_sunny_outlined,
    Icons.fitness_center,
    Icons.water_drop_outlined,
    Icons.menu_book,
    Icons.self_improvement,
    Icons.bedtime_outlined,
    Icons.directions_walk,
    Icons.edit_note,
    Icons.music_note,
    Icons.task_alt,
  ];

  final List<Color> _colorOptions = [
    Colors.amber,
    Colors.orange,
    Colors.blue,
    Colors.teal,
    Colors.indigo,
    Colors.purple,
    Colors.green,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    final r = widget.existingRoutine;
    _title = r?.title ?? '';
    _description = r?.description ?? '';
    _section = r?.section ?? RoutineSection.morning;
    _targetTime = r?.targetTime ?? const TimeOfDay(hour: 7, minute: 30);
    _daysOfWeek = r?.daysOfWeek.toList() ?? [1, 2, 3, 4, 5, 6, 7];
    _categoryId = r?.categoryId ?? 'health';
    _iconCodePoint = r?.iconCodePoint ?? Icons.star_outline.codePoint;
    _colorValue = r?.colorValue ?? Colors.teal.value;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newRoutine = RoutineModel(
        id: widget.existingRoutine?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _title,
        description: _description,
        section: _section,
        targetTime: _targetTime,
        daysOfWeek: _daysOfWeek,
        categoryId: _categoryId,
        iconCodePoint: _iconCodePoint,
        colorValue: _colorValue,
        streak: widget.existingRoutine?.streak ?? 0,
        bestStreak: widget.existingRoutine?.bestStreak ?? 0,
        completionHistory: widget.existingRoutine?.completionHistory,
      );

      widget.onSave(newRoutine);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dayLabels = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingRoutine == null ? 'Yeni Rutin Oluştur' : 'Rutini Düzenle',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Rutin / Alışkanlık Başlığı',
                  hintText: 'Örn: 10 Dakika Esneme Hareketi',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.auto_awesome),
                ),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Başlık giriniz' : null,
                onSaved: (val) => _title = val!.trim(),
              ),
              const SizedBox(height: 12),

              // Section & Time
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<RoutineSection>(
                      value: _section,
                      decoration: InputDecoration(
                        labelText: 'Zaman Dilimi',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: RoutineSection.values.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _section = val);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: _targetTime,
                        );
                        if (picked != null) setState(() => _targetTime = picked);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Hedef Saat',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.alarm),
                        ),
                        child: Text(_targetTime.format(context)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Repeat Days
              Text('Tekrar Günleri', style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (i) {
                  final dayNumber = i + 1;
                  final isSelected = _daysOfWeek.contains(dayNumber);
                  return FilterChip(
                    label: Text(dayLabels[i]),
                    selected: isSelected,
                    visualDensity: VisualDensity.compact,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _daysOfWeek.add(dayNumber);
                        } else if (_daysOfWeek.length > 1) {
                          _daysOfWeek.remove(dayNumber);
                        }
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),

              // Icon & Color Picker
              Text('Simge ve Vurgu Rengi', style: theme.textTheme.titleSmall),
              const SizedBox(height: 6),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _iconOptions.length,
                  itemBuilder: (context, idx) {
                    final ic = _iconOptions[idx];
                    final isSelected = ic.codePoint == _iconCodePoint;
                    return InkWell(
                      onTap: () => setState(() => _iconCodePoint = ic.codePoint),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : theme.colorScheme.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: theme.colorScheme.primary, width: 2)
                              : null,
                        ),
                        child: Icon(ic, size: 20),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colorOptions.length,
                  itemBuilder: (context, idx) {
                    final col = _colorOptions[idx];
                    final isSelected = col.value == _colorValue;
                    return InkWell(
                      onTap: () => setState(() => _colorValue = col.value),
                      child: Container(
                        width: 32,
                        height: 32,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: col,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    widget.existingRoutine == null ? 'Rutin Oluştur' : 'Kaydet',
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
