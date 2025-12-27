import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        _AlertCard(
          icon: Icons.approval_outlined,
          title: 'Pending Approvals',
          description: '3 events awaiting your approval',
        ),

        const SizedBox(height: 10),

        _AlertCard(
          icon: Icons.pause_circle_outline,
          title: 'Inactive Committees',
          description: '2 committees inactive for over 60 days',
        ),

        const SizedBox(height: 10),

        _AlertCard(
          icon: Icons.schedule_outlined,
          title: 'Overdue Tasks',
          description: '5 tasks have exceeded their deadlines',
        ),
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _AlertCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            icon,
            color: AppTheme.primary,
            size: 26,
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
