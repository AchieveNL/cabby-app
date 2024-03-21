import 'package:cabby/config/theme.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

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
            // Image
            Container(
              width: size.width * .9,
              height: size.height * .45,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Color(0xFFC3EDFB),
              ),
              child: Center(
                  child: Image.asset(
                      'assets/images/data_verification.png')), // Replace 'asset image path' with your actual asset image path.
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              "Je gegevens worden geverifieerd",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppColors
                    .blackColor, // You might want to define this color if it's not in your code.
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                "Je gegevens worden geverifieerd door onze admin. We laten je binnen 24 uur via e-mail weten of je gegevens zijn geaccepteerd of afgewezen.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Color(0xFF575757),
                ),
              ),
            ),
            SecondaryButton(
              width: size.width * 0.9,
              height: 50,
              onPressed: () {
                AuthService(context).signOut();
              },
              btnText: "Afmelden",
            ),
          ],
        ),
      ),
    );
  }
}
