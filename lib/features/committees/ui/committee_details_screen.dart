import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/committee_admin_overview.dart';
import '../widgets/committee_members_list.dart';

class CommitteeDetailsScreen extends StatelessWidget {
  final String committeeName;

  const CommitteeDetailsScreen({
    super.key,
    required this.committeeName,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CommitteeAdminOverview(),
            SizedBox(height: 24),
            CommitteeMembersList(),
          ],
        ),
      ),
    );
  }
}
