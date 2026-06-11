import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../models/dev_project.dart';
import '../providers/project_notifier.dart';

class AddProjectSheet extends ConsumerStatefulWidget {
  const AddProjectSheet({super.key});

  @override
  ConsumerState<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends ConsumerState<AddProjectSheet> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _primaryLanguage = 'Dart';
  final List<String> _techStack = [];
  String _status = 'active';
  String _colorHex = '#006EE6';
  int _completionPercent = 0;

  static const _projectColors = [
    '#006EE6', '#00B4FF', '#00D4AA', '#FFB800', '#FF3B5C', '#FF6B35',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    final languages = profile?.primaryLanguages ?? ['Dart', 'Python', 'JavaScript'];

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
              'New Project',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Name
            _buildLabel('PROJECT NAME'),
            const SizedBox(height: 8),
            _buildTextField(_nameController, 'My Awesome Project'),

            const SizedBox(height: AppTheme.spaceMD),

            // Description
            _buildLabel('DESCRIPTION'),
            const SizedBox(height: 8),
            _buildTextField(_descController, 'Optional description', maxLines: 2),

            const SizedBox(height: AppTheme.spaceMD),

            // Primary Language
            _buildLabel('PRIMARY LANGUAGE'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: languages.map((lang) {
                final isSelected = _primaryLanguage == lang;
                return GestureDetector(
                  onTap: () => setState(() => _primaryLanguage = lang),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primarySubtle : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                      ),
                    ),
                    child: Text(
                      lang,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Status
            _buildLabel('STATUS'),
            const SizedBox(height: 8),
            Row(
              children: ['active', 'planned'].map((s) {
                final isSelected = _status == s;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _status = s),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primarySubtle : AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
                        ),
                      ),
                      child: Text(
                        s[0].toUpperCase() + s.substring(1),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Project color
            _buildLabel('PROJECT COLOR'),
            const SizedBox(height: 8),
            Row(
              children: _projectColors.map((hex) {
                final isSelected = _colorHex == hex;
                final color = Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
                return GestureDetector(
                  onTap: () => setState(() => _colorHex = hex),
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? AppTheme.textPrimary : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: AppTheme.spaceXL),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _createProject,
                style: AppTheme.primaryButtonStyle.copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: Text(
                  'Create Project',
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

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(AppTheme.radiusMD),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.spaceGrotesk(color: AppTheme.textMuted),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppTheme.spaceMD),
        ),
      ),
    );
  }

  Future<void> _createProject() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final now = DateTime.now();
    final project = DevProject()
      ..name = name
      ..description = _descController.text.trim()
      ..primaryLanguage = _primaryLanguage
      ..techStack = _techStack.isEmpty ? [_primaryLanguage] : _techStack
      ..status = _status
      ..completionPercent = _completionPercent
      ..startedAt = now
      ..lastActiveAt = now
      ..colorHex = _colorHex
      ..iconName = 'code';

    await ref.read(projectNotifierProvider.notifier).addProject(project);
    if (mounted) Navigator.pop(context);
  }
}
