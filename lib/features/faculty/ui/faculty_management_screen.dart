import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FacultyManagementScreen extends StatelessWidget {
  const FacultyManagementScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _FacultyCard(
            name: 'Dr. S. Kumar',
            designation: 'Professor',
            role: 'Committee Coordinator',
          ),
          _FacultyCard(
            name: 'Prof. R. Mehta',
            designation: 'Associate Professor',
            role: 'Committee Chairperson',
          ),
          _FacultyCard(
            name: 'Dr. A. Rao',
            designation: 'Assistant Professor',
            role: 'Committee Member',
          ),
        ],
      ),
    );
  }
}

/* =========================
   FACULTY CARD
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
