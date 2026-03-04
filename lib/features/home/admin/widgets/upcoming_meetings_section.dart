import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../services/event_service.dart';

class UpcomingMeetingsSection extends StatefulWidget {
  const UpcomingMeetingsSection({super.key});

  @override
  State<UpcomingMeetingsSection> createState() =>
      _UpcomingMeetingsSectionState();
}

class _UpcomingMeetingsSectionState
    extends State<UpcomingMeetingsSection> {
  final EventService _eventService = EventService();

  /// Track expanded dates
  final Map<String, bool> _expandedDates = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _eventService.getUpcomingMeetings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Failed to load meetings');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No upcoming meetings');
        }

        // 🔁 Group meetings by date
        final Map<String, List<Map<String, dynamic>>> grouped = {};

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final Timestamp ts = data['date'];
          final date = ts.toDate();

          final label =
              '${date.day.toString().padLeft(2, '0')} '
              '${_monthName(date.month)}';

          grouped.putIfAbsent(label, () => []);
          grouped[label]!.add(data);

          _expandedDates.putIfAbsent(label, () => false);
        }

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

            ...grouped.entries.map((entry) {
              final dateLabel = entry.key;
              final meetings = entry.value;
              final expanded = _expandedDates[dateLabel]!;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DateGroupTile(
                  dateLabel: dateLabel,
                  meetingCount: meetings.length,
                  expanded: expanded,
                  onTap: () {
                    setState(() {
                      _expandedDates[dateLabel] = !expanded;
                    });
                  },
                  children: meetings.map((m) {
                    return _MeetingTile(
                      title: m['title'],
                      time: m['time'],
                      committee: m['committee'],
                    );
                  }).toList(),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
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
                    expanded ? Icons.expand_less : Icons.expand_more,
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
   MEETING TILE
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
    return Padding(
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
    );
  }
}