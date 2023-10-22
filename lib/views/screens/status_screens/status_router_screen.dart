import 'package:cabby/models/user.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusRouterScreen extends StatelessWidget {
  const StatusRouterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: unnecessary_null_comparison
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("/login");
      } else {
        switch (user.status) {
          case UserStatus.REQUIRE_REGISTRATION_FEE:
            Navigator.of(context).pushReplacementNamed("/pay-deposit");
            break;
          case UserStatus.PENDING:
            Navigator.of(context).pushReplacementNamed("/verification");
            break;
          case UserStatus.BLOCKED:
            Navigator.of(context).pushReplacementNamed("/blocked");
            break;
          case UserStatus.REJECTED:
            Navigator.of(context).pushReplacementNamed("/rejected");
            break;
          case UserStatus.ACTIVE:
          case UserStatus.APPROVED:
            Navigator.of(context).pushReplacementNamed("/home");
            break;
          default:
            _showErrorDialog(context);
            break;
        }
      }
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
