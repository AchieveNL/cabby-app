import 'package:flutter/material.dart';

class FilePickerButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FilePickerButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Pick File'),
    );
  }
}
