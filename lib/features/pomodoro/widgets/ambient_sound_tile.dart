import 'package:flutter/material.dart';

class AmbientSoundTile extends StatelessWidget {
  const AmbientSoundTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF7C3AED) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0x557C3AED) : const Color(0xFF262626),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : const Color(0xFF555555),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
