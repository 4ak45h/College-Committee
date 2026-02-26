import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState extends State<SystemSettingsScreen> {
  final TextEditingController _institutionController =
      TextEditingController(text: 'Bangalore Institute of Technology');

  final TextEditingController _academicYearController =
      TextEditingController(text: '2025-2026');

  bool _allowMultipleLeaders = false;
  bool _requireCommitteeApproval = true;
  bool _emailNotifications = true;

  bool _loading = false;

  Future<void> _saveSettings() async {
    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _academicYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('System Settings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _sectionTitle('Institutional'),

            _textField(
              label: 'Institution Name',
              controller: _institutionController,
            ),

            const SizedBox(height: 14),

            _textField(
              label: 'Academic Year',
              controller: _academicYearController,
            ),

            const SizedBox(height: 24),

            _sectionTitle('Governance'),

            _switchTile(
              title: 'Allow Multiple Leaders',
              value: _allowMultipleLeaders,
              onChanged: (value) =>
                  setState(() => _allowMultipleLeaders = value),
            ),

            _switchTile(
              title: 'Require Approval for Committee Creation',
              value: _requireCommitteeApproval,
              onChanged: (value) =>
                  setState(() => _requireCommitteeApproval = value),
            ),

            const SizedBox(height: 24),

            _sectionTitle('Notifications'),

            _switchTile(
              title: 'Enable Email Notifications',
              value: _emailNotifications,
              onChanged: (value) =>
                  setState(() => _emailNotifications = value),
            ),

            const SizedBox(height: 24),

            _sectionTitle('System'),

            _infoTile('System Version', 'v1.0.0'),
            _infoTile('Last Backup', 'Today, 02:15 AM'),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _loading ? null : _saveSettings,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* =========================
     COMPONENTS
     ========================= */

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _textField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        value: value,
        activeColor: AppTheme.primary,
        onChanged: onChanged,
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}