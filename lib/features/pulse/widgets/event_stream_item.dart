import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/models/github_event_cache.dart';
import '../../../app/theme.dart';
import 'pulse_theme.dart';

class EventStreamItem extends StatelessWidget {
  const EventStreamItem({
    required this.event,
    required this.onTap,
    required this.index,
    super.key,
  });

  final GitHubEventCache event;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(event.createdAt);
    return InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RichText(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: GoogleFonts.robotoMono(fontSize: 11),
                children: [
                  TextSpan(
                    text: '[$timestamp] ',
                    style: const TextStyle(color: pulseMuted),
                  ),
                  TextSpan(
                    text: '${event.eventType} ',
                    style: TextStyle(
                      color: _eventColor(event.eventType),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: '${event.description}\n',
                    style: const TextStyle(color: pulseText),
                  ),
                  TextSpan(
                    text:
                        '  ↳ ${event.repoFullName}:${event.branch ?? 'main'} @${event.shortSha ?? '--'}',
                    style: const TextStyle(color: pulseMuted),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .slideX(begin: -0.05, end: 0, duration: 200.ms, delay: (index * 50).ms)
        .fadeIn(duration: 200.ms, delay: (index * 50).ms);
  }
}

Color _eventColor(String type) => switch (type) {
  'PUSH' => pulseSuccess,
  'MERGE' => pulsePrimary,
  'RELEASE' => pulseCyan,
  'ISSUE' => pulseDanger,
  'WATCH' => pulseMuted,
  'FORK' => AppTheme.warning,
  'CREATE' => pulseSuccess,
  _ => pulseText,
};
