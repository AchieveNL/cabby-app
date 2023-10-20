import 'package:cabby/models/user.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel get user => _user!;

  void setUser(UserModel user) {
    _user = user;
    saveUserToPrefs(user);
    notifyListeners();
  }

  Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(user.toJson());
    prefs.setString('user', userData);
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      final userData = prefs.getString('user');
      _user = UserModel.fromJson(json.decode(userData!));
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    removeUserFromPrefs();
    notifyListeners();
  }

  Future<void> removeUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
  }
}


