import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

import '../../../committees/ui/committees_screen.dart';
import '../../../approvals/ui/approval_queue_screen.dart';
import '../../../faculty/ui/faculty_management_screen.dart';

class AdminActionsSection extends StatelessWidget {
  const AdminActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Administrative Controls',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _ActionCard(
              icon: Icons.groups_outlined,
              title: 'Manage Committees',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommitteesScreen(),
                  ),
                );
              },
            ),
            _ActionCard(
              icon: Icons.approval_outlined,
              title: 'Approval Queue',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ApprovalQueueScreen(),
                  ),
                );
              },
            ),
            _ActionCard(
              icon: Icons.person_outline,
              title: 'Manage Faculty',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FacultyManagementScreen(),
                  ),
                );
              },
            ),
            _ActionCard(
              icon: Icons.analytics_outlined,
              title: 'Reports & Analytics',
              onTap: () {
                // Placeholder — will be implemented later
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reports & Analytics coming soon'),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/* =========================
   ACTION CARD
   ========================= */

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: AppTheme.primary,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
