import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app/theme.dart';

/// A selectable duration chip for the Focus Lock duration picker.
class DurationChip extends StatelessWidget {
  const DurationChip({
    required this.minutes,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final int minutes;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primary.withValues(alpha: 0.15)
                : AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.surfaceBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              '${minutes}m',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
