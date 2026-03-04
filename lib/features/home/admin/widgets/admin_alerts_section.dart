import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../approvals/ui/approval_queue_screen.dart';
import '../../../committees/ui/committees_screen.dart';

class AdminAlertsSection extends StatelessWidget {
  const AdminAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requires Administrative Attention',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        // ALERT 1 — Pending Approvals
        _AlertTile(
          icon: Icons.approval_outlined,
          title: 'Pending Approvals',
          subtitle: '3 requests awaiting decision',
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ApprovalQueueScreen(),
              ),
            );
          },
        ),

        // ALERT 2 — Inactive Committees
        _AlertTile(
          icon: Icons.pause_circle_outline,
          title: 'Inactive Committees',
          subtitle: '2 committees inactive for over 30 days',
          color: Colors.grey,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommitteesScreen(),
              ),
            );
          },
        ),

        // ALERT 3 — Overdue Tasks
        _AlertTile(
          icon: Icons.warning_amber_outlined,
          title: 'Overdue Tasks',
          subtitle: '5 tasks overdue across committees',
          color: Colors.red,
          onTap: () {
            // Future: Overdue tasks overview
          },
        ),
      ],
    );
  }
}

/* =========================
   ALERT TILE
   ========================= */

class _AlertTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AlertTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}
