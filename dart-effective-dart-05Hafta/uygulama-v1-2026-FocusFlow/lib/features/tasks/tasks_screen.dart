import 'package:flutter/material.dart';

import '../../blockchain/core/focus_chain_network.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_time_utils.dart';
import '../../models/study_task.dart';
import '../../state/app_controller.dart';
import '../../widgets/app_snack_bar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/page_header.dart';
import 'task_form_dialog.dart';

enum _TaskFilter { all, pending, completed }

enum _TaskMenuAction { edit, delete }

/// Görevleri listeler; ekleme, düzenleme, tamamlama ve silme akışlarını yönetir.
class TasksScreen extends StatefulWidget {
  /// Görev ekranını merkezi denetleyiciyle oluşturur.
  const TasksScreen({super.key, required this.controller});

  /// Uygulamanın merkezi durumu.
  final AppController controller;

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  _TaskFilter _filter = _TaskFilter.all;

  List<StudyTask> get _visibleTasks {
    return switch (_filter) {
      _TaskFilter.all => widget.controller.sortedTasks,
      _TaskFilter.pending => widget.controller.pendingTasks,
      _TaskFilter.completed => widget.controller.completedTasks,
    };
  }

  Future<void> _openTaskForm({StudyTask? task}) {
    return showTaskFormDialog(
      context,
      controller: widget.controller,
      task: task,
    );
  }

  Future<void> _toggleTask(StudyTask task) async {
    final wasCompleted = task.isCompleted;
    final saved = await widget.controller.setTaskCompleted(
      task,
      isCompleted: !task.isCompleted,
    );
    if (!mounted) {
      return;
    }
    if (!saved) {
      showAppSnackBar(
        context,
        widget.controller.lastError ?? 'Görev güncellenemedi.',
        tone: SnackBarTone.error,
      );
      return;
    }
    if (!wasCompleted) {
      final reward = widget.controller.lastChainReward;
      if (reward != null) {
        showAppSnackBar(
          context,
          'Görev tamamlandı • +${reward.totalReward} FOCUS kazanıldı.',
          tone: SnackBarTone.success,
        );
      }
    }
  }

