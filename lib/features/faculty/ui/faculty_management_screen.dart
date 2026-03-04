import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/faculty_service.dart';

class FacultyManagementScreen extends StatelessWidget {
  FacultyManagementScreen({super.key});

  // 🔹 Service instance
  final FacultyService _facultyService = FacultyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Faculty Management'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      // 🔹 StreamBuilder replacing hardcoded data
      body: StreamBuilder(
        stream: _facultyService.getFaculty(),
        builder: (context, snapshot) {

          // 🔄 Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ Error state
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // 📭 Empty state
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No faculty found'));
          }

          final facultyList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: facultyList.length,
            itemBuilder: (context, index) {
              final data =
              facultyList[index].data() as Map<String, dynamic>;

              return _FacultyCard(
                name: data['name'] ?? 'Unknown',
                designation: data['designation'] ?? 'N/A',
                role: data['role'] ?? 'Member',
              );
            },
          );
        },
      ),
    );
  }
}

/* =========================
   FACULTY CARD (UNCHANGED)
   ========================= */

class _FacultyCard extends StatelessWidget {
  final String name;
  final String designation;
  final String role;

  const _FacultyCard({
    required this.name,
    required this.designation,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.person_outline,
            color: AppTheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  designation,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Text(
            role,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}