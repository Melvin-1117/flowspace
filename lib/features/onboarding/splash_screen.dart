import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/theme.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/onboarding_service.dart';
import '../pulse/providers/pulse_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndNavigate();
  }

  Future<void> _checkAndNavigate() async {
    // Minimum splash duration
    await Future.delayed(const Duration(seconds: 2));

    // Check if onboarding is complete
    final isComplete = await ref
        .read(onboardingServiceProvider)
        .isOnboardingComplete();

    if (!mounted) return;

    if (isComplete) {
      // Verify token still valid silently
      final isValid = await ref.read(githubServiceProvider).verifyStoredToken();

      if (!mounted) return;

      if (isValid) {
        // Load cached profile into provider
        await ref.read(userProfileProvider.notifier).loadFromCache();
        if (!mounted) return;
        context.go('/dashboard');
      } else {
        // Token expired or revoked
        // Clear everything and restart onboarding
        await ref.read(onboardingServiceProvider).clearOnboarding();
        if (!mounted) return;
        context.go('/onboarding');
      }
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  BoxShadow(
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
