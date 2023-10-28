import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Terms and Conditions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200], // Light grey background
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTerm(
                  "1. Reservation: All reservations are subject to availability. We reserve the right to cancel a reservation at any time and for any reason."),
              const SizedBox(height: 10),
              _buildTerm(
                  "2. Driver's License and Age Requirements: The renter must be at least 21 years old and possess a valid driver's license. The driver's license must be presented at the time of pickup."),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTerm(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
