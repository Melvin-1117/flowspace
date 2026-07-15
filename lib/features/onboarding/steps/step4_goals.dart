import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../onboarding_screen.dart';
import 'onboarding_widgets.dart';

class OnboardingStep4Goals extends StatefulWidget {
  final OnboardingData data;

  const OnboardingStep4Goals({super.key, required this.data});

  @override
  State<OnboardingStep4Goals> createState() => _OnboardingStep4GoalsState();
}

class _OnboardingStep4GoalsState extends State<OnboardingStep4Goals> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const StepLabel(number: '04', label: 'GOALS'),
          const SizedBox(height: 24),
          Text(
            'Set your daily\ntargets',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -1.2,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'These drive your streaks and progress tracking.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),

          // Daily focus sessions
          const FieldLabel(label: 'DAILY FOCUS SESSIONS'),
          const SizedBox(height: 4),
          Text(
            'How many Pomodoro sessions per day?',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [2, 4, 6, 8, 10, 12].map((count) {
              final isSelected = data.dailySessionGoal == count;
              final label = count <= 4
                  ? ['Light', 'Moderate', 'Productive', 'Intense'][count ~/ 2 -
                        1]
                  : count <= 8
                  ? 'Deep Work'
                  : 'Extreme';
              return GestureDetector(
                onTap: () => setState(() => data.dailySessionGoal = count),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: (MediaQuery.of(context).size.width - 64) / 3,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surfaceBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$count',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: isSelected ? AppTheme.primary : Colors.white,
                        ),
                      ),
                      Text(
                        'sessions',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 9,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Daily coding hours
          const FieldLabel(label: 'DAILY CODING HOURS TARGET'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.laptop_rounded,
                  color: AppTheme.accent,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Coding hours per day',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                StepperControl(
                  value: data.dailyCodingHoursGoal,
                  min: 1,
                  max: 12,
                  onDecrement: () =>
                      setState(() => data.dailyCodingHoursGoal--),
                  onIncrement: () =>
                      setState(() => data.dailyCodingHoursGoal++),
                  suffix: 'h',
                  color: AppTheme.accent,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Daily reminder
          const FieldLabel(label: 'DAILY REMINDER (OPTIONAL)'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: data.reminderTime != null
                    ? AppTheme.primary.withValues(alpha: 0.4)
                    : AppTheme.surfaceBorder,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: data.reminderTime != null
                      ? AppTheme.primary
                      : AppTheme.textMuted,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    data.reminderTime != null
                        ? 'Remind me at ${data.reminderTime!.format(context)}'
                        : 'Set a daily reminder',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: data.reminderTime != null
                          ? Colors.white
                          : AppTheme.textMuted,
                    ),
                  ),
                ),
                Switch(
                  value: data.reminderTime != null,
                  activeThumbColor: AppTheme.primary,
                  onChanged: (val) async {
                    if (val) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: const TimeOfDay(hour: 9, minute: 0),
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: AppTheme.primary,
                              surface: AppTheme.surfaceCard,
                              onPrimary: Colors.white,
                              onSurface: Colors.white,
                            ),
                            dialogTheme: const DialogThemeData(
                              backgroundColor: AppTheme.surfaceElevated,
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (time != null) {
                        setState(() => data.reminderTime = time);
                      }
                    } else {
                      setState(() => data.reminderTime = null);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
