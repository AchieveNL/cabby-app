import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          width: size.width * .9,
          height: size.height * .45,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12),),
              color: Color(0xFFC3EDFB),),
          child: Center(child: SvgPicture.asset(image)),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Text(
            description,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0xFF575757),
            ),
          ),
        ),
      ],
    );
  }
}
