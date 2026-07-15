import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../core/providers/isar_provider.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/onboarding_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  String? _error;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    try {
      // On web: Isar is not supported — just wait the minimum splash duration.
      // On native: wait for both Isar to be ready AND the minimum splash duration.
      if (kIsWeb) {
        await Future.delayed(const Duration(seconds: 1));
      } else {
        await Future.wait([
          Future.delayed(const Duration(seconds: 1)),
          ref.read(isarProvider.future), // ensures Isar is fully open
        ]);
      }

      if (!mounted) return;

      // Check if onboarding is complete
      final isComplete = await ref
          .read(onboardingServiceProvider)
          .isOnboardingComplete();

      if (!mounted) return;

      if (isComplete) {
        // Load cached profile into provider
        await ref.read(userProfileProvider.notifier).loadFromCache();
        if (!mounted) return;
        context.go('/dashboard');
      } else {
        setState(() => _isChecking = false);
      }
    } catch (e, stack) {
      debugPrint('SplashScreen error: $e\n$stack');
      if (!mounted) return;
      // Show the error on-screen so we can read it without ADB logs
      setState(() {
        _error = '$e';
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we're still checking the onboarding status, show a clean loading screen
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: AppTheme.primary,
            strokeWidth: 2,
          ),
        ),
      );
    }

    // If there was a startup error, show it so we can diagnose
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Startup Error',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: SelectableText(
                    _error!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _error = null;
                      _isChecking = true;
                    });
                    _checkAndNavigate();
                  },
                  child: const Text('Retry', style: TextStyle(color: AppTheme.primary)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          // ── Animated background gradient ─────────────
          // Subtle radial glow from center
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.3),
                  radius: 1.2,
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Grid dot pattern (subtle background) ─────
          Positioned.fill(
            child: CustomPaint(
              painter: DotGridPainter(
                dotColor: AppTheme.surfaceBorder,
                spacing: 24,
                dotRadius: 1,
              ),
            ),
          ),

          // ── Main content ─────────────────────────────
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // App logo
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppTheme.primary,
                        AppTheme.accent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 52,
                  ),
                )
                    .animate()
                    .scaleXY(
                      begin: 0.7,
                      end: 1.0,
                      duration: 700.ms,
                      curve: Curves.easeOutBack,
                    )
                    .fadeIn(duration: 500.ms),

                const SizedBox(height: 28),

                // App name
                Text(
                  'FlowSpace',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -1.5,
                  ),
                )
                    .animate()
                    .fadeIn(
                      delay: 300.ms,
                      duration: 500.ms,
                    )
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Built for developers who ship',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                    letterSpacing: 0.2,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 500.ms),

                const Spacer(flex: 2),

                // Feature pills row
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _FeaturePill(
                        icon: Icons.timer_rounded,
                        label: 'Pomodoro',
                      ),
                      SizedBox(width: 8),
                      _FeaturePill(
                        icon: Icons.task_alt_rounded,
                        label: 'Tasks',
                      ),
                      SizedBox(width: 8),
                      _FeaturePill(
                        icon: Icons.school_rounded,
                        label: 'Planner',
                      ),
                      SizedBox(width: 8),
                      _FeaturePill(
                        icon: Icons.analytics_rounded,
                        label: 'Analytics',
                      ),
                      SizedBox(width: 8),
                      _FeaturePill(
                        icon: Icons.developer_board_rounded,
                        label: 'DevTrack',
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 500.ms),

                const SizedBox(height: 48),

                // Get Started button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/onboarding'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
                            AppTheme.primaryLight.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 900.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                const SizedBox(height: 16),

                // Privacy note
                Text(
                  '🔒  All data stored locally on your device',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1000.ms),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// _FeaturePill widget
class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeaturePill({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primary, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// DotGridPainter
class DotGridPainter extends CustomPainter {
  final Color dotColor;
  final double spacing;
  final double dotRadius;

  DotGridPainter({
    required this.dotColor,
    required this.spacing,
    required this.dotRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dotColor;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
