import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voorwaarden',
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
                  "1. Reservering: alle reserveringen zijn onderhevig aan beschikbaarheid.We behouden ons het recht voor om een reservering op elk gewenst moment en om welke reden dan ook te annuleren."),
              const SizedBox(height: 10),
              _buildTerm(
                  "2. Rijbewijs en leeftijdsvereisten: de huurder moet minimaal 21 jaar oud zijn en een geldig rijbewijs bezitten.Het rijbewijs moet worden gepresenteerd op het moment van ophalen."),
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
