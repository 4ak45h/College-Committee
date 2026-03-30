import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../services/committee_service.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class CreateCommitteeScreen extends StatefulWidget {
  const CreateCommitteeScreen({super.key});

  @override
  State<CreateCommitteeScreen> createState() =>
      _CreateCommitteeScreenState();
}

class _CreateCommitteeScreenState extends State<CreateCommitteeScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  final CommitteeService _committeeService = CommitteeService();

  String? _selectedChair;
  String? _selectedCoordinator;

  bool _loading = false;

  final List<String> _facultyList = [
    'Dr. R. Mehta',
    'Prof. S. Kumar',
    'Dr. A. Rao',
    'Prof. L. Sharma',
    'Dr. N. Iyer',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createCommittee() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedChair == _selectedCoordinator) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Chairperson and Coordinator cannot be the same person'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      /// Create Committee
      final committeeRef =
      await FirebaseFirestore.instance.collection('committees').add({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'chairperson': _selectedChair,
        'coordinator': _selectedCoordinator,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final committeeId = committeeRef.id;

      /// Add Chairperson to committee_members
      await FirebaseFirestore.instance
          .collection('committee_members')
          .add({
        'committeeId': committeeId,
        'facultyName': _selectedChair,
        'role': 'Chairperson',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      /// Add Coordinator to committee_members
      await FirebaseFirestore.instance
          .collection('committee_members')
          .add({
        'committeeId': committeeId,
        'facultyName': _selectedCoordinator,
        'role': 'Coordinator',
        'joinedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Committee created successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }

    setState(() => _loading = false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Create Committee'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Committee Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Committee name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Chairperson',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _buildDropdown(
                value: _selectedChair,
                onChanged: (value) {
                  setState(() => _selectedChair = value);
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Coordinator',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              _buildDropdown(
                value: _selectedCoordinator,
                onChanged: (value) {
                  setState(() => _selectedCoordinator = value);
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Description (Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              AppButton(
                label: 'Create Committee',
                loading: _loading,
                onPressed: _createCommittee,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: _facultyList
          .map(
            (faculty) => DropdownMenuItem(
              value: faculty,
              child: Text(faculty),
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
      validator: (value) {
        if (value == null) {
          return 'Selection required';
        }
        return null;
      },
    );
  }
}