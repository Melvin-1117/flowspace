import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';

const Color _bg = Color(0xFF000000);
const Color _surface = Color(0xFF0D0D0D);
const Color _surfaceAlt = Color(0xFF151515);
const Color _primary = Color(0xFF7C3AED);
const Color _secondary = Color(0xFF4CD7F6);
const Color _text = Color(0xFFE8DFEE);
const Color _muted = Color(0xFF958DA1);

class PulseDashboardScreen extends StatefulWidget {
  const PulseDashboardScreen({super.key});

  @override
  State<PulseDashboardScreen> createState() => _PulseDashboardScreenState();
}

class _PulseDashboardScreenState extends State<PulseDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: const AppDrawer(),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1D1A24),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 108),
        children: [
          Text(
            'LIVE REPOSITORY ANALYSIS',
            style: GoogleFonts.inter(
              color: _secondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pulse Dashboard',
            style: GoogleFonts.spaceGrotesk(
              color: _text,
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _ActionChip(
                  icon: Icons.calendar_today,
                  label: 'Last 30 Days',
                  filled: false,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionChip(
                  icon: Icons.refresh,
                  label: 'Sync Data',
                  filled: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _GlassCard(child: _ContributionCard()),
          const SizedBox(height: 14),
          _GlassCard(child: _LanguageCard()),
          const SizedBox(height: 14),
          _GlassCard(child: _TerminalCard()),
          const SizedBox(height: 14),
          _GlassCard(child: _TopReposCard()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: _primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0D0D0D),
        selectedItemColor: _primary,
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
        currentIndex: 4,
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
            icon: Icon(Icons.code_outlined),
            activeIcon: Icon(Icons.code),
            label: 'GITHUB',
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: child,
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.filled,
  });

  final IconData icon;
  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: filled ? _primary : const Color(0xFF262626),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: filled
              ? Colors.transparent
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContributionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contribution Activity',
          style: GoogleFonts.spaceGrotesk(
            color: _text,
            fontSize: 30 - 8,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                '1,284 contributions in the last year',
                style: GoogleFonts.inter(color: _muted, fontSize: 14),
              ),
            ),
            Text('Less', style: GoogleFonts.inter(color: _muted, fontSize: 10)),
            const SizedBox(width: 4),
            Row(
              children: const [
                _LevelCell(color: Color(0xFF181818)),
                _LevelCell(color: Color(0xFF32195A)),
                _LevelCell(color: Color(0xFF5D2FB0)),
                _LevelCell(color: _primary),
              ],
            ),
            const SizedBox(width: 4),
            Text('More', style: GoogleFonts.inter(color: _muted, fontSize: 10)),
          ],
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 106,
          child: Row(
            children: List.generate(
              8,
              (col) => Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: List.generate(7, (row) {
                    final seed = (col * 7 + row) % 5;
                    final colors = [
                      const Color(0xFF161616),
                      const Color(0xFF1F1F1F),
                      const Color(0xFF32195A),
                      const Color(0xFF5D2FB0),
                      _primary,
                    ];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: _LevelCell(color: colors[seed]),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LevelCell extends StatelessWidget {
  const _LevelCell({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Language Distribution',
          style: GoogleFonts.spaceGrotesk(
            color: _text,
            fontSize: 26 - 4,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 126,
                height: 126,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 16,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF2A2A2A)),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 126,
                height: 126,
                child: CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 16,
                  valueColor: const AlwaysStoppedAnimation(_primary),
                  backgroundColor: Colors.transparent,
                ),
              ),
              SizedBox(
                width: 126,
                height: 126,
                child: Transform.rotate(
                  angle: 4.084,
                  child: CircularProgressIndicator(
                    value: 0.2,
                    strokeWidth: 16,
                    valueColor: const AlwaysStoppedAnimation(_secondary),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '82%',
                      style: GoogleFonts.spaceGrotesk(
                        color: _text,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'TypeScript',
                      style: GoogleFonts.inter(color: _muted, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _LegendRow(color: _primary, label: 'TypeScript', value: '65%'),
        const SizedBox(height: 8),
        const _LegendRow(color: _secondary, label: 'Rust', value: '20%'),
        const SizedBox(height: 8),
        const _LegendRow(
          color: Color(0xFF6B7280),
          label: 'Other',
          value: '15%',
        ),
      ],
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.value,
  });

  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.inter(color: _text, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            color: _text,
            fontSize: 24 - 8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TerminalCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _dot(const Color(0xFFEF4444)),
              const SizedBox(width: 6),
              _dot(const Color(0xFFF59E0B)),
              const SizedBox(width: 6),
              _dot(const Color(0xFF10B981)),
              const Spacer(),
              Text(
                'REAL-TIME STREAM',
                style: GoogleFonts.inter(
                  color: const Color(0xFF6B7280),
                  fontSize: 10,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _TerminalLine(
          stamp: '[2023-10-24 09:12:44]',
          tag: 'PUSH',
          message: 'feat(auth): implement oauth2 flow',
          detail: '↳ core-api:main @d23f5a1',
        ),
        _TerminalLine(
          stamp: '[2023-10-24 10:05:01]',
          tag: 'MERGE',
          message: 'Merge pull request #128 from dev/hotfix-ui',
          detail: '↳ ui-shell:staging @f98a21b',
        ),
        _TerminalLine(
          stamp: '[2023-10-24 11:45:12]',
          tag: 'RELEASE',
          message: 'v2.4.0-stable successfully deployed',
          detail: '↳ prod-cluster-01',
          messageColor: _primary,
        ),
        _TerminalLine(
          stamp: '[2023-10-24 12:01:33]',
          tag: 'ISSUE',
          message: 'Opened: "Memory leak in socket handler"',
          detail: '↳ issue-tracker #442',
        ),
        const SizedBox(height: 8),
        Text(
          '> listening for webhooks...',
          style: GoogleFonts.robotoMono(color: _text, fontSize: 12),
        ),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _TerminalLine extends StatelessWidget {
  const _TerminalLine({
    required this.stamp,
    required this.tag,
    required this.message,
    required this.detail,
    this.messageColor = _text,
  });

  final String stamp;
  final String tag;
  final String message;
  final String detail;
  final Color messageColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.robotoMono(fontSize: 12),
          children: [
            TextSpan(
              text: '$stamp ',
              style: const TextStyle(color: _primary),
            ),
            TextSpan(
              text: '$tag ',
              style: const TextStyle(
                color: _secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: '$message\n',
              style: TextStyle(color: messageColor),
            ),
            TextSpan(
              text: '  $detail',
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopReposCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repos = <_RepoData>[
      const _RepoData(
        icon: Icons.terminal,
        iconColor: _primary,
        title: 'flowspace-engine',
        stars: '1.2k',
        forks: '234',
        lang: 'Rust',
        langColor: _secondary,
        updated: '2h ago',
      ),
      const _RepoData(
        icon: Icons.code,
        iconColor: _secondary,
        title: 'ui-glass-system',
        stars: '856',
        forks: '88',
        lang: 'TypeScript',
        langColor: _primary,
        updated: '1d ago',
      ),
      const _RepoData(
        icon: Icons.storage,
        iconColor: Color(0xFF9CA3AF),
        title: 'data-lake-adapter',
        stars: '124',
        forks: '12',
        lang: 'Python',
        langColor: Color(0xFFF59E0B),
        updated: '4d ago',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Top Repositories',
              style: GoogleFonts.spaceGrotesk(
                color: _text,
                fontSize: 24 - 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              'VIEW ALL',
              style: GoogleFonts.inter(
                color: _primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...repos.map(
          (repo) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _RepoTile(data: repo),
          ),
        ),
      ],
    );
  }
}

class _RepoTile extends StatelessWidget {
  const _RepoTile({required this.data});

  final _RepoData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18 - 2,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.star_border, size: 12, color: _muted),
                    const SizedBox(width: 3),
                    Text(
                      data.stars,
                      style: GoogleFonts.inter(color: _muted, fontSize: 11),
                    ),
                    const SizedBox(width: 9),
                    const Icon(Icons.call_split, size: 12, color: _muted),
                    const SizedBox(width: 3),
                    Text(
                      data.forks,
                      style: GoogleFonts.inter(color: _muted, fontSize: 11),
                    ),
                    const SizedBox(width: 9),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: data.langColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      data.lang,
                      style: GoogleFonts.inter(
                        color: data.langColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            data.updated,
            style: GoogleFonts.robotoMono(color: _muted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _RepoData {
  const _RepoData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.stars,
    required this.forks,
    required this.lang,
    required this.langColor,
    required this.updated,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String stars;
  final String forks;
  final String lang;
  final Color langColor;
  final String updated;
}
