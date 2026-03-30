import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/committee_admin_overview.dart';
import '../widgets/committee_members_list.dart';
import '../widgets/committee_list_card.dart';
import 'edit_committee_screen.dart';

class CommitteeDetailsScreen extends StatelessWidget {
  final String committeeId;
  final String committeeName;
  final CommitteeStatus status;

  const CommitteeDetailsScreen({
    super.key,
    required this.committeeId,
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
                      committeeId: committeeId,
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('committees')
              .doc(committeeId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommitteeAdminOverview(
                  committeeId: committeeId,
                  status: data['isActive'] == true
                      ? CommitteeStatus.active
                      : CommitteeStatus.inactive,
                  chairperson: data['chairperson'] ?? '',
                  coordinator: data['coordinator'] ?? '',
                ),
                const SizedBox(height: 24),
                CommitteeMembersList(
                  committeeId: committeeId,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

