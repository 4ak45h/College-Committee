import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/add_member_sheet.dart';

class CommitteeMembersList extends StatelessWidget {
  final String committeeId;

  const CommitteeMembersList({
    super.key,
    required this.committeeId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Committee Members',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add_alt_1),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddMemberSheet(
                    committeeId: committeeId,
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('committee_members')
              .where('committeeId', isEqualTo: committeeId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No members found');
            }

            final members = snapshot.data!.docs;

            return Column(
              children: members.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return _MemberTile(
                  name: data['facultyName'] ?? '',
                  role: data['role'] ?? '',
                  docId: doc.id,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _MemberTile extends StatelessWidget {
  final String name;
  final String role;
  final String docId;

  const _MemberTile({
    required this.name,
    required this.role,
    required this.docId,
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
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              if (role == 'Chairperson' || role == 'Coordinator') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Cannot remove Chairperson or Coordinator. Change leadership first.',
                    ),
                  ),
                );
                return;
              }

              await FirebaseFirestore.instance
                  .collection('committee_members')
                  .doc(docId)
                  .delete();
            },
          ),
        ],
      ),
    );
  }
}
