import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryLightColor = Color(0xff5c7ffc);
  static const Color primaryColor = Color(0xFF2D46C4);
  static const Color secondaryColor = Color(0xFF7BAD20);
  static const Color greyColor = Color(0xFFF4F4F4);
  static const Color darkGreyColor = Colors.grey;
  static const Color yellowColor = Colors.yellow;
  static const Color redColor = Colors.red;
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color whiteShadeBackgroundColor = Color(0XffF4F4F4);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color greenColor = Color(0xFF1C704F);
  static const Color purpleColor = Color(0xFF735BF2);
  static const Color blackColor = Color(0xFF0A0A1C);
  static const Color disabledTitleColor = Color(0xFF7B8EF0);
  static const Color notSelectedGreyColor = Color(0xFF575757);
  static const Color successColor = Color(0xFFDCFFD6);
}

ThemeData themeData = ThemeData(
  textTheme: ThemeData.light().textTheme.copyWith(
        displayLarge: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w900,
          fontSize: 28,
          color: Colors.black,
        ),
        displayMedium: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: Colors.black87,
        ),
        displaySmall: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w700,
          fontSize: 22,
          color: Colors.black54,
        ),
        headlineLarge: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w600,
          fontSize: 26,
          color: Colors.black87,
        ),
        headlineMedium: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w500,
          fontSize: 22,
          color: Colors.black87,
        ),
        headlineSmall: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w400,
          fontSize: 20,
          color: Colors.black87,
        ),
        titleLarge: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.black,
        ),
        titleMedium: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          color: Colors.black87,
        ),
        titleSmall: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Colors.black54,
        ),
        bodyLarge: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
        bodyMedium: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: Colors.black54,
        ),
        bodySmall: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w300,
          fontSize: 14,
          color: Colors.black54,
        ),
        labelLarge: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black,
        ),
        labelMedium: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.black54,
        ),
        labelSmall: const TextStyle(
          fontFamily: 'THICCCBOI',
          fontWeight: FontWeight.w300,
          fontSize: 12,
          color: Colors.black38,
        ),
      ),
);
