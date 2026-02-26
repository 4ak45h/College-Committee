import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'change_leadership_sheet.dart';
import 'committee_list_card.dart';

class CommitteeAdminOverview extends StatelessWidget {
  final CommitteeStatus status;

  const CommitteeAdminOverview({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == CommitteeStatus.active;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Committee Overview',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          _InfoRow(
            label: 'Status',
            value: isActive ? 'Active' : 'Inactive',
          ),
          const _InfoRow(label: 'Chairperson', value: 'Dr. R. Mehta'),
          const _InfoRow(label: 'Coordinator', value: 'Prof. S. Kumar'),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => const ChangeLeadershipSheet(),
                  );
                },
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Change Leadership'),
              ),
              const SizedBox(width: 8),

              if (isActive)
                TextButton.icon(
                  onPressed: () {
                    _showDeactivateDialog(context);
                  },
                  icon: const Icon(
                    Icons.pause_circle_outline,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Deactivate',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else
                TextButton.icon(
                  onPressed: () {
                    _showReactivateDialog(context);
                  },
                  icon: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.green,
                  ),
                  label: const Text(
                    'Reactivate',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Deactivate Committee'),
        content: const Text(
          'This will temporarily disable the committee.\n\nYou can reactivate it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Committee deactivated'),
                ),
              );
            },
            child: const Text('Deactivate'),
          ),
        ],
      ),
    );
  }

  void _showReactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reactivate Committee'),
        content: const Text(
          'This will restore committee operations and member access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Committee reactivated'),
                ),
              );
            },
            child: const Text('Reactivate'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}