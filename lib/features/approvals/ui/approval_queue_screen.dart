import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/approval_request_card.dart';

class ApprovalQueueScreen extends StatelessWidget {
  const ApprovalQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Approval Queue'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ApprovalRequestCard(
            type: ApprovalType.meeting,
            title: 'Academic Review Meeting',
            committee: 'Academic Review Committee',
            requestedBy: 'Dr. S. Kumar',
            date: '12 Sep 2026',
          ),
          ApprovalRequestCard(
            type: ApprovalType.event,
            title: 'Cultural Fest Proposal',
            committee: 'Cultural Committee',
            requestedBy: 'Prof. R. Mehta',
            date: '10 Sep 2026',
          ),
          ApprovalRequestCard(
            type: ApprovalType.document,
            title: 'Annual Budget Submission',
            committee: 'Finance Committee',
            requestedBy: 'Dr. A. Rao',
            date: '08 Sep 2026',
          ),
        ],
      ),
    );
  }
}
