import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../core/models/user_profile.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/onboarding_service.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Step 1 — Name + Avatar
  final _nameController = TextEditingController();
  String _selectedAvatar = '👨‍💻';

  // Step 2 — Semester Info
  final _semesterController = TextEditingController(text: 'Semester 7');
  final _courseController = TextEditingController(text: 'B.Tech CSE');
  DateTime? _semesterEndDate;
  final List<String> _selectedLanguages = [];

  // Step 3 — Daily Goals
  int _dailySessions = 4;
  int _dailyCodingHours = 3;

  static const _avatarOptions = [
    '👨‍💻', '👩‍💻', '🧑‍💻', '👾', '🤖', '🦊',
    '🐼', '🦁', '🐉', '🚀', '⚡', '🎯',
  ];

  static const _languageOptions = [
    'Dart', 'Python', 'JavaScript', 'TypeScript',
    'Java', 'C++', 'Rust', 'Go', 'Swift', 'Kotlin', 'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _semesterController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppTheme.spaceLG),

            // Step indicators
            _buildStepIndicator(),

            const SizedBox(height: AppTheme.spaceLG),

            // Step content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spaceXL),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: switch (_currentStep) {
                    0 => _buildStep1(),
                    1 => _buildStep2(),
                    2 => _buildStep3(),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  // ── Step Indicator ────────────────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index == _currentStep;
        final isComplete = index < _currentStep;
        return Container(
          width: isActive ? 32 : 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary
                : isComplete
                    ? AppTheme.primary.withOpacity(0.5)
                    : AppTheme.surfaceBorder,
            borderRadius: BorderRadius.circular(5),
          ),
        );
      }),
    );
  }

  // ── Step 1: Name + Avatar ─────────────────────────────────────────────────
  Widget _buildStep1() {
    return Column(
      key: const ValueKey('step1'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // FlowSpace logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            boxShadow: [
              BoxShadow(color: AppTheme.primaryGlow, blurRadius: 20),
            ],
          ),
          child: const Icon(
            Icons.bolt_rounded,
            color: AppTheme.textPrimary,
            size: 32,
          ),
        ),

        const SizedBox(height: AppTheme.spaceXL),

        Text(
          'Welcome to\nFlowSpace',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -1.5,
            height: 1.1,
          ),
        ),

        const SizedBox(height: AppTheme.spaceSM + 4),

        Text(
          'Set up your profile to get started.\nEverything stays on your device.',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: AppTheme.spaceXXL),

        // Display Name
        Text(
          'YOUR NAME',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spaceSM + 4),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            border: Border.all(color: AppTheme.surfaceBorder),
          ),
          child: TextField(
            controller: _nameController,
            maxLength: 40,
            style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: 'What should we call you?',
              hintStyle: GoogleFonts.spaceGrotesk(
                color: AppTheme.textMuted,
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppTheme.spaceMD),
              counterText: '',
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spaceXL),

        // Avatar picker
        Text(
          'PICK YOUR AVATAR',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppTheme.spaceSM + 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _avatarOptions.length,
          itemBuilder: (context, index) {
            final avatar = _avatarOptions[index];
            final isSelected = _selectedAvatar == avatar;
            return GestureDetector(
              onTap: () => setState(() => _selectedAvatar = avatar),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primarySubtle
                      : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.surfaceBorder,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Center(
                  child: Text(avatar, style: const TextStyle(fontSize: 24)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ── Step 2: Semester Info ─────────────────────────────────────────────────
  Widget _buildStep2() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Academic Info',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppTheme.spaceSM),
        Text(
          'Tell us about your current semester.',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: AppTheme.spaceXL),

        // Semester name
        _buildLabel('SEMESTER'),
        const SizedBox(height: AppTheme.spaceSM + 4),
        _buildTextField(_semesterController, 'Semester 7'),

        const SizedBox(height: AppTheme.spaceMD + 4),

        // Course
        _buildLabel('COURSE / DEGREE'),
        const SizedBox(height: AppTheme.spaceSM + 4),
        _buildTextField(_courseController, 'B.Tech CSE'),

        const SizedBox(height: AppTheme.spaceMD + 4),

        // Semester end date
        _buildLabel('SEMESTER END DATE'),
        const SizedBox(height: AppTheme.spaceSM + 4),
        GestureDetector(
          onTap: _pickSemesterEndDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceMD),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _semesterEndDate != null
                        ? '${_semesterEndDate!.day}/${_semesterEndDate!.month}/${_semesterEndDate!.year}'
                        : 'Select date',
                    style: GoogleFonts.spaceGrotesk(
                      color: _semesterEndDate != null
                          ? AppTheme.textPrimary
                          : AppTheme.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppTheme.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppTheme.spaceXL),

        // Primary languages
        _buildLabel('PRIMARY LANGUAGES'),
        const SizedBox(height: AppTheme.spaceSM + 4),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _languageOptions.map((lang) {
            final isSelected = _selectedLanguages.contains(lang);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedLanguages.remove(lang);
                  } else {
                    _selectedLanguages.add(lang);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primarySubtle
                      : AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.surfaceBorder,
                  ),
                ),
                child: Text(
                  lang,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primary
                        : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Step 3: Daily Goals ───────────────────────────────────────────────────
  Widget _buildStep3() {
    return Column(
      key: const ValueKey('step3'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Goals',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppTheme.spaceSM),
        Text(
          'Set targets to keep yourself on track.',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 15,
            color: AppTheme.textSecondary,
            height: 1.6,
          ),
        ),

        const SizedBox(height: AppTheme.spaceXXL),

        // Daily focus sessions
        _buildLabel('DAILY FOCUS SESSIONS'),
        const SizedBox(height: AppTheme.spaceSM),
        _buildSliderCard(
          value: _dailySessions,
          min: 1,
          max: 12,
          icon: Icons.timer_rounded,
          suffix: 'sessions',
          onChanged: (v) => setState(() => _dailySessions = v),
        ),

        const SizedBox(height: AppTheme.spaceXL),

        // Daily coding hours
        _buildLabel('DAILY CODING HOURS'),
        const SizedBox(height: AppTheme.spaceSM),
        _buildSliderCard(
          value: _dailyCodingHours,
          min: 1,
          max: 12,
          icon: Icons.code_rounded,
          suffix: 'hours',
          onChanged: (v) => setState(() => _dailyCodingHours = v),
        ),

        const SizedBox(height: AppTheme.spaceXXL),

        // Privacy note
        Container(
          padding: const EdgeInsets.all(AppTheme.spaceMD),
          decoration: BoxDecoration(
            color: AppTheme.primarySubtle,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            border: Border.all(
              color: AppTheme.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lock_rounded,
                color: AppTheme.primary,
                size: 18,
              ),
              const SizedBox(width: AppTheme.spaceSM),
              Expanded(
                child: Text(
                  'All data is stored locally on your device. No internet needed.',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: AppTheme.primary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Navigation Buttons ────────────────────────────────────────────────────
  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep--),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppTheme.surfaceBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  ),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),

          if (_currentStep > 0) const SizedBox(width: 12),

          // Next / Get Started button
          Expanded(
            flex: _currentStep > 0 ? 2 : 1,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                disabledBackgroundColor: AppTheme.primaryDark,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppTheme.textPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      _currentStep == 2 ? 'Get Started' : 'Next',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppTheme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.spaceGrotesk(
            color: AppTheme.textMuted,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppTheme.spaceMD),
        ),
      ),
    );
  }

  Widget _buildSliderCard({
    required int value,
    required int min,
    required int max,
    required IconData icon,
    required String suffix,
    required ValueChanged<int> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceMD),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: AppTheme.spaceSM),
              Text(
                '$value $suffix',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceSM),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primary,
              inactiveTrackColor: AppTheme.surfaceBorder,
              thumbColor: AppTheme.primary,
              overlayColor: AppTheme.primary.withOpacity(0.1),
              trackHeight: 4,
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$min',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
              Text(
                '$max',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickSemesterEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              surface: AppTheme.surfaceCard,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _semesterEndDate = picked);
    }
  }

  void _handleNext() {
    if (_currentStep == 0) {
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please enter your name',
              style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary),
            ),
            backgroundColor: AppTheme.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
          ),
        );
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      setState(() => _currentStep = 2);
    } else if (_currentStep == 2) {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final profile = UserProfile()
        ..id = 1
        ..displayName = _nameController.text.trim()
        ..avatarEmoji = _selectedAvatar
        ..avatarUrl = ''
        ..bio = ''
        ..semesterName = _semesterController.text.trim()
        ..courseName = _courseController.text.trim()
        ..semesterEndDate = _semesterEndDate
        ..primaryLanguages = _selectedLanguages
        ..dailySessionGoal = _dailySessions
        ..dailyCodingHoursGoal = _dailyCodingHours
        ..createdAt = now
        ..lastUpdatedAt = now;

      await ref.read(userProfileProvider.notifier).saveProfile(profile);
      await ref.read(onboardingServiceProvider).markOnboardingComplete();

      if (!mounted) return;
      context.go('/dashboard');
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Something went wrong — please try again',
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
