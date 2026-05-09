import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/models/task.dart';
import '../../widgets/app_drawer.dart';
import 'providers/task_providers.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/kanban_board.dart';
import 'widgets/new_task_sheet.dart';
import 'widgets/notification_sheet.dart';
import 'widgets/profile_sheet.dart';
import 'widgets/progress_breakdown_sheet.dart';
import 'widgets/quick_action_fab.dart';
import 'widgets/task_list_view.dart';

class TaskBoardScreen extends ConsumerStatefulWidget {
  const TaskBoardScreen({super.key, this.embedInShell = false});

  /// When true, hide [AppBar] and bottom navigation — used inside [HomePage]
  /// body so outer shell provides nav. Drawer & FAB stay on this [Scaffold].
  final bool embedInShell;

  @override
  ConsumerState<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends ConsumerState<TaskBoardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _searchOpen = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final projectState = ref.watch(projectProvider);
    final project = projectState.valueOrNull;
    final projectName = project?.name ?? 'Project Sprint: Nebula';
    final tasks = ref.watch(filteredTasksProvider);
    final allTasks = ref.watch(taskNotifierProvider).valueOrNull ?? <Task>[];
    final progress = ref.watch(projectProgressProvider);
    final notifications = ref.watch(notificationsProvider);
    final unreadCount = notifications.where((n) => n.unread).length;
    final filters = ref.watch(activeFiltersProvider);
    final viewMode = ref.watch(viewModeProvider);
    final online = ref.watch(syncOnlineProvider);
    final selected = ref.watch(selectedTasksProvider);

