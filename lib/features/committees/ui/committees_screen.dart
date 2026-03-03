import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/committee_list_card.dart';
import '../../../services/committee_service.dart';

class CommitteesScreen extends StatelessWidget {
  CommitteesScreen({super.key});

  // 🔗 Firestore service instance
  final CommitteeService _committeeService = CommitteeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Committees'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // 🔥 REAL-TIME FIRESTORE CONNECTION
      body: StreamBuilder(
        stream: _committeeService.getCommittees(),
        builder: (context, snapshot) {

          // ⏳ Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // ❌ Error state
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          // 📭 Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No committees found'),
            );
          }

          final committees = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: committees.length,
            itemBuilder: (context, index) {
              final doc = committees[index];
              final data = doc.data() as Map<String, dynamic>;

              return CommitteeListCard(
                name: data['name'] ?? 'Unnamed Committee',
                coordinator: data['coordinator'] ?? 'N/A',
                status: data['isActive'] == true
                    ? CommitteeStatus.active
                    : CommitteeStatus.inactive,
              );
            },
          );
        },
      ),
    );
  }
}