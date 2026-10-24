import 'package:flutter/material.dart';

import '../../core/utils/date_time_utils.dart';
import '../../models/study_task.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_snack_bar.dart';

/// Görev formunun kaydetmek üzere dışarıya aktardığı veri.
class TaskDraft {
  /// Formdan gelen başlık, kategori ve son tarih bilgisini taşır.
  const TaskDraft({required this.title, this.category, this.dueDate});

  /// Kullanıcının girdiği, başı sonu temizlenmiş başlık.
  final String title;

  /// İsteğe bağlı kategori.
  final String? category;

  /// İsteğe bağlı son tarih.
  final DateTime? dueDate;
}

/// Görev ekleme ve düzenleme formunu açar.
///
/// Kaydetme işlemi form kapanmadan önce tamamlanır. Depoya yazma başarısız
/// olursa form açık kalır ve hata satır içinde gösterilir. Başarı mesajı
/// yalnızca kayıt gerçekten tamamlandıktan sonra gösterilir.
Future<bool> showTaskFormDialog(
  BuildContext context, {
  required AppController controller,
  StudyTask? task,
}) async {
  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return TaskFormDialog(
        initialTask: task,
        onSave: (draft) async {
          final bool success;
          if (task == null) {
            success = await controller.addTask(
              title: draft.title,
              category: draft.category,
              dueDate: draft.dueDate,
            );
          } else {
            success = await controller.updateTask(
              task.copyWith(
                title: draft.title,
                category: draft.category,
                dueDate: draft.dueDate,
              ),
            );
          }

          if (success) {
            return null;
          }
          return controller.lastError ?? 'Görev kaydedilemedi.';
        },
      );
    },
  );

  if (saved == true && context.mounted) {
    showAppSnackBar(
      context,
      task == null ? 'Görev eklendi.' : 'Görev güncellendi.',
      tone: SnackBarTone.success,
    );
  }
  return saved ?? false;
}

/// Görev başlığı, kategori ve son tarih alanlarını içeren dialog.
class TaskFormDialog extends StatefulWidget {
  /// Formu mevcut görevle veya boş olarak oluşturur.
  const TaskFormDialog({super.key, required this.onSave, this.initialTask});

  /// Kaydetme işlemini yürütür; başarıda `null`, hatada mesaj döndürür.
  final Future<String?> Function(TaskDraft draft) onSave;

  /// Düzenlenecek görev; yeni görev için `null`.
  final StudyTask? initialTask;

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _categoryController;
  DateTime? _dueDate;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _categoryController = TextEditingController(text: task?.category ?? '');
    _dueDate = task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      helpText: 'Son tarih seç',
      cancelText: 'Vazgeç',
      confirmText: 'Seç',
    );
    if (picked != null && mounted) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _submit() async {
    if (_isSaving) {
      return;
    }
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final category = _categoryController.text.trim();
    final error = await widget.onSave(
      TaskDraft(
        title: _titleController.text.trim(),
        category: category.isEmpty ? null : category,
        dueDate: _dueDate,
      ),
    );

    if (!mounted) {
      return;
    }
    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _isSaving = false;
      _errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isEditing = widget.initialTask != null;

    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      title: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isEditing ? Icons.edit_note_rounded : Icons.add_task_rounded,
              color: scheme.onPrimaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(isEditing ? 'Görevi düzenle' : 'Yeni görev')),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _titleController,
              autofocus: true,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.sentences,
              maxLength: StudyTask.maxTitleLength,
              decoration: const InputDecoration(
                labelText: 'Görev başlığı',
                hintText: 'Örn. Lineer cebir tekrarı',
                prefixIcon: Icon(Icons.edit_outlined),
                counterText: '',
              ),
              validator: StudyTask.validateTitle,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _categoryController,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 40,
              decoration: const InputDecoration(
                labelText: 'Ders / kategori (isteğe bağlı)',
                hintText: 'Örn. Matematik',
                prefixIcon: Icon(Icons.school_outlined),
                counterText: '',
              ),
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSaving ? null : _pickDueDate,
                    icon: const Icon(Icons.event_outlined, size: 18),
                    label: Text(
                      _dueDate == null
                          ? 'Son tarih ekle'
                          : 'Son tarih: ${formatDueDate(_dueDate!)}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                if (_dueDate != null) ...<Widget>[
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: _isSaving
                        ? null
                        : () => setState(() => _dueDate = null),
                    tooltip: 'Son tarihi kaldır',
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Son tarih isteğe bağlıdır. Boş bırakırsan görev tarihsiz kalır.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (_errorMessage != null) ...<Widget>[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.error_outline,
                      size: 18,
                      color: scheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Vazgeç'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(isEditing ? 'Kaydet' : 'Görev ekle'),
        ),
      ],
    );
  }
}
