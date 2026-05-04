import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pomodoro_providers.dart';
import 'ambient_sound_tile.dart';

class AmbientSoundGrid extends ConsumerWidget {
  const AmbientSoundGrid({super.key});

  static const List<_AmbientOption> _options = <_AmbientOption>[
    _AmbientOption('rain', 'Rain', Icons.water_drop_outlined),
    _AmbientOption('waves', 'Waves', Icons.waves_rounded),
    _AmbientOption('forest', 'Forest', Icons.forest_outlined),
    _AmbientOption('wind', 'Wind', Icons.air_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ambient = ref.watch(ambientSoundProvider);
    final notifier = ref.read(ambientSoundProvider.notifier);
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AMBIENT SOUND',
            style: TextStyle(
              color: Color(0xFF555555),
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: _options.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.4,
            ),
            itemBuilder: (context, index) {
              final option = _options[index];
              return AmbientSoundTile(
                label: option.label,
                icon: option.icon,
                selected: ambient.selectedSound == option.key,
                onTap: () => notifier.selectOrToggle(option.key),
                onLongPress: () => _showVolumeDialog(context, ref),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showVolumeDialog(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(ambientSoundProvider.notifier);
    var volume = ref.read(ambientSoundProvider).volume;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0D0D0D),
          title: const Text('Ambient Volume'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Slider(
                value: volume,
                min: 0,
                max: 1,
                onChanged: (value) async {
                  setState(() => volume = value);
                  await notifier.setVolume(value);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _AmbientOption {
  const _AmbientOption(this.key, this.label, this.icon);

  final String key;
  final String label;
  final IconData icon;
}

Widget _sectionCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF0D0D0D),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x1AFFFFFF)),
    ),
    child: child,
  );
}
