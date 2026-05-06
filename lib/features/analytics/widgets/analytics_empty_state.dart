import 'package:flutter/material.dart';

const Color _textSecondary = Color(0xFF555555);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _accent = Color(0xFF7C3AED);
const Color _accentSoft = Color(0x337C3AED);

class AnalyticsEmptyState extends StatelessWidget {
  const AnalyticsEmptyState({
    required this.message,
    this.icon = Icons.insights_outlined,
    super.key,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _accentSoft,
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _accent.withValues(alpha: 0.6)),
                ),
              ),
              Icon(icon, color: _accent, size: 22),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: _textSecondary,
            fontSize: 12,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Start one focus session to populate this card.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _textPrimary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
