import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color color;

  const Loader({
    super.key,
    this.color = AppColors.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

