import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ChangeLeadershipSheet extends StatefulWidget {
  final String committeeId;

  const ChangeLeadershipSheet({
    super.key,
    required this.committeeId,
  });

  @override
  State<ChangeLeadershipSheet> createState() =>
      _ChangeLeadershipSheetState();
}

class _ChangeLeadershipSheetState extends State<ChangeLeadershipSheet> {
  String? _selectedChairperson;
  String? _selectedCoordinator;

  final List<String> _faculty = [
    'Dr. R. Mehta',
    'Prof. S. Kumar',
    'Dr. A. Rao',
    'Prof. L. Sharma',
    'Dr. N. Iyer',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 16),

          _dropdown(
            label: 'Chairperson',
            value: _selectedChairperson,
            onChanged: (value) {
              setState(() => _selectedChairperson = value);
            },
          ),
          const SizedBox(height: 12),

          _dropdown(
            label: 'Coordinator',
            value: _selectedCoordinator,
            onChanged: (value) {
              setState(() => _selectedCoordinator = value);
            },
          ),
          const SizedBox(height: 20),

          _actions(context),
        ],
      ),
    );
  }

  Widget _header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Change Leadership',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Select new leadership for this committee',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: _faculty
              .map(
                (name) => DropdownMenuItem(
                  value: name,
                  child: Text(name),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    final bool canSubmit =
        _selectedChairperson != null && _selectedCoordinator != null;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: canSubmit
                ? () async {
              final committeeId = widget.committeeId;
              final newChair = _selectedChairperson;
              final newCoordinator = _selectedCoordinator;

              /// STEP 1 — Update committees
              await FirebaseFirestore.instance
                  .collection('committees')
                  .doc(committeeId)
                  .update({
                'chairperson': newChair,
                'coordinator': newCoordinator,
                'updatedAt': FieldValue.serverTimestamp(),
              });

              /// STEP 2 — Get existing members
              final membersSnapshot = await FirebaseFirestore.instance
                  .collection('committee_members')
                  .where('committeeId', isEqualTo: committeeId)
                  .get();

              List<String> existingMembers = [];

              for (var doc in membersSnapshot.docs) {
                final data = doc.data();
                final facultyName = data['facultyName'];
                existingMembers.add(facultyName);

                String role = 'Member';

                if (facultyName == newChair) {
                  role = 'Chairperson';
                } else if (facultyName == newCoordinator) {
                  role = 'Coordinator';
                }

                await FirebaseFirestore.instance
                    .collection('committee_members')
                    .doc(doc.id)
                    .update({'role': role});
              }

              /// STEP 3 — Add new Chair if not member
              if (!existingMembers.contains(newChair)) {
                await FirebaseFirestore.instance
                    .collection('committee_members')
                    .add({
                  'committeeId': committeeId,
                  'facultyName': newChair,
                  'role': 'Chairperson',
                  'joinedAt': FieldValue.serverTimestamp(),
                });
              }

              /// STEP 4 — Add new Coordinator if not member
              if (!existingMembers.contains(newCoordinator)) {
                await FirebaseFirestore.instance
                    .collection('committee_members')
                    .add({
                  'committeeId': committeeId,
                  'facultyName': newCoordinator,
                  'role': 'Coordinator',
                  'joinedAt': FieldValue.serverTimestamp(),
                });
              }

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Leadership updated successfully'),
                ),
              );
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('Confirm'),
          ),
        ),
      ],
    );
  }
}
