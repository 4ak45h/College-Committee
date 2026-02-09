import 'package:flutter/material.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({super.key});

  // ------- DEMO DATA -------
  final List<Map<String, String>> demoNotices = const [
    {
      "title": "Monthly Meeting Reminder",
      "date": "28 Dec 2025",
      "description":
          "A reminder that the committee monthly meeting will be held on 29 Dec 2025 at 10:00 AM in the auditorium."
    },
    {
      "title": "Cleanliness Drive",
      "date": "24 Dec 2025",
      "description":
          "All committee members must participate in the annual cleanliness drive scheduled next week."
    },
    {
      "title": "Budget Submission Deadline",
      "date": "20 Dec 2025",
      "description":
          "Submit all department budget reports by 22 Dec 2025 without fail."
    },
    {
      "title": "Holiday Notice",
      "date": "18 Dec 2025",
      "description":
          "The institution will remain closed on 25 Dec 2025 in view of Christmas celebrations."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Committee Notices",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoNotices.length,
        itemBuilder: (context, index) {
          final notice = demoNotices[index];

          return GestureDetector(
            onTap: () {
              // Optional: Add detailed page later
            },
            child: Container(
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
                  // Notice Title
                  Text(
                    notice["title"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_month,
                          size: 16, color: Colors.blue),
                      const SizedBox(width: 6),
                      Text(
                        notice["date"]!,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black54),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Description
                  Text(
                    notice["description"]!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
