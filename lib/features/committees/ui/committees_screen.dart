import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/committee_list_card.dart';
import 'create_committee_screen.dart';

class CommitteesScreen extends StatelessWidget {
  const CommitteesScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle(title: 'Active Committees'),
          const SizedBox(height: 12),

          const CommitteeListCard(
            name: 'Academic Review Committee',
            coordinator: 'Dr. S. Kumar',
            status: CommitteeStatus.active,
          ),
          const CommitteeListCard(
            name: 'Cultural Committee',
            coordinator: 'Prof. R. Mehta',
            status: CommitteeStatus.active,
          ),

          const SizedBox(height: 24),

          const _SectionTitle(title: 'Inactive Committees'),
          const SizedBox(height: 12),

          const CommitteeListCard(
            name: 'Disciplinary Committee',
            coordinator: 'Dr. A. Rao',
            status: CommitteeStatus.inactive,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateCommitteeScreen(),
            ),
          );
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}

/* =========================
   SECTION TITLE
   ========================= */

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}