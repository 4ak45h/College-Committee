import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class UpcomingMeetingsSection extends StatelessWidget {
  const UpcomingMeetingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK DATA (later from backend)
    final meetingsByDay = {
      '12 Sep': [
        _Meeting('Academic Review Committee', '10:00 AM'),
        _Meeting('Research Council', '2:00 PM'),
      ],
      '14 Sep': [
        _Meeting('Cultural Committee', '2:00 PM'),
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Meetings',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        ...meetingsByDay.entries.map(
          (entry) => _MeetingDayCard(
            date: entry.key,
            meetings: entry.value,
          ),
        ),
      ],
    );
  }
}

class _Meeting {
  final String committee;
  final String time;

  _Meeting(this.committee, this.time);
}

class _MeetingDayCard extends StatefulWidget {
  final String date;
  final List<_Meeting> meetings;

  const _MeetingDayCard({
    required this.date,
    required this.meetings,
  });

  @override
  State<_MeetingDayCard> createState() => _MeetingDayCardState();
}

class _MeetingDayCardState extends State<_MeetingDayCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.meetings.length > 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: hasMultiple
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.date,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hasMultiple
                              ? '${widget.meetings.length} meetings scheduled'
                              : '${widget.meetings.first.committee} · ${widget.meetings.first.time}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hasMultiple)
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppTheme.muted,
                    ),
                ],
              ),
            ),
          ),

          if (_expanded)
            const Divider(height: 1),

          if (_expanded)
            Column(
              children: widget.meetings
                  .map(
                    (m) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 58),
                          Expanded(
                            child: Text(
                              m.committee,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            m.time,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }
}
