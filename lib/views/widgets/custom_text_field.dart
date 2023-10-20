import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final bool obscureText;

  const CustomTextField({super.key, 
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          color: AppColors.primaryColor,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
