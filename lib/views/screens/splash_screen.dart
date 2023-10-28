import 'dart:async';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    loadUser().then((_) {
      timer = Timer(duration, () {
        Navigator.of(context).pushReplacementNamed("/status");
      });
    });
  }

  Future<void> loadUser() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserFromPrefs();
    await Provider.of<UserProvider>(context, listen: false)
        .loadProfileFromPrefs();
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
      body: Container(
        decoration: DecorationBoxes.decorationBackground(),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: screenSize.width * 0.7,
          ),
        ),
      ),
    );
  }
}
