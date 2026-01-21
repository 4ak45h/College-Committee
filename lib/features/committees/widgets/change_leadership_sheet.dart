import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ChangeLeadershipSheet extends StatefulWidget {
  const ChangeLeadershipSheet({super.key});

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
                ? () {
                    // Future: persist leadership change
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
