import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const FlowSpaceApp());
}

class AppColors {
  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF15121B);
  static const Color surfaceAlt = Color(0xFF221E28);
  static const Color card = Color(0x661D1A24);
  static const Color cardBorder = Color(0x33FFFFFF);
  static const Color primary = Color(0xFF7C3AED);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color textPrimary = Color(0xFFE8DFEE);
  static const Color textMuted = Color(0xFF9A8FAA);
  static const Color error = Color(0xFF93000A);
  static const Color errorText = Color(0xFFFFDAD6);
  static const Color codeBackground = Color(0xFF0A0C10);
}

class FlowSpaceApp extends StatelessWidget {
  const FlowSpaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseText = GoogleFonts.interTextTheme();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlowSpace',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          surface: AppColors.surface,
          primary: AppColors.primary,
          secondary: AppColors.cyan,
        ),
        textTheme: baseText.copyWith(
          headlineLarge: GoogleFonts.spaceGrotesk(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          headlineMedium: GoogleFonts.spaceGrotesk(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 18,
            color: AppColors.textMuted,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      home: const FlowSpaceDashboardPage(),
    );
  }
}

class FlowSpaceDashboardPage extends StatelessWidget {
  const FlowSpaceDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF15121B), Color(0xFF0F1117)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const _UrgencyBanner(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _TopBar(),
                      const SizedBox(height: 18),
                      const _GreetingSection(),
                      const SizedBox(height: 14),
                      const _QuoteStrip(),
                      const SizedBox(height: 14),
                      const _FocusCard(),
                      const SizedBox(height: 14),
                      const _ProgressCard(),
                      const SizedBox(height: 14),
                      const _CalendarCard(),
                      const SizedBox(height: 14),
                      const _TaskCard(
                        title: 'Fix Auth Middleware',
                        priority: 'URGENT',
                        priorityColor: AppColors.cyan,
                        tags: ['TYPESCRIPT', 'BACKEND'],
                      ),
                      const SizedBox(height: 10),
                      const _TaskCard(
                        title: 'Bento Grid UI Component',
                        priority: 'FEATURE',
                        priorityColor: AppColors.primary,
                        tags: ['REACT', 'UI/UX'],
                      ),
                      const SizedBox(height: 10),
                      const _TaskCard(
                        title: 'Refactor Docker Files',
                        priority: 'BACKLOG',
                        priorityColor: Color(0xFF7B7688),
                        tags: ['DEVOPS'],
                      ),
                      const SizedBox(height: 10),
                      const _CreateTaskCard(),
                      const SizedBox(height: 14),
                      const _CodeCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNav(),
    );
  }
}

