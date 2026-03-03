import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/event_service.dart';

class AdminEventsOverviewScreen extends StatelessWidget {
  AdminEventsOverviewScreen({super.key});

  final EventService _eventService = EventService();

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
      body: StreamBuilder<QuerySnapshot>(
        stream: _eventService.getEvents(),
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
            return const Center(child: Text('No events found'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final data = events[index].data() as Map<String, dynamic>;

              // Convert Firestore Timestamp → formatted date
              final Timestamp? timestamp = data['date'];
              final String formattedDate =
              timestamp != null ? _formatDate(timestamp) : 'N/A';

              return _EventCard(
                title: data['title'] ?? 'Untitled Event',
                committee: data['committee'] ?? 'Unknown Committee',
                date: formattedDate,
                time: data['time'] ?? 'N/A',
              );
            },
          );
        },
      ),
    );
  }

  /// Helper: Timestamp → "12 Sep 2026"
  String _formatDate(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
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