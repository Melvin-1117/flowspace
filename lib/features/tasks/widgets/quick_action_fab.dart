import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme.dart';

class QuickActionFab extends StatefulWidget {
  const QuickActionFab({
    super.key,
    required this.onAddTask,
    required this.onSearch,
    required this.onStartFocus,
  });

  final VoidCallback onAddTask;
  final VoidCallback onSearch;
  final VoidCallback onStartFocus;

  @override
  State<QuickActionFab> createState() => _QuickActionFabState();
}

class _QuickActionFabState extends State<QuickActionFab> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _actionButton(
          icon: Icons.search,
          color: AppTheme.surfaceElevated,
          onTap: widget.onSearch,
        ),
        const SizedBox(height: 10),
        _actionButton(
          icon: Icons.bolt,
          color: AppTheme.surfaceElevated,
          onTap: () => setState(() => _expanded = !_expanded),
        ),
        if (_expanded) ...[
          const SizedBox(height: 10),
          _dialOption(
            'Add Task',
            AppTheme.primary,
            Icons.add,
            widget.onAddTask,
          ),
          const SizedBox(height: 8),
          _dialOption(
            'Start Focus',
            AppTheme.accent,
            Icons.timer,
            widget.onStartFocus,
          ),
          const SizedBox(height: 8),
          _dialOption(
            'Add Note',
            AppTheme.textSecondary,
            Icons.note_add,
            () {},
          ),
        ],
        const SizedBox(height: 12),
        GestureDetector(
          onTapDown: (_) => setState(() {}),
          onTap: widget.onAddTask,
          child:
              Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(blurRadius: 16, color: Color(0x807C3AED)),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 30),
                  )
                  .animate(onPlay: (controller) => controller.forward())
                  .scale(
                    begin: const Offset(0.96, 0.96),
                    end: const Offset(1, 1),
                  ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x22FFFFFF)),
        ),
        child: Icon(icon, color: AppTheme.textPrimary),
      ),
    );
  }

  Widget _dialOption(
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(label),
          ),
          const SizedBox(width: 8),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18),
          ),
        ],
      ),
    );
  }
}
