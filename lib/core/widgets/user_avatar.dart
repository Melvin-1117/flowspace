import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../providers/user_profile_provider.dart';
import '../widgets/user_profile_sheet.dart';
import '../../app/theme.dart';

class UserAvatar extends ConsumerWidget {
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({this.size = 36, this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarData = ref.watch(avatarEmojiProvider);
    final isSvg = avatarData.startsWith('assets/') || avatarData.endsWith('.svg');

    return GestureDetector(
      onTap: onTap ?? () => _showProfileSheet(context),
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primarySubtle,
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: isSvg
              ? SvgPicture.asset(
                  avatarData,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                )
              : Text(
                  avatarData,
                  style: TextStyle(fontSize: size * 0.5),
                ),
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const UserProfileSheet(),
    );
  }
}
