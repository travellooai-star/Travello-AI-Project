import 'package:flight_app/screens/home/unified_home_screen.dart';
import 'package:flight_app/screens/intro/intro_screen.dart';
import 'package:flight_app/ui/layouts/general_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flight_app/utils/auth_service.dart';
import 'package:flight_app/screens/auth/welcome.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:get/route_manager.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final String _key = 'finishedIntro';
  bool _isFinishedIntro = false;
  bool _isLoggedIn = false;
  bool _isGuestMode = false;
  bool _isLoading = true;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _checkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final finishedIntro = prefs.getBool(_key) ?? false;
    final loggedIn = await AuthService.isLoggedIn();
    final guestMode = await AuthService.isGuestMode();

    setState(() {
      _isFinishedIntro = finishedIntro;
      _isLoggedIn = loggedIn;
      _isGuestMode = guestMode;
      _isLoading = false;
    });
  }

  _saveIntroStatus() async {
    SharedPreferences pref = await _prefs;
    await pref.setBool(_key, true);
    // Industry pattern: after intro → home as guest (no forced login)
    await AuthService.enableGuestMode();
    Get.offAllNamed('/home-hub');
  }

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking status
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If logged in OR in guest mode, go to unified home
    if (_isLoggedIn || _isGuestMode) {
      return const UnifiedHomeScreen();
    }

    // If finished intro but not logged in, go to welcome
    if (_isFinishedIntro) {
      return const GeneralLayout(content: Welcome());
    }

    // Otherwise show intro
    return IntroScreen(saveIntroStatus: () {
      _saveIntroStatus();
    });
  }
}
