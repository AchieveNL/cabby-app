import 'package:cabby/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCard extends StatelessWidget {
  final String locationUrl =
      "https://www.google.com/maps/place/Venenweg+66,+1161+AK+Zwanenburg,+Netherlands/@52.3827605,4.7329646,17z/data=!3m1!4b1!4m6!3m5!1s0x47c5e442dcb1554d:0xe781c8d3b2c93e27!8m2!3d52.3827605!4d4.7355395!16s%2Fg%2F11c1h3lhd4?entry=ttu";

  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Plaats',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/svg/location.svg',
                height: 24,
                width: 24,
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cabby locatie',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Amsterdam',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: _openMap,
                child: const Text(
                  'Zie op de kaart',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _openMap() async {
    await launchUrl(Uri.parse(locationUrl));
  }
}
