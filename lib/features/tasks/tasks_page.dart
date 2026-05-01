import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTasksContent();
  }

  Widget _buildTasksContent() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF06060A), Color(0xFF030005)],
              ),
            ),
          ),
        ),
        ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            const SizedBox(height: 10),
            _buildProjectHeader(),
            const SizedBox(height: 24),
            _buildControls(),
            const SizedBox(height: 32),
            _buildToDoSectionHeader(),
            const SizedBox(height: 16),
            _buildTaskCard(
              tag: 'FRONTEND',
              title: 'Implement OLED Dark Mode Theme engine',
              description:
                  'Ensure all containers use the #0D0D0D\nglassmorphism standard with 16px blur effect.',
              priority: 'High',
              isHighPriority: true,
              deps: '2 deps',
            ),
            const SizedBox(height: 16),
            _buildTaskCard(
              tag: 'UI DESIGN',
              title: 'Refine typography scale for mobile devices',
              description: '',
              priority: 'Med',
              isHighPriority: false,
              deps: '',
            ),
            const SizedBox(height: 24),
            _buildTaskCard(
              tag: 'BACKEND',
              title: 'Finalize realtime sync and offline conflict logic',
              description:
                  'Handle optimistic updates and queue retries when network is unstable.',
              priority: 'High',
              isHighPriority: true,
              deps: '1 dep',
            ),
          ],
        ),
        Positioned(
          right: -130,
          top: 305,
          child: Container(
            width: 240,
            height: 385,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.85),
                width: 1.8,
              ),
            ),
          ),
        ),
        _buildFloatingActions(),
      ],
    );
  }

  Widget _buildProjectHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Sprint: Nebula',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              height: 32,
              width: 80,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF0A595B),
                      child: Text(
                        'AM',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF332A54),
                      child: Text(
                        'SK',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 36,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFF1E1E26),
                      child: Text(
                        '+4',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFB6B7C2),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 16, color: const Color(0xFF333333)),
            const SizedBox(width: 16),
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF06B6D4),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '82% COMPLETE',
              style: GoogleFonts.inter(
                color: const Color(0xFF8D8FA1),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF25252D)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1F),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.view_kanban_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kanban',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.format_list_bulleted,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'List',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D0D),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF25252D)),
          ),
          child: const Icon(
            Icons.filter_list,
            color: Color(0xFF6B7280),
            size: 18,
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.add, size: 18),
              const SizedBox(width: 6),
              Text(
                'New\nTask',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildToDoSectionHeader() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF333333),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'TO DO',
          style: GoogleFonts.inter(
            color: const Color(0xFF9CA3AF),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '3',
          style: GoogleFonts.inter(
            color: const Color(0xFF4B5563),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        const Icon(Icons.more_horiz, color: Color(0xFF6B7280)),
        const SizedBox(width: 24),
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFF8B5CF6),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required String tag,
    required String title,
    required String description,
    required String priority,
    required bool isHighPriority,
    required String deps,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E1E26)),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: Colors.black.withValues(alpha: 0.28),
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const Icon(Icons.edit_note, color: Color(0xFF6B7280), size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: GoogleFonts.inter(
                color: const Color(0xFF6B7280),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF1A1A1A), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                isHighPriority ? Icons.priority_high : Icons.low_priority,
                color: isHighPriority
                    ? const Color(0xFFE48E83)
                    : const Color(0xFF6B7280),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                priority,
                style: GoogleFonts.inter(
                  color: isHighPriority
                      ? const Color(0xFFE48E83)
                      : const Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (deps.isNotEmpty) ...[
                const Icon(Icons.link, color: Color(0xFF4B5563), size: 16),
                const SizedBox(width: 6),
                Text(
                  deps,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ] else ...[
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xFF262626),
                  child: Text(
                    'MA',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 10),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActions() {
    return Positioned(
      bottom: 30,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildMiniAction(icon: Icons.search),
          const SizedBox(height: 10),
          _buildMiniAction(icon: Icons.bolt),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x773C18B6),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: () {},
              backgroundColor: const Color(0xFF8B5CF6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 34),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAction({required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1FFFFFFF)),
        color: const Color(0xFF101014),
      ),
      child: SizedBox(
        width: 56,
        height: 56,
        child: Icon(icon, color: Colors.white, size: 26),
      ),
    );
  }
}
