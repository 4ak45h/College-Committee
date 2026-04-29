import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/settings_service.dart';

class SystemSettingsScreen extends StatefulWidget {
  const SystemSettingsScreen({super.key});

  @override
  State<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();
}

class _SystemSettingsScreenState
    extends State<SystemSettingsScreen> {

  final SettingsService _settingsService = SettingsService();

  final TextEditingController _institutionController =
  TextEditingController(
    text: 'Bangalore Institute of Technology',
  );

  final TextEditingController _academicYearController =
  TextEditingController(
    text: '2025-2026',
  );

  bool _loading = false;

  String _meetingStatus = "Draft";

  @override
  void dispose() {
    _institutionController.dispose();
    _academicYearController.dispose();
    super.dispose();
  }

  /// SAVE BUTTON
  Future<void> _saveSettings() async {

    setState(() => _loading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Settings updated successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.bg,

      appBar: AppBar(
        title: const Text('System Settings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ================= INSTITUTION =================

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

            /// ================= GOVERNANCE =================

            _sectionTitle('Governance'),

            /// APPROVAL REQUIRED
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('approval_required')
                  .snapshots(),

              builder: (context, snapshot) {

                bool value = true;

                if (snapshot.hasData && snapshot.data!.exists) {
                  value = snapshot.data!['value'] ?? true;
                }

                return _switchTile(
                  title: 'Approval Required',
                  value: value,
                  onChanged: (newValue) async {

                    await _settingsService.updateSetting(
                      "approval_required",
                      newValue,
                    );

                    setState(() {});
                  },
                );
              },
            ),

            /// EVENTS MODULE ENABLED
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('settings')
                  .doc('events_module_enabled')
                  .snapshots(),

              builder: (context, snapshot) {

                bool value = true;

                if (snapshot.hasData && snapshot.data!.exists) {
                  value = snapshot.data!['value'] ?? true;
                }

                return _switchTile(
                  title: 'Enable Events Module',
                  value: value,
                  onChanged: (newValue) async {

                    await _settingsService.updateSetting(
                      "events_module_enabled",
                      newValue,
                    );

                    setState(() {});
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            /// ================= DEFAULT STATUS =================

            _sectionTitle('Default Meeting Status'),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),

              child: DropdownButtonFormField<String>(

                value: _meetingStatus,

                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),

                items: const [

                  DropdownMenuItem(
                    value: "Draft",
                    child: Text("Draft"),
                  ),

                  DropdownMenuItem(
                    value: "Approved",
                    child: Text("Approved"),
                  ),

                  DropdownMenuItem(
                    value: "Archived",
                    child: Text("Archived"),
                  ),
                ],

                onChanged: (value) async {

                  if (value == null) return;

                  setState(() {
                    _meetingStatus = value;
                  });

                  await _settingsService.updateSetting(
                    "default_meeting_status",
                    value,
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            /// ================= SYSTEM =================

            _sectionTitle('System'),

            _infoTile('System Version', 'v1.0.0'),

            _infoTile('Last Backup', 'Today, 02:15 AM'),

            const SizedBox(height: 30),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding:
                  const EdgeInsets.symmetric(vertical: 14),

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

  /// ================= UI COMPONENTS =================

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
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,

        children: [

          Text(label),

          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}