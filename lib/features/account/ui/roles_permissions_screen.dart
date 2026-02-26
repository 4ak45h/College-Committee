import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/audit_log_service.dart';

class RolesPermissionsScreen extends StatelessWidget {
  const RolesPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          title: const Text('Roles & Permissions'),
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Global Roles'),
              Tab(text: 'Committee Roles'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _GlobalRolesTab(),
            _CommitteeRolesTab(),
          ],
        ),
      ),
    );
  }
}

/* =========================================================
   GLOBAL ROLES TAB
   ========================================================= */

class _GlobalRolesTab extends StatefulWidget {
  const _GlobalRolesTab();

  @override
  State<_GlobalRolesTab> createState() => _GlobalRolesTabState();
}

class _GlobalRolesTabState extends State<_GlobalRolesTab> {
  final List<UserRoleModel> _users = [
    UserRoleModel(name: 'Dr. R. Mehta', role: 'Leader'),
    UserRoleModel(name: 'Prof. S. Kumar', role: 'Member'),
    UserRoleModel(name: 'Dr. A. Rao', role: 'Member'),
  ];

  String _searchQuery = '';

  bool _leaderExists() {
    return _users.any((u) => u.role == 'Leader');
  }

  Future<void> _toggleRole(int index) async {
    final user = _users[index];
    final currentRole = user.role;
    final newRole = currentRole == 'Leader' ? 'Member' : 'Leader';

    // Enforce single leader
    if (newRole == 'Leader' && _leaderExists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Only one Leader is allowed at a time.'),
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          newRole == 'Leader'
              ? 'Promote to Leader?'
              : 'Demote Leader?',
        ),
        content: Text(
          newRole == 'Leader'
              ? 'This user will gain leader privileges.'
              : 'This user will lose leader privileges.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        user.role = newRole;
      });

      // 🔥 Centralized audit log
      AuditLogService().addLog(
        '${user.name} changed to $newRole',
        'Role',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users
        .where((u) =>
            u.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    final recentLogs = AuditLogService().logs;

    return Column(
      children: [
        /* =========================
           SEARCH BAR
           ========================= */

        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search user...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
        ),

        /* =========================
           USER LIST
           ========================= */

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];

              return _UserRoleCard(
                name: user.name,
                role: user.role,
                onToggle: () {
                  final realIndex =
                      _users.indexWhere((u) => u.name == user.name);
                  _toggleRole(realIndex);
                },
              );
            },
          ),
        ),

        /* =========================
           RECENT ACTIVITY PREVIEW
           ========================= */

        if (recentLogs.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  recentLogs.first.action,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/* =========================================================
   COMMITTEE ROLES TAB
   ========================================================= */

class _CommitteeRolesTab extends StatelessWidget {
  const _CommitteeRolesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _CommitteeRoleCard(
          committee: 'Academic Review Committee',
          chair: 'Dr. R. Mehta',
          coordinator: 'Prof. S. Kumar',
        ),
        _CommitteeRoleCard(
          committee: 'Cultural Committee',
          chair: 'Prof. L. Sharma',
          coordinator: 'Dr. N. Iyer',
        ),
      ],
    );
  }
}

/* =========================================================
   MODEL
   ========================================================= */

class UserRoleModel {
  final String name;
  String role;

  UserRoleModel({
    required this.name,
    required this.role,
  });
}

/* =========================================================
   USER CARD
   ========================================================= */

class _UserRoleCard extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback onToggle;

  const _UserRoleCard({
    required this.name,
    required this.role,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLeader = role == 'Leader';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isLeader
                  ? Colors.blue.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 12,
                color: isLeader ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: onToggle,
            child: Text(
              isLeader ? 'Demote' : 'Promote',
              style: TextStyle(
                color: isLeader ? Colors.red : AppTheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* =========================================================
   COMMITTEE CARD
   ========================================================= */

class _CommitteeRoleCard extends StatelessWidget {
  final String committee;
  final String chair;
  final String coordinator;

  const _CommitteeRoleCard({
    required this.committee,
    required this.chair,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            committee,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text('Chairperson: $chair'),
          Text('Coordinator: $coordinator'),
        ],
      ),
    );
  }
}