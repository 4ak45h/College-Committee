import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_button.dart';

class EditCommitteeScreen extends StatefulWidget {
  final String committeeName;

  const EditCommitteeScreen({
    super.key,
    required this.committeeName,
  });

  @override
  State<EditCommitteeScreen> createState() =>
      _EditCommitteeScreenState();
}

class _EditCommitteeScreenState extends State<EditCommitteeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  final TextEditingController _descriptionController =
      TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.committeeName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Committee updated successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Edit Committee'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Committee Name',
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
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description (Optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              AppButton(
                label: 'Save Changes',
                loading: _loading,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}