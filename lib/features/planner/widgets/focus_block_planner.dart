import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/focus_block.dart';
import '../../../core/models/subject.dart';
import '../providers/focus_block_notifier.dart';
import '../providers/planner_providers.dart';
import 'focus_block_item.dart';
import 'focus_block_options_menu.dart';

class FocusBlockPlanner extends ConsumerWidget {
  const FocusBlockPlanner({
    required this.sectionKey,
    required this.subjects,
    required this.blocks,
    required this.loading,
    required this.onAddBlock,
    required this.onOpenBlock,
    super.key,
  });

  final GlobalKey sectionKey;
  final List<Subject> subjects;
  final List<FocusBlock> blocks;
  final bool loading;
  final VoidCallback onAddBlock;
  final Future<void> Function(FocusBlock block) onOpenBlock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: sectionKey,
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0DFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule, color: Color(0xFF06B6D4), size: 18),
              SizedBox(width: 8),
              Text(
                'Focus Block Planner',
                style: TextStyle(
                  color: Color(0xFFF0F0F0),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (blocks.isEmpty)
            const Text(
              'No blocks today. Add a focus block to stay on plan.',
              style: TextStyle(color: Color(0xFF555555)),
            )
          else
            ...blocks.map(
              (block) => FocusBlockItem(
                block: block,
                onOpenDetails: () => onOpenBlock(block),
                onOpenMenu: () => _openOptions(context, ref, block),
              ),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: FloatingActionButton.small(
              heroTag: 'planner-add-focus-block',
              backgroundColor: const Color(0xFF7C3AED),
              onPressed: onAddBlock,
              child: const Icon(Icons.timer, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOptions(
    BuildContext context,
    WidgetRef ref,
    FocusBlock block,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0D0D0D),
      builder: (_) => FocusBlockOptionsMenu(
        onStartNow: () async {
          await ref
              .read(focusBlockNotifierProvider.notifier)
              .startFocusSession(block);
          if (context.mounted) context.go('/pomodoro');
        },
        onEdit: () async {
          await onOpenBlock(block);
        },
        onDelete: () async {
          await ref
              .read(focusBlockNotifierProvider.notifier)
              .deleteBlock(block.uuid);
        },
        onComplete: () async {
          await ref
              .read(focusBlockNotifierProvider.notifier)
              .completeBlock(block.uuid);
        },
      ),
    );
  }
}
