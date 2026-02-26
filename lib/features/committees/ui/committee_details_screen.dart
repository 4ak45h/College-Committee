import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/committee_admin_overview.dart';
import '../widgets/committee_members_list.dart';
import '../widgets/committee_list_card.dart';
import 'edit_committee_screen.dart';

class CommitteeDetailsScreen extends StatelessWidget {
  final String committeeName;
  final CommitteeStatus status;

  const CommitteeDetailsScreen({
    super.key,
    required this.committeeName,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(committeeName),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditCommitteeScreen(
                      committeeName: committeeName,
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit Committee'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommitteeAdminOverview(
              status: status,
            ),
            const SizedBox(height: 24),
            const CommitteeMembersList(),
          ],
        ),
      ),
    );
  }
}

