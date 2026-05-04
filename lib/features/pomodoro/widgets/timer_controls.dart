import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';

class TimerControls extends ConsumerWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(timerRunningProvider);
    final notifier = ref.read(timerNotifierProvider.notifier);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScaleTapButton(
          onTap: () async {
            if (isRunning) {
              await notifier.pause();
            } else {
              await notifier.start();
            }
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Color(0x807C3AED), blurRadius: 16),
              ],
            ),
            child: Icon(
              isRunning ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 12),
        _ScaleTapButton(
          onTap: () async {
            if (isRunning) {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF0D0D0D),
                  title: const Text('Reset timer?'),
                  content: const Text('Current progress will be lost.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                      ),
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;
            }
            await notifier.reset();
          },
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF262626)),
            ),
            child: const Icon(
              Icons.refresh,
              color: Color(0xFFF0F0F0),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScaleTapButton extends StatefulWidget {
  const _ScaleTapButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_ScaleTapButton> createState() => _ScaleTapButtonState();
}

class _ScaleTapButtonState extends State<_ScaleTapButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
