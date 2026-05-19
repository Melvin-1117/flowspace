import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/animation_tokens.dart';
import '../../../core/models/github_event_cache.dart';
import '../providers/pulse_providers.dart';
import 'event_stream_item.dart';
import '../../../app/theme.dart';
import 'pulse_theme.dart';

class EventStreamTerminal extends ConsumerStatefulWidget {
  const EventStreamTerminal({super.key});

  @override
  ConsumerState<EventStreamTerminal> createState() =>
      _EventStreamTerminalState();
}

class _EventStreamTerminalState extends ConsumerState<EventStreamTerminal> {
  final ScrollController _controller = ScrollController();
  bool _showScrollToBottom = false;
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    _cursorTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => mounted ? setState(() => _cursorVisible = !_cursorVisible) : null,
    );
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final delta = _controller.position.maxScrollExtent - _controller.offset;
    final shouldShow = delta > 120;
    if (shouldShow != _showScrollToBottom) {
      setState(() => _showScrollToBottom = shouldShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(recentEventsProvider);
    return Container(
      decoration: BoxDecoration(
        color: pulseCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                _dot(pulseDanger),
                const SizedBox(width: 4),
                _dot(AppTheme.warning),
                const SizedBox(width: 4),
                _dot(pulseSuccess),
                const Spacer(),
                Text(
                  'REAL-TIME STREAM',
                  style: GoogleFonts.spaceGrotesk(
                    color: pulseMuted,
                    fontSize: 11,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 240,
            child: Stack(
              children: [
                eventsAsync.when(
                  data: (events) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_controller.hasClients && !_showScrollToBottom) {
                        _controller.jumpTo(
                          _controller.position.maxScrollExtent,
                        );
                      }
                    });
                    return ListView(
                      controller: _controller,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      children: [
                        for (var i = 0; i < events.length; i++)
                          EventStreamItem(
                            event: events[i],
                            index: i,
                            onTap: () => _showEventDetails(context, events[i]),
                          ),
                        Row(
                          children: [
                            Text(
                              '> listening for webhooks...',
                              style: GoogleFonts.robotoMono(
                                color: pulseSuccess,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _cursorVisible ? '|' : ' ',
                              style: GoogleFonts.robotoMono(
                                color: pulseSuccess,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: pulsePrimary),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Unable to load events',
                      style: GoogleFonts.spaceGrotesk(color: pulseMuted),
                    ),
                  ),
                ),
                if (_showScrollToBottom)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: FloatingActionButton.small(
                      onPressed: () {
                        if (_controller.hasClients) {
                          _controller.animateTo(
                            _controller.position.maxScrollExtent,
                            duration: kScrollToDuration,
                            curve: kScrollToCurve,
                          );
                        }
                      },
                      backgroundColor: pulsePrimary,
                      child: const Icon(Icons.arrow_downward, size: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Future<void> _showEventDetails(
    BuildContext context,
    GitHubEventCache event,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: pulseCard,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.eventType,
              style: GoogleFonts.spaceGrotesk(
                color: pulseText,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              event.createdAt.toString(),
              style: GoogleFonts.spaceGrotesk(color: pulseMuted),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                event.repoFullName,
                style: GoogleFonts.spaceGrotesk(color: pulseText),
              ),
              subtitle: Text(
                event.description,
                style: GoogleFonts.spaceGrotesk(color: pulseMuted),
              ),
              trailing: const Icon(Icons.open_in_new, color: pulsePrimary),
              onTap: () => _openUrl(event.htmlUrl),
            ),
            if ((event.fullMessage ?? '').isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                'Message',
                style: GoogleFonts.spaceGrotesk(
                  color: pulseText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                event.fullMessage!,
                style: GoogleFonts.spaceGrotesk(color: pulseMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
