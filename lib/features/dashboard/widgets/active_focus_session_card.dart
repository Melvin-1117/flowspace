import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/pomodoro_session.dart';
import '../../../core/providers/session_timer_provider.dart';

class ActiveFocusSessionCard extends ConsumerWidget {
  const ActiveFocusSessionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(activeSessionProvider);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.2), // slides down from above
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: session == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: _SessionCardContent(
                session: session,
                key: const ValueKey('active_card'),
              ),
            ),
    );
  }
}

class _SessionCardContent extends ConsumerWidget {
  final PomodoroSession session;

  const _SessionCardContent({required this.session, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(sessionRunningProvider);
    final formattedTime = ref.watch(formattedTimeProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1F1235).withValues(alpha: 0.8),
                const Color(0xFF0F0C16).withValues(alpha: 0.9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Indicator Row
              Row(
                children: [
                  Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7C3AED),
                          shape: BoxShape.circle,
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.4, 1.4),
                        duration: 600.ms,
                        curve: Curves.easeInOut,
                      )
                      .fade(
                        begin: 1.0,
                        end: 0.4,
                        duration: 600.ms,
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(width: 12),
                  const Text(
                    'ACTIVE FOCUS SESSION',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF7C3AED),
                      fontSize: 11,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Task Title
              Tooltip(
                message: session.linkedTaskTitle,
                child: Text(
                  session.linkedTaskTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF0F0F0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Info Row
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    color: Color(0xFF555555),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Remaining:',
                        style: TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: Color(0xFFF0F0F0),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  if (session.totalSubtasks > 0) ...[
                    const SizedBox(width: 24),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFF262626),
                    ),
                    const SizedBox(width: 24),

                    const Icon(
                      Icons.check_circle_outline,
                      color: Color(0xFF555555),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${session.completedSubtasks}',
                                style: const TextStyle(
                                  color: Color(0xFF7C3AED),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              TextSpan(
                                text: ' of ${session.totalSubtasks}',
                                style: const TextStyle(
                                  color: Color(0xFF555555),
                                  fontSize: 13,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'subtasks',
                          style: TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 13,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: _ScaleButton(
                        onTap: () {
                          if (isRunning) {
                            ref
                                .read(sessionTimerProvider.notifier)
                                .pauseTimer();
                          } else {
                            ref
                                .read(sessionTimerProvider.notifier)
                                .resumeTimer();
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isRunning
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF262626),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isRunning
                                ? [
                                    BoxShadow(
                                      color: const Color(
                                        0xFF7C3AED,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 12,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              isRunning ? 'Pause Focus' : 'Resume Focus',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: _ScaleButton(
                        onTap: () {
                          try {
                            context.push('/pomodoro');
                          } catch (
                            _
                          ) {} // Avoid crash if routing isn't set up yet
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF262626)),
                          ),
                          child: const Center(
                            child: Text(
                              'View Plan',
                              style: TextStyle(
                                color: Color(0xFFF0F0F0),
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: !isRunning
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Center(
                          child: Text(
                            'Session paused � resume to continue',
                            style: TextStyle(
                              color: Colors.red[400],
                              fontSize: 12,
                              fontFamily: 'Inter',
                            ),
                          ).animate().fade().slideY(begin: 0.2, end: 0),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ScaleButton({required this.child, required this.onTap});

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
