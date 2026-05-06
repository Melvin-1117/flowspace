import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import 'analytics_payload.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({this.payload, super.key});

  final AnalyticsPayload? payload;

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final payload = widget.payload;
    final focusHours = ((payload?.totalFocusMinutes ?? 750) / 60)
        .toStringAsFixed(1);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF000000),
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF8B5CF6)),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'FlowSpace',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1A1A1A),
              child: Text('FS', style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'SYSTEM PERFORMANCE',
            style: TextStyle(
              color: Color(0xFF00D9FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Analytics',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 48,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          _buildFocusRecordCard('${focusHours}h'),
          const SizedBox(height: 16),
          _buildWeeklyVelocityChart(),
          const SizedBox(height: 16),
          _buildAllocationChart(),
          const SizedBox(height: 16),
          _buildConsistencyArchive(),
          const SizedBox(height: 16),
          _buildMetricProgressBar(
            label: 'AVG SESSION DURATION',
            value: '52m',
            change: '(-4m vs LY)',
            progressColor: const Color(0xFF00D9FF),
            progress: 0.65,
            icon: Icons.alarm,
            iconColor: const Color(0xFF00D9FF),
          ),
          const SizedBox(height: 16),
          _buildMetricProgressBar(
            label: 'TASK COMPLETION RATIO',
            value: '94%',
            change: '(+12% spike)',
            progressColor: const Color(0xFFAE7EFF),
            progress: 0.94,
            icon: Icons.check_circle_outline,
            iconColor: const Color(0xFFAE7EFF),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.75,
      backgroundColor: const Color(0xFF0D0D0D),
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              leading: CircleAvatar(child: Text('FS')),
              title: Text('FlowSpace User'),
              subtitle: Text('student@flowspace.app'),
            ),
            const Divider(color: Color(0x22FFFFFF)),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Focus'),
              onTap: () => context.go('/focus'),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Tasks'),
              onTap: () => context.go('/tasks'),
            ),
            ListTile(
              leading: const Icon(Icons.hourglass_top_rounded),
              title: const Text('Pomodoro'),
              onTap: () => context.go('/pomodoro'),
            ),
            const ListTile(
              leading: Icon(Icons.analytics_outlined, color: Color(0xFF8B5CF6)),
              title: Text(
                'Analytics',
                style: TextStyle(
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => context.go('/settings'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Close'),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'FlowSpace v1.0.0',
                style: TextStyle(color: Color(0xFF555555)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFocusRecordCard(String hours) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D1B4E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.flash_on,
              color: Color(0xFFAE7EFF),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FOCUS RECORD',
                style: TextStyle(
                  color: Color(0xFF7C8590),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                hours,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyVelocityChart() {
    final values = [45.0, 38.0, 52.0, 42.0, 55.0, 65.0, 48.0];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Velocity',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A2D1A),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF2D5C2D)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.trending_up, color: Color(0xFF00D9FF), size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+24%',
                      style: TextStyle(
                        color: Color(0xFF00D9FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Activity output vs baseline performance',
            style: TextStyle(color: Color(0xFFB2B2B7), fontSize: 12),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 80,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = [
                          'MON',
                          'TUE',
                          'WED',
                          'THU',
                          'FRI',
                          'SAT',
                          'SUN',
                        ];
                        if (value.toInt() >= 0 &&
                            value.toInt() < titles.length) {
                          return Text(
                            titles[value.toInt()],
                            style: const TextStyle(
                              color: Color(0xFF7C8590),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFF2D2D2D),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(values.length, (index) {
                  bool isHighlight = index == 5;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: values[index],
                        color: isHighlight
                            ? const Color(0xFFAE7EFF)
                            : const Color(0xFF3D3D3D),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Allocation',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 42,
                        color: const Color(0xFFAE7EFF),
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 28,
                        color: const Color(0xFF00D9FF),
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 10,
                        color: const Color(0xFF4D4D4D),
                        radius: 50,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 20,
                        color: const Color(0xFF2D2D2D),
                        radius: 50,
                        showTitle: false,
                      ),
                    ],
                    centerSpaceRadius: 35,
                    sectionsSpace: 2,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '78%',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'OPTIMIZED',
                      style: TextStyle(
                        color: Color(0xFF7C8590),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildLegendItem('Deep Work', const Color(0xFFAE7EFF), '42%'),
          const SizedBox(height: 12),
          _buildLegendItem('Operations', const Color(0xFF00D9FF), '28%'),
          const SizedBox(height: 12),
          _buildLegendItem('Planning', const Color(0xFF4D4D4D), '10%'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFC8C8CC),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          percentage,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildConsistencyArchive() {
    final rows = 7;
    final cols = 13;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Consistency\nArchive',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Text(
                      'LESS',
                      style: TextStyle(
                        color: Color(0xFF7C8590),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ...[
                          const Color(0xFF3D2D5C),
                          const Color(0xFF5C4E8F),
                          const Color(0xFF7E6BAE),
                          const Color(0xFFAE7EFF),
                        ]
                        .map(
                          (color) => Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        )
                        .toList(),
                    const Text(
                      'MORE',
                      style: TextStyle(
                        color: Color(0xFF7C8590),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Activity density over the last 90 days',
            style: TextStyle(color: Color(0xFFB2B2B7), fontSize: 12),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(cols, (weekIndex) {
                return Column(
                  children: List.generate(rows, (dayIndex) {
                    final intensity = (weekIndex * rows + dayIndex) % 4;
                    Color getColor() {
                      switch (intensity) {
                        case 0:
                          return const Color(0xFF2D2D2D);
                        case 1:
                          return const Color(0xFF3D2D5C);
                        case 2:
                          return const Color(0xFF5C4E8F);
                        case 3:
                          return const Color(0xFFAE7EFF);
                        default:
                          return const Color(0xFF2D2D2D);
                      }
                    }

                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: getColor(),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricProgressBar({
    required String label,
    required String value,
    required String change,
    required Color progressColor,
    required double progress,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1AFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF7C8590),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        change,
                        style: const TextStyle(
                          color: Color(0xFF7C8590),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFF2D2D2D),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            ),
          ),
        ],
      ),
    );
  }

}
