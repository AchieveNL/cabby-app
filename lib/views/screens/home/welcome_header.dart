import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeHeader extends StatelessWidget {
  final Size screenSize;
  final String userName;

  const WelcomeHeader(
      {super.key, required this.screenSize, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 70.0, 20.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welkom',
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(0.7),
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Hi, $userName!',
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // ignore: use_build_context_synchronously
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            child: SvgPicture.asset(
              'assets/svg/bell.svg',
              color: Colors.white,
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
    );
  }
}
