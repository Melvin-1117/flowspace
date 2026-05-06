import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_drawer.dart';
import 'analytics_payload.dart';
import 'providers/analytics_providers.dart';
import 'widgets/allocation_donut_chart.dart';
import 'widgets/analytics_banner.dart';
import 'widgets/avg_session_card.dart';
import 'widgets/consistency_archive_heatmap.dart';
import 'widgets/focus_record_card.dart';
import 'widgets/task_completion_card.dart';
import 'widgets/weekly_velocity_chart.dart';

const Color _screenBackground = Color(0xFF000000);
const Color _textPrimary = Color(0xFFF0F0F0);
const Color _textSecondary = Color(0xFF555555);
const Color _purple = Color(0xFF7C3AED);
const Duration _bannerAutoDismiss = Duration(seconds: 5);
const Duration _fadeDuration = Duration(milliseconds: 420);
const Duration _slideDuration = Duration(milliseconds: 420);

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
      appBar: AppBar(
        backgroundColor: _screenBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: _purple),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          'FlowSpace',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: _textPrimary,
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
              .fadeIn(duration: _fadeDuration, delay: 0.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: _slideDuration,
                delay: 0.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 16),
          const WeeklyVelocityChart()
              .animate()
              .fadeIn(duration: _fadeDuration, delay: 100.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: _slideDuration,
                delay: 100.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 16),
          const AllocationDonutChart()
              .animate()
              .fadeIn(duration: _fadeDuration, delay: 200.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: _slideDuration,
                delay: 200.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 16),
          const ConsistencyArchiveHeatmap()
              .animate()
              .fadeIn(duration: _fadeDuration, delay: 300.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: _slideDuration,
                delay: 300.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 16),
          const AvgSessionCard()
              .animate()
              .fadeIn(duration: _fadeDuration, delay: 400.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: _slideDuration,
                delay: 400.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 16),
          const TaskCompletionCard()
              .animate()
              .fadeIn(duration: _fadeDuration, delay: 400.ms)
              .slideY(
                begin: 0.06,
                end: 0,
                duration: _slideDuration,
                delay: 400.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
