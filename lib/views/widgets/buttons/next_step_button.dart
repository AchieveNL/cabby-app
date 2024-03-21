import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';

class NextStepButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const NextStepButton({super.key, 
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.primaryColor),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
