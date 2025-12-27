import 'package:flutter/material.dart';

import '../../features/home/admin/ui/admin_home_screen.dart';
import '../../features/home/leader/ui/leader_home_screen.dart';
import '../../features/home/member/ui/member_home_screen.dart';
import 'user_role.dart';

class RoleRouter {
  static Widget resolve(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return const AdminHomeScreen();
      case UserRole.leader:
        return const LeaderHomeScreen();
      case UserRole.member:
        return const MemberHomeScreen();
    }
  }
}
