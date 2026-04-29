import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Audit Logs'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          /// FILTERS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _filterChip('All'),
                const SizedBox(width: 8),
                _filterChip('event'),
                const SizedBox(width: 8),
                _filterChip('committee'),
              ],
            ),
          ),

          /// LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('audit_logs')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading logs"));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No activity recorded'),
                  );
                }

                final logs = snapshot.data!.docs;

                /// FILTER LOGIC
                final filteredLogs = _filter == 'All'
                    ? logs
                    : logs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['entityType'] == _filter;
                }).toList();

                if (filteredLogs.isEmpty) {
                  return const Center(
                    child: Text('No activity for selected filter'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredLogs.length,
                  itemBuilder: (context, index) {
                    final data =
                    filteredLogs[index].data() as Map<String, dynamic>;

                    return _AuditLogCard(data: data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    final isSelected = _filter == label;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppTheme.primary.withOpacity(0.2),
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
  final Map<String, dynamic> data;

  const _AuditLogCard({required this.data});

  @override
  Widget build(BuildContext context) {

    final action = data['action'] ?? '';
    final details = data['details'] ?? '';
    final timestamp = data['timestamp'] as Timestamp?;

    IconData icon;
    Color color;

    if (action.contains("CREATE")) {
      icon = Icons.add_circle_outline;
      color = Colors.blue;
    } else if (action.contains("APPROVE")) {
      icon = Icons.check_circle_outline;
      color = Colors.green;
    } else if (action.contains("REJECT")) {
      icon = Icons.cancel_outlined;
      color = Colors.red;
    } else if (action.contains("DELETE")) {
      icon = Icons.delete_outline;
      color = Colors.grey;
    } else {
      icon = Icons.info_outline;
      color = Colors.black54;
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

                /// ACTION
                Text(
                  _formatAction(action),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                /// DETAILS
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                /// TIME
                Text(
                  timestamp != null
                      ? _formatTime(timestamp.toDate())
                      : '',
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

  String _formatAction(String action) {
    return action
        .replaceAll("_", " ")
        .toLowerCase()
        .replaceFirstMapped(RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase());
  }

  String _formatTime(DateTime time) {
    return '${time.day}/${time.month}/${time.year} • '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}