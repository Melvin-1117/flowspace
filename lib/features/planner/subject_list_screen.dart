import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/app_drawer.dart';
import 'providers/planner_providers.dart';
import 'widgets/subject_mastery_card.dart';
import '../../app/theme.dart';

class SubjectListScreen extends ConsumerStatefulWidget {
  const SubjectListScreen({super.key});

  @override
  ConsumerState<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends ConsumerState<SubjectListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final subjects = ref.watch(allSubjectsProvider);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
        title: const Text('All Subjects'),
      ),
      body: subjects.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load subjects')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'No subjects available',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final subject = items[index];
              return SubjectMasteryCard(
                subject: subject,
                index: index,
                hoursProvider: subjectHoursProvider(subject.uuid),
                onTap: () => context.push('/planner/subjects/${subject.uuid}'),
              );
            },
          );
        },
      ),
    );
  }
}
