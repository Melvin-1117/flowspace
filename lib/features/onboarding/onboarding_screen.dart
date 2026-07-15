import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../core/models/user_profile.dart';
import '../../core/models/focus_goal_settings.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/onboarding_service.dart';
import '../pomodoro/providers/pomodoro_providers.dart';
import '../pomodoro/providers/pomodoro_web_store.dart';

import 'steps/step1_identity.dart';
import 'steps/step2_academic.dart';
import 'steps/step3_developer.dart';
import 'steps/step4_goals.dart';
import 'steps/step5_personalize.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isLoading = false;

  // Shared data collected across all steps
  final _data = OnboardingData();

  // Page controller for smooth transitions
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // Subtle background glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Back button
                      if (_currentStep > 0)
                        GestureDetector(
                          onTap: _goBack,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.surfaceBorder),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppTheme.textSecondary,
                              size: 20,
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),

                      const Spacer(),

                      // Step counter
                      Text(
                        '${_currentStep + 1} of $_totalSteps',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      // Skip button (steps 3-4 only)
                      if (_currentStep >= 2 && _currentStep <= 3)
                        GestureDetector(
                          onTap: _goNext,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              'Skip',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox(width: 40),
                    ],
                  ),
                ),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: List.generate(_totalSteps, (i) {
                      final isComplete = i < _currentStep;
                      final isActive = i == _currentStep;
                      return Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            right: i < _totalSteps - 1 ? 4 : 0,
                          ),
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: isComplete || isActive
                                ? AppTheme.primary
                                : AppTheme.surfaceBorder,
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 8),

                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OnboardingStep1Identity(
                        data: _data,
                        onValidationChanged: () => setState(() {}),
                      ),
                      OnboardingStep2Academic(
                        data: _data,
                        onValidationChanged: () => setState(() {}),
                      ),
                      OnboardingStep3Developer(data: _data),
                      OnboardingStep4Goals(data: _data),
                      OnboardingStep5Personalize(data: _data),
                    ],
                  ),
                ),

                // Bottom CTA
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCurrentStepValid() ? _goNext : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        disabledBackgroundColor: AppTheme.primary.withValues(
                          alpha: 0.3,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _isLastStep()
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Launch FlowSpace',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.rocket_launch_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            )
                          : Text(
                              'Continue',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isCurrentStepValid() => switch (_currentStep) {
    0 => _data.displayName.trim().length >= 2,
    1 => _data.courseName.trim().isNotEmpty && _data.semesterName.isNotEmpty,
    2 => true, // optional step
    3 => true, // optional step
    4 => true, // optional step
    _ => false,
  };

  bool _isLastStep() => _currentStep == _totalSteps - 1;

  void _goNext() {
    if (_isLastStep()) {
      _completeOnboarding();
      return;
    }
    setState(() => _currentStep++);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  void _goBack() {
    if (_currentStep == 0) return;
    setState(() => _currentStep--);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      // Save UserProfile
      await ref
          .read(userProfileProvider.notifier)
          .saveProfile(_data.toUserProfile());

      if (!mounted) return;

      // Update timer settings
      if (!kIsWeb) {
        final settings = await ref.read(focusGoalSettingsProvider.future);
        if (!mounted) return;
        final updatedSettings = FocusGoalSettings()
          ..id = settings.id
          ..focusDuration = settings.focusDuration
          ..shortBreakDuration = settings.shortBreakDuration
          ..longBreakDuration = settings.longBreakDuration
          ..dailySessionGoal = _data.dailySessionGoal
          ..longBreakInterval = settings.longBreakInterval
          ..autoStartBreaks = _data.autoStartBreaks
          ..autoStartFocus = _data.autoStartFocus
          ..ambientVolume = settings.ambientVolume
          ..musicVolume = settings.musicVolume
          ..lastAmbientSound = settings.lastAmbientSound
          ..wasTimerRunning = settings.wasTimerRunning
          ..remainingSecondsOnKill = settings.remainingSecondsOnKill
          ..sessionTypeOnKill = settings.sessionTypeOnKill
          ..killTimestamp = settings.killTimestamp;
        await ref
            .read(focusGoalSettingsUpdaterProvider.notifier)
            .updateSettings(updatedSettings);
      } else {
        final settings = PomodoroWebStore.instance.ensureSettings();
        final updatedSettings = FocusGoalSettings()
          ..focusDuration = settings.focusDuration
          ..shortBreakDuration = settings.shortBreakDuration
          ..longBreakDuration = settings.longBreakDuration
          ..dailySessionGoal = _data.dailySessionGoal
          ..longBreakInterval = settings.longBreakInterval
          ..autoStartBreaks = _data.autoStartBreaks
          ..autoStartFocus = _data.autoStartFocus
          ..ambientVolume = settings.ambientVolume
          ..musicVolume = settings.musicVolume
          ..lastAmbientSound = settings.lastAmbientSound
          ..wasTimerRunning = settings.wasTimerRunning
          ..remainingSecondsOnKill = settings.remainingSecondsOnKill
          ..sessionTypeOnKill = settings.sessionTypeOnKill
          ..killTimestamp = settings.killTimestamp;
        PomodoroWebStore.instance.updateSettings(updatedSettings);
        ref.invalidate(focusGoalSettingsProvider);
      }

      if (!mounted) return;

      // Mark onboarding complete
      await ref.read(onboardingServiceProvider).markOnboardingComplete();

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong — please try again: $e',
            style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary),
          ),
          backgroundColor: AppTheme.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
          ),
        ),
      );
    }
  }
}

// OnboardingData model (in-memory during onboarding)
class OnboardingData {
  String displayName = '';
  String avatarEmoji = '👨‍💻';
  String courseName = '';
  String semesterName = '';
  String institution = '';
  DateTime? semesterEndDate;
  List<String> primaryLanguages = [];
  List<String> techStack = [];
  String experienceLevel = 'intermediate';
  int dailySessionGoal = 4;
  int dailyCodingHoursGoal = 3;
  TimeOfDay? reminderTime;
  String accentColor = '#006EE6';
  bool autoStartBreaks = false;
  bool autoStartFocus = false;

  UserProfile toUserProfile() => UserProfile()
    ..id = 1
    ..displayName = displayName
    ..avatarEmoji = avatarEmoji
    ..courseName = courseName
    ..semesterName = semesterName
    ..semesterEndDate = semesterEndDate
    ..primaryLanguages = primaryLanguages
    ..dailySessionGoal = dailySessionGoal
    ..dailyCodingHoursGoal = dailyCodingHoursGoal
    ..createdAt = DateTime.now()
    ..lastUpdatedAt = DateTime.now();
}
