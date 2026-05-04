import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';

class SessionTypeToggle extends ConsumerWidget {
  const SessionTypeToggle({super.key, required this.onSwitchType});

  final Future<void> Function(SessionType type) onSwitchType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentType = ref.watch(sessionTypeProvider);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1EFFFFFF)),
      ),
      child: Row(
        children: SessionType.values.map((type) {
          final selected = type == currentType;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSwitchType(type),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF7C3AED)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  type.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFF555555),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
