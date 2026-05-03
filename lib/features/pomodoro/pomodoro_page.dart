import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PomodoroPage extends StatefulWidget {
  const PomodoroPage({super.key});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  final List<String> _modes = ['Focus', 'Short Break', 'Long Break'];
  final List<String> _ambientSounds = ['Rain', 'Waves', 'Forest', 'Wind'];
  int _selectedMode = 0;
  int _selectedAmbient = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF7C3AED),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF09090B),
        selectedItemColor: const Color(0xFF7C3AED),
        unselectedItemColor: const Color(0xFF7A7A83),
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go('/focus');
          if (index == 1) context.go('/tasks');
          if (index == 2) context.go('/pomodoro');
          if (index == 3) context.go('/planner');
          if (index == 4) context.go('/settings');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            label: 'FOCUS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'TASKS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_top_rounded),
            activeIcon: Icon(Icons.hourglass_bottom_rounded),
            label: 'POMO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'PLANNER',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'SETTINGS',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const Divider(height: 1, color: Color(0x16FFFFFF)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                child: Column(
                  children: [
                    _buildModeTabs(),
                    const SizedBox(height: 18),
                    _buildTimerDial(),
                    const SizedBox(height: 18),
                    _buildDailyGoalCard(),
                    const SizedBox(height: 18),
                    _buildNowPlayingCard(),
                    const SizedBox(height: 14),
                    _buildAmbientCard(),
                    const SizedBox(height: 14),
                    _buildHistoryCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Color(0xFF7C3AED)),
            splashRadius: 20,
          ),
          const Text(
            'FlowSpace',
            style: TextStyle(
              color: Color(0xFFF0F0F0),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: const Color(0x33FFFFFF)),
              color: const Color(0xFF121212),
            ),
            child: const Icon(Icons.person, size: 18, color: Color(0xFFB0B0B0)),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1EFFFFFF)),
      ),
      child: Row(
        children: List.generate(_modes.length, (index) {
          final selected = _selectedMode == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedMode = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF24183F)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: selected
                      ? Border.all(color: const Color(0x3F7C3AED))
                      : null,
                ),
                child: Text(
                  _modes[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFFF5F5F5)
                        : const Color(0xFF7A7A83),
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTimerDial() {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size.square(300),
              painter: _PomodoroRingPainter(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '25:00',
                  style: TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _circleAction(
                      icon: Icons.play_arrow_rounded,
                      primary: true,
                      onTap: () {},
                    ),
                    const SizedBox(width: 10),
                    _circleAction(
                      icon: Icons.refresh_rounded,
                      primary: false,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleAction({
    required IconData icon,
    required bool primary,
    required VoidCallback onTap,
  }) {
    return Material(
      color: primary ? const Color(0xFF7C3AED) : const Color(0xFF101014),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x1EFFFFFF)),
            boxShadow: primary
                ? const [BoxShadow(color: Color(0x667C3AED), blurRadius: 18)]
                : null,
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildDailyGoalCard() {
    return _sectionCard(
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircularProgressIndicator(
                  value: 0.75,
                  strokeWidth: 4,
                  backgroundColor: Color(0xFF1D1D22),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF06B6D4)),
                ),
                const Text(
                  '3/4',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DAILY FOCUS GOAL',
                style: TextStyle(
                  color: Color(0xFF777782),
                  fontSize: 12,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                '75% Complete',
                style: TextStyle(
                  color: Color(0xFFF3F3F3),
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNowPlayingCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NOW PLAYING',
            style: TextStyle(
              color: Color(0xFF777782),
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF121733),
                      Color(0xFF4C1D95),
                      Color(0xFF00BCD4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: const Color(0x26FFFFFF)),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deep Work Beats',
                      style: TextStyle(
                        color: Color(0xFFF2F2F2),
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'FlowState Records',
                      style: TextStyle(color: Color(0xFFAAAAAE), fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.skip_previous_rounded, color: Color(0xFFA0A0A5)),
              _circleAction(
                icon: Icons.play_arrow_rounded,
                primary: true,
                onTap: () {},
              ),
              const Icon(Icons.skip_next_rounded, color: Color(0xFFA0A0A5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmbientCard() {
    final icons = <IconData>[
      Icons.water_drop_outlined,
      Icons.waves_rounded,
      Icons.forest_outlined,
      Icons.air_rounded,
    ];
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AMBIENT SOUND',
            style: TextStyle(
              color: Color(0xFF777782),
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            itemCount: _ambientSounds.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final selected = index == _selectedAmbient;
              return GestureDetector(
                onTap: () => setState(() => _selectedAmbient = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF251A43)
                        : const Color(0xFF131316),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? const Color(0x667C3AED)
                          : const Color(0x22FFFFFF),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icons[index],
                        color: selected
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFFC2C2C7),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _ambientSounds[index],
                        style: TextStyle(
                          color: selected
                              ? const Color(0xFFE4D9FF)
                              : const Color(0xFFD0D0D3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SESSION HISTORY',
            style: TextStyle(
              color: Color(0xFF777782),
              letterSpacing: 1.6,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _historyItem(
            color: const Color(0xFF8B5CF6),
            title: 'Deep Work Block',
            time: '10:30 AM - 11:20 AM',
            duration: '50 MIN',
            muted: false,
          ),
          const SizedBox(height: 10),
          _historyItem(
            color: const Color(0xFF22D3EE),
            title: 'Project Sprint',
            time: '09:15 AM - 09:40 AM',
            duration: '25 MIN',
            muted: false,
          ),
          const SizedBox(height: 10),
          _historyItem(
            color: const Color(0xFF232329),
            title: 'Quick Catchup',
            time: '08:45 AM - 09:00 AM',
            duration: '15 MIN',
            muted: true,
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFB2B2B7),
                side: const BorderSide(color: Color(0x1EFFFFFF)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'VIEW ANALYTICS',
                style: TextStyle(letterSpacing: 1.2, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyItem({
    required Color color,
    required String title,
    required String time,
    required String duration,
    required bool muted,
  }) {
    final primaryColor = muted
        ? const Color(0xFF4C4C53)
        : const Color(0xFFF1F1F2);
    final secondaryColor = muted
        ? const Color(0xFF3B3B43)
        : const Color(0xFF8F8F99);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 6,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(time, style: TextStyle(color: secondaryColor, fontSize: 16)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF111116),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                duration,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090A0D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1EFFFFFF)),
      ),
      child: child,
    );
  }
}

class _PomodoroRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    final basePaint = Paint()
      ..color = const Color(0xFF101014)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, basePaint);

    final arcPaint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    const segmentCount = 5;
    final segmentSweep = (2 * math.pi) / segmentCount * 0.58;
    final segmentGap = (2 * math.pi) / segmentCount - segmentSweep;
    double startAngle = -math.pi / 2;

    for (var i = 0; i < segmentCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle + (segmentGap / 2),
        segmentSweep,
        false,
        arcPaint,
      );
      startAngle += segmentSweep + segmentGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
