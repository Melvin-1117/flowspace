import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/repository_cache.dart';
import 'repository_detail_sheet.dart';

class RepositoryCard extends StatelessWidget {
  const RepositoryCard({required this.repo, super.key});

  final RepositoryCache repo;

  @override
  Widget build(BuildContext context) {
    final ago = _ago(repo.pushedAt);
    final langColor = _languageColor(repo.primaryLanguage);
    return InkWell(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        backgroundColor: const Color(0xFF0D0D0D),
        isScrollControlled: true,
        builder: (_) => RepositoryDetailSheet(repo: repo),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _languageIcon(repo.primaryLanguage),
                color: langColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _openUrl(repo.htmlUrl),
                    child: Text(
                      repo.name.length > 20
                          ? '${repo.name.substring(0, 20)}…'
                          : repo.name,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF0F0F0),
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      _stat(
                        Icons.star_border,
                        _formatCount(repo.stargazersCount),
                      ),
                      _stat(Icons.call_split, _formatCount(repo.forksCount)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: langColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: langColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              repo.primaryLanguage,
                              style: GoogleFonts.inter(
                                color: langColor,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Updated $ago',
              style: GoogleFonts.inter(
                color: const Color(0xFF555555),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF555555)),
        const SizedBox(width: 3),
        Text(
          value,
          style: GoogleFonts.inter(
            color: const Color(0xFF555555),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _formatCount(int value) {
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(1)}k';
    return '$value';
  }

  String _ago(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  IconData _languageIcon(String language) => switch (language.toLowerCase()) {
        'rust' => Icons.settings,
        'typescript' => Icons.code,
        'javascript' => Icons.code,
        'python' => Icons.storage,
        _ => Icons.folder_open,
      };

  Color _languageColor(String language) => switch (language.toLowerCase()) {
    'rust' => const Color(0xFFEF4444),
    'typescript' => const Color(0xFF7C3AED),
    'javascript' => const Color(0xFFF59E0B),
    'python' => const Color(0xFF06B6D4),
    'go' => const Color(0xFF10B981),
    'dart' => const Color(0xFF4C1D95),
    _ => const Color(0xFF555555),
  };

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
