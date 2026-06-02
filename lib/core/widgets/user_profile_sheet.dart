import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../providers/user_profile_provider.dart';
import '../../app/theme.dart';

class UserProfileSheet extends ConsumerWidget {
  const UserProfileSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final readmeAsync = ref.watch(profileReadmeProvider);

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
          return SingleChildScrollView(
            child: Column(
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
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
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

              // GitHub README Section
              readmeAsync.when(
                data: (readme) {
                  if (readme == null || readme.trim().isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppTheme.spaceLG),
                      Row(
                        children: [
                          const Icon(
                            Icons.article_outlined,
                            color: AppTheme.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'GITHUB README',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppTheme.textSecondary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceSM),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 250),
                        padding: const EdgeInsets.all(AppTheme.spaceMD),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceHover,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMD),
                          border: Border.all(color: AppTheme.surfaceBorder),
                        ),
                        child: SingleChildScrollView(
                          child: MarkdownBody(
                            data: _preprocessReadme(readme),
                            selectable: true,
                            imageBuilder: (uri, title, alt) {
                              // Strip dimension fragment before building the fetch URL
                              final fragment = uri.fragment;
                              double? reqWidth;
                              double? reqHeight;
                              if (fragment.isNotEmpty) {
                                final wM = RegExp(r'_w=(\d+)').firstMatch(fragment);
                                final hM = RegExp(r'_h=(\d+)').firstMatch(fragment);
                                if (wM != null) reqWidth = double.parse(wM.group(1)!);
                                if (hM != null) reqHeight = double.parse(hM.group(1)!);
                              }
                              // Remove our custom fragment so we don't send it in HTTP
                              final cleanUri = uri.replace(fragment: '');
                              final urlString = cleanUri.toString().replaceAll(RegExp(r'#$'), '');
                              final lowerUrl = urlString.toLowerCase();

                              // Only treat as SVG when we are confident the URL returns SVG data
                              final isSvg = lowerUrl.endsWith('.svg') ||
                                  RegExp(r'\.svg[?#]').hasMatch(lowerUrl) ||
                                  lowerUrl.contains('shields.io') ||
                                  lowerUrl.contains('github-readme-stats') ||
                                  lowerUrl.contains('streak-stats') ||
                                  lowerUrl.contains('komarev.com/ghpvc') ||
                                  lowerUrl.contains('visitcount.itsvg.in') ||
                                  lowerUrl.contains('readme-typing-svg') ||
                                  lowerUrl.contains('capsule-render');

                              if (isSvg) {
                                return _TimedNetworkSvg(
                                  url: urlString,
                                  displayHeight: reqHeight,
                                  displayWidth: reqWidth,
                                );
                              }

                              // Raster images (PNG from skillicons.dev, etc.)
                              final double imgHeight = reqHeight ?? 48.0;
                              final double? imgWidth = reqWidth;

                              if (kIsWeb) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: imgHeight,
                                    maxWidth: imgWidth ?? double.infinity,
                                  ),
                                  child: Image.network(
                                    urlString,
                                    fit: BoxFit.contain,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return SizedBox(
                                        height: imgHeight,
                                        width: imgWidth ?? 80,
                                        child: Shimmer.fromColors(
                                          baseColor: AppTheme.surfaceCard,
                                          highlightColor: AppTheme.surfaceHover,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.surfaceBorder,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => const Icon(
                                      Icons.broken_image_outlined,
                                      size: 16,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                );
                              }

                              return ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: imgHeight,
                                  maxWidth: imgWidth ?? double.infinity,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: urlString,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => SizedBox(
                                    height: imgHeight,
                                    width: imgWidth ?? 80,
                                  ),
                                  errorWidget: (context, url, error) => const Icon(
                                    Icons.broken_image,
                                    size: 16,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              );
                            },
                            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                              p: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary, fontSize: 13),
                              h1: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
                              h2: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                              h3: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600),
                              code: GoogleFonts.spaceGrotesk(backgroundColor: AppTheme.surfaceCard, color: AppTheme.primary, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppTheme.spaceLG),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
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
          ),
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

String _preprocessReadme(String markdown) {
  var processed = markdown;

  // 1. Remove HTML comments
  processed = processed.replaceAll(RegExp(r'<!--[\s\S]*?-->'), '');

  // 2. Convert HTML headers to Markdown headers
  processed = processed.replaceAllMapped(
    RegExp(r'<h([1-6])(?:\s+[^>]*)?>([\s\S]*?)</h\1>', caseSensitive: false),
    (match) {
      final level = int.parse(match.group(1) ?? '1');
      final content = (match.group(2) ?? '').trim();
      return '${'#' * level} $content\n';
    },
  );

  // 3. Convert HTML bold/strong and italic/em
  processed = processed.replaceAllMapped(
    RegExp(r'<(strong|b)(?:\s+[^>]*)?>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '**${match.group(2)}**',
  );
  processed = processed.replaceAllMapped(
    RegExp(r'<(em|i)(?:\s+[^>]*)?>([\s\S]*?)</\1>', caseSensitive: false),
    (match) => '*${match.group(2)}*',
  );

  // 4. Convert HTML list items
  processed = processed.replaceAllMapped(
    RegExp(r'<li(?:\s+[^>]*)?>([\s\S]*?)</?li>', caseSensitive: false),
    (match) => '- ${match.group(1)?.trim()}\n',
  );

  // 5. Convert HTML img tags to Markdown image format: ![alt](src)
  //    Preserve width/height as URL fragment so imageBuilder can read them.
  processed = processed.replaceAllMapped(
    RegExp(r'<img\s+[^>]*>', caseSensitive: false),
    (match) {
      final tag = match.group(0) ?? '';
      final srcMatch = RegExp(r'''src=["']([^"']+)["']''', caseSensitive: false).firstMatch(tag);
      final altMatch = RegExp(r'''alt=["']([^"']+)["']''', caseSensitive: false).firstMatch(tag);
      final widthMatch = RegExp(r'''width=["']?(\d+)["']?''', caseSensitive: false).firstMatch(tag);
      final heightMatch = RegExp(r'''height=["']?(\d+)["']?''', caseSensitive: false).firstMatch(tag);

      final src = srcMatch?.group(1) ?? '';
      final alt = altMatch?.group(1) ?? '';

      if (src.isEmpty) return '';

      // Encode original dimensions as URL fragment
      final dims = <String>[];
      if (widthMatch != null) dims.add('_w=${widthMatch.group(1)}');
      if (heightMatch != null) dims.add('_h=${heightMatch.group(1)}');
      final frag = dims.isNotEmpty ? '#${dims.join('&')}' : '';
      return '![$alt]($src$frag)';
    },
  );

  // 6. Convert HTML anchor tags to Markdown link format: [content](href)
  processed = processed.replaceAllMapped(
    RegExp(r'''<a\s+[^>]*href=["']([^"']+)["'][^>]*>([\s\S]*?)</a>''', caseSensitive: false),
    (match) {
      final href = match.group(1) ?? '';
      final content = match.group(2) ?? '';
      return '[$content]($href)';
    },
  );

  // 7. Strip other HTML tags, replacing them with newlines or spaces
  processed = processed.replaceAll(
    RegExp(r'</?(p|div|span|center|sub|sup|pre|code|table|tr|td|thead|tbody|ul|ol|a)(?:\s+[^>]*)?>', caseSensitive: false),
    '\n',
  );

  // 8. Replace <br> and <br /> with newlines
  processed = processed.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');

  // Clean up excessive consecutive newlines
  processed = processed.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  return processed.trim();
}

class _ImageShimmerPlaceholder extends StatelessWidget {
  final bool isBadge;

  const _ImageShimmerPlaceholder({
    required this.isBadge,
  });

  @override
  Widget build(BuildContext context) {
    final double displayHeight = isBadge ? 20.0 : 140.0;
    final double displayWidth = isBadge ? 80.0 : double.infinity;

    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceCard,
      highlightColor: AppTheme.surfaceHover,
      child: Container(
        width: displayWidth,
        height: displayHeight,
        decoration: BoxDecoration(
          color: AppTheme.surfaceBorder,
          borderRadius: BorderRadius.circular(isBadge ? 4 : 8),
        ),
      ),
    );
  }
}

enum _SvgLoadState { loading, loaded, failed, raster }

/// Loads an SVG from the network by manually fetching the data.
/// Validates content is actual SVG XML before rendering; falls back to
/// raster Image.memory() if the response is PNG/JPEG/etc.
class _TimedNetworkSvg extends StatefulWidget {
  const _TimedNetworkSvg({
    required this.url,
    this.displayHeight,
    this.displayWidth,
  });

  final String url;
  final double? displayHeight;
  final double? displayWidth;

  @override
  State<_TimedNetworkSvg> createState() => _TimedNetworkSvgState();
}

class _TimedNetworkSvgState extends State<_TimedNetworkSvg> {
  static const _kSvgTimeout = Duration(seconds: 10);

  _SvgLoadState _state = _SvgLoadState.loading;
  String? _svgData;
  Uint8List? _rasterBytes;

  @override
  void initState() {
    super.initState();
    _fetchSvg();
  }

  Future<void> _fetchSvg() async {
    try {
      final response = await http
          .get(Uri.parse(widget.url))
          .timeout(_kSvgTimeout);
      if (!mounted) return;
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';
        final body = response.body.trimLeft();
        // Check Content-Type header first, then inspect body content
        final isSvgContent = contentType.contains('svg') ||
            body.startsWith('<svg') ||
            body.startsWith('<?xml') ||
            body.startsWith('<!DOCTYPE') && body.contains('<svg') ||
            body.contains('<svg ') ||
            body.contains('<svg>');
        if (isSvgContent) {
          setState(() {
            _svgData = response.body;
            _state = _SvgLoadState.loaded;
          });
        } else {
          // Not SVG — treat as raster image
          setState(() {
            _rasterBytes = response.bodyBytes;
            _state = _SvgLoadState.raster;
          });
        }
      } else {
        setState(() => _state = _SvgLoadState.failed);
      }
    } catch (_) {
      if (mounted) setState(() => _state = _SvgLoadState.failed);
    }
  }

  double get _h => widget.displayHeight ?? 28;
  double? get _w => widget.displayWidth;

  @override
  Widget build(BuildContext context) {
    return switch (_state) {
      _SvgLoadState.loading => SizedBox(
          height: _h,
          width: _w ?? 80,
          child: Shimmer.fromColors(
            baseColor: AppTheme.surfaceCard,
            highlightColor: AppTheme.surfaceHover,
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      _SvgLoadState.failed => SizedBox(
          height: _h,
          width: _w ?? 80,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
      _SvgLoadState.loaded => SvgPicture.string(
          _svgData!,
          height: widget.displayHeight,
          width: widget.displayWidth,
          fit: BoxFit.contain,
        ),
      _SvgLoadState.raster => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _h,
            maxWidth: _w ?? double.infinity,
          ),
          child: Image.memory(
            _rasterBytes!,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.broken_image_outlined,
              size: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
    };
  }
}
