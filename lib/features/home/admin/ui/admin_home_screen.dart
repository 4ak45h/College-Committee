import 'package:flutter/material.dart';
import '../../../committees/ui/committees_screen.dart';
import '../../../account/ui/account_screen.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/admin_metrics_section.dart';
import '../widgets/admin_actions_section.dart';
import '../widgets/admin_alerts_section.dart';
import '../widgets/upcoming_meetings_section.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Administration Dashboard'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Committees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const AdminMetricsSection(),
        const SizedBox(height: 20),
        const AdminActionsSection(),
        const SizedBox(height: 20),
        const AdminAlertsSection(),
        const SizedBox(height: 20),
        const UpcomingMeetingsSection(),
        ],
      ),
    );
  }

  Widget _buildBody() {
  switch (_currentIndex) {
    case 0:
      return _buildDashboard();
    case 1:
      return CommitteesScreen();
    case 2:
      return const AccountScreen();
    default:
      return _buildDashboard();
  }
}

  Widget _placeholder() {
    return const Center(
      child: Text('This section will be implemented later'),
    );
  }
}
