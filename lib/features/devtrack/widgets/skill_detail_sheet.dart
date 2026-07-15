import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';
import '../models/skill_entry.dart';
import '../providers/skill_notifier.dart';

class SkillDetailSheet extends ConsumerStatefulWidget {
  final SkillEntry skill;

  const SkillDetailSheet({super.key, required this.skill});

  @override
  ConsumerState<SkillDetailSheet> createState() => _SkillDetailSheetState();
}

class _SkillDetailSheetState extends ConsumerState<SkillDetailSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late String _category;
  late int _proficiencyLevel;
  late int _hoursInvested;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill.skillName);
    _notesController = TextEditingController(text: widget.skill.notes);
    _category = widget.skill.category;
    _proficiencyLevel = widget.skill.proficiencyLevel;
    _hoursInvested = widget.skill.hoursInvested;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Skill',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: _deleteSkill,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Name
            _buildLabel('SKILL NAME'),
            const SizedBox(height: 8),
            _buildTextField(_nameController, 'Skill name'),

            const SizedBox(height: AppTheme.spaceMD),

            // Hours Invested
            _buildLabel('HOURS INVESTED'),
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
                      '$_hoursInvested hours',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceSM),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _hoursInvested += 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.surfaceElevated,
                    foregroundColor: AppTheme.textPrimary,
                    side: const BorderSide(color: AppTheme.surfaceBorder),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    ),
                  ),
                  child: Text(
                    '+1 hr',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Category
            _buildLabel('CATEGORY'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['language', 'framework', 'concept', 'tool'].map((cat) {
                final isSelected = _category == cat;
                return GestureDetector(
                  onTap: () => setState(() => _category = cat),
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
                      cat.toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
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

            // Proficiency Level
            _buildLabel('PROFICIENCY LEVEL (1-5)'),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final level = index + 1;
                final isSelected = _proficiencyLevel == level;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _proficiencyLevel = level),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.surfaceElevated,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryLight
                              : AppTheme.surfaceBorder,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$level',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Notes
            _buildLabel('NOTES'),
            const SizedBox(height: 8),
            _buildTextField(
              _notesController,
              'Optional notes or resources',
              maxLines: 2,
            ),

            const SizedBox(height: AppTheme.spaceXL),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSkill,
                style: AppTheme.primaryButtonStyle.copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: Text(
                  'Save Changes',
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

  Future<void> _saveSkill() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final updated = widget.skill
      ..skillName = name
      ..category = _category
      ..proficiencyLevel = _proficiencyLevel
      ..hoursInvested = _hoursInvested
      ..notes = _notesController.text.trim()
      ..lastPracticedAt = DateTime.now();

    await ref.read(skillNotifierProvider.notifier).updateSkill(updated);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _deleteSkill() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Skill'),
        content: Text(
          'Are you sure you want to delete "${widget.skill.skillName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.spaceGrotesk(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: GoogleFonts.spaceGrotesk(color: AppTheme.danger),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref
          .read(skillNotifierProvider.notifier)
          .deleteSkill(widget.skill.uuid);
      if (mounted) {
        Navigator.pop(context); // close bottom sheet
      }
    }
  }
}
