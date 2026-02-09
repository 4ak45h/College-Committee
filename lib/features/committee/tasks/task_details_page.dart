import 'package:flutter/material.dart';

class TaskDetailsPage extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final String description;

  const TaskDetailsPage({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status == "Completed";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.3,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------- TASK TITLE --------
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            // -------- STATUS + DATE CARD --------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: Column(
                children: [
                  // STATUS
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        "Status: ",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isCompleted ? Colors.green : Colors.orange,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // DATE
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        "Due Date: ",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        date,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // -------- DESCRIPTION --------
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // -------- ACTION BUTTON --------
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isCompleted
                            ? "This task is already completed."
                            : "Marked as Completed!",
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? Colors.grey : Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isCompleted ? "Completed" : "Mark as Completed",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
