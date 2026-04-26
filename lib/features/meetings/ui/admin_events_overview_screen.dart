import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/theme/app_theme.dart';
import '../../../services/event_service.dart';

class AdminEventsOverviewScreen extends StatefulWidget {
  const AdminEventsOverviewScreen({super.key});

  @override
  State<AdminEventsOverviewScreen> createState() =>
      _AdminEventsOverviewScreenState();
}

class _AdminEventsOverviewScreenState
    extends State<AdminEventsOverviewScreen> {
  final EventService _eventService = EventService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCommittee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('Events & Meetings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [

          /// CREATE BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                _showCreateEventDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Create Event'),
            ),
          ),

          /// EVENTS LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _eventService.getEvents(),
              builder: (context, snapshot) {

                /// 🔄 LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// ❌ ERROR (IMPORTANT FIX)
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error loading events'),
                  );
                }

                /// 📭 EMPTY
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No events found'));
                }

                final events = snapshot.data!.docs;

                /// ✅ LOCAL SORT (LATEST FIRST)
                events.sort((a, b) {
                  final aDate = (a['date'] as Timestamp?)?.toDate() ?? DateTime(2000);
                  final bDate = (b['date'] as Timestamp?)?.toDate() ?? DateTime(2000);
                  return bDate.compareTo(aDate);
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final data =
                    events[index].data() as Map<String, dynamic>;

                    /// SAFE DATE
                    String formattedDate = 'N/A';
                    if (data['date'] is Timestamp) {
                      formattedDate = _formatDate(data['date']);
                    }

                    /// SAFE TIME
                    String timeValue = 'N/A';
                    if (data['time'] is String) {
                      timeValue = data['time'];
                    }

                    return _EventCard(
                      title: data['title'] ?? 'Untitled Event',
                      committee: data['committee'] ?? 'Unknown',
                      date: formattedDate,
                      time: timeValue,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CREATE EVENT DIALOG =================
  void _showCreateEventDialog(BuildContext context) {

    /// RESET FORM (IMPORTANT)
    _titleController.clear();
    _venueController.clear();
    _selectedCommittee = null;
    _selectedDate = null;
    _selectedTime = null;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [

                /// TITLE
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),

                const SizedBox(height: 10),

                /// COMMITTEE DROPDOWN
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('committees')
                      .snapshots(),
                  builder: (context, snapshot) {

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return const Text('No committees found');
                    }

                    final committees = snapshot.data!.docs;

                    return DropdownButtonFormField<String>(
                      value: _selectedCommittee,
                      hint: const Text("Select Committee"),
                      items: committees.map((doc) {
                        final data =
                        doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: data['name'],
                          child: Text(data['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCommittee = value;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 10),

                /// VENUE
                TextField(
                  controller: _venueController,
                  decoration: const InputDecoration(labelText: 'Venue'),
                ),

                const SizedBox(height: 10),

                /// DATE PICKER
                TextFormField(
                  readOnly: true,
                  decoration:
                  const InputDecoration(labelText: "Select Date"),
                  controller: TextEditingController(
                    text: _selectedDate == null
                        ? ''
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),

                const SizedBox(height: 10),

                /// TIME PICKER
                TextFormField(
                  readOnly: true,
                  decoration:
                  const InputDecoration(labelText: "Select Time"),
                  controller: TextEditingController(
                    text: _selectedTime == null
                        ? ''
                        : _selectedTime!.format(context),
                  ),
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          /// ACTIONS
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () async {

                /// VALIDATION
                if (_selectedCommittee == null ||
                    _selectedDate == null ||
                    _selectedTime == null ||
                    _titleController.text.isEmpty ||
                    _venueController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Please fill all fields")),
                  );
                  return;
                }

                /// CREATE EVENT
                await _eventService.createEvent({
                  'title': _titleController.text,
                  'committee': _selectedCommittee,
                  'committeeName': _selectedCommittee,
                  'committeeId': 'AUTO',
                  'date': Timestamp.fromDate(_selectedDate!),
                  'time': _selectedTime!.format(context),
                  'venue': _venueController.text,
                  'type': 'MEETING',
                });

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  /// DATE FORMAT
  String _formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun',
      'Jul','Aug','Sep','Oct','Nov','Dec'
    ];

    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }
}

/// ================= EVENT CARD =================

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
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(committee,
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16),
              const SizedBox(width: 6),
              Text(date),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_outlined, size: 16),
              const SizedBox(width: 6),
              Text(time),
            ],
          ),
        ],
      ),
    );
  }
}