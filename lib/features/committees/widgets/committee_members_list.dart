import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CommitteeMembersList extends StatelessWidget {
  const CommitteeMembersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Committee Members',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        _MemberTile(
          name: 'Dr. R. Mehta',
          role: 'Chairperson',
        ),
        _MemberTile(
          name: 'Prof. S. Kumar',
          role: 'Coordinator',
        ),
        _MemberTile(
          name: 'Dr. A. Rao',
          role: 'Member',
        ),
        _MemberTile(
          name: 'Prof. L. Sharma',
          role: 'Member',
        ),
        _MemberTile(
          name: 'Dr. N. Iyer',
          role: 'Member',
        ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  final String name;
  final String role;

  const _MemberTile({
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLeader = role != 'Member';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isLeader ? Icons.star_outline : Icons.person_outline,
            color: isLeader ? AppTheme.primary : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isLeader
                  ? AppTheme.primary.withOpacity(0.12)
                  : Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isLeader ? AppTheme.primary : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