    final searchedTasks = _searchQuery.isEmpty
        ? tasks
        : tasks.where((task) {
            final q = _searchQuery.toLowerCase();
            return task.title.toLowerCase().contains(q) ||
                task.description.toLowerCase().contains(q) ||
                task.tag.toLowerCase().contains(q);
          }).toList();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xFF000000),
        drawer: const AppDrawer(),
        appBar: widget.embedInShell
            ? null
            : AppBar(
                backgroundColor: const Color(0xFF000000),
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                actions: [
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: const Color(0xFF0D0D0D),
                            isScrollControlled: true,
                            builder: (_) =>
                                NotificationSheet(notifications: notifications),
                          );
                        },
                        icon: const Icon(Icons.notifications_none),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          backgroundColor: const Color(0xFF0D0D0D),
                          builder: (_) => const ProfileSheet(),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF1A1A1A),
                        child: Text('FS', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                ],
              ),
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (widget.embedInShell)
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 40,
                                    minHeight: 40,
                                  ),
                                  icon: const Icon(Icons.menu_outlined),
                                  onPressed: () =>
                                      _scaffoldKey.currentState?.openDrawer(),
                                  tooltip: 'Menu',
                                ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _renameProjectDialog(
                                    context,
                                    projectName,
                                  ),
                                  child: Text(
                                    projectName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFF0F0F0),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _showTeamSheet(context),
                                child: const CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Color(0xFF1A1A1A),
                                  child: Text(
                                    '+4',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    backgroundColor: const Color(0xFF0D0D0D),
                                    builder: (_) => ProgressBreakdownSheet(
                                      tasks: allTasks,
                                      progress: progress,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF06B6D4),
                                        shape: BoxShape.circle,
                                      ),
                                    ).animate().scale(
                                      begin: const Offset(0.8, 0.8),
                                      end: const Offset(1.15, 1.15),
                                      duration: const Duration(
                                        milliseconds: 450,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${(progress * 100).round()}% COMPLETE',
                                      style: const TextStyle(
                                        letterSpacing: 1.4,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              if (!online)
                                const Text(
                                  'OFFLINE',
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final narrow = constraints.maxWidth < 460;
                              final togglesRow = Row(
                                children: [
                                  Expanded(
                                    child: _viewToggleButton(
                                      icon: Icons.view_kanban_outlined,
                                      title: 'Kanban',
                                      active: viewMode == ViewMode.kanban,
                                      onTap: () =>
                                          ref
                                              .read(viewModeProvider.notifier)
                                              .state = ViewMode
                                              .kanban,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _viewToggleButton(
                                      icon: Icons.format_list_bulleted,
                                      title: 'List',
                                      active: viewMode == ViewMode.list,
                                      onTap: () =>
                                          ref
                                              .read(viewModeProvider.notifier)
                                              .state = ViewMode
                                              .list,
                                    ),
                                  ),
                                ],
                              );
                              final filterBtn = IconButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: const Color(0xFF0D0D0D),
                                    builder: (_) => const FilterSheet(),
                                  );
                                },
                                icon: Stack(
                                  children: [
                                    const Icon(Icons.filter_list),
                                    if (filters.activeCount > 0)
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: CircleAvatar(
                                          radius: 7,
                                          backgroundColor: const Color(
                                            0xFFEF4444,
                                          ),
                                          child: Text(
                                            filters.activeCount.toString(),
                                            style: const TextStyle(fontSize: 8),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                              final newBtn = ElevatedButton(
                                onPressed: () => _openNewTaskSheet(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7C3AED),
                                  foregroundColor: const Color(0xFFF0F0F0),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('New Task'),
                              );
                              if (narrow) {
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    togglesRow,
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        filterBtn,
                                        const SizedBox(width: 4),
                                        Expanded(child: newBtn),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _viewToggleButton(
                                            icon: Icons.view_kanban_outlined,
                                            title: 'Kanban',
                                            active: viewMode == ViewMode.kanban,
                                            onTap: () =>
                                                ref
                                                    .read(
                                                      viewModeProvider.notifier,
                                                    )
                                                    .state = ViewMode
                                                    .kanban,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _viewToggleButton(
                                            icon: Icons.format_list_bulleted,
                                            title: 'List',
                                            active: viewMode == ViewMode.list,
                                            onTap: () =>
                                                ref
                                                    .read(
                                                      viewModeProvider.notifier,
                                                    )
                                                    .state = ViewMode
                                                    .list,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  filterBtn,
                                  const SizedBox(width: 4),
                                  newBtn,
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        if (viewMode == ViewMode.kanban) {
                          return KanbanBoard(
                            tasks: searchedTasks,
                            maxWidth: constraints.hasBoundedWidth
                                ? constraints.maxWidth
                                : null,
                          );
                        }
                        return TaskListView(tasks: searchedTasks);
                      },
                    ),
                  ),
                ],
              ),
              if (_searchOpen) _buildSearchOverlay(searchedTasks),
            ],
          ),
        ),
        floatingActionButton: QuickActionFab(
          onAddTask: () => _openNewTaskSheet(context),
          onSearch: () => setState(() => _searchOpen = true),
          onStartFocus: () => context.go('/focus'),
        ),
        bottomNavigationBar: widget.embedInShell
            ? null
            : _buildBottomNavigation(context),
        bottomSheet: selected.isEmpty
            ? null
            : Container(
                color: const Color(0xFF0D0D0D),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text('${selected.length} selected'),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          final notifier = ref.read(
                            taskNotifierProvider.notifier,
                          );
                          for (final id in selected) {
                            await notifier.moveTask(id, 'inprogress');
                          }
                          ref.read(selectedTasksProvider.notifier).state = [];
                        },
                        child: const Text('Move to'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final notifier = ref.read(
                            taskNotifierProvider.notifier,
                          );
                          for (final id in selected) {
                            await notifier.updatePriority(id, 'high');
                          }
                          ref.read(selectedTasksProvider.notifier).state = [];
                        },
                        child: const Text('Priority'),
                      ),
                      TextButton(
                        onPressed: () async {
                          final notifier = ref.read(
                            taskNotifierProvider.notifier,
                          );
                          for (final id in selected) {
                            await notifier.deleteTask(id);
                          }
                          ref.read(selectedTasksProvider.notifier).state = [];
                        },
                        child: const Text('Delete'),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.read(selectedTasksProvider.notifier).state = [],
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _viewToggleButton({
    required IconData icon,
    required String title,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A1A1A) : const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0x22FFFFFF)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: active ? const Color(0xFFF0F0F0) : const Color(0xFF555555),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: active
                    ? const Color(0xFFF0F0F0)
                    : const Color(0xFF555555),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF000000),
      selectedItemColor: const Color(0xFF7C3AED),
      unselectedItemColor: const Color(0xFF555555),
      currentIndex: 1,
      onTap: (index) {
        if (index == 0) context.go('/focus');
        if (index == 1) context.go('/tasks');
        if (index == 2) context.go('/pomodoro');
        if (index == 3) context.go('/planner');
        if (index == 4) context.go('/settings');
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.timer_outlined),
          label: 'Focus',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Tasks'),
        BottomNavigationBarItem(
          icon: Icon(Icons.hourglass_top_rounded),
          activeIcon: Icon(Icons.hourglass_bottom_rounded),
          label: 'Pomo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Planner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.code_outlined),
          activeIcon: Icon(Icons.code),
          label: 'GitHub',
        ),
      ],
    );
  }

  Widget _buildSearchOverlay(List<Task> searchedTasks) {
    return Positioned.fill(
      child: Material(
        color: const Color(0xEE000000),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(color: Color(0xFFF0F0F0)),
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    suffixIcon: IconButton(
                      onPressed: () => setState(() {
                        _searchOpen = false;
                        _searchQuery = '';
                      }),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchedTasks.length,
                  itemBuilder: (context, index) {
                    final task = searchedTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.tag),
                      trailing: Text(
                        task.dueDate == null
                            ? ''
                            : DateFormat('MMM d').format(task.dueDate!),
                      ),
                      onTap: () {
                        setState(() => _searchOpen = false);
                        context.push('/tasks/${task.uuid}');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _renameProjectDialog(
    BuildContext context,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF0D0D0D),
        title: const Text('Rename project'),
        content: TextField(
          controller: controller,
          maxLength: 40,
          decoration: const InputDecoration(hintText: 'Project name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              ref.read(projectProvider.notifier).rename(name);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _openNewTaskSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0D0D0D),
      builder: (_) => const NewTaskSheet(),
    );
  }

  Future<void> _showTeamSheet(BuildContext context) async {
    final members = ref.read(teamMembersProvider);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final member in members)
              ListTile(
                leading: CircleAvatar(child: Text(member.initials)),
                title: Text(member.name),
                trailing: Chip(label: Text(member.role)),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Invite Member'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
