import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'features/dashboard/widgets/calendar_widget.dart';
import 'features/dashboard/widgets/active_focus_session_card.dart';
import 'core/providers/session_timer_provider.dart';
import 'core/models/pomodoro_session.dart';
import 'widgets/app_bottom_nav.dart';
import 'widgets/app_drawer.dart';
import 'widgets/app_top_bar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        useTransparentBackground: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 24,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.purple.withValues(alpha: 0.3),
              radius: 16,
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReviewBanner(),
            const SizedBox(height: 24),
            _buildWelcomeText(),
            const SizedBox(height: 24),
            const ActiveFocusSessionCard(),
            const SizedBox(height: 16),
            _buildStreakCard(),
            const SizedBox(height: 16),
            _buildDailyGoalCard(context),
            const SizedBox(height: 16),
            const DashboardCalendarWidget(),
            const SizedBox(height: 16),
            _buildQuoteCard(),
            const SizedBox(height: 80), // Padding for bottom nav & FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Demo: Start a mock session
          final mockSession = PomodoroSession()
            ..uuid = ''
            ..sessionType = 'focus'
            ..linkedTaskId = "1"
            ..linkedTaskTitle = "Complete User Interface Audit"
            ..startTime = DateTime.now()
            ..plannedDurationSeconds = 0
            ..actualDurationSeconds = 0
            ..isCompleted = false
            ..isAbandoned = false;
          await ref.read(sessionTimerProvider.notifier).startTimer(mockSession);
        },
        backgroundColor: const Color(0xFF8B5CF6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.bolt, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }

  Widget _buildReviewBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE48E83).withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFE48E83)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Weekly Review\nOverdue: Reflect on your focus sessions from last week to maintain streak.',
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Complete\nNow',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFE48E83),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome back, Productivity Pro.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready for some Deep Work? Your\nenvironment is optimized.',
          style: TextStyle(color: Colors.grey[400], fontSize: 14, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildStreakCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF13101A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(Icons.bolt, color: Color(0xFFC084FC), size: 40),
          const SizedBox(height: 12),
          const Text(
            '14',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Day Focus Streak',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 24,
                decoration: BoxDecoration(
                  color: index < 4
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF2A2438),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            'Top 5% of users this week',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF13101A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 80.0,
            lineWidth: 12.0,
            percent: 0.75,
            circularStrokeCap: CircularStrokeCap.round,
            backgroundColor: const Color(0xFF2A2438),
            progressColor: const Color(0xFF8B5CF6),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '75%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Daily Goal',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  Text(
                    '6h 15m',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'FOCUS TIME',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    '12',
                    style: TextStyle(
                      color: Color(0xFF2DD4BF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'TASKS DONE',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static const List<Map<String, String>> _techQuotes = [
    {
      'quote': "Artificial intelligence is the new electricity.",
      'author': "ANDREW NG",
    },
    {
      'quote':
          "The real danger is not that computers will begin to think like men, but that men will begin to think like computers.",
      'author': "SYDNEY J. HARRIS",
    },
    {
      'quote':
          "Machine intelligence is the last invention that humanity will ever need to make.",
      'author': "NICK BOSTROM",
    },
    {
      'quote':
          "By 2029, computers will have emotional intelligence and be convincing as people.",
      'author': "RAY KURZWEIL",
    },
    {
      'quote':
          "We can build a much brighter future where humans are relieved of menial work using AI.",
      'author': "ANDREW NG",
    },
    {
      'quote':
          "The question is not whether machines can think, but whether men do.",
      'author': "B. F. SKINNER",
    },
    {
      'quote':
          "AI is likely to be either the best or worst thing to happen to humanity.",
      'author': "STEPHEN HAWKING",
    },
  ];

  Map<String, String> _getDailyQuote() {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final index = dayOfYear % _techQuotes.length;
    return _techQuotes[index];
  }

  Widget _buildQuoteCard() {
    final dailyQuote = _getDailyQuote();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF13101A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -20,
            child: Text(
              '"',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.05),
                fontSize: 120,
                fontFamily: 'serif',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '"${dailyQuote['quote']}"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 1,
                    color: const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dailyQuote['author']!,
                      style: const TextStyle(
                        color: Color(0xFFC084FC),
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
