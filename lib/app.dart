import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/ui/splash_screen.dart';

class CCMSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),

      // App starts here
      home: SplashScreen(),
    );
  }
}
