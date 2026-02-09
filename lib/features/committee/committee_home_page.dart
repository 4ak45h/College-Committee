import 'package:flutter/material.dart';
import 'package:ccms_app/features/committee/tasks/tasks_page.dart';
import 'package:ccms_app/features/committee/members/members_list_page.dart';
import 'package:ccms_app/features/committee/notices/notices_page.dart';
import 'package:ccms_app/features/committee/meetings/meetings_page.dart';
import 'package:ccms_app/features/committee/profile/profile_page.dart';


class CommitteeHomePage extends StatelessWidget {
  const CommitteeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Committee Home",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Title
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Here’s an overview of your committee tasks and members.",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 20),

              // -------- DASHBOARD CARDS --------
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Members",
                      value: "24",
                      icon: Icons.group,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard(
                      title: "Pending Tasks",
                      value: "08",
                      icon: Icons.pending_actions,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      title: "Meetings",
                      value: "03",
                      icon: Icons.calendar_month,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _infoCard(
                      title: "Notices",
                      value: "12",
                      icon: Icons.notifications,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),

              _quickAction(
  icon: Icons.task,
  label: "View All Tasks",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TasksPage()),
    );
  },
),

              _quickAction(
  icon: Icons.group,
  label: "Members List",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MembersListPage(),
      ),
    );
  },
),

              _quickAction(
  icon: Icons.message,
  label: "Committee Notices",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NoticesPage()),
    );
  },
),
_quickAction(
  icon: Icons.calendar_month,
  label: "Meetings",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MeetingsPage()),
    );
  },
),
_quickAction(
  icon: Icons.person,
  label: "Committee Profile",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CommitteeProfilePage(),
      ),
    );
  },
),

            ],
          ),
        ),
      ),
    );
  }

  // ---------------- CARDS ----------------
  Widget _infoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: Colors.blue),
          const SizedBox(height: 8),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ----------- QUICK ACTION BUTTONS -----------
  Widget _quickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 26, color: Colors.blue),
              const SizedBox(width: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
