import 'package:cabby/config/utils.dart';
import 'package:cabby/models/profile.dart';
import 'package:cabby/models/user.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cabby/services/profile_service.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthService {
  final BuildContext context;

  AuthService(this.context);

  Future<void> initializeUser(UserModel user) async {
    logger('Initializing user: ${user.toJson()}');

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.setUser(user);

    logger('User set to user provider');

    ProfileService profileService = ProfileService();

    try {
      UserProfileModel userProfile = await profileService.getCurrentProfile();
      logger(
          'Received user profile: ${userProfile.toJson()}'); // log the user profile object
      userProvider.setUserProfile(userProfile);
      logger(
          'User profile set to user provider'); // Confirm that the user profile has been set
    } catch (e) {
      logger(
          'Error while getting user profile: $e'); // Log any error while getting the user profile
      signOut();
    }
  }

  void deleteAccount() async {
    await UserService().deleteUser();
    AuthService(context).signOut();
  }

  void signOut() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    userProvider.clearUser();
    userProvider.clearUserProfile();

    ApiService.sharedCookieJar.deleteAll();

    Navigator.of(context).pushReplacementNamed('/login');
  }
}
