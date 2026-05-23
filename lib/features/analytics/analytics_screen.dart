import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/animation_tokens.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/app_top_bar.dart';
import '../../core/widgets/user_avatar.dart';
import 'analytics_payload.dart';
import 'providers/analytics_providers.dart';
import 'widgets/allocation_donut_chart.dart';
import 'widgets/analytics_banner.dart';
import 'widgets/avg_session_card.dart';
import 'widgets/consistency_archive_heatmap.dart';
import 'widgets/focus_record_card.dart';
import 'widgets/task_completion_card.dart';
import 'widgets/weekly_velocity_chart.dart';
import '../../app/theme.dart';

const Color _screenBackground = AppTheme.background;
const Color _textPrimary = AppTheme.textPrimary;
const Color _purple = AppTheme.primary;
const Duration _bannerAutoDismiss = Duration(seconds: 5);

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({this.payload, super.key});

  final AnalyticsPayload? payload;

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    if (widget.payload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(analyticsBannerProvider.notifier).show(widget.payload!, ref);
        _bannerTimer = Timer(_bannerAutoDismiss, () {
          if (mounted) {
            ref.read(analyticsBannerProvider.notifier).dismiss();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showBanner = ref.watch(analyticsBannerProvider);
    final payload = ref.watch(analyticsBannerPayloadProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _screenBackground,
      drawer: const AppDrawer(),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: UserAvatar(size: 36),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'SYSTEM PERFORMANCE',
            style: TextStyle(
              color: _purple,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Analytics',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showBanner && payload != null) ...[
            AnalyticsBanner(
              payload: payload,
              onDismiss: () =>
                  ref.read(analyticsBannerProvider.notifier).dismiss(),
            ),
          ],
          const SizedBox(height: 16),
          const FocusRecordCard()
              .animate()
              .fadeIn(duration: kPageEntryDuration, delay: 0.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: kPageEntryDuration,
                delay: 0.ms,
                curve: kPageEntryCurve,
              ),
          const SizedBox(height: 16),
          const WeeklyVelocityChart()
              .animate()
              .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: kPageEntryDuration,
                delay: kPageStaggerStep,
                curve: kPageEntryCurve,
              ),
          const SizedBox(height: 16),
          const AllocationDonutChart()
              .animate()
              .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 2)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: kPageEntryDuration,
                delay: kPageStaggerStep * 2,
                curve: kPageEntryCurve,
              ),
          const SizedBox(height: 16),
          const ConsistencyArchiveHeatmap()
              .animate()
              .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 3)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: kPageEntryDuration,
                delay: kPageStaggerStep * 3,
                curve: kPageEntryCurve,
              ),
          const SizedBox(height: 16),
          const AvgSessionCard()
              .animate()
              .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 4)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: kPageEntryDuration,
                delay: kPageStaggerStep * 4,
                curve: kPageEntryCurve,
              ),
          const SizedBox(height: 16),
          const TaskCompletionCard()
              .animate()
              .fadeIn(duration: kPageEntryDuration, delay: kPageStaggerStep * 5)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: kPageEntryDuration,
                delay: kPageStaggerStep * 5,
                curve: kPageEntryCurve,
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
