import 'package:flutter/material.dart';

class MeetingsPage extends StatelessWidget {
  const MeetingsPage({super.key});

  // -------- DEMO MEETINGS DATA --------
  final List<Map<String, String>> demoMeetings = const [
    {
      "title": "Monthly Committee Meeting",
      "date": "05 Jan 2026",
      "time": "10:00 AM",
      "venue": "Main Conference Hall",
      "details":
          "Agenda includes event planning, member updates, and discussion on new proposals."
    },
    {
      "title": "Cleanliness Drive Planning",
      "date": "28 Dec 2025",
      "time": "2:00 PM",
      "venue": "Room 203",
      "details":
          "Planning session for the annual cleanliness drive. All members must attend."
    },
    {
      "title": "Budget Review Meeting",
      "date": "22 Dec 2025",
      "time": "11:30 AM",
      "venue": "Finance Office",
      "details":
          "Discussion on budget allocation for upcoming events and department needs."
    },
    {
      "title": "New Members Orientation",
      "date": "18 Dec 2025",
      "time": "3:00 PM",
      "venue": "Auditorium",
      "details":
          "Orientation for newly added members. Attendance is mandatory."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Meeting Schedule",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoMeetings.length,
        itemBuilder: (context, index) {
          final meet = demoMeetings[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meeting Title
                Text(
                  meet["title"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // DATE & TIME
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.blue),
                    const SizedBox(width: 6),
                    Text(
                      meet["date"]!,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.access_time,
                        size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      meet["time"]!,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // VENUE
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.red),
                    const SizedBox(width: 6),
                    Text(
                      meet["venue"]!,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // DETAILS
                Text(
                  meet["details"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
