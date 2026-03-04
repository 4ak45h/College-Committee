import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/audit_log_service.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final service = AuditLogService();

    final logs = _filter == 'All'
        ? service.logs
        : service.logs.where((log) => log.category == _filter).toList();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Audit Logs'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              service.clearLogs();
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _filterChip('All'),
                const SizedBox(width: 8),
                _filterChip('Role'),
                const SizedBox(width: 8),
                _filterChip('Committee'),
              ],
            ),
          ),
          Expanded(
            child: logs.isEmpty
                ? const Center(
                    child: Text(
                      'No activity recorded',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      return _AuditLogCard(log: logs[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final bool isSelected = _filter == label;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primary.withOpacity(0.15),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primary : Colors.black54,
      ),
      onSelected: (_) {
        setState(() => _filter = label);
      },
    );
  }
}

class _AuditLogCard extends StatelessWidget {
  final AuditLogModel log;

  const _AuditLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (log.category) {
      case 'Role':
        icon = Icons.admin_panel_settings_outlined;
        color = Colors.blue;
        break;
      case 'Committee':
        icon = Icons.groups_outlined;
        color = Colors.green;
        break;
      default:
        icon = Icons.info_outline;
        color = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.action,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(log.timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTimestamp(DateTime time) {
    return '${time.day}/${time.month}/${time.year} • '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}