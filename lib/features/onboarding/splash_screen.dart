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
        await Future.delayed(const Duration(seconds: 2));
      } else {
        await Future.wait([
          Future.delayed(const Duration(seconds: 2)),
          ref.read(isarProvider.future), // ensures Isar is fully open
        ]);
      }

      if (!mounted) return;

      // Check if onboarding is complete (Isar is now loaded)
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
        context.go('/onboarding');
      }
    } catch (e, stack) {
      debugPrint('SplashScreen error: $e\n$stack');
      if (!mounted) return;
      // Show the error on-screen so you can read it without ADB logs
      setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    setState(() => _error = null);
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
      backgroundColor: AppTheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo/icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusLG),
                boxShadow: [
                  const BoxShadow(
                    color: AppTheme.primaryGlow,
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.bolt_rounded,
                color: AppTheme.textPrimary,
                size: 48,
              ),
            ).animate().scaleXY(
              begin: 0.8,
              end: 1.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // App name
            Text(
              'FlowSpace',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
                letterSpacing: -1.0,
              ),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 500),
            ),

            const SizedBox(height: AppTheme.spaceSM),

            // Tagline
            Text(
              'Built for developers',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ).animate().fadeIn(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 500),
            ),

            const SizedBox(height: AppTheme.spaceXXL),

            // Loading indicator
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 2,
              ),
            ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
          ],
        ),
      ),
    );
  }
}
