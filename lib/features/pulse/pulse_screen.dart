import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/animation_tokens.dart';
import '../../core/models/task.dart';
import '../../core/providers/isar_provider.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../app/theme.dart';
import '../../widgets/app_top_bar.dart';
import 'providers/github_sync_notifier.dart';
import 'providers/pulse_providers.dart';
import 'services/github_service.dart';
import 'widgets/contribution_heatmap.dart';
import 'widgets/date_range_selector.dart';
import 'widgets/event_stream_terminal.dart';
import 'widgets/github_connect_banner.dart';
import 'widgets/language_donut_chart.dart';
import 'widgets/pulse_theme.dart';
import 'widgets/top_repositories_section.dart';

class PulseScreen extends ConsumerStatefulWidget {
  const PulseScreen({super.key});

  @override
  ConsumerState<PulseScreen> createState() => _PulseScreenState();
}

class _PulseScreenState extends ConsumerState<PulseScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final tokenChanged = await consumeTokenChangedFlag();
    if (tokenChanged) {
      await clearPulseCaches();
      ref.invalidate(githubConnectedProvider);
      ref.invalidate(githubUserProvider);
      ref.invalidate(contributionDataProvider);
      ref.invalidate(languageDistributionProvider);
      ref.invalidate(recentEventsProvider);
      ref.invalidate(topRepositoriesProvider);
      ref.invalidate(allRepositoriesProvider);
    }
    final connected = await ref.read(githubConnectedProvider.future);
    if (!connected) return;
    final last = await ref.read(lastSyncedAtProvider.future);
    if (last == null ||
        DateTime.now().difference(last) > const Duration(hours: 1)) {
      unawaited(
        ref.read(githubSyncNotifierProvider.notifier).syncAll(silent: true),
      );
    } else {
      ref.read(offlineModeProvider.notifier).state = await readOfflineMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectedAsync = ref.watch(githubConnectedProvider);
    final syncing = ref.watch(syncLoadingProvider);
    final offlineMode = ref.watch(offlineModeProvider);
    final userAsync = ref.watch(githubUserProvider);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: pulseBackground,
      drawer: _PulseDrawer(
        onDisconnect: _disconnectGitHub,
        onSettingsTap: () => Navigator.of(context).pop(),
      ),
      appBar: buildFlowSpaceAppBar(
        scaffoldKey: _scaffoldKey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => _showProfileSheet(context),
              borderRadius: BorderRadius.circular(20),
              child: userAsync.when(
                data: (user) => CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.surfaceCard,
                  backgroundImage: user != null && user.avatarUrl.isNotEmpty
                      ? NetworkImage(user.avatarUrl)
                      : null,
                  child: (user == null || user.avatarUrl.isEmpty)
                      ? const Icon(Icons.person, color: Colors.white, size: 16)
                      : null,
                ),
                error: (_, __) => const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.surfaceCard,
                  child: Icon(Icons.person, color: Colors.white, size: 16),
                ),
                loading: () => const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.surfaceCard,
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: connectedAsync.when(
        data: (connected) {
          if (!connected) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: GitHubConnectBanner(
                onConnect: () => _showTokenEntrySheet(context),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 108),
            children: [
              Text(
                'LIVE REPOSITORY ANALYSIS',
                style: GoogleFonts.spaceGrotesk(
                  color: pulsePrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ).animate().fadeIn(delay: 0.ms),
              const SizedBox(height: 6),
              Text(
                'Pulse Dashboard',
                style: GoogleFonts.spaceGrotesk(
                  color: pulseText,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(delay: 0.ms),
              const SizedBox(height: 4),
              _LastSyncedSubtitle().animate().fadeIn(delay: 0.ms),
              const SizedBox(height: 12),
              DateRangeSelector(
                syncing: syncing,
                onSync: () => _sync(context),
              ).animate().fadeIn(delay: 0.ms),
              if (offlineMode)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Offline — showing cached data',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.warning,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              const ContributionHeatmap()
                  .animate()
                  .fadeIn(delay: kPageStaggerStep)
                  .slideY(begin: 0.05, end: 0, delay: kPageStaggerStep),
              const SizedBox(height: 14),
              const LanguageDonutChart()
                  .animate()
                  .fadeIn(delay: kPageStaggerStep * 2)
                  .slideY(begin: 0.05, end: 0, delay: kPageStaggerStep * 2),
              const SizedBox(height: 14),
              const EventStreamTerminal()
                  .animate()
                  .fadeIn(delay: kPageStaggerStep * 3)
                  .slideY(begin: 0.05, end: 0, delay: kPageStaggerStep * 3),
              const SizedBox(height: 14),
              const TopRepositoriesSection()
                  .animate()
                  .fadeIn(delay: kPageStaggerStep * 4)
                  .slideY(begin: 0.05, end: 0, delay: kPageStaggerStep * 4),
            ],
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: pulsePrimary)),
        error: (_, __) => Center(
          child: Text(
            'Unable to determine GitHub connection',
            style: GoogleFonts.spaceGrotesk(color: pulseMuted),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showQuickActions(context),
        backgroundColor: pulsePrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }

  Future<void> _sync(BuildContext context) async {
    try {
      await ref.read(githubSyncNotifierProvider.notifier).syncAll();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Synced successfully ✓')));
    } on GitHubApiException catch (e) {
      if (!mounted) return;
      final msg = switch (e.type) {
        GitHubErrorType.rateLimited =>
          'GitHub rate limit reached — try again in ${_minutesUntil(e.retryAt)} minutes',
        GitHubErrorType.unauthorized =>
          'Token expired — please reconnect GitHub',
        _ => 'Sync failed — check connection',
      };
      if (e.type == GitHubErrorType.unauthorized) {
        await _disconnectGitHub();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync failed — check connection')),
      );
    }
  }

  int _minutesUntil(DateTime? retryAt) {
    if (retryAt == null) return 1;
    final mins = retryAt.difference(DateTime.now()).inMinutes;
    return mins <= 0 ? 1 : mins;
  }

  Future<void> _disconnectGitHub() async {
    await ref.read(githubServiceProvider).clearToken();
    await clearPulseCaches();
    await setTokenChangedFlag();
    ref.invalidate(githubTokenProvider);
    ref.invalidate(githubConnectedProvider);
    ref.invalidate(githubUserProvider);
    ref.invalidate(contributionDataProvider);
    ref.invalidate(languageDistributionProvider);
    ref.invalidate(recentEventsProvider);
    ref.invalidate(topRepositoriesProvider);
    ref.invalidate(allRepositoriesProvider);
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('GitHub disconnected')));
    }
  }

  Future<void> _showTokenEntrySheet(BuildContext context) async {
    final controller = TextEditingController();
    var loading = false;
    String? error;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: pulseCard,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your GitHub Personal Access Token',
                  style: GoogleFonts.spaceGrotesk(
                    color: pulseText,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final uri = Uri.parse('https://github.com/settings/tokens');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    'Open github.com/settings/tokens (scopes: repo, read:user, read:org)',
                    style: GoogleFonts.spaceGrotesk(
                      color: pulsePrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'ghp_...',
                    errorText: error,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () async {
                            setModalState(() {
                              loading = true;
                              error = null;
                            });
                            final token = controller.text.trim();
                            final valid = await ref
                                .read(githubServiceProvider)
                                .verifyToken(token);
                            if (!valid) {
                              setModalState(() {
                                loading = false;
                                error = 'Invalid token — please try again';
                              });
                              return;
                            }
                            await ref
                                .read(githubServiceProvider)
                                .saveToken(token);
                            await clearPulseCaches();
                            await setTokenChangedFlag();
                            ref.invalidate(githubTokenProvider);
                            ref.invalidate(githubConnectedProvider);
                            ref.invalidate(githubUserProvider);
                            ref.invalidate(contributionDataProvider);
                            ref.invalidate(languageDistributionProvider);
                            ref.invalidate(recentEventsProvider);
                            ref.invalidate(topRepositoriesProvider);
                            ref.invalidate(allRepositoriesProvider);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            await _sync(this.context);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pulsePrimary,
                    ),
                    child: loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Verify + Save'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showProfileSheet(BuildContext context) async {
    final user = await ref.read(githubUserProvider.future);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: pulseCard,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? Text(
                'No profile loaded',
                style: GoogleFonts.spaceGrotesk(color: pulseMuted),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.displayName,
                    style: GoogleFonts.spaceGrotesk(
                      color: pulseText,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '@${user.username}',
                    style: GoogleFonts.spaceGrotesk(color: pulseMuted),
                  ),
                  const SizedBox(height: 10),
                  Text(user.bio, style: GoogleFonts.spaceGrotesk(color: pulseMuted)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _stat('Followers', '${user.followers}'),
                      _stat('Following', '${user.following}'),
                      _stat('Repos', '${user.publicRepos}'),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            color: pulseText,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(label, style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 12)),
      ],
    );
  }

  Future<void> _showQuickActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: pulseCard,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _actionTile(
              icon: Icons.note_add_outlined,
              title: 'Add Repository Note',
              onTap: () => _addRepositoryNote(context),
            ),
            _actionTile(
              icon: Icons.bug_report_outlined,
              title: 'Create Task from Issue',
              onTap: () => _createTaskFromIssue(context),
            ),
            _actionTile(
              icon: Icons.flag_outlined,
              title: 'Set Coding Goal',
              onTap: () => _setCodingGoal(context),
            ),
            _actionTile(
              icon: Icons.ios_share_outlined,
              title: 'Share Stats',
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share export is ready for integration'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: pulsePrimary),
      title: Text(title, style: GoogleFonts.spaceGrotesk(color: pulseText)),
      onTap: onTap,
    );
  }

  Future<void> _addRepositoryNote(BuildContext context) async {
    Navigator.of(context).pop();
    final repos = await ref.read(allRepositoriesProvider.future);
    final noteController = TextEditingController();
    String selected = repos.isNotEmpty ? repos.first.fullName : '';
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: pulseCard,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Repository Note',
                style: GoogleFonts.spaceGrotesk(
                  color: pulseText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              if (repos.isNotEmpty)
                DropdownButtonFormField<String>(
                  value: selected,
                  dropdownColor: pulseCard,
                  items: repos
                      .map(
                        (repo) => DropdownMenuItem(
                          value: repo.fullName,
                          child: Text(repo.fullName),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setState(() => selected = value ?? selected),
                ),
              const SizedBox(height: 8),
              TextField(
                controller: noteController,
                maxLines: 4,
                decoration: const InputDecoration(hintText: 'Write a note'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final list = prefs.getStringList('pulse_repo_notes') ?? [];
                  list.add(
                    '${DateTime.now().toIso8601String()}|$selected|${noteController.text.trim()}',
                  );
                  await prefs.setStringList('pulse_repo_notes', list);
                  if (context.mounted) Navigator.of(context).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(content: Text('Repository note saved')),
                    );
                  }
                },
                child: const Text('Save Note'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createTaskFromIssue(BuildContext context) async {
    Navigator.of(context).pop();
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: pulseCard,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'owner/repo#issueNumber',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  final issue = await ref
                      .read(githubServiceProvider)
                      .fetchIssueByRef(controller.text.trim());
                  final isar = await ref.read(isarProvider.future);
                  final task = Task()
                    ..uuid = const Uuid().v4()
                    ..title = issue.title
                    ..description =
                        'Imported from GitHub issue #${issue.number}\n${issue.htmlUrl}'
                    ..tag = 'github'
                    ..priority = 'med'
                    ..status = issue.state == 'closed' ? 'done' : 'todo'
                    ..dueDate = null
                    ..createdAt = DateTime.now()
                    ..updatedAt = DateTime.now()
                    ..isRecurring = false
                    ..recurringFrequency = 'none'
                    ..assignToPomodoro = false
                    ..subtasks = []
                    ..subtaskCompleted = []
                    ..dependencyIds = []
                    ..projectId = '';
                  await isar.writeTxn(() async {
                    await isar.tasks.put(task);
                  });
                  if (context.mounted) Navigator.of(context).pop();
                  if (mounted) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(content: Text('Task created from issue')),
                    );
                  }
                } on GitHubApiException catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      this.context,
                    ).showSnackBar(SnackBar(content: Text(e.message)));
                  }
                }
              },
              child: const Text('Import Issue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setCodingGoal(BuildContext context) async {
    Navigator.of(context).pop();
    final controller = TextEditingController(text: '5');
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: pulseCard,
        title: const Text('Set Coding Goal'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Daily commit target'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt(
                'pulse_daily_commit_goal',
                int.tryParse(controller.text) ?? 0,
              );
              if (context.mounted) Navigator.of(context).pop();
              if (mounted) {
                ScaffoldMessenger.of(this.context).showSnackBar(
                  const SnackBar(content: Text('Coding goal saved')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _LastSyncedSubtitle extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastSynced = ref.watch(lastSyncedAtProvider);
    return lastSynced.when(
      data: (value) {
        if (value == null) {
          return Text(
            'Not synced yet',
            style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 12),
          );
        }
        final diff = DateTime.now().difference(value);
        final label = diff.inMinutes < 1
            ? 'just now'
            : diff.inMinutes < 60
            ? '${diff.inMinutes} mins ago'
            : DateFormat.yMMMd().add_jm().format(value);
        return Text(
          'Last synced $label',
          style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 12),
        );
      },
      loading: () => Text(
        'Loading sync status…',
        style: GoogleFonts.spaceGrotesk(color: pulseMuted, fontSize: 12),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _PulseDrawer extends ConsumerWidget {
  const _PulseDrawer({required this.onDisconnect, required this.onSettingsTap});

  final Future<void> Function() onDisconnect;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connected = ref.watch(githubConnectedProvider).valueOrNull ?? false;
    final user = ref.watch(githubUserProvider).valueOrNull;
    return Drawer(
      backgroundColor: pulseCard,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            if (user != null)
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: user.avatarUrl.isNotEmpty
                        ? NetworkImage(user.avatarUrl)
                        : null,
                    child: user.avatarUrl.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: GoogleFonts.spaceGrotesk(
                            color: pulseText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '@${user.username}',
                          style: GoogleFonts.spaceGrotesk(color: pulseMuted),
                        ),
                        Text(
                          '${user.followers} followers • ${user.following} following',
                          style: GoogleFonts.spaceGrotesk(
                            color: pulseMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              Text(
                'No account connected',
                style: GoogleFonts.spaceGrotesk(color: pulseMuted),
              ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: connected ? pulseSuccess : pulseDanger,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  connected ? 'Connected' : 'Not connected',
                  style: GoogleFonts.spaceGrotesk(color: pulseText),
                ),
              ],
            ),
            const Divider(height: 28),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: pulsePrimary),
              title: Text(
                'Settings shortcut',
                style: GoogleFonts.spaceGrotesk(color: pulseText),
              ),
              onTap: onSettingsTap,
            ),
            ListTile(
              leading: const Icon(Icons.link_off, color: pulseDanger),
              title: Text(
                'Disconnect GitHub',
                style: GoogleFonts.spaceGrotesk(color: pulseDanger),
              ),
              onTap: () => onDisconnect(),
            ),
          ],
        ),
      ),
    );
  }
}
