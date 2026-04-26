import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/approval_service.dart';
import '../widgets/approval_request_card.dart';

class ApprovalQueueScreen extends StatelessWidget {
  ApprovalQueueScreen({super.key});

  final ApprovalService _approvalService = ApprovalService();

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day.toString().padLeft(2, '0')} '
        '${_monthName(date.month)} '
        '${date.year}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  ApprovalType _mapApprovalType(String type) {
    switch (type) {
      case 'MEETING':
        return ApprovalType.meeting;
      case 'EVENT':
        return ApprovalType.event;
      case 'DOCUMENT':
        return ApprovalType.document;
      default:
        return ApprovalType.document;
    }
  }

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _approvalService.getPendingApprovals(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pending approvals'));
          }

          final approvals = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: approvals.length,
            itemBuilder: (context, index) {
              final doc = approvals[index];
              final data = doc.data() as Map<String, dynamic>;

              final docId = doc.id;

              return ApprovalRequestCard(
                type: _mapApprovalType(data['type'] ?? ''),
                title: data['title'] ?? 'Untitled',
                committee: data['committee'] ?? 'Unknown Committee',

                /// ✅ REMOVED requestedBy

                date: data['createdAt'] != null
                    ? _formatDate(data['createdAt'])
                    : 'N/A',

                onApprove: () async {
                  await _approvalService.updateApprovalStatus(
                      docId,
                      "APPROVED"
                  );
                },

                onReject: () async {
                  await _approvalService.updateApprovalStatus(
                      docId,
                      "REJECTED"
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}