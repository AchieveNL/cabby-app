import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  bool _hasSeenOnboarding = false;

  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> checkSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    notifyListeners();
  }

  Future<void> markOnboardingAsSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    _hasSeenOnboarding = true;
    notifyListeners();
  }
}
