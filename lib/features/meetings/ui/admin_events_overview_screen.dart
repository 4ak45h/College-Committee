import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AdminEventsOverviewScreen extends StatelessWidget {
  const AdminEventsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Events & Meetings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _EventCard(
            title: 'Academic Review Meeting',
            committee: 'Academic Review Committee',
            date: '12 Sep 2026',
            time: '10:00 AM – 11:30 AM',
          ),
          _EventCard(
            title: 'Cultural Fest Planning',
            committee: 'Cultural Committee',
            date: '14 Sep 2026',
            time: '2:00 PM – 3:00 PM',
          ),
          _EventCard(
            title: 'Disciplinary Review',
            committee: 'Disciplinary Committee',
            date: '18 Sep 2026',
            time: '11:00 AM – 12:00 PM',
          ),
        ],
      ),
    );
  }
}

/* =========================
   EVENT CARD (READ-ONLY)
   ========================= */

class _EventCard extends StatelessWidget {
  final String title;
  final String committee;
  final String date;
  final String time;

  const _EventCard({
    required this.title,
    required this.committee,
    required this.date,
    required this.time,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            committee,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.access_time_outlined,
                size: 16,
                color: Colors.black54,
              ),
              const SizedBox(width: 6),
              Text(
                time,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
