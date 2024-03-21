import 'package:cabby/config/theme.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget title;
  final Widget body;
  const CustomContainer({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: DecorationBoxes.decorationBackground(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(screenSize, title),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: body,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(Size screenSize, Widget title) {
    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.1),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }
}
