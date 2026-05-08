import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../providers/planner_providers.dart';

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
          color: const Color(0xFF0D0D0D),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x0DFFFFFF)),
        ),
        child: Column(
          children: [
            const Text(
              'SEMESTER HEALTH',
              style: TextStyle(
                color: Color(0xFF555555),
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
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: ratio,
                      strokeWidth: 12,
                      color: const Color(0xFF7C3AED),
                    ),
                  ).animate().fadeIn(duration: 1000.ms),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${score.round()}%',
                        style: const TextStyle(
                          color: Color(0xFFF0F0F0),
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
  if (score >= 85) return const Color(0xFF10B981);
  if (score >= 60) return const Color(0xFF06B6D4);
  if (score >= 40) return const Color(0xFFF59E0B);
  return const Color(0xFFEF4444);
}
