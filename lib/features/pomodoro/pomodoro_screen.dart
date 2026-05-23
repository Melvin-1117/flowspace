import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/app_bottom_nav.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../core/widgets/user_avatar.dart';
import 'providers/pomodoro_providers.dart';
import 'services/alarm_service.dart';
import 'services/flip_detector_service.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/flip_pause_overlay.dart';
import 'widgets/session_alarm_overlay.dart';
import 'widgets/session_complete_overlay.dart';
import 'widgets/session_history_card.dart';
import 'widgets/session_type_toggle.dart';
import 'widgets/timer_controls.dart';
import 'widgets/timer_ring.dart';
import 'widgets/trial_indicator.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: UserAvatar(size: 36),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Main Pomodoro screen content ──
            Column(
              children: [
                const Divider(height: 1, color: Color(0x16FFFFFF)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    child: Column(
                      children: [
                        SessionTypeToggle(onSwitchType: _confirmSwitchType),
                        const SizedBox(height: 18),
                        const TimerRing(),
                        const SizedBox(height: 12),
                        // Trial indicator — only visible during focus sessions
                        const TrialIndicator(),
                        const SizedBox(height: 16),
                        const TimerControls(),
                        const SizedBox(height: 18),
                        const DailyGoalCard(),
                        const SizedBox(height: 18),
                        const SessionHistoryCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Onboarding tooltip ──
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
                    child: const Text(
                      'Pomodoro: 25 min focus → 5 min break → repeat. Tap to dismiss.',
                      style: TextStyle(color: AppTheme.textPrimary),
                    ),
                  ),
                ),
              ),

            // ── Existing session complete overlay ──
            const SessionCompleteOverlay(),

            // ── Flip pause overlay (Feature 1) ──
            if (timerState.pausedByFlip) const FlipPauseOverlay(),

            // ── Session alarm overlay (Feature 3) ──
            if (ref.watch(alarmOverlayVisibleProvider))
              SessionAlarmOverlay(
                sessionNumber: ref.watch(sessionCountProvider),
                isLastBeforeLong: ref.watch(isLastBeforeLongProvider),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmSwitchType(SessionType nextType) async {
    final timerState = ref.read(timerNotifierProvider);
    if (timerState.sessionType == nextType) return;
    final hasProgress =
        timerState.remainingSeconds != timerState.totalDurationSeconds;
    var shouldSwitch = true;
    if (timerState.isRunning || hasProgress) {
      shouldSwitch =
          await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: AppTheme.surfaceCard,
              title: Text('Switch to ${nextType.label}?'),
              content: const Text('Current session will be lost.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ) ??
          false;
    }
    if (!shouldSwitch) return;
    await ref.read(timerNotifierProvider.notifier).switchType(nextType);
  }
}
