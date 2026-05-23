import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme.dart';
import '../../core/providers/user_profile_provider.dart';
import '../../core/services/onboarding_service.dart';
import '../pulse/providers/pulse_providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _obscureToken = true;
  String? _errorMessage;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spaceXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spaceXXL),

              // FlowSpace logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  boxShadow: [
                    BoxShadow(color: AppTheme.primaryGlow, blurRadius: 20),
                  ],
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: AppTheme.textPrimary,
                  size: 32,
                ),
              ),

              const SizedBox(height: AppTheme.spaceXL),

              // Welcome heading
              Text(
                'Welcome to\nFlowSpace',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -1.5,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: AppTheme.spaceSM + 4),

              // Subtitle
              Text(
                'Connect your GitHub account to get started. '
                'Your GitHub profile will be used across the app.',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  color: AppTheme.textSecondary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: AppTheme.spaceXXL),

              // GitHub token section heading
              Text(
                'GITHUB PERSONAL ACCESS TOKEN',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: AppTheme.spaceSM + 4),

              // Token input field
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                  border: Border.all(
                    color: _errorMessage != null
                        ? AppTheme.danger
                        : AppTheme.surfaceBorder,
                  ),
                ),
                child: TextField(
                  controller: _tokenController,
                  obscureText: _obscureToken,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ghp_xxxxxxxxxxxxxxxxxxxx',
                    hintStyle: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textMuted,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppTheme.spaceMD),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureToken
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppTheme.textSecondary,
                        size: 20,
                      ),
                      onPressed: () => setState(() {
                        _obscureToken = !_obscureToken;
                      }),
                    ),
                  ),
                ),
              ),

              // Error message
              if (_errorMessage != null) ...[
                const SizedBox(height: AppTheme.spaceSM),
                Text(
                  _errorMessage!,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: AppTheme.danger,
                  ),
                ),
              ],

              const SizedBox(height: AppTheme.spaceMD),

              // How to get token instruction card
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceMD),
                decoration: BoxDecoration(
                  color: AppTheme.primarySubtle,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.primary,
                          size: 16,
                        ),
                        const SizedBox(width: AppTheme.spaceSM),
                        Text(
                          'How to get your token',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceSM + 4),
                    _tokenStep('1', 'Go to GitHub → Settings'),
                    _tokenStep(
                      '2',
                      'Developer Settings → Personal Access Tokens',
                    ),
                    _tokenStep('3', 'Generate new token (classic)'),
                    _tokenStep('4', 'Select scopes: repo, read:user, read:org'),
                    _tokenStep('5', 'Copy and paste token above'),
                    const SizedBox(height: AppTheme.spaceSM + 4),
                    GestureDetector(
                      onTap: () => launchUrl(
                        Uri.parse(
                          'https://github.com/settings/tokens/new'
                          '?scopes=repo,read:user,read:org'
                          '&description=FlowSpace',
                        ),
                        mode: LaunchMode.externalApplication,
                      ),
                      child: Text(
                        'Open GitHub token page →',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: AppTheme.accent,
                          decoration: TextDecoration.underline,
                          decorationColor: AppTheme.accent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spaceXL),

              // Permissions list
              Text(
                'REQUIRED PERMISSIONS',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppTheme.spaceSM + 4),
              _permissionRow(
                Icons.person_rounded,
                'read:user',
                'Access your profile info',
              ),
              _permissionRow(
                Icons.code_rounded,
                'repo',
                'Read your repositories',
              ),
              _permissionRow(
                Icons.groups_rounded,
                'read:org',
                'Read your organisation data',
              ),

              const SizedBox(height: AppTheme.spaceXXL - 8),

              // Connect button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _connectGitHub,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: AppTheme.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppTheme.textPrimary,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.hub_rounded,
                              color: AppTheme.textPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: AppTheme.spaceSM),
                            Text(
                              'Connect GitHub',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: AppTheme.spaceMD),

              // Privacy note
              Center(
                child: Text(
                  '🔒  Your token is stored securely on device only',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spaceXL),
            ],
          ),
        ),
      ),
    );
  }

  // Token step helper
  Widget _tokenStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceSM + 2),
          Text(
            text,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Permission row helper
  Widget _permissionRow(IconData icon, String scope, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceSM + 2),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 16),
          const SizedBox(width: AppTheme.spaceSM + 2),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceSM,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppTheme.primarySubtle,
              borderRadius: BorderRadius.circular(AppTheme.radiusXS),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Text(
              scope,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceSM),
          Text(
            description,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Connect GitHub action
  Future<void> _connectGitHub() async {
    final token = _tokenController.text.trim();

    if (token.isEmpty) {
      setState(() => _errorMessage = 'Please enter your GitHub token');
      return;
    }

    if (!token.startsWith('ghp_') && !token.startsWith('github_pat_')) {
      setState(() {
        _errorMessage =
            'Token format invalid — should start with ghp_ or github_pat_';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verify token and fetch profile
      final profile = await ref
          .read(githubServiceProvider)
          .verifyAndFetchProfile(token);

      // Save token securely
      await ref.read(onboardingServiceProvider).saveToken(token);

      // Save profile to Isar and provider
      await ref.read(userProfileProvider.notifier).saveProfile(profile);

      // Mark onboarding complete
      await ref.read(onboardingServiceProvider).markOnboardingComplete();

      if (!mounted) return;

      // Navigate to main app
      context.go('/dashboard');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = _mapErrorMessage(e.toString());
      });
    }
  }

  String _mapErrorMessage(String error) {
    if (error.contains('401')) {
      return 'Invalid token — please check and try again';
    }
    if (error.contains('403')) {
      return 'Token lacks required permissions';
    }
    if (error.contains('SocketException') || error.contains('network')) {
      return 'No internet connection — please try again';
    }
    return 'Something went wrong — please try again';
  }
}
