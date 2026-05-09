import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/pulse_providers.dart';
import 'pulse_theme.dart';
import 'repository_card.dart';

class TopRepositoriesSection extends ConsumerWidget {
  const TopRepositoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRepos = ref.watch(topRepositoriesProvider);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: pulseCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Top Repositories',
                style: GoogleFonts.inter(
                  color: pulseText,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () => _showAllRepos(context, ref),
                child: Text(
                  'VIEW ALL',
                  style: GoogleFonts.inter(
                    color: pulsePrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          asyncRepos.when(
            data: (repos) {
              if (repos.isEmpty) {
                return _EmptyRepos(onOpenGithub: _openCreateRepo);
              }
              return Column(
                children: [
                  for (var i = 0; i < repos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RepositoryCard(repo: repos[i])
                          .animate()
                          .slideX(begin: 0.08, end: 0, delay: (i * 80).ms)
                          .fadeIn(delay: (i * 80).ms),
                    ),
                ],
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(color: pulsePrimary),
              ),
            ),
            error: (_, __) => Text(
              'Failed to load repositories',
              style: GoogleFonts.inter(color: pulseMuted),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAllRepos(BuildContext context, WidgetRef ref) async {
    final repos = await ref.read(allRepositoriesProvider.future);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: pulseCard,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'All Repositories',
                style: GoogleFonts.inter(
                  color: pulseText,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: repos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, index) => RepositoryCard(repo: repos[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openCreateRepo() async {
    final uri = Uri.parse('https://github.com/new');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _EmptyRepos extends StatelessWidget {
  const _EmptyRepos({required this.onOpenGithub});

  final Future<void> Function() onOpenGithub;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No repositories found',
            style: GoogleFonts.inter(color: pulseText),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onOpenGithub,
            child: const Text('Create your first repo on GitHub'),
          ),
        ],
      ),
    );
  }
}
