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
                  "1. Reservering: Alle reserveringen zijn afhankelijk van beschikbaarheid. Wij behouden ons het recht voor om een reservering op elk moment en om welke reden dan ook te annuleren."),
              const SizedBox(height: 10),
              _buildTerm(
                  "2. Rijbewijs- en leeftijdsvereisten: De huurder moet minimaal 21 jaar oud zijn en in het bezit van een geldig rijbewijs en chauffeurskaart. Wij controleren alleen het rijbewijs en chauffeurskaart bij het aanmeldproces van de Cabby app."),
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
