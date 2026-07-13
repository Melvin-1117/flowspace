import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/animation_tokens.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../core/widgets/user_avatar.dart';
import 'providers/pomodoro_providers.dart';
import 'services/alarm_service.dart';
import 'services/flip_detector_service.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/flip_pause_overlay.dart';
import 'widgets/session_alarm_overlay.dart';
import 'widgets/session_history_card.dart';
import 'widgets/session_type_toggle.dart';
import 'widgets/timer_controls.dart';
import 'widgets/timer_ring.dart';
import 'widgets/trial_indicator.dart';
import 'widgets/link_task_sheet.dart';

// New redesigned widgets
import 'widgets/linked_task_card.dart';
import 'widgets/editable_timing_card.dart';
import 'widgets/focus_stats_row.dart';
import 'widgets/completion_celebration_overlay.dart';
import 'widgets/timer_settings_sheet.dart';

import '../../app/theme.dart';

class PomodoroScreen extends ConsumerStatefulWidget {
  const PomodoroScreen({super.key});

  @override
  ConsumerState<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends ConsumerState<PomodoroScreen>
    with WidgetsBindingObserver {
  bool _showOnboarding = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadOnboarding();
  }

  Future<void> _loadOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('pomodoro_tooltip_seen') ?? false;
    if (!mounted) return;
    setState(() => _showOnboarding = !seen);
  }

  Future<void> _dismissOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pomodoro_tooltip_seen', true);
    if (!mounted) return;
    setState(() => _showOnboarding = false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(timerNotifierProvider.notifier).syncWithClock();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Ensure flip detection is stopped when screen disposes
    ref.read(flipDetectorProvider).stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerNotifierProvider);
    final flipDetector = ref.read(flipDetectorProvider);

    // Start or stop flip detection based on timer state
    ref.listen(timerNotifierProvider, (previous, next) {
      if (next.isRunning && next.sessionType == SessionType.focus) {
        flipDetector.startListening();
      } else if (!next.isRunning && !next.pausedByFlip) {
        flipDetector.stopListening();
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            CustomScrollView(
              slivers: [
                // Redesigned collapsable app bar
                SliverAppBar(
                  backgroundColor: AppTheme.background,
                  floating: true,
                  snap: true,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.menu_rounded, color: Colors.white),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FOCUS TIMER',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'FlowSpace',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    // WakeLock indicator (visible when running)
                    Consumer(builder: (context, ref, _) {
                      final isRunning = ref.watch(
                        timerNotifierProvider.select((s) => s.isRunning),
                      );
                      if (!isRunning) return const SizedBox.shrink();
                      return const Tooltip(
                        message: 'Screen staying on during session',
                        child: Icon(
                          Icons.screen_lock_rotation_rounded,
                          color: AppTheme.primary,
                          size: 20,
                        ),
                      );
                    }),

                    const SizedBox(width: 8),

                    // Settings shortcut
                    IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: AppTheme.textSecondary,
                      ),
                      tooltip: 'Timer settings',
                      onPressed: () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const TimerSettingsSheet(),
                      ),
                    ),

                    // User avatar
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: UserAvatar(size: 32),
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      const SessionTypeToggle()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, curve: kPageEntryCurve),
                      const SizedBox(height: 24),
                      const TimerRing()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep, curve: kPageEntryCurve),
                      const SizedBox(height: 20),
                      const TrialIndicator()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 2, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 2, curve: kPageEntryCurve),
                      const SizedBox(height: 20),
                      const TimerControls()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 3, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 3, curve: kPageEntryCurve),
                      const SizedBox(height: 24),
                      LinkedTaskCard(
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const LinkTaskSheet(),
                          );
                        },
                      )
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve),
                      const SizedBox(height: 16),
                      const EditableTimingCard()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve),
                      const SizedBox(height: 16),
                      const FocusStatsRow()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve),
                      const SizedBox(height: 16),
                      const DailyGoalCard()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 4, curve: kPageEntryCurve),
                      const SizedBox(height: 16),
                      const SessionHistoryCard()
                          .animate()
                          .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 5, curve: kPageEntryCurve)
                          .slideY(begin: 0.06, end: 0, duration: kPageEntryDuration, delay: kPageStaggerStep * 5, curve: kPageEntryCurve),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),

            // Onboarding tooltip
            if (_showOnboarding)
              Positioned(
                top: 82,
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: _dismissOnboarding,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryGlow),
                    ),
                    child: Text(
                      'Pomodoro: 25 min focus → 5 min break → repeat. Tap to dismiss.',
                      style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary),
                    ),
                  ),
                ),
              ),

            // Overlays
            if (timerState.pausedByFlip) const FlipPauseOverlay(),

            if (ref.watch(alarmOverlayVisibleProvider))
              SessionAlarmOverlay(
                sessionNumber: ref.watch(sessionCountProvider),
                isLastBeforeLong: ref.watch(isLastBeforeLongProvider),
              ),

            if (ref.watch(showCompletionCelebrationProvider))
              const CompletionCelebrationOverlay(),
          ],
        ),
      ),
    );
  }
}
