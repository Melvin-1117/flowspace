import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/animation_tokens.dart';
import '../../core/models/focus_block.dart';
import '../../core/models/milestone.dart';
import '../../core/models/subject.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../core/widgets/user_avatar.dart';
import 'providers/planner_providers.dart';
import 'providers/planner_storage.dart';
import 'widgets/add_focus_block_sheet.dart';
import 'widgets/add_subject_sheet.dart';
import 'widgets/focus_block_planner.dart';
import 'widgets/milestone_card.dart';
import 'widgets/milestone_detail_sheet.dart';
import 'widgets/semester_health_ring.dart';
import 'widgets/semester_health_sheet.dart';
import 'widgets/subject_mastery_card.dart';
import '../../app/theme.dart';

class PlannerScreen extends ConsumerStatefulWidget {
  const PlannerScreen({super.key});

  @override
  ConsumerState<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends ConsumerState<PlannerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _healthSectionKey = GlobalKey();
  final GlobalKey _milestoneSectionKey = GlobalKey();
  final GlobalKey _subjectsSectionKey = GlobalKey();
  final GlobalKey _focusSectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ref.watch(plannerNotificationBootstrapProvider);
    final health = ref.watch(semesterHealthProvider);
    final nextMilestone = ref.watch(nextMilestoneProvider);
    final milestoneCountdown = ref.watch(milestoneCountdownProvider);
    final subjects = ref.watch(allSubjectsProvider);
    final focusBlocks = ref.watch(todayFocusBlocksProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: _openSearchOverlay,
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: UserAvatar(size: 36),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      key: _healthSectionKey,
                      alignment: Alignment.center,
                      child: health.when(
                        loading: () => const _PlannerSkeletonBox(height: 200),
                        error: (_, __) => const _ErrorCard(
                          message: 'Failed to load semester health',
                        ),
                        data: (value) => SemesterHealthRing(
                          health: value,
                          onTap: () => showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: AppTheme.surfaceCard,
                            builder: (_) => SemesterHealthSheet(health: value),
                          ),
                        ),
                      ),
                    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
                    const SizedBox(height: 20),
                    Container(
                          key: _milestoneSectionKey,
                          child: nextMilestone.when(
                            loading: () =>
                                const _PlannerSkeletonBox(height: 170),
                            error: (_, __) => const _ErrorCard(
                              message: 'Failed to load milestones',
                            ),
                            data: (milestone) => MilestoneCard(
                              milestone: milestone,
                              countdown: milestoneCountdown.valueOrNull,
                              onAddMilestone: _openAddMilestoneSheet,
                              onTap: milestone == null
                                  ? null
                                  : () => _openMilestoneDetailSheet(milestone),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 100.ms)
                        .slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),
                    Row(
                      key: _subjectsSectionKey,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subject Mastery',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/planner/subjects'),
                          child: const Text(
                            'View All →',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    subjects.when(
                      loading: () => const Column(
                        children: [
                          _PlannerSkeletonBox(height: 120),
                          SizedBox(height: 12),
                          _PlannerSkeletonBox(height: 120),
                        ],
                      ),
                      error: (_, __) =>
                          const _ErrorCard(message: 'Failed to load subjects'),
                      data: (items) {
                        if (items.isEmpty) {
                          return const _EmptyPrompt(
                            title: 'No subjects added yet',
                            subtitle: 'Add subjects to start tracking mastery',
                          );
                        }
                        return Column(
                          children: [
                            for (var i = 0; i < items.length; i++) ...[
                              SubjectMasteryCard(
                                    subject: items[i],
                                    index: i,
                                    hoursProvider: subjectHoursProvider(
                                      items[i].uuid,
                                    ),
                                    onTap: () => context.push(
                                      '/planner/subjects/${items[i].uuid}',
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(
                                    delay: Duration(
                                      milliseconds:
                                          kPageStaggerStep.inMilliseconds * 2 +
                                          (i * kPageStaggerStep.inMilliseconds),
                                    ),
                                  )
                                  .slideY(begin: 0.1, end: 0),
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.surfaceBorder),
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: _openAddSubjectSheet,
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: AppTheme.textSecondary,
                      ),
                      label: const Text(
                        'Add New Subject',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FocusBlockPlanner(
                          sectionKey: _focusSectionKey,
                          subjects: subjects.valueOrNull ?? const <Subject>[],
                          blocks:
                              focusBlocks.valueOrNull ?? const <FocusBlock>[],
                          loading: focusBlocks.isLoading,
                          onAddBlock: _openAddFocusBlockSheet,
                          onOpenBlock: _openBlockDetails,
                        )
                        .animate()
                        .fadeIn(delay: kPageStaggerStep * 6)
                        .slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Future<void> _openSearchOverlay() async {
    final controller = TextEditingController();
    final allSubjects = await ref.read(allSubjectsProvider.future);
    final allMilestones = await ref.read(allMilestonesProvider.future);
    final allBlocks = await ref.read(todayFocusBlocksProvider.future);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.background,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.95,
          maxChildSize: 0.98,
          minChildSize: 0.6,
          expand: false,
          builder: (_, scrollController) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                final items = _filterSearchItems(
                  controller.text,
                  allSubjects,
                  allMilestones,
                  allBlocks,
                );
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search Planner',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller,
                        autofocus: true,
                        onChanged: (_) => setModalState(() {}),
                        decoration: const InputDecoration(
                          hintText:
                              'Search subjects, modules, milestones, blocks',
                          filled: true,
                          fillColor: AppTheme.surfaceCard,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: controller.text.trim().isEmpty
                            ? const _EmptyPrompt(
                                title: 'Start typing to search',
                                subtitle: 'Results are grouped by category',
                              )
                            : items.isEmpty
                            ? const _EmptyPrompt(
                                title: 'No matches found',
                                subtitle: 'Try a different keyword',
                              )
                            : _buildSearchGroupedList(items, scrollController),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _scrollToCategory(String category) {
    final key = (category == 'Subjects' || category == 'Modules')
        ? _subjectsSectionKey
        : (category == 'Milestones')
        ? _milestoneSectionKey
        : (category == 'Focus Blocks')
        ? _focusSectionKey
        : _healthSectionKey;
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: kScrollToDuration,
        curve: kScrollToCurve,
      );
    }
  }

  Widget _buildSearchGroupedList(
    List<SearchResultItem> items,
    ScrollController controller,
  ) {
    final categories = <String, List<SearchResultItem>>{};
    for (final item in items) {
      categories.putIfAbsent(item.category, () => []).add(item);
    }
    return ListView(
      controller: controller,
      children: categories.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                entry.key.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...entry.value.map(
              (result) => ListTile(
                title: Text(result.title),
                onTap: () {
                  Navigator.of(context).pop();
                  _scrollToCategory(entry.key);
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  List<SearchResultItem> _filterSearchItems(
    String query,
    List<Subject> subjects,
    List<Milestone> milestones,
    List<FocusBlock> blocks,
  ) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const <SearchResultItem>[];
    final results = <SearchResultItem>[];
    for (final subject in subjects) {
      if (subject.name.toLowerCase().contains(q)) {
        results.add(
          SearchResultItem(
            category: 'Subjects',
            title: subject.name,
            id: subject.uuid,
          ),
        );
      }
      for (final module in subject.modules) {
        if (module.name.toLowerCase().contains(q)) {
          results.add(
            SearchResultItem(
              category: 'Modules',
              title: '${subject.name} • ${module.name}',
              id: subject.uuid,
            ),
          );
        }
      }
    }
    for (final block in blocks) {
      if (block.title.toLowerCase().contains(q)) {
        results.add(
          SearchResultItem(
            category: 'Focus Blocks',
            title: block.title,
            id: block.uuid,
          ),
        );
      }
    }
    for (final milestone in milestones) {
      if (milestone.title.toLowerCase().contains(q)) {
        results.add(
          SearchResultItem(
            category: 'Milestones',
            title: milestone.title,
            id: milestone.uuid,
          ),
        );
      }
    }
    return results;
  }

  Future<void> _openAddSubjectSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      builder: (_) => AddSubjectSheet(
        onSubmit: (subject, examMilestone) async {
          await ref.read(subjectNotifierProvider.notifier).addSubject(subject);
          if (examMilestone != null) {
            await ref
                .read(milestoneNotifierProvider.notifier)
                .addMilestone(examMilestone);
          }
        },
      ),
    );
  }

  Future<void> _openAddMilestoneSheet() async {
    final subjects =
        ref.read(allSubjectsProvider).valueOrNull ?? const <Subject>[];
    final selected = subjects.isNotEmpty ? subjects.first.uuid : null;
    final due = DateTime.now().add(const Duration(days: 7));
    final milestone = Milestone(
      uuid: const Uuid().v4(),
      title: 'New Milestone',
      description: 'Add details',
      linkedSubjectId: selected,
      dueDate: due,
      priority: plannerPriorityFromRemainingDays(
        due.difference(DateTime.now()).inDays,
      ),
      isCompleted: false,
      completedAt: null,
      checklistItems: const <String>['Prepare', 'Revise', 'Submit'],
      checklistCompleted: const <bool>[false, false, false],
    );
    await ref.read(milestoneNotifierProvider.notifier).addMilestone(milestone);
  }

  Future<void> _openMilestoneDetailSheet(Milestone milestone) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      builder: (_) => MilestoneDetailSheet(
        milestone: milestone,
        onToggleChecklist: (index, value) async {
          await ref
              .read(milestoneNotifierProvider.notifier)
              .updateChecklist(milestone.uuid, index, value);
        },
        onComplete: () => ref
            .read(milestoneNotifierProvider.notifier)
            .completeMilestone(milestone.uuid),
        onEdit: (title, description, dueDate) async {
          await ref
              .read(milestoneNotifierProvider.notifier)
              .addMilestone(
                Milestone(
                  id: milestone.id,
                  uuid: milestone.uuid,
                  title: title,
                  description: description,
                  linkedSubjectId: milestone.linkedSubjectId,
                  dueDate: dueDate,
                  priority: plannerPriorityFromRemainingDays(
                    dueDate.difference(DateTime.now()).inDays,
                  ),
                  isCompleted: milestone.isCompleted,
                  completedAt: milestone.completedAt,
                  checklistItems: milestone.checklistItems,
                  checklistCompleted: milestone.checklistCompleted,
                ),
              );
        },
      ),
    );
  }

  Future<void> _openAddFocusBlockSheet() async {
    final subjects =
        ref.read(allSubjectsProvider).valueOrNull ?? const <Subject>[];
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      builder: (_) => AddFocusBlockSheet(
        subjects: subjects,
        onSubmit: (block) =>
            ref.read(focusBlockNotifierProvider.notifier).addBlock(block),
      ),
    );
  }

  Future<void> _openBlockDetails(FocusBlock block) async {
    final subjects =
        ref.read(allSubjectsProvider).valueOrNull ?? const <Subject>[];
    final subjectName = subjects
        .where((s) => s.uuid == block.linkedSubjectId)
        .map((s) => s.name)
        .firstOrNull;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceCard,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subjectName ?? 'No linked subject',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 8),
                Text(
                  '${DateFormat.Hm().format(block.scheduledTime)} • ${block.durationMinutes} mins • ${block.sessionType}',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  onPressed: () async {
                    await ref
                        .read(focusBlockNotifierProvider.notifier)
                        .startFocusSession(block);
                    if (mounted) context.go('/pomodoro');
                  },
                  child: const Text('Start Focus Session'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await ref
                              .read(focusBlockNotifierProvider.notifier)
                              .completeBlock(block.uuid);
                          if (mounted) Navigator.of(context).pop();
                        },
                        child: const Text('Mark Complete'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await ref
                              .read(focusBlockNotifierProvider.notifier)
                              .deleteBlock(block.uuid);
                          if (mounted) Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.danger,
                        ),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlannerSkeletonBox extends StatelessWidget {
  const _PlannerSkeletonBox({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fade(begin: 0.35, end: 0.8, duration: kShimmerDuration);
  }
}

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0DFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.danger),
      ),
      child: Text(message, style: const TextStyle(color: AppTheme.textPrimary)),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
