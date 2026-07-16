import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/theme.dart';
import 'providers/focus_lock_notifier.dart';
import 'services/focus_lock_flip_detector.dart';
import 'widgets/breathing_guide.dart';
import 'widgets/session_complete_overlay.dart';
import 'widgets/session_void_overlay.dart';
import 'widgets/strike_warning_overlay.dart';

/// The locked session screen — appears only when the phone is flipped face down.
///
/// All navigation is disabled via [PopScope] during active session.
/// Uses [WidgetsBindingObserver] to detect app backgrounding (→ strike).
/// WakeLock keeps the screen on.
class FocusLockActiveScreen extends ConsumerStatefulWidget {
  const FocusLockActiveScreen({
    required this.durationMinutes,
    super.key,
  });

  final int durationMinutes;

  @override
  ConsumerState<FocusLockActiveScreen> createState() =>
      _FocusLockActiveScreenState();
}

class _FocusLockActiveScreenState extends ConsumerState<FocusLockActiveScreen>
    with WidgetsBindingObserver {
  late final FocusLockFlipDetector _flipDetector;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    _flipDetector = ref.read(focusLockFlipDetectorProvider);

    // Prepare and start session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(focusLockNotifierProvider.notifier);
      notifier.prepareSession(widget.durationMinutes);
      // Start the detector — it will call onPhoneFlippedDown immediately
      // since the phone should already be face down
      _flipDetector.startMonitoring(ref);
      // Also directly start as active since we arrived here from a flip
      notifier.onPhoneFlippedDown();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _flipDetector.stopMonitoring();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // App backgrounded → treat as phone lifted → strike
      final lockState = ref.read(focusLockNotifierProvider);
      if (lockState.status == FocusLockStatus.active) {
        ref.read(focusLockNotifierProvider.notifier).addStrikeFromBackground();
      }
    }
  }

  void _showLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Session is locked — keep your phone face down',
          style: GoogleFonts.spaceGrotesk(fontSize: 13),
        ),
        backgroundColor: AppTheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(focusLockNotifierProvider);

    // Allow navigation only when session is over (void or complete)
    final canPop =
        lockState.isVoid || lockState.isComplete;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _showLockedMessage();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: Stack(
          children: [
            // ── Main locked screen body ─────────────────────────────────
            _FocusLockBody(lockState: lockState),

            // ── Strike warning overlay ──────────────────────────────────
            if (lockState.showStrikeWarning)
              StrikeWarningOverlay(
                strikeNumber: lockState.strikes,
                onDismiss: () => ref
                    .read(focusLockNotifierProvider.notifier)
                    .dismissStrikeWarning(),
              ),

            // ── Session void overlay ────────────────────────────────────
            if (lockState.isVoid)
              SessionVoidOverlay(
                durationAttempted: widget.durationMinutes,
                timeCompletedSeconds: lockState.elapsedSeconds,
              ),

            // ── Session complete overlay ─────────────────────────────────
            if (lockState.isComplete)
              SessionCompleteOverlay(
                durationMinutes: widget.durationMinutes,
                strikes: lockState.strikes,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Main locked body ─────────────────────────────────────────────────────────
class _FocusLockBody extends StatelessWidget {
  const _FocusLockBody({required this.lockState});

  final FocusLockState lockState;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // ── Top strip ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Lock indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_rounded,
                          color: AppTheme.primary, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'LOCKED',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),

                // Strike counter dots
                Row(
                  children: List.generate(3, (i) {
                    final isStrike = i < lockState.strikes;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isStrike
                              ? AppTheme.danger
                              : AppTheme.surfaceBorder,
                          boxShadow: isStrike
                              ? [
                                  BoxShadow(
                                    color:
                                        AppTheme.danger.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const Spacer(),

          // ── Central timer ──────────────────────────────────────────────
          Column(
            children: [
              // Session type label
              Text(
                'FOCUS LOCK',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Large countdown
              Text(
                lockState.formattedTime,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 80,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -4,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),

              const SizedBox(height: 16),

              // Progress bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: lockState.progress,
                    backgroundColor: AppTheme.surfaceBorder,
                    valueColor:
                        const AlwaysStoppedAnimation(AppTheme.primary),
                    minHeight: 4,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                '${(lockState.progress * 100).round()}% complete',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Breathing guide ────────────────────────────────────────────
          const BreathingGuide(),

          const SizedBox(height: 16),

          // ── Bottom instruction ─────────────────────────────────────────
          Text(
            'Keep phone face down to maintain session',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Lifting phone = 1 strike',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 11,
              color: lockState.strikes > 0
                  ? AppTheme.danger
                  : AppTheme.surfaceBorder,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
