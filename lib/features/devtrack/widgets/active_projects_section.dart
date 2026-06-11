import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../providers/devtrack_providers.dart';
import 'project_card.dart';
import 'add_project_sheet.dart';

class ActiveProjectsSection extends ConsumerWidget {
  const ActiveProjectsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(activeProjectsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active Projects',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to full project list (could be a separate route)
              },
              child: Text(
                'View All →',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        projectsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
          data: (projects) {
            if (projects.isEmpty) {
              return _EmptyState(
                onAdd: () => _showAddProjectSheet(context),
              );
            }
            return Column(
              children: projects
                  .take(3)
                  .map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ProjectCard(project: p),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  void _showAddProjectSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AddProjectSheet(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.folder_open_rounded,
            color: AppTheme.textMuted,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            'No active projects yet',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              'Add Project',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}
