import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/user_profile_provider.dart';
import '../../app/theme.dart';
import '../../features/devtrack/providers/devtrack_providers.dart';

class UserProfileSheet extends ConsumerWidget {
  const UserProfileSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final totalHoursAsync = ref.watch(totalCodingHoursProvider);
    final activeProjectsAsync = ref.watch(activeProjectsProvider);
    final streakAsync = ref.watch(codingStreakProvider);

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

          final totalHours = totalHoursAsync.valueOrNull ?? 0.0;
          final activeProjects = activeProjectsAsync.valueOrNull ?? [];
          final streak = streakAsync.valueOrNull ?? 0;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top header row with back button and drag handle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceMD),

                // Avatar (emoji/SVG in circle)
                Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primarySubtle,
                    border: Border.all(color: AppTheme.primary, width: 2),
                  ),
                  child: Center(
                    child: profile.avatarEmoji.startsWith('assets/') || profile.avatarEmoji.endsWith('.svg')
                        ? SvgPicture.asset(
                            profile.avatarEmoji,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Text(
                            profile.avatarEmoji,
                            style: const TextStyle(fontSize: 40),
                          ),
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

                // Course + Semester
                if (profile.courseName.isNotEmpty ||
                    profile.semesterName.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    [profile.courseName, profile.semesterName]
                        .where((s) => s.isNotEmpty)
                        .join(' — '),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],

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

                // DevTrack stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(
                      value: '${totalHours.toStringAsFixed(0)}h',
                      label: 'Coded',
                    ),
                    const _StatDivider(),
                    _StatItem(
                      value: activeProjects.length.toString(),
                      label: 'Projects',
                    ),
                    const _StatDivider(),
                    _StatItem(
                      value: '$streak days',
                      label: 'Streak',
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.spaceLG),

                // Primary languages chips
                if (profile.primaryLanguages.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: profile.primaryLanguages.map((lang) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primarySubtle,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          lang,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppTheme.spaceLG),
                ],

                // Member since
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceMD,
                    vertical: AppTheme.spaceSM + 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primarySubtle,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        color: AppTheme.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Using FlowSpace since ${DateFormat('MMM yyyy').format(profile.createdAt)}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spaceLG),

                // Edit Profile button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditProfileSheet(context, ref);
                    },
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 16,
                      color: AppTheme.primary,
                    ),
                    label: Text(
                      'Edit Profile',
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
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMD),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                    height: MediaQuery.of(context).padding.bottom + 8),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _EditProfileSheet(),
    );
  }
}

// ── Edit Profile Sheet ────────────────────────────────────────────────────────
class _EditProfileSheet extends ConsumerStatefulWidget {
  const _EditProfileSheet();

  @override
  ConsumerState<_EditProfileSheet> createState() =>
      _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<_EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String _selectedEmoji = 'assets/avatars/cyberpunk.svg';

  static const _avatarOptions = [
    'assets/avatars/cyberpunk.svg',
    'assets/avatars/robot.svg',
    'assets/avatars/coffee.svg',
    'assets/avatars/ninja.svg',
    'assets/avatars/wizard.svg',
    'assets/avatars/rocket.svg',
    'assets/avatars/coder_cat.svg',
    'assets/avatars/coder_owl.svg',
    'assets/avatars/battery.svg',
    'assets/avatars/gamepad.svg',
    'assets/avatars/dragon.svg',
    'assets/avatars/brain.svg',
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    _nameController =
        TextEditingController(text: profile?.displayName ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _selectedEmoji = profile?.avatarEmoji ?? 'assets/avatars/cyberpunk.svg';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXL),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppTheme.spaceLG,
        AppTheme.spaceLG,
        AppTheme.spaceLG,
        MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceLG,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            Text(
              'Edit Profile',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: AppTheme.spaceLG),

            // Avatar picker
            Text(
              'AVATAR',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _avatarOptions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final emoji = _avatarOptions[index];
                  final isSelected = _selectedEmoji == emoji;
                  final isSvg = emoji.startsWith('assets/') || emoji.endsWith('.svg');
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedEmoji = emoji),
                    child: Container(
                      width: 48,
                      height: 48,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primarySubtle
                            : AppTheme.surfaceElevated,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSM),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primary
                              : AppTheme.surfaceBorder,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                const BoxShadow(
                                  color: AppTheme.primaryGlow,
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isSvg
                            ? SvgPicture.asset(
                                emoji,
                                width: 32,
                                height: 32,
                                fit: BoxFit.contain,
                              )
                            : Text(emoji,
                                style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Name
            Text(
              'NAME',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: TextField(
                controller: _nameController,
                maxLength: 40,
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Your name',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.all(AppTheme.spaceMD),
                  counterText: '',
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spaceMD),

            // Bio
            Text(
              'BIO',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: AppTheme.spaceSM),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: TextField(
                controller: _bioController,
                maxLength: 120,
                maxLines: 2,
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Short bio (optional)',
                  hintStyle: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.all(AppTheme.spaceMD),
                  counterText: '',
                ),
              ),
            ),

            const SizedBox(height: AppTheme.spaceLG),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: AppTheme.primaryButtonStyle.copyWith(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                child: Text(
                  'Save Changes',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
            ),

            SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    await ref.read(userProfileProvider.notifier).updateProfile(
          displayName: name,
          avatarEmoji: _selectedEmoji,
          bio: _bioController.text.trim(),
        );

    if (mounted) Navigator.pop(context);
  }
}

// ── Helper Widgets ──────────────────────────────────────────────────────────
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ShimmerStat(),
              _StatDivider(),
              _ShimmerStat(),
              _StatDivider(),
              _ShimmerStat(),
            ],
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
