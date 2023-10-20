import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final Color color;

  const Loader({
    Key? key,
    this.color = AppColors.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

