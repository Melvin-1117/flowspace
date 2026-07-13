import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A styled error card shown when an async provider fails.
/// Displays a message and an optional retry button.
class ErrorCard extends StatelessWidget {
  const ErrorCard({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF080C14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1A2640)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFFF3B5C),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF6B8CAE),
                fontSize: 13,
              ),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.spaceGrotesk(
                color: const Color(0xFF006EE6),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
