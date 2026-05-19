import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/animation_tokens.dart';
import '../../../core/models/subject.dart';
import '../../../app/theme.dart';

class SubjectMasteryCard extends ConsumerWidget {
  const SubjectMasteryCard({
    required this.subject,
    required this.index,
    required this.hoursProvider,
    required this.onTap,
    super.key,
  });

  final Subject subject;
  final int index;
  final ProviderListenable<AsyncValue<double>> hoursProvider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hours = ref.watch(hoursProvider).valueOrNull ?? 0;
    final progress = (subject.completionPercent * 100).clamp(0, 100).toDouble();
    final module = subject.modules.where((m) => !m.isCompleted).firstOrNull;
    final color = _colorFromHex(subject.colorHex);
    final barColor = progress == 100
        ? AppTheme.success
        : progress >= 70
        ? AppTheme.accent
        : AppTheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x0DFFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _iconForName(subject.iconName),
                      color: index.isEven
                          ? AppTheme.primary
                          : AppTheme.accent,
                      size: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${hours.toStringAsFixed(0)} HOURS TRACKED',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                subject.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                module == null
                    ? 'All modules completed'
                    : 'Module ${module.moduleNumber}: ${module.name}',
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    'PROGRESS',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${progress.round()}%',
                    style: TextStyle(
                      color: barColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress / 100),
                  duration: kChartDuration,
                  curve: kChartCurve,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 4,
                      backgroundColor: AppTheme.surfaceElevated,
                      color: barColor,
                    );
                  },
                ),
              ),
              if (progress == 100) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'COMPLETE',
                    style: TextStyle(
                      color: AppTheme.success,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().scale(duration: kMountDuration),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

IconData _iconForName(String iconName) {
  return switch (iconName) {
    'psychology' => Icons.psychology_alt_outlined,
    'code' => Icons.code,
    'memory' => Icons.memory,
    'science' => Icons.science_outlined,
    'calculate' => Icons.calculate_outlined,
    _ => Icons.menu_book_outlined,
  };
}

Color _colorFromHex(String hex) {
  final value = hex.replaceFirst('#', '');
  if (value.length != 6) return AppTheme.primary;
  return Color(int.parse('FF$value', radix: 16));
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
