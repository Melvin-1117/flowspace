import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../models/coding_session.dart';
import '../providers/devtrack_providers.dart';
import '../providers/project_notifier.dart';

class LogSessionSheet extends ConsumerStatefulWidget {
  const LogSessionSheet({super.key});

  @override
  ConsumerState<LogSessionSheet> createState() => _LogSessionSheetState();
}

class _LogSessionSheetState extends ConsumerState<LogSessionSheet> {
  String? _selectedProjectId;
  String _language = 'Dart';
  int _durationMinutes = 30;
  String _sessionType = 'feature';
  final _notesController = TextEditingController();

  static const List<String> _sessionTypes = [
    'feature',
    'bugfix',
    'learning',
    'review',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(allProjectsProvider);
    final profile = ref.watch(userProfileProvider).value;
    final languages =
        profile?.primaryLanguages ?? ['Dart', 'Python', 'JavaScript'];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXL),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppTheme.spaceLG,
        AppTheme.spaceLG,
        AppTheme.spaceLG,
        MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceLG,
      ),
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

            Text(
              'Log Coding Session',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Project Selector
            _buildLabel('SELECT PROJECT'),
            const SizedBox(height: 8),
            projectsAsync.when(
              data: (projects) {
                if (projects.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(AppTheme.spaceMD),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Text(
                      'No projects found. Create a project first to link sessions.',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  );
                }

                // If no project selected yet, select the first one
                if (_selectedProjectId == null && projects.isNotEmpty) {
                  _selectedProjectId = projects.first.uuid;
                }

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMD,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    border: Border.all(color: AppTheme.surfaceBorder),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedProjectId,
                      dropdownColor: AppTheme.surfaceElevated,
                      isExpanded: true,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: AppTheme.textSecondary,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _selectedProjectId = value;
                          // Automatically set language to project primary language if possible
                          final proj = projects.firstWhere(
                            (p) => p.uuid == value,
                          );
                          _language = proj.primaryLanguage;
                        });
                      },
                      items: projects.map((p) {
                        return DropdownMenuItem<String>(
                          value: p.uuid,
                          child: Text(p.name),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (err, stack) => Text(
                'Error loading projects',
                style: GoogleFonts.spaceGrotesk(color: AppTheme.danger),
              ),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Language
            _buildLabel('LANGUAGE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: languages.map((lang) {
                final isSelected = _language == lang;
                return GestureDetector(
                  onTap: () => setState(() => _language = lang),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primarySubtle
                          : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Text(
                      lang,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Duration
            _buildLabel('DURATION'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceMD,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Text(
                      '$_durationMinutes minutes',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSM),
                _buildQuickDurationButton('+15m', 15),
                const SizedBox(width: AppTheme.spaceSM),
                _buildQuickDurationButton('+30m', 30),
                const SizedBox(width: AppTheme.spaceSM),
                _buildQuickDurationButton('+60m', 60),
              ],
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Session Type
            _buildLabel('SESSION TYPE'),
            const SizedBox(height: 8),
            Row(
              children: _sessionTypes.map((type) {
                final isSelected = _sessionType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _sessionType = type),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primarySubtle
                            : AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.surfaceBorder,
                        ),
                      ),
                      child: Text(
                        type[0].toUpperCase() + type.substring(1),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Notes
            _buildLabel('WHAT DID YOU WORK ON?'),
            const SizedBox(height: 8),
            _buildTextField(
              _notesController,
              'e.g., refactored database module, fixed auth state bug',
              maxLines: 2,
            ),

            const SizedBox(height: AppTheme.spaceXL),

            // Log button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logSession,
                style: AppTheme.primaryButtonStyle.copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: Text(
                  'Log Session',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDurationButton(String label, int mins) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _durationMinutes += mins;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.surfaceElevated,
        foregroundColor: AppTheme.textPrimary,
        side: const BorderSide(color: AppTheme.surfaceBorder),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

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

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.spaceGrotesk(color: AppTheme.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppTheme.spaceMD),
        ),
      ),
    );
  }

  Future<void> _logSession() async {
    final now = DateTime.now();
    final session = CodingSession()
      ..projectId = _selectedProjectId ?? ''
      ..language = _language
      ..startTime = now.subtract(Duration(minutes: _durationMinutes))
      ..endTime = now
      ..durationMinutes = _durationMinutes
      ..sessionType = _sessionType
      ..notes = _notesController.text.trim();

    await ref.read(projectNotifierProvider.notifier).logCodingSession(session);
    if (mounted) Navigator.pop(context);
  }
}
