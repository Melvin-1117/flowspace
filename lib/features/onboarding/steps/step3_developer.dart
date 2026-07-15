import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme.dart';
import '../onboarding_screen.dart';
import 'onboarding_widgets.dart';

class OnboardingStep3Developer extends StatefulWidget {
  final OnboardingData data;

  const OnboardingStep3Developer({super.key, required this.data});

  @override
  State<OnboardingStep3Developer> createState() =>
      _OnboardingStep3DeveloperState();
}

class _OnboardingStep3DeveloperState extends State<OnboardingStep3Developer> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const StepLabel(number: '03', label: 'DEVELOPER'),
          const SizedBox(height: 24),
          Text(
            'What do you\nbuild with?',
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
            'Helps FlowSpace personalize your DevTrack experience.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Experience level
          const FieldLabel(label: 'EXPERIENCE LEVEL'),
          const SizedBox(height: 12),
          Row(
            children: [
              _ExperienceCard(
                emoji: '🌱',
                label: 'Beginner',
                subtitle: '0–1 years',
                value: 'beginner',
                selected: data.experienceLevel,
                onTap: () => setState(() => data.experienceLevel = 'beginner'),
              ),
              const SizedBox(width: 8),
              _ExperienceCard(
                emoji: '⚡',
                label: 'Intermediate',
                subtitle: '1–3 years',
                value: 'intermediate',
                selected: data.experienceLevel,
                onTap: () =>
                    setState(() => data.experienceLevel = 'intermediate'),
              ),
              const SizedBox(width: 8),
              _ExperienceCard(
                emoji: '🚀',
                label: 'Advanced',
                subtitle: '3+ years',
                value: 'advanced',
                selected: data.experienceLevel,
                onTap: () => setState(() => data.experienceLevel = 'advanced'),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Primary languages
          const FieldLabel(label: 'PRIMARY LANGUAGES'),
          const SizedBox(height: 4),
          Text(
            'Select all you use regularly',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                  'Dart',
                  'Python',
                  'JavaScript',
                  'TypeScript',
                  'Java',
                  'Kotlin',
                  'C++',
                  'C',
                  'Rust',
                  'Go',
                  'Swift',
                  'Ruby',
                  'PHP',
                  'Other',
                ].map((lang) {
                  final isSelected = data.primaryLanguages.contains(lang);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (isSelected) {
                        data.primaryLanguages.remove(lang);
                      } else {
                        data.primaryLanguages.add(lang);
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary.withValues(alpha: 0.15)
                            : AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.surfaceBorder,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            const Icon(
                              Icons.check_rounded,
                              size: 12,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            lang,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 28),

          // Tech stack / frameworks
          const FieldLabel(label: 'TECH STACK / FRAMEWORKS'),
          const SizedBox(height: 4),
          Text(
            'What frameworks do you work with?',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                  'Flutter',
                  'React',
                  'Next.js',
                  'Node.js',
                  'Django',
                  'FastAPI',
                  'Spring Boot',
                  'Android',
                  'iOS',
                  'Docker',
                  'Firebase',
                  'AWS',
                  'PostgreSQL',
                  'MongoDB',
                  'Other',
                ].map((tech) {
                  final isSelected = data.techStack.contains(tech);
                  return GestureDetector(
                    onTap: () => setState(() {
                      if (isSelected) {
                        data.techStack.remove(tech);
                      } else {
                        data.techStack.add(tech);
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accent.withValues(alpha: 0.1)
                            : AppTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accent
                              : AppTheme.surfaceBorder,
                        ),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppTheme.accent
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String subtitle;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _ExperienceCard({
    required this.emoji,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.12)
                : AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppTheme.primary : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
