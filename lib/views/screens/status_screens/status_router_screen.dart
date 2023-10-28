import 'package:cabby/config/utils.dart';
import 'package:cabby/models/user.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusRouterScreen extends StatelessWidget {
  const StatusRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        logger("Saved User: $user");
        if (user == null) {
          return _navigateToScreen(context, "/login");
        } else {
          switch (user.status) {
            case UserStatus.REQUIRE_REGISTRATION_FEE:
              return _navigateToScreen(context, "/pay-deposit");
            case UserStatus.PENDING:
              return _navigateToScreen(context, "/verification");
            case UserStatus.BLOCKED:
              return _navigateToScreen(context, "/blocked");
            case UserStatus.REJECTED:
              return _navigateToScreen(context, "/rejected");
            case UserStatus.ACTIVE:
            case UserStatus.APPROVED:
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
        title: const Text('Error'),
        content:
            const Text('An unexpected error occurred. Please try again later.'),
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
