import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.75,
      backgroundColor: AppTheme.surfaceCard,
      child: SafeArea(
        child: Column(
          children: [
            // User Profile Section
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primary),
              accountName: const Text(
                'FlowSpace User',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: const Text(
                'student@flowspace.app',
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Focus/Home
                  _buildDrawerItem(
                    context,
                    icon: Icons.timer_outlined,
                    title: 'Focus',
                    subtitle: 'Deep work sessions',
                    route: '/focus',
                    isSelected:
                        GoRouterState.of(context).uri.toString() == '/focus',
                  ),

                  // Tasks
                  _buildDrawerItem(
                    context,
                    icon: Icons.check_circle_outline,
                    title: 'Tasks',
                    subtitle: 'Manage your tasks',
                    route: '/tasks',
                    isSelected:
                        GoRouterState.of(context).uri.toString() == '/tasks',
                  ),

                  // Pomodoro
                  _buildDrawerItem(
                    context,
                    icon: Icons.hourglass_top_rounded,
                    title: 'Pomodoro',
                    subtitle: 'Timer and sessions',
                    route: '/pomodoro',
                    isSelected:
                        GoRouterState.of(context).uri.toString() == '/pomodoro',
                  ),

                  // Planner
                  _buildDrawerItem(
                    context,
                    icon: Icons.calendar_today_outlined,
                    title: 'Planner',
                    subtitle: 'Schedule and planning',
                    route: '/planner',
                    isSelected:
                        GoRouterState.of(context).uri.toString() == '/planner',
                  ),

                  // GitHub
                  _buildDrawerItem(
                    context,
                    icon: Icons.code_outlined,
                    title: 'GitHub',
                    subtitle: 'Repository dashboard',
                    route: '/settings',
                    isSelected:
                        GoRouterState.of(context).uri.toString() == '/settings',
                  ),

                  // Analytics
                  _buildDrawerItem(
                    context,
                    icon: Icons.analytics_outlined,
                    title: 'Analytics',
                    subtitle: 'View your progress',
                    route: '/analytics',
                    isSelected:
                        GoRouterState.of(context).uri.toString() ==
                        '/analytics',
                  ),

                  const Divider(color: Color(0x22FFFFFF), height: 32),

                  // Help & Support
                  _buildDrawerItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    subtitle: 'Get help and feedback',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showHelpDialog(context);
                    },
                  ),

                  // About
                  _buildDrawerItem(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App information',
                    onTap: () {
                      Navigator.of(context).pop();
                      _showAboutDialog(context);
                    },
                  ),
                ],
              ),
            ),

            // Logout Section
            Container(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const Icon(Icons.logout, color: AppTheme.danger),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _showLogoutDialog(context);
                },
              ),
            ),

            // App Version
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'FlowSpace v1.0.0',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? route,
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primary : Colors.grey[400],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppTheme.primary : Colors.white,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[400], fontSize: 12),
      ),
      selected: isSelected,
      selectedTileColor: AppTheme.primary.withValues(alpha: 0.1),
      onTap:
          onTap ??
          () {
            Navigator.of(context).pop();
            if (route != null) {
              context.go(route);
            }
          },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'FlowSpace Help',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('• Focus: Start deep work sessions'),
            Text('• Tasks: Manage your to-do list'),
            Text('• Pomodoro: Use time management'),
            Text('• Planner: Schedule your work'),
            Text('• Analytics: Track your progress'),
            SizedBox(height: 16),
            Text(
              'Need more help?',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text('Email: support@flowspace.app'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'FlowSpace',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.timer, color: AppTheme.primary),
      children: [
        const Text(
          'FlowSpace is your productivity companion for deep work, task management, and focus sessions.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement actual logout logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logout functionality coming soon!'),
                  backgroundColor: AppTheme.primary,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.danger,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
