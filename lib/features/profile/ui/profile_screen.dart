import 'package:flutter/material.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/profile_option_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF1F2A5A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ProfileHeaderCard(),
            const SizedBox(height: 20),

            /// Info Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  ProfileOptionTile(
                    icon: Icons.email,
                    title: 'chetanhaha@gmail.com',
                  ),
                  Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.phone,
                    title: '+91 420XXXXXXX',
                  ),
                  Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.group,
                    title: 'Committees · 2',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Actions Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: const [
                  ProfileOptionTile(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                  ),
                  Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.lock,
                    title: 'Change Password',
                  ),
                  Divider(height: 1),
                  ProfileOptionTile(
                    icon: Icons.power_settings_new,
                    title: 'Log Out',
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
