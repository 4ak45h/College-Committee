import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../approvals/ui/approval_queue_screen.dart';
import '../../../committees/ui/committees_screen.dart';
import '../../../faculty/ui/faculty_management_screen.dart';
import '../../../meetings/ui/admin_events_overview_screen.dart';

class AdminMetricsSection extends StatelessWidget {
  const AdminMetricsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Overview',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // HERO METRIC — Pending Approvals (CLICKABLE)
        HeroMetricCard(
          title: 'Pending Approvals',
          value: '3',
          subtitle: 'Requires immediate attention',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ApprovalQueueScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // REGULAR METRICS
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            MetricCard(
              title: 'Committees',
              value: '12',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CommitteesScreen(),
                  ),
                );
              },
            ),
            MetricCard(
              title: 'Faculty Members',
              value: '86',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FacultyManagementScreen(),
                  ),
                );
              },
            ),
            MetricCard(
              title: 'Events This Month',
              value: '8',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminEventsOverviewScreen(),
                  ),
                );
              },
            ),
            MetricCard(
              title: 'Average Attendance',
              value: '92%',
              isInsight: true,
            ),
          ],
        ),
      ],
    );
  }
}

/* =========================
   HERO METRIC CARD
   ========================= */

class HeroMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback onTap;

  const HeroMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppTheme.primary.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.approval_outlined,
              size: 36,
              color: AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

/* =========================
   REGULAR METRIC CARD
   ========================= */

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool isInsight;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.onTap,
    this.isInsight = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: isInsight ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isInsight
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
        border: isInsight
            ? Border.all(color: Colors.grey.shade300)
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isInsight ? Colors.black54 : Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isInsight ? Colors.black45 : AppTheme.muted,
            ),
          ),
          if (isInsight) ...[
            const SizedBox(height: 6),
            const Text(
              'Insight',
              style: TextStyle(
                fontSize: 11,
                color: Colors.black38,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );

    // Insight cards are NEVER clickable
    if (isInsight || onTap == null) return card;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: card,
    );
  }
}


