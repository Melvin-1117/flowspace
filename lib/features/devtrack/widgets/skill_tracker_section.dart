import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/error_card.dart';
import '../providers/devtrack_providers.dart';
import 'add_skill_sheet.dart';
import 'skill_card.dart';

class SkillTrackerSection extends ConsumerWidget {
  const SkillTrackerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(allSkillsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'SKILL DEVELOPMENT',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const AddSkillSheet(),
                );
              },
              icon: const Icon(
                Icons.add_circle_outline,
                color: AppTheme.primary,
                size: 20,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spaceSM),
        skillsAsync.when(
          data: (skills) {
            if (skills.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceXL),
                decoration: AppTheme.cardDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No skills tracked yet.',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => const AddSkillSheet(),
                        );
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        'Track your first skill',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppTheme.spaceSM),
              itemBuilder: (context, index) {
                return SkillCard(skill: skills[index]);
              },
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spaceLG),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (err, stack) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ErrorCard(
              message: 'Could not load skills',
              onRetry: () => ref.invalidate(allSkillsProvider),
            ),
          ),
        ),
      ],
    );
  }
}
