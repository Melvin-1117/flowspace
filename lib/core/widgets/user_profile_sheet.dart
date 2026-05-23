import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/user_profile_provider.dart';
import '../../app/theme.dart';

class UserProfileSheet extends ConsumerWidget {
  const UserProfileSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXL),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spaceLG),
      child: profileAsync.when(
        loading: () => const _ProfileShimmer(),
        error: (e, _) => const _ProfileError(),
        data: (profile) {
          if (profile == null) return const _ProfileError();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppTheme.spaceLG),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Avatar (large)
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: ClipOval(
                  child: profile.avatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: profile.avatarUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const _AvatarPlaceholder(),
                          errorWidget: (context, url, error) =>
                              const _AvatarPlaceholder(),
                        )
                      : const _AvatarPlaceholder(),
                ),
              ),

              const SizedBox(height: AppTheme.spaceMD),

              // Display name
              Text(
                profile.displayName,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 4),

              // Username with GitHub icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.hub_rounded,
                    color: AppTheme.textSecondary,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '@${profile.githubUsername}',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),

              // Bio (if exists)
              if (profile.bio.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spaceSM),
                Text(
                  profile.bio,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: AppTheme.spaceLG),

              // GitHub stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    value: profile.publicRepos.toString(),
                    label: 'Repos',
                  ),
                  const _StatDivider(),
                  _StatItem(
                    value: profile.followers.toString(),
                    label: 'Followers',
                  ),
                  const _StatDivider(),
                  _StatItem(
                    value: profile.following.toString(),
                    label: 'Following',
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spaceLG),

              // Connected since
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceMD,
                  vertical: AppTheme.spaceSM + 2,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primarySubtle,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      color: AppTheme.primary,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Connected ${_formatDate(profile.connectedAt)}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spaceLG),

              // Open GitHub profile button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => launchUrl(
                    Uri.parse(profile.githubUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                    color: AppTheme.primary,
                  ),
                  label: Text(
                    'View GitHub Profile',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spaceSM + 6,
                    ),
                    side: const BorderSide(color: AppTheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spaceSM),

              // Refresh profile button
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(userProfileProvider.notifier)
                          .refreshFromGitHub();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Profile refreshed',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            backgroundColor: AppTheme.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMD,
                              ),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Unable to refresh profile',
                              style: GoogleFonts.spaceGrotesk(
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            backgroundColor: AppTheme.danger,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMD,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: AppTheme.textSecondary,
                    size: 16,
                  ),
                  label: Text(
                    'Refresh Profile',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM yyyy').format(date);
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceCard,
      child: const Icon(Icons.person_rounded, color: AppTheme.textSecondary),
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLG),
        child: Text(
          'Unable to load profile',
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textSecondary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _ProfileShimmer extends StatelessWidget {
  const _ProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceCard,
      highlightColor: AppTheme.surfaceHover,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppTheme.spaceLG),
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceBorder,
            ),
          ),
          const SizedBox(height: AppTheme.spaceMD),
          Container(
            width: 160,
            height: 16,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
          ),
          const SizedBox(height: AppTheme.spaceSM),
          Container(
            width: 120,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _ShimmerStat(),
              _StatDivider(),
              _ShimmerStat(),
              _StatDivider(),
              _ShimmerStat(),
            ],
          ),
          const SizedBox(height: AppTheme.spaceLG),
          Container(
            width: 180,
            height: 28,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
          ),
          const SizedBox(height: AppTheme.spaceLG),
          Container(
            width: double.infinity,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.surfaceBorder,
              borderRadius: BorderRadius.circular(AppTheme.radiusMD),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerStat extends StatelessWidget {
  const _ShimmerStat();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 36,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.surfaceBorder,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 44,
          height: 10,
          decoration: BoxDecoration(
            color: AppTheme.surfaceBorder,
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
        ),
      ],
    );
  }
}

// Stat item widget
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: AppTheme.surfaceBorder);
  }
}
