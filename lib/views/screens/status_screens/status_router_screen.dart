import 'package:cabby/config/utils.dart';
import 'package:cabby/services/supabase.dart';
import 'package:cabby/state/app_provider.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> updateTokenIfNeeded(BuildContext context) async {
  final appProvider = Provider.of<AppProvider>(context, listen: false);
  String? newToken = await FirebaseMessaging.instance.getToken();
  String? oldToken = await appProvider.getLocalToken();
  String? userId = Provider.of<UserProvider>(context, listen: false).user?.id;

  logger('newToken: $newToken, oldToken: $oldToken, userId: $userId');

  if (newToken != null && userId != null) {
    logger("Saving new token to database");
    saveTokenToDatabase(newToken, userId);
    await appProvider.saveTokenLocally(newToken);
  }
}

class StatusRouterScreen extends StatelessWidget {
  const StatusRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final userProfile = userProvider.userProfile;
        logger(
            "Saved User: ${user?.toJson()} and user profile: ${userProfile?.toJson()}");
        if (userProfile == null) {
          return _navigateToScreen(context, "/login");
        } else {
          updateTokenIfNeeded(context);
          switch (userProfile.status) {
            case "REQUIRE_REGISTRATION_FEE":
              return _navigateToScreen(context, "/pay-deposit");
            case "PENDING":
              return _navigateToScreen(context, "/verification");
            case "BLOCKED":
              return _navigateToScreen(context, "/blocked");
            case "REJECTED":
              return _navigateToScreen(context, "/rejected");
            case "ACTIVE":
            case "APPROVED":
              return _navigateToScreen(context, "/home");
            default:
              _showErrorDialog(context);
              return const SizedBox.shrink();
          }
        }
      },
    );
  }

  Widget _navigateToScreen(BuildContext context, String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(route);
    });
    return const SizedBox.shrink();
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fout'),
        content: const Text(
            'Er is een onverwachte fout opgetreden.Probeer het later opnieuw.'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}
