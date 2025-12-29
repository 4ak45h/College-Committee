import 'package:flutter/material.dart';

class MembersListPage extends StatelessWidget {
  const MembersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Members List",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
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
                  hintText: "Search members...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.blue),
                ),
              ),
            ),
          ),

          // ---------------- MEMBER LIST ----------------
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: demoMembers.length,
              itemBuilder: (context, index) {
                final member = demoMembers[index];

                final String name = member["name"] ?? "Unknown";
                final String role = member["role"] ?? "Member";

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

                        // ------------ Avatar with First Letter -------------
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            name.isNotEmpty ? name[0] : "?",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // ------------ Member Details ------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                role,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- DEMO MEMBER DATA ----------------
final List<Map<String, String>> demoMembers = [
  {"name": "Ayesha Khan", "role": "President"},
  {"name": "Rohit Raj", "role": "Vice President"},
  {"name": "Priya Sharma", "role": "Secretary"},
  {"name": "Aman Verma", "role": "Treasurer"},
  {"name": "Devika Rao", "role": "Member"},
  {"name": "Vignesh P", "role": "Member"},
  {"name": "Farah Sheikh", "role": "Member"},
  {"name": "Siddharth Rao", "role": "Member"},
];
