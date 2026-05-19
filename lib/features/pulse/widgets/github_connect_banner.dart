import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pulse_theme.dart';

class GitHubConnectBanner extends StatelessWidget {
  const GitHubConnectBanner({required this.onConnect, super.key});

  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: pulseCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Connect your GitHub account to see your activity',
            style: GoogleFonts.spaceGrotesk(
              color: pulseText,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onConnect,
            icon: const Icon(Icons.link),
            style: ElevatedButton.styleFrom(
              backgroundColor: pulsePrimary,
              foregroundColor: Colors.white,
            ),
            label: const Text('Connect GitHub'),
          ),
        ],
      ),
    );
  }
}