  Future<void> _confirmDelete(StudyTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Görevi sil'),
          content: Text(
            '"${task.title}" kalıcı olarak silinecek. Bu işlem geri alınamaz.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Vazgeç'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
                foregroundColor: Theme.of(dialogContext).colorScheme.onError,
              ),
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final deleted = await widget.controller.deleteTask(task);
    if (!mounted) {
      return;
    }
    showAppSnackBar(
      context,
      deleted
          ? 'Görev silindi.'
          : widget.controller.lastError ?? 'Görev silinemedi.',
      tone: deleted ? SnackBarTone.success : SnackBarTone.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final visibleTasks = _visibleTasks;
    final total = widget.controller.totalTaskCount;
    final pending = widget.controller.pendingTaskCount;
    final completed = widget.controller.completedTaskCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      children: <Widget>[
        PageHeader(
          title: 'Görevler',
          subtitle: '$pending bekleyen • $completed tamamlanan',
          trailing: FilledButton.icon(
            onPressed: () => _openTaskForm(),
            icon: const Icon(Icons.add_rounded, size: 19),
            label: const Text('Ekle'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 46),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        const SizedBox(height: 18),
        if (total > 0) ...<Widget>[
          _TaskOverviewCard(completed: completed, total: total),
          const SizedBox(height: 14),
        ],
        _FilterBar(
          selected: _filter,
          allCount: total,
          pendingCount: pending,
          completedCount: completed,
          onChanged: (filter) => setState(() => _filter = filter),
        ),
        const SizedBox(height: 16),
        if (visibleTasks.isEmpty)
          EmptyState(
            icon: _filter == _TaskFilter.completed
                ? Icons.task_alt_rounded
                : Icons.checklist_rounded,
            title: switch (_filter) {
              _TaskFilter.all => 'Henüz görev yok',
              _TaskFilter.pending => 'Bekleyen görev yok',
              _TaskFilter.completed => 'Tamamlanan görev yok',
            },
            message: switch (_filter) {
              _TaskFilter.all =>
                'İlk görevini ekleyerek çalışma planını oluşturmaya başla.',
              _TaskFilter.pending =>
                'Tebrikler, bekleyen tüm görevleri tamamladın. Yeni bir görev '
                    'ekleyebilirsin.',
              _TaskFilter.completed =>
                'Bir görevi tamamladığında burada listelenecek.',
            },
            actionLabel: _filter == _TaskFilter.completed ? null : 'Görev ekle',
            onAction: _filter == _TaskFilter.completed
                ? null
                : () => _openTaskForm(),
          )
        else ...<Widget>[
          for (final task in visibleTasks) ...<Widget>[
            _TaskTile(
              task: task,
              rewarded: widget.controller.hasRewardForTask(task.id),
              onToggle: () => _toggleTask(task),
              onEdit: () => _openTaskForm(task: task),
              onDelete: () => _confirmDelete(task),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 2),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${visibleTasks.length} görev gösteriliyor',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TaskOverviewCard extends StatelessWidget {
  const _TaskOverviewCard({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final progress = total == 0 ? 0.0 : completed / total;
    final percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            scheme.surfaceContainerLowest,
            scheme.secondaryContainer.withValues(alpha: 0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.72),
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  scheme.primaryContainer,
                  scheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.insights_rounded,
              color: scheme.onPrimaryContainer,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Günün planı',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '%$percentage',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.secondary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$completed / $total görev tamamlandı',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 7,
                    backgroundColor: scheme.surfaceContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(scheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.selected,
    required this.allCount,
    required this.pendingCount,
    required this.completedCount,
    required this.onChanged,
  });

  final _TaskFilter selected;
  final int allCount;
  final int pendingCount;
  final int completedCount;
  final ValueChanged<_TaskFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _FilterButton(
            label: 'Tümü',
            count: allCount,
            selected: selected == _TaskFilter.all,
            onTap: () => onChanged(_TaskFilter.all),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterButton(
            label: 'Bekleyenler',
            count: pendingCount,
            selected: selected == _TaskFilter.pending,
            onTap: () => onChanged(_TaskFilter.pending),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterButton(
            label: 'Tamamlananlar',
            count: completedCount,
            selected: selected == _TaskFilter.completed,
            onTap: () => onChanged(_TaskFilter.completed),
          ),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: '$label, $count görev',
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? scheme.primary
                  : scheme.surfaceContainerLowest.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? scheme.primary
                    : scheme.outlineVariant.withValues(alpha: 0.8),
              ),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$count',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground.withValues(alpha: selected ? 0.8 : 0.65),
                    fontWeight: FontWeight.w700,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
    required this.rewarded,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  final StudyTask task;
  final bool rewarded;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final overdue = _isOverdue(task);
    final isCompleted = task.isCompleted;

    return Material(
      color: isCompleted
          ? scheme.surfaceContainerLow.withValues(alpha: 0.85)
          : scheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 6, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.72),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _TaskCheck(completed: isCompleted, onTap: onToggle),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? scheme.onSurfaceVariant
                              : scheme.onSurface,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: <Widget>[
                          if (task.category != null)
                            _MetaChip(
                              icon: Icons.school_outlined,
                              label: task.category!,
                            ),
                          if (task.dueDate != null)
                            _MetaChip(
                              icon: overdue
                                  ? Icons.warning_amber_rounded
                                  : Icons.event_outlined,
                              label: overdue
                                  ? 'Gecikti · ${formatDueDate(task.dueDate!)}'
                                  : formatDueDate(task.dueDate!),
                              color: overdue
                                  ? scheme.error
                                  : scheme.onSurfaceVariant,
                            ),
                          _MetaChip(
                            icon: Icons.toll_rounded,
                            label: isCompleted
                                ? rewarded
                                      ? 'Ödendi'
                                      : 'Ödül bekliyor'
                                : '+${FocusChainNetwork.taskReward} FOCUS',
                            color: rewarded
                                ? scheme.secondary
                                : AppColors.tokenGold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              PopupMenuButton<_TaskMenuAction>(
                tooltip: 'Görev seçenekleri',
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: scheme.onSurfaceVariant,
                ),
                onSelected: (action) {
                  switch (action) {
                    case _TaskMenuAction.edit:
                      onEdit();
                    case _TaskMenuAction.delete:
                      onDelete();
                  }
                },
                itemBuilder: (context) =>
                    const <PopupMenuEntry<_TaskMenuAction>>[
                      PopupMenuItem<_TaskMenuAction>(
                        value: _TaskMenuAction.edit,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Düzenle'),
                        ),
                      ),
                      PopupMenuItem<_TaskMenuAction>(
                        value: _TaskMenuAction.delete,
                        child: ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.delete_outline),
                          title: Text('Sil'),
                        ),
                      ),
                    ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isOverdue(StudyTask task) {
    final dueDate = task.dueDate;
    if (dueDate == null || task.isCompleted) {
      return false;
    }
    return dateOnly(dueDate).isBefore(dateOnly(DateTime.now()));
  }
}

class _TaskCheck extends StatelessWidget {
  const _TaskCheck({required this.completed, required this.onTap});

  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      label: completed
          ? 'Tamamlanmadı olarak işaretle'
          : 'Tamamlandı olarak işaretle',
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: completed ? scheme.secondary : scheme.surfaceContainerLow,
            shape: BoxShape.circle,
            border: Border.all(
              color: completed ? scheme.secondary : scheme.outlineVariant,
              width: 1.4,
            ),
          ),
          child: completed
              ? Icon(Icons.check_rounded, size: 18, color: scheme.onSecondary)
              : null,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final effectiveColor = color ?? scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 11, color: effectiveColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: effectiveColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
