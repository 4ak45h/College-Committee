import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/committee_list_card.dart';

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
        children: const [
          CommitteeListCard(
            name: 'Academic Review Committee',
            coordinator: 'Dr. S. Kumar',
            status: CommitteeStatus.active,
          ),
          CommitteeListCard(
            name: 'Cultural Committee',
            coordinator: 'Prof. R. Mehta',
            status: CommitteeStatus.active,
          ),
          CommitteeListCard(
            name: 'Disciplinary Committee',
            coordinator: 'Dr. A. Rao',
            status: CommitteeStatus.inactive,
          ),
        ],
      ),
    );
  }
}