class _UrgencyBanner extends StatelessWidget {
  const _UrgencyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: AppColors.error,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.errorText,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Critical Deadline: Project Alpha Submission in 32 hours.',
            style: GoogleFonts.inter(
              color: AppColors.errorText,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'RESOLVE',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            const Icon(Icons.terminal_rounded, color: AppColors.cyan, size: 20),
            const SizedBox(width: 8),
            Text(
              'Flow',
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.dark_mode_outlined,
          color: Color(0xFFCCC3D8),
          size: 20,
        ),
        const SizedBox(width: 10),
        Stack(
          children: const [
            Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFFCCC3D8),
              size: 22,
            ),
            Positioned(
              right: 1,
              top: 1,
              child: CircleAvatar(radius: 4, backgroundColor: Colors.redAccent),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFF2A2138),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            'JS',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Dev!',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textPrimary,
                  fontSize: 42,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ready to ship some code today?',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 20,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuoteStrip extends StatelessWidget {
  const _QuoteStrip();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: AppColors.primary.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '"The only way to do great work is to love what you do. Stay hungry, stay foolish." - Steve Jobs',
              style: GoogleFonts.inter(
                color: const Color(0xFFCFC7DA),
                fontStyle: FontStyle.italic,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusCard extends StatelessWidget {
  const _FocusCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 12,
      borderColor: AppColors.primary.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "TODAY'S FOCUS",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Icon(
                  Icons.push_pin_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optimize DB Queries',
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.white,
                        fontSize: 38,
                        height: 1.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Refactor the analytics aggregation pipeline to reduce latency by 40%. Critical for the upcoming release.',
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 19,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _TagChip('POSTGRESQL'),
                        _TagChip('PERFORMANCE'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {},
              child: Text(
                'EXECUTE FOCUS',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: 1,
                    strokeWidth: 12,
                    color: const Color(0xFF332B47),
                  ),
                  CircularProgressIndicator(
                    value: 0.75,
                    strokeWidth: 12,
                    color: AppColors.primary,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '75%',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textPrimary,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'DAILY GOAL',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Deep Work Progress',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.primary,
              fontSize: 34,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ve completed 6 hours of focused coding today. Keep the momentum going to reach your target.',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 20,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'START SESSION',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'VIEW LOGS',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'OCTOBER 2023',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textPrimary,
                  letterSpacing: 1.2,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_left,
                color: AppColors.textMuted,
                size: 18,
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: [
              ...['M', 'T', 'W', 'T', 'F', 'S', 'S'].map(
                (d) => Center(
                  child: Text(
                    d,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              ...[
                '28',
                '29',
                '30',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
              ].map((day) => _CalendarCell(day: day)),
              const _CalendarCell(day: '7', isActive: true),
              ...['8', '9', '10', '11'].map((day) => _CalendarCell(day: day)),
            ],
          ),
          const Divider(color: Color(0x22FFFFFF), height: 28),
          const _EventDot(
            label: 'Algo Practice @ 14:00',
            color: AppColors.cyan,
          ),
          const SizedBox(height: 10),
          const _EventDot(
            label: 'System Design @ 16:30',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.title,
    required this.priority,
    required this.priorityColor,
    required this.tags,
  });

  final String title;
  final String priority;
  final Color priorityColor;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      borderRadius: 10,
      leftAccent: priorityColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                priority,
                style: GoogleFonts.spaceGrotesk(
                  color: priorityColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              const Icon(Icons.more_horiz, color: AppColors.textMuted),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((tag) => _TagChip(tag)).toList(),
          ),
        ],
      ),
    );
  }
}

class _CreateTaskCard extends StatelessWidget {
  const _CreateTaskCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColors.primary, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'CREATE NEW TASK',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.codeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.codeBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Row(
                  children: const [
                    _WindowDot(color: Color(0xFFFF5F56)),
                    SizedBox(width: 4),
                    _WindowDot(color: Color(0xFFFFBD2E)),
                    SizedBox(width: 4),
                    _WindowDot(color: Color(0xFF27C93F)),
                  ],
                ),
                const SizedBox(width: 10),
                Text(
                  'flowspace_analytics.py',
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.copy_outlined,
                  size: 14,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
          const Divider(color: Color(0x22FFFFFF), height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.robotoMono(
                  fontSize: 11,
                  color: const Color(0xFFC8D2DF),
                  height: 1.45,
                ),
                children: const [
                  TextSpan(
                    text: 'def ',
                    style: TextStyle(color: Color(0xFFC084FC)),
                  ),
                  TextSpan(
                    text: 'calculate_flow_state',
                    style: TextStyle(color: Color(0xFF22D3EE)),
                  ),
                  TextSpan(text: '(session_data):\n'),
                  TextSpan(text: '  focus_duration = session_data.get('),
                  TextSpan(
                    text: "'duration'",
                    style: TextStyle(color: Color(0xFFFDBA74)),
                  ),
                  TextSpan(text: ', 0)\n  distractions = session_data.get('),
                  TextSpan(
                    text: "'interruptions'",
                    style: TextStyle(color: Color(0xFFFDBA74)),
                  ),
                  TextSpan(text: ', 0)\n\n  '),
                  TextSpan(
                    text: 'if ',
                    style: TextStyle(color: Color(0xFFC084FC)),
                  ),
                  TextSpan(text: 'distractions == 0:\n'),
                  TextSpan(text: '    '),
                  TextSpan(
                    text: 'return ',
                    style: TextStyle(color: Color(0xFFC084FC)),
                  ),
                  TextSpan(text: 'focus_duration * 1.25\n\n  '),
                  TextSpan(
                    text: 'return ',
                    style: TextStyle(color: Color(0xFFC084FC)),
                  ),
                  TextSpan(text: 'focus_duration / (distractions * 0.5)\n\n'),
                  TextSpan(
                    text: '# Current Flow Score Tracking\n',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  TextSpan(text: 'score = calculate_flow_state('),
                  TextSpan(
                    text: '{',
                    style: TextStyle(color: Color(0xFFFDBA74)),
                  ),
                  TextSpan(
                    text: "'duration'",
                    style: TextStyle(color: Color(0xFFFDBA74)),
                  ),
                  TextSpan(text: ': 360, '),
                  TextSpan(
                    text: "'interruptions'",
                    style: TextStyle(color: Color(0xFFFDBA74)),
                  ),
                  TextSpan(text: ': 2'),
                  TextSpan(text: '})\n'),
                  TextSpan(
                    text: 'print',
                    style: TextStyle(color: Color(0xFF22D3EE)),
                  ),
                  TextSpan(text: '(f"State achieved: {score} Fp")\n'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0D14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _BottomIcon(icon: Icons.dashboard, selected: true),
          _BottomIcon(icon: Icons.view_kanban_outlined),
          _BottomIcon(icon: Icons.schedule),
          _BottomIcon(icon: Icons.edit_note),
          _BottomIcon(icon: Icons.equalizer),
        ],
      ),
    );
  }
}

class _BottomIcon extends StatelessWidget {
  const _BottomIcon({required this.icon, this.selected = false});

  final IconData icon;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        size: 20,
        color: selected ? AppColors.cyan : AppColors.textMuted,
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({required this.day, this.isActive = false});

  final String day;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isActive) {
      return Center(
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            day,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return Center(
      child: Text(
        day,
        style: GoogleFonts.inter(color: const Color(0xFFE8DFEE), fontSize: 12),
      ),
    );
  }
}

class _EventDot extends StatelessWidget {
  const _EventDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 13),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1A2A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          color: const Color(0xFFCFC7DA),
          letterSpacing: 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({
    required this.child,
    this.borderRadius = 16,
    this.borderColor,
    this.leftAccent,
  });

  final Widget child;
  final double borderRadius;
  final Color? borderColor;
  final Color? leftAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          if (leftAccent != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: leftAccent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              leftAccent == null ? 12 : 16,
              12,
              12,
              12,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
