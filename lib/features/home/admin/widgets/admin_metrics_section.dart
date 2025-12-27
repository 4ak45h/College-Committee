import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

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

        // HERO METRIC — Pending Approvals
        _HeroMetricCard(
          title: 'Pending Approvals',
          value: '3',
          subtitle: 'Requires immediate attention',
        ),

        const SizedBox(height: 16),

        // REGULAR METRICS (CENTERED)
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: const [
            _MetricCard(
              title: 'Committees',
              value: '12',
            ),
            _MetricCard(
              title: 'Faculty Members',
              value: '86',
            ),
            _MetricCard(
              title: 'Events This Month',
              value: '8',
            ),
            _MetricCard(
              title: 'Average Attendance',
              value: '92%',
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

class _HeroMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const _HeroMetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

/* =========================
   REGULAR METRIC CARD
   (CENTERED CONTENT)
   ========================= */

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;

  const _MetricCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.muted,
            ),
          ),
        ],
      ),
    );
  }
}
