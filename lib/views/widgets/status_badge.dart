import 'package:flutter/material.dart';

Widget buildStatusBadge({required String status}) {
  Color badgeColor;
  Color textColor;
  String text;

  switch (status) {
    case "CONFIRMED":
      badgeColor = const Color.fromARGB(255, 220, 255, 214);
      textColor = const Color.fromARGB(255, 91, 188, 75);
      text = 'Bevestigd';
      break;
    case "PENDING":
      badgeColor = const Color.fromARGB(255, 255, 247, 153);
      textColor = const Color.fromARGB(255, 228, 171, 16);
      text = 'In behandeling';
      break;
    case "CANCELED":
      badgeColor = const Color.fromARGB(255, 255, 212, 212);
      textColor = const Color.fromARGB(255, 217, 32, 55);
      text = 'Geannuleerd';
      break;
    case "REJECTED":
      badgeColor = const Color.fromARGB(255, 248, 215, 218);
      textColor = const Color.fromARGB(255, 231, 76, 60);
      text = 'Afgewezen';
      break;
    case "COMPLETED":
      badgeColor = const Color.fromARGB(255, 212, 230, 241);
      textColor = const Color.fromARGB(255, 52, 152, 219);
      text = 'Completed';
      break;
    case "UNPAID":
      badgeColor = const Color.fromARGB(255, 220, 220, 220);
      textColor = const Color.fromARGB(255, 150, 150, 150);
      text = 'Betaling vereist';
      break;
    default:
      badgeColor = const Color.fromARGB(255, 220, 220, 220);
      textColor = const Color.fromARGB(255, 150, 150, 150);
      text = 'Onbekend';
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      color: badgeColor,
    ),
    child: Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),
  );
}
