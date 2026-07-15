import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../onboarding_screen.dart';
import 'onboarding_widgets.dart';

class OnboardingStep1Identity extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onValidationChanged;

  const OnboardingStep1Identity({
    super.key,
    required this.data,
    required this.onValidationChanged,
  });

  @override
  State<OnboardingStep1Identity> createState() => _OnboardingStep1IdentityState();
}

class _OnboardingStep1IdentityState extends State<OnboardingStep1Identity> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const StepLabel(number: '01', label: 'IDENTITY'),
          const SizedBox(height: 24),
          Text(
            'What should we\ncall you?',
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
            'This is how you will be greeted in FlowSpace.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          const FieldLabel(label: 'YOUR NAME'),
          const SizedBox(height: 8),
          OnboardingTextField(
            hintText: 'e.g. Melvin',
            initialValue: data.displayName,
            prefixIcon: Icons.person_outline_rounded,
            maxLength: 40,
            onChanged: (val) {
              setState(() {
                data.displayName = val;
              });
              widget.onValidationChanged();
            },
            validator: (val) =>
                val != null && val.trim().length >= 2
                    ? null
                    : 'Name must be at least 2 characters',
          ),
          const SizedBox(height: 32),
          const FieldLabel(label: 'CHOOSE YOUR AVATAR'),
          const SizedBox(height: 4),
          Text(
            'Pick one that represents you',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              '👨‍💻', '👩‍💻', '🧑‍💻', '👾',
              '🤖', '🦊', '🐼', '🦁',
              '🐉', '🚀', '⚡', '🎯',
              '🔥', '💎', '🌊', '🎮',
            ].map((emoji) {
              final isSelected = data.avatarEmoji == emoji;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    data.avatarEmoji = emoji;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surfaceBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                )
                .animate(target: isSelected ? 1 : 0)
                .scaleXY(end: 1.05, duration: 200.ms),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.surfaceBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.4),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      data.avatarEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.displayName.isEmpty ? 'Your Name' : data.displayName,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: data.displayName.isEmpty
                            ? AppTheme.textMuted
                            : Colors.white,
                      ),
                    ),
                    Text(
                      'FlowSpace Member',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    'PREVIEW',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 9,
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
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
