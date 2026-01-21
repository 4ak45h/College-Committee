import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../ui/committee_details_screen.dart';

enum CommitteeStatus { active, inactive }

class CommitteeListCard extends StatelessWidget {
  final String name;
  final String coordinator;
  final CommitteeStatus status;

  const CommitteeListCard({
    super.key,
    required this.name,
    required this.coordinator,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == CommitteeStatus.active;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommitteeDetailsScreen(
              committeeName: name,
            ),
          ),
        );
      },
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS INDICATOR
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),

            // MAIN CONTENT
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
                  const SizedBox(height: 6),
                  Text(
                    'Coordinator: $coordinator',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.muted,
                    ),
                  ),
                ],
              ),
            ),

            // STATUS CHIP
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.green.withOpacity(0.12)
                    : Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.green : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
