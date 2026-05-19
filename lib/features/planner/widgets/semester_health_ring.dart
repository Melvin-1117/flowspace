import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/planner_providers.dart';
import '../../../app/theme.dart';

class SemesterHealthRing extends StatelessWidget {
  const SemesterHealthRing({
    required this.health,
    required this.onTap,
    super.key,
  });

  final SemesterHealth health;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final score = health.score.clamp(0, 100).toDouble();
    final ratio = score / 100;
    final status = _statusForScore(score);
    final statusColor = _statusColor(score);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x0DFFFFFF)),
        ),
        child: Column(
          children: [
            const Text(
              'SEMESTER HEALTH',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w700,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: 1,
                      strokeWidth: 12,
                      color: AppTheme.surfaceElevated,
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: ratio,
                      strokeWidth: 12,
                      color: AppTheme.primary,
                    ),
                  ).animate().fadeIn(duration: 1000.ms),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${score.round()}%',
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _statusForScore(double score) {
  if (score >= 60) return 'OPTIMAL';
  if (score >= 40) return 'AT RISK';
  return 'CRITICAL';
}

Color _statusColor(double score) {
  if (score >= 85) return AppTheme.success;
  if (score >= 60) return AppTheme.accent;
  if (score >= 40) return AppTheme.warning;
  return AppTheme.danger;
}
