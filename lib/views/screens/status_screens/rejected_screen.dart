import 'package:cabby/config/theme.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              child: Center(
                child: Icon(Icons.cancel,
                    size: 150,
                    color: Colors
                        .red), // Using Flutter's built-in Icon for rejected case.
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Je account is afgewezen",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppColors.blackColor,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Helaas is je accountaanvraag afgewezen. Neem contact op met de beheerder voor meer informatie.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF575757),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SecondaryButton(
                width: size.width * 0.9,
                height: 50,
                onPressed: () {
                  AuthService(context).signOut();
                },
                btnText: "Afmelden",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
