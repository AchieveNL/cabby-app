import 'dart:async';

import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  late Duration duration;
  late Timer timer;
  String routeName = "/onboarding";

  @override
  void initState() {
    super.initState();

    duration = const Duration(seconds: 3);
    _decideRoute().then((_) {
      timer = Timer(duration, () {
        Navigator.of(context).pushReplacementNamed(routeName);
      });
    });
  }

  Future<void> _decideRoute() async {
    final sp = await prefs;
    if (sp.containsKey('user')) {
      setState(() {
        routeName = "/home";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset('assets/logo.png', width: screenSize.width * 0.7),
      ),
    );
  }
}
