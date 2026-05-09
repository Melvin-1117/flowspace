import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/repository_cache.dart';
import 'pulse_theme.dart';

class RepositoryDetailSheet extends StatelessWidget {
  const RepositoryDetailSheet({required this.repo, super.key});

  final RepositoryCache repo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              repo.fullName,
              style: GoogleFonts.inter(
                color: pulseText,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              repo.description.isEmpty ? 'No description' : repo.description,
              style: GoogleFonts.inter(color: pulseMuted),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 6,
              children: [
                _chip('⭐ ${repo.stargazersCount}'),
                _chip('🍴 ${repo.forksCount}'),
                _chip('👀 ${repo.watchersCount}'),
                _chip('❗ ${repo.openIssuesCount}'),
                _chip(repo.primaryLanguage),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Last pushed ${DateFormat.yMMMd().add_jm().format(repo.pushedAt)}',
              style: GoogleFonts.inter(color: pulseMuted),
            ),
            if (repo.topics.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: repo.topics.map(_chip).toList(),
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openUrl(repo.htmlUrl),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pulsePrimary,
                    ),
                    child: const Text('Open on GitHub'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _openUrl(
                      '${repo.htmlUrl}/commits/${repo.defaultBranch}',
                    ),
                    child: const Text('View Commits'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.06),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(color: pulseText, fontSize: 12),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
