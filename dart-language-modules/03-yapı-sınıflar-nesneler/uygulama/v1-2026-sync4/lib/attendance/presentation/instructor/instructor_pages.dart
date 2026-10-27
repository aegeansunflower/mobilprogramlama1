// DART KONUSU: Classes & objects — `ConsumerWidget` kalıtımı, Hero ile
// paylaşılan eleman geçişi, private widget sınıfları. Class modifiers —
// `final class`.

/// Öğretim görevlisi: ana sayfa (bölüm seçimi) ve ders listesi.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sarkisla_yoklama/attendance/attendance.dart';
import 'package:sarkisla_yoklama/attendance/presentation/attendance_providers.dart';
import 'package:sarkisla_yoklama/attendance/presentation/shared_widgets.dart';
import 'package:sarkisla_yoklama/auth/auth.dart';
import 'package:sarkisla_yoklama/auth/presentation/auth_controller.dart';
import 'package:sarkisla_yoklama/core/core.dart';
import 'package:sarkisla_yoklama/ui/ui.dart';

/// Öğretim görevlisi ana sayfası: özet + bölüm seçimi.
final class InstructorHomePage extends ConsumerWidget {
  const InstructorHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(currentUserProvider);
    final taught = user is Instructor ? user.departments : <Department>{};
    final blocks = ref.watch(chainBlocksProvider).value ?? const [];
    final records = ref.watch(ledgerProvider).length;
    final courseCount = [
      for (final d in taught)
        ref.watch(instructorCoursesProvider(d)).value?.length ?? 0,
    ].fold(0, (a, b) => a + b);

    return AppScaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          Space.lg,
          Space.sm,
          Space.lg,
          Space.xxl,
        ),
        children: [
          UserHeader(
            subtitle: user is Instructor
                ? '${user.title} · ${l10n.roleInstructor}'
                : l10n.roleInstructor,
          ).enter(context),
          const SizedBox(height: Space.xl),
          StatStrip(
            items: [
              (l10n.statCourses, '$courseCount'),
              (l10n.statBlocks, '${blocks.isEmpty ? 0 : blocks.length - 1}'),
              (l10n.statRecords, '$records'),
            ],
          ).enter(context, index: 1),
          const SizedBox(height: Space.md),
          ChainStatusCard(onTap: () => context.push('/ogretim/zincir'))
              .enter(context, index: 2),
          SectionHeader(l10n.departmentsTitle),
          AdaptiveGrid(
            maxColumns: 2,
            minItemWidth: 300,
            children: [
              for (final (i, department) in Department.values.indexed)
                _DepartmentCard(
                  department: department,
                  taught: taught.contains(department),
                ).enter(context, index: 3 + i),
            ],
          ),
        ],
      ),
    );
  }
}

final class _DepartmentCard extends StatelessWidget {
  const _DepartmentCard({required this.department, required this.taught});

  final Department department;
  final bool taught;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final theme = Theme.of(context);
    final icon = switch (department) {
      Department.informationSystems => Icons.lan_outlined,
      Department.artificialIntelligence => Icons.psychology_outlined,
    };
    return SurfaceCard(
      onTap: () => context.push('/ogretim/bolum/${department.code}'),
      semanticLabel: department.label,
      child: Row(
        children: [
          IconTile(icon, size: 44, color: taught ? null : p.textMuted),
          const SizedBox(width: Space.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  department.code,
                  style: AppTheme.mono(context, size: 11.5),
                ),
                const SizedBox(height: 2),
                Text(
                  department.label,
                  style: AppTheme.display(size: 19, color: p.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  context.l10n.coursesTitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.sm),
          const Icon(Icons.arrow_forward, size: Sizes.iconSm),
        ],
      ),
    );
  }
}

/// Seçilen bölümdeki dersler.
final class CourseListPage extends ConsumerWidget {
  const CourseListPage({required this.department, super.key});

  final Department department;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final courses = ref.watch(instructorCoursesProvider(department));
    return AppScaffold(
      title: department.label,
      body: AsyncValueView(
        value: courses,
        onRetry: () => ref.invalidate(instructorCoursesProvider(department)),
        data: (list) => list.isEmpty
            ? EmptyState(icon: Icons.class_outlined, message: l10n.noCourses)
            : ListView(
                padding: const EdgeInsets.all(Space.lg),
                children: [
                  Text(
                    department.label,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ).enter(context),
                  SectionHeader(l10n.coursesTitle),
                  for (final (i, course) in list.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: Space.sm),
                      child: CourseTile(course: course)
                          .enter(context, index: i + 1),
                    ),
                ],
              ),
      ),
    );
  }
}

/// Ders kartı. Ders kodu, detay sayfasına `Hero` ile uçar.
final class CourseTile extends StatelessWidget {
  const CourseTile({
    required this.course,
    this.trailing,
    this.onTap,
    super.key,
  });

  final Course course;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SurfaceCard(
      onTap: onTap ?? () => context.push('/ogretim/ders/${course.id}'),
      semanticLabel: '${course.code} ${course.name}',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourseCodeBadge(course: course),
                const SizedBox(height: Space.sm),
                Text(course.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(
                  context.l10n.studentsCount(course.studentIds.length),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: Space.md),
          trailing ?? const Icon(Icons.arrow_forward, size: Sizes.iconSm),
        ],
      ),
    );
  }
}

/// Paylaşılan eleman: ders kodu rozeti.
final class CourseCodeBadge extends StatelessWidget {
  const CourseCodeBadge({required this.course, super.key});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Hero(
      tag: 'course-${course.id}',
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: p.accentSoft,
            borderRadius: Radii.small,
          ),
          child: Text(
            course.code,
            style: AppTheme.mono(context, size: 11.5, color: p.accent),
          ),
        ),
      ),
    );
  }
}
