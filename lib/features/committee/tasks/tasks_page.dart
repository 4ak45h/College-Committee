import 'package:flutter/material.dart';
import 'add_task_page.dart';
import 'task_details_page.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Committee Tasks",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- SEARCH BAR ----------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search tasks...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.blue),
                ),
              ),
            ),
          ),

          // ---------------- TASK LIST ----------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: demoTasks.length,
              itemBuilder: (context, index) {
                final task = demoTasks[index];

                final String title = task["title"] ?? "Untitled Task";
                final String status = task["status"] ?? "Pending";
                final String date = task["date"] ?? "No date";
                final bool isCompleted = status == "Completed";

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
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
                    child: Row(
                      children: [
                        // Status dot
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green : Colors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Task details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Status label
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.green.shade100
                                : Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 12,
                              color: isCompleted ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(
          title: title,
          status: status,
          date: date,
          description:
              "This task is related to committee activity. You can expand this later.",
        ),
      ),
    );
  },
  icon: const Icon(Icons.chevron_right),
)

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ---------------- FAB ----------------
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
      ),
    );
  }
}

// ---------------- DEMO DATA ----------------
final List<Map<String, String>> demoTasks = [
  {
    "title": "Prepare Meeting Agenda",
    "status": "Pending",
    "date": "Due: 29 Dec 2025",
  },
  {
    "title": "Update Committee Members List",
    "status": "Completed",
    "date": "Completed: 24 Dec 2025",
  },
  {
    "title": "Organize Cleanliness Drive",
    "status": "Pending",
    "date": "Due: 03 Jan 2026",
  },
  {
    "title": "Send Monthly Notices",
    "status": "Completed",
    "date": "Completed: 20 Dec 2025",
  },
  {
    "title": "Budget Report Submission",
    "status": "Pending",
    "date": "Due: 05 Jan 2026",
  },
];
