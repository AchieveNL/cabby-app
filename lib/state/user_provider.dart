import 'package:cabby/models/profile.dart';
import 'package:cabby/models/user.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  UserProfileModel? _profile;

  UserModel? get user => _user;
  UserProfileModel? get userProfile => _profile;

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
      _user = UserModel.fromJsonWithInt(json.decode(userData!));
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

  void setUserProfile(UserProfileModel profile) {
    _profile = profile;
    saveProfileToPrefs(profile);
    notifyListeners();
  }

  Future<void> saveProfileToPrefs(UserProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = json.encode(profile.toJson());
    prefs.setString('userProfile', profileData);
  }

  Future<void> loadProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userProfile')) {
      final profileData = prefs.getString('userProfile');
      _profile = UserProfileModel.fromJson(json.decode(profileData!));
      notifyListeners();
    }
  }

  void clearUserProfile() {
    _profile = null;
    removeProfileFromPrefs();
    notifyListeners();
  }

  Future<void> removeProfileFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userProfile');
  }
}
