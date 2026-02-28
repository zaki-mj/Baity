import 'package:baity/pages/AdminDashboardPage.dart';
import 'package:baity/pages/navigation_shell.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:baity/pages/welcome.dart';
import 'package:baity/pages/DiscoveryPage.dart';

class StartupDecider extends StatefulWidget {
  const StartupDecider({super.key});

  @override
  State<StartupDecider> createState() => _StartupDeciderState();
}

class _StartupDeciderState extends State<StartupDecider> {
  Widget? _nextPage;

  @override
  void initState() {
    super.initState();
    _determineStartPage();
  }

  Future<void> _determineStartPage() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      // Mark as not first run for future launches
      await prefs.setBool('isFirstRun', false);
      setState(() => _nextPage = const WelcomePage());
      return;
    }

    // Example check: FirebaseAuth token
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() => _nextPage = const AdminDashboardPage());
    } else {
      setState(() => _nextPage = const NavigationShell());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_nextPage == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return _nextPage!;
  }
}
