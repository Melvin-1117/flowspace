import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../onboarding_screen.dart';
import 'onboarding_widgets.dart';

class OnboardingStep5Personalize extends StatefulWidget {
  final OnboardingData data;

  const OnboardingStep5Personalize({
    super.key,
    required this.data,
  });

  @override
  State<OnboardingStep5Personalize> createState() => _OnboardingStep5PersonalizeState();
}

class _OnboardingStep5PersonalizeState extends State<OnboardingStep5Personalize> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const StepLabel(number: '05', label: 'PERSONALIZE'),
          const SizedBox(height: 24),
          Text(
            'Almost ready\nto launch 🚀',
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
            'A few final preferences to make FlowSpace yours.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),

          // Timer preferences
          const FieldLabel(label: 'TIMER PREFERENCES'),
          const SizedBox(height: 12),
          _ToggleRow(
            icon: Icons.coffee_rounded,
            label: 'Auto-start breaks',
            subtitle: 'Break starts automatically after focus',
            value: data.autoStartBreaks,
            onChanged: (val) => setState(() => data.autoStartBreaks = val),
          ),
          const SizedBox(height: 8),
          _ToggleRow(
            icon: Icons.bolt_rounded,
            label: 'Auto-start focus',
            subtitle: 'Next focus starts after break ends',
            value: data.autoStartFocus,
            onChanged: (val) => setState(() => data.autoStartFocus = val),
          ),
          const SizedBox(height: 32),

          // Setup Summary Card
          const FieldLabel(label: 'YOUR SETUP SUMMARY'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile row
                Row(
                  children: [
                    Text(
                      data.avatarEmoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.displayName,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${data.semesterName} • ${data.courseName}',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: AppTheme.surfaceBorder, height: 24),

                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        icon: Icons.timer_rounded,
                        label: 'Daily Goal',
                        value: '${data.dailySessionGoal} Sessions',
                      ),
                    ),
                    Expanded(
                      child: _SummaryItem(
                        icon: Icons.laptop_rounded,
                        label: 'Coding Goal',
                        value: '${data.dailyCodingHoursGoal} Hours',
                      ),
                    ),
                  ],
                ),
                if (data.primaryLanguages.isNotEmpty || data.techStack.isNotEmpty) ...[
                  const Divider(color: AppTheme.surfaceBorder, height: 24),
                  Text(
                    'DEVELOPER STACK',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ...data.primaryLanguages,
                      ...data.techStack,
                    ].map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceElevated,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: Text(
                          item,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppTheme.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
