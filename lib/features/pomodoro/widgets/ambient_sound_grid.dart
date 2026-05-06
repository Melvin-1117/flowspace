import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pomodoro_providers.dart';

class AmbientSoundGrid extends ConsumerWidget {
  const AmbientSoundGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambientState = ref.watch(ambientSoundProvider);
    final notifier = ref.read(ambientSoundProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13101A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ambient Sounds',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children: [
              _buildSoundButton(
                context,
                icon: Icons.nature,
                label: 'Rain',
                isSelected: ambientState.selected == 'rain',
                onTap: () => notifier.setSound('rain'),
              ),
              _buildSoundButton(
                context,
                icon: Icons.waves,
                label: 'Ocean',
                isSelected: ambientState.selected == 'ocean',
                onTap: () => notifier.setSound('ocean'),
              ),
              _buildSoundButton(
                context,
                icon: Icons.forest,
                label: 'Forest',
                isSelected: ambientState.selected == 'forest',
                onTap: () => notifier.setSound('forest'),
              ),
              _buildSoundButton(
                context,
                icon: Icons.coffee,
                label: 'Cafe',
                isSelected: ambientState.selected == 'cafe',
                onTap: () => notifier.setSound('cafe'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSoundButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF2A2A2A),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[400],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
