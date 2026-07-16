import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../core/widgets/user_avatar.dart';
import 'providers/focus_lock_notifier.dart';
import 'services/focus_lock_flip_detector.dart';
import 'widgets/duration_chip.dart';
import 'widgets/phone_flip_illustration.dart';
import 'widgets/today_focus_lock_stats.dart';

/// Entry screen for Focus Lock Mode.
///
/// User picks a duration, sees rules, then flips phone face-down to begin.
/// The accelerometer listener starts here and navigates to the active screen.
class FocusLockScreen extends ConsumerStatefulWidget {
  const FocusLockScreen({super.key});

  @override
  ConsumerState<FocusLockScreen> createState() => _FocusLockScreenState();
}

class _FocusLockScreenState extends ConsumerState<FocusLockScreen> {
  int _selectedMinutes = 25;
  bool _isCustom = false;
  bool _isListening = false;
  late final FocusLockFlipDetector _flipDetector;

  @override
  void initState() {
    super.initState();
    _flipDetector = ref.read(focusLockFlipDetectorProvider);
    // Reset any previous session state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(focusLockNotifierProvider.notifier).reset();
    });
  }

  @override
  void dispose() {
    // Stop accelerometer if still monitoring
    if (_isListening) {
      _flipDetector.stopMonitoring();
    }
    super.dispose();
  }

  void _startListeningForFlip() {
    if (_isListening) return;

    // Prepare the session in the notifier
    ref
        .read(focusLockNotifierProvider.notifier)
        .prepareSession(_selectedMinutes);

    // Start accelerometer monitoring
    ref.read(focusLockFlipDetectorProvider).startMonitoring(ref);
    _isListening = true;
  }

  void _showCustomDurationSheet() {
    final controller = TextEditingController(
      text: _isCustom ? '$_selectedMinutes' : '',
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            24 + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Duration',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter minutes (5–120)',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '25',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textMuted,
                  ),
                  suffix: Text(
                    'minutes',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.surfaceBorder),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final value = int.tryParse(controller.text);
                    if (value != null && value >= 5 && value <= 120) {
                      setState(() {
                        _selectedMinutes = value;
                        _isCustom = true;
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Set Duration',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes — navigate to active screen when flip is detected
    ref.listen(focusLockNotifierProvider, (prev, next) {
      if (next.status == FocusLockStatus.active && mounted) {
        // Phone was flipped down → navigate to active screen
        // Stop the entry-screen detector; the active screen manages its own
        ref.read(focusLockFlipDetectorProvider).stopMonitoring();
        _isListening = false;
        context.go('/focus-lock/active', extra: _selectedMinutes);
      }
    });

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: CustomScrollView(
          slivers: [
            // ── App bar ──────────────────────────────────────────────────
            SliverAppBar(
              backgroundColor: AppTheme.background,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppTheme.textSecondary),
                onPressed: () => context.pop(),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FOCUS LOCK',
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
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: UserAvatar(size: 32),
                ),
              ],
            ),

            // ── Body ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Hero section ───────────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          const PhoneFlipIllustration(),
                          const SizedBox(height: 24),
                          Text(
                            'Focus Lock Mode',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                              letterSpacing: -0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Flip your phone face down to begin.\nStay locked in — no distractions.',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15,
                              color: AppTheme.textSecondary,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // ── Duration picker ──────────────────────────────────
                    Text(
                      'SESSION DURATION',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // First row: 5, 10, 15, 25, 30, 45
                    Row(
                      children: [5, 10, 15, 25, 30, 45]
                          .expand<Widget>((mins) => [
                                DurationChip(
                                  minutes: mins,
                                  isSelected:
                                      _selectedMinutes == mins && !_isCustom,
                                  onTap: () => setState(() {
                                    _selectedMinutes = mins;
                                    _isCustom = false;
                                  }),
                                ),
                                if (mins != 45) const SizedBox(width: 6),
                              ])
                          .toList(),
                    ),

                    const SizedBox(height: 10),

                    // Second row: 60, 90, 120 + Custom
                    Row(
                      children: [
                        ...[60, 90, 120].expand<Widget>((mins) => [
                              DurationChip(
                                minutes: mins,
                                isSelected:
                                    _selectedMinutes == mins && !_isCustom,
                                onTap: () => setState(() {
                                  _selectedMinutes = mins;
                                  _isCustom = false;
                                }),
                              ),
                              const SizedBox(width: 6),
                            ]),
                        // Custom chip
                        Expanded(
                          child: GestureDetector(
                            onTap: _showCustomDurationSheet,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isCustom
                                    ? AppTheme.primary.withValues(alpha: 0.15)
                                    : AppTheme.surfaceCard,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.radiusSM),
                                border: Border.all(
                                  color: _isCustom
                                      ? AppTheme.primary
                                      : AppTheme.surfaceBorder,
                                  width: _isCustom ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _isCustom
                                      ? '${_selectedMinutes}m ✎'
                                      : 'Custom',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: _isCustom
                                        ? AppTheme.primary
                                        : AppTheme.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── Selected duration display ────────────────────────
                    Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          '$_selectedMinutes minutes of pure focus',
                          key: ValueKey(_selectedMinutes),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Strike rules card ────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.surfaceBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shield_rounded,
                                  color: AppTheme.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'HOW FOCUS LOCK WORKS',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primary,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _RuleRow(
                            icon: Icons.phone_android_rounded,
                            iconColor: AppTheme.success,
                            text: 'Flip phone face DOWN to start session',
                          ),
                          const SizedBox(height: 10),
                          _RuleRow(
                            icon: Icons.lock_rounded,
                            iconColor: AppTheme.primary,
                            text: 'Screen locks — only timer visible',
                          ),
                          const SizedBox(height: 10),
                          _RuleRow(
                            icon: Icons.warning_amber_rounded,
                            iconColor: AppTheme.warning,
                            text: 'Lifting phone = 1 strike (max 3)',
                          ),
                          const SizedBox(height: 10),
                          _RuleRow(
                            icon: Icons.cancel_rounded,
                            iconColor: AppTheme.danger,
                            text: '3 strikes = session void, not saved',
                          ),
                          const SizedBox(height: 10),
                          _RuleRow(
                            icon: Icons.emoji_events_rounded,
                            iconColor: AppTheme.warning,
                            text: 'Complete session = saved to DevTrack',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Flip CTA ─────────────────────────────────────────
                    GestureDetector(
                      onTap: _startListeningForFlip,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primary.withValues(alpha: 0.15),
                              AppTheme.accent.withValues(alpha: 0.08),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.screen_rotation_rounded,
                              color: AppTheme.primary,
                              size: 40,
                            )
                                .animate(onPlay: (c) => c.repeat())
                                .rotate(
                                  begin: 0,
                                  end: 0.5,
                                  duration: 3000.ms,
                                  curve: Curves.easeInOut,
                                )
                                .then()
                                .rotate(
                                  begin: 0.5,
                                  end: 0,
                                  duration: 3000.ms,
                                  curve: Curves.easeInOut,
                                ),
                            const SizedBox(height: 12),
                            Text(
                              _isListening
                                  ? 'Waiting for flip...'
                                  : 'Ready to lock in?',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isListening
                                  ? 'Flip your phone face down now'
                                  : 'Tap here, then flip your phone\nface down to begin',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Today's stats ─────────────────────────────────────
                    const TodayFocusLockStats(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Rule row widget ──────────────────────────────────────────────────────────
class _RuleRow extends StatelessWidget {
  const _RuleRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  final IconData icon;
  final Color iconColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
