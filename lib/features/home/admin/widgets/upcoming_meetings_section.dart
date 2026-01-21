import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class UpcomingMeetingsSection extends StatefulWidget {
  const UpcomingMeetingsSection({super.key});

  @override
  State<UpcomingMeetingsSection> createState() =>
      _UpcomingMeetingsSectionState();
}

class _UpcomingMeetingsSectionState extends State<UpcomingMeetingsSection> {
  bool _expanded12Sep = false;
  bool _expanded14Sep = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Meetings',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        _DateGroupTile(
          dateLabel: '12 Sep',
          meetingCount: 2,
          expanded: _expanded12Sep,
          onTap: () {
            setState(() {
              _expanded12Sep = !_expanded12Sep;
            });
          },
          children: [
            _MeetingTile(
              title: 'Academic Review Meeting',
              time: '10:00 AM – 11:30 AM',
              committee: 'Academic Review Committee',
            ),
            _MeetingTile(
              title: 'Curriculum Planning',
              time: '12:00 PM – 1:00 PM',
              committee: 'Academic Review Committee',
            ),
          ],
        ),

        const SizedBox(height: 8),

        _DateGroupTile(
          dateLabel: '14 Sep',
          meetingCount: 1,
          expanded: _expanded14Sep,
          onTap: () {
            setState(() {
              _expanded14Sep = !_expanded14Sep;
            });
          },
          children: [
            _MeetingTile(
              title: 'Cultural Fest Planning',
              time: '2:00 PM – 3:00 PM',
              committee: 'Cultural Committee',
            ),
          ],
        ),
      ],
    );
  }
}

/* =========================
   DATE GROUP TILE
   ========================= */

class _DateGroupTile extends StatelessWidget {
  final String dateLabel;
  final int meetingCount;
  final bool expanded;
  final VoidCallback onTap;
  final List<Widget> children;

  const _DateGroupTile({
    required this.dateLabel,
    required this.meetingCount,
    required this.expanded,
    required this.onTap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$dateLabel · $meetingCount meeting${meetingCount > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    expanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
          if (expanded) ...[
            const Divider(height: 1),
            ...children,
          ],
        ],
      ),
    );
  }
}

/* =========================
   MEETING TILE (READ-ONLY)
   ========================= */

class _MeetingTile extends StatelessWidget {
  final String title;
  final String time;
  final String committee;

  const _MeetingTile({
    required this.title,
    required this.time,
    required this.committee,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meeting details view coming soon'),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$time · $committee',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
