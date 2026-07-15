import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../app/theme.dart';
import '../onboarding_screen.dart';
import 'onboarding_widgets.dart';

class OnboardingStep2Academic extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onValidationChanged;

  const OnboardingStep2Academic({
    super.key,
    required this.data,
    required this.onValidationChanged,
  });

  @override
  State<OnboardingStep2Academic> createState() => _OnboardingStep2AcademicState();
}

class _OnboardingStep2AcademicState extends State<OnboardingStep2Academic> {
  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const StepLabel(number: '02', label: 'ACADEMIC'),
          const SizedBox(height: 24),
          Text(
            'Tell us about\nyour studies',
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
            'FlowSpace adapts to your academic calendar.',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 40),

          // Course / Degree
          const FieldLabel(label: 'COURSE / DEGREE'),
          const SizedBox(height: 8),
          OnboardingTextField(
            hintText: 'e.g. B.Tech Computer Science',
            initialValue: data.courseName,
            prefixIcon: Icons.school_rounded,
            maxLength: 60,
            onChanged: (val) {
              setState(() {
                data.courseName = val;
              });
              widget.onValidationChanged();
            },
          ),
          const SizedBox(height: 20),

          // Current Semester
          const FieldLabel(label: 'CURRENT SEMESTER'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(8, (i) {
              final sem = 'Semester ${i + 1}';
              final isSelected = data.semesterName == sem;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    data.semesterName = sem;
                  });
                  widget.onValidationChanged();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : AppTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.surfaceBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    'Sem ${i + 1}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primary
                          : AppTheme.textSecondary,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Institution name
          const FieldLabel(label: 'INSTITUTION (OPTIONAL)'),
          const SizedBox(height: 8),
          OnboardingTextField(
            hintText: 'e.g. IIT Madras',
            initialValue: data.institution,
            prefixIcon: Icons.account_balance_rounded,
            maxLength: 80,
            onChanged: (val) {
              setState(() {
                data.institution = val;
              });
            },
          ),
          const SizedBox(height: 20),

          // Semester end date
          const FieldLabel(label: 'SEMESTER END DATE (OPTIONAL)'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now().add(const Duration(days: 120)),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppTheme.primary,
                      surface: AppTheme.surfaceCard,
                      onPrimary: Colors.white,
                      onSurface: Colors.white,
                    ),
                    dialogTheme: const DialogThemeData(
                      backgroundColor: AppTheme.surfaceElevated,
                    ),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                setState(() => data.semesterEndDate = picked);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: data.semesterEndDate != null
                      ? AppTheme.primary.withValues(alpha: 0.4)
                      : AppTheme.surfaceBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: data.semesterEndDate != null
                        ? AppTheme.primary
                        : AppTheme.textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    data.semesterEndDate != null
                        ? DateFormat('MMMM d, yyyy')
                            .format(data.semesterEndDate!)
                        : 'Pick end date',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: data.semesterEndDate != null
                          ? Colors.white
                          : AppTheme.textMuted,
                    ),
                  ),
                  const Spacer(),
                  if (data.semesterEndDate != null)
                    GestureDetector(
                      onTap: () {
                        setState(() => data.semesterEndDate = null);
                      },
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textSecondary,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}
