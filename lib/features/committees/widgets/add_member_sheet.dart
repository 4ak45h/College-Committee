import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMemberSheet extends StatefulWidget {
  final String committeeId;

  const AddMemberSheet({
    super.key,
    required this.committeeId,
  });

  @override
  State<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<AddMemberSheet> {
  String? _selectedFaculty;

  Future<void> _addMember() async {
    if (_selectedFaculty == null) return;

    await FirebaseFirestore.instance.collection('committee_members').add({
      'committeeId': widget.committeeId,
      'facultyName': _selectedFaculty,
      'role': 'Member',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Member added successfully'),
      ),
    );
  }

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
        children: [
          const Text(
            'Add Member',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('faculty')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }

              final facultyDocs = snapshot.data!.docs;

              return DropdownButtonFormField<String>(
                value: _selectedFaculty,
                items: facultyDocs
                    .map<DropdownMenuItem<String>>((doc) {
                  final data =
                  doc.data() as Map<String, dynamic>;
                  final name = data['name'] ?? '';

                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFaculty = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Faculty',
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _addMember,
            child: const Text('Add Member'),
          ),
        ],
      ),
    );
  }
}