import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../models/dev_project.dart';
import '../providers/project_notifier.dart';

class ProjectDetailSheet extends ConsumerWidget {
  final DevProject project;
  const ProjectDetailSheet({required this.project, super.key});

  Color get _accentColor {
    try {
      final hex = project.colorHex.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accent = _accentColor;
    final totalHours = project.totalCodingMinutes ~/ 60;
    final totalMins = project.totalCodingMinutes % 60;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXL),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Project name
            Text(
              project.name,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),

            if (project.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                project.description,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
            ],

            const SizedBox(height: AppTheme.spaceLG),

            // Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
                Text(
                  '${project.completionPercent}%',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: project.completionPercent / 100,
                backgroundColor: AppTheme.surfaceBorder,
                valueColor: AlwaysStoppedAnimation(accent),
                minHeight: 8,
              ),
            ),

            const SizedBox(height: AppTheme.spaceLG),

            // Stats row
            Row(
              children: [
                _DetailStat(
                  icon: Icons.access_time_rounded,
                  value: '${totalHours}h ${totalMins}m',
                  label: 'Time Logged',
                ),
                const SizedBox(width: 16),
                _DetailStat(
                  icon: Icons.code_rounded,
                  value: project.primaryLanguage,
                  label: 'Language',
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Tech stack
            if (project.techStack.isNotEmpty) ...[
              Text(
                'TECH STACK',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: project.techStack.map((t) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBorder,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppTheme.spaceLG),
            ],

            // Delete project
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () async {
                  await ref
                      .read(projectNotifierProvider.notifier)
                      .deleteProject(project.uuid);
                  if (context.mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_rounded, size: 16),
                label: Text(
                  'Delete Project',
                  style: GoogleFonts.spaceGrotesk(fontSize: 14),
                ),
                style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

class _DetailStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _DetailStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppTheme.primary, size: 18),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
