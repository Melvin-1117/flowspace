import 'package:flutter/widgets.dart';

import 'task_board_screen.dart';

/// Shown inside [HomePage] when Focus tab strips should own the chrome.
/// Delegates to [TaskBoardScreen] without duplicate app bars / bottom nav.
class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const TaskBoardScreen(embedInShell: true);
}
