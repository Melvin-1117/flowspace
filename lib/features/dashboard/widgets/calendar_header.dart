import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final VoidCallback onLeftChevronTap;
  final VoidCallback onRightChevronTap;
  final VoidCallback onTitleTap;

  const CalendarHeader({
    super.key,
    required this.focusedDay,
    required this.onLeftChevronTap,
    required this.onRightChevronTap,
    required this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTitleTap,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      DateFormat('MMMM yyyy').format(focusedDay).toUpperCase(),
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFFFFFF),
                        letterSpacing: 1.2,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.expand_more_rounded,
                    color: Color(0xFF6B7280),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onLeftChevronTap,
                icon: const Icon(
                  Icons.chevron_left,
                  color: Color(0xFF7C3AED), // Primary color
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onRightChevronTap,
                icon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF7C3AED), // Primary color
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
