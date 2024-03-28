import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/home/home_filter_card.dart';
import 'package:cabby/views/screens/vehicles_screens/vehicles_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: AppColors.primaryLightColor,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: const EdgeInsets.only(top: 30),
          child: const HomeFilterCard(isInScreen: true),
        ),
      ),
      bottomSheet: SizedBox(
        height: 70,
        child: PrimaryButton(
          btnText: 'Zoeken',
          radius: 10,
          width: screenSize.width * 0.95,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VehiclesScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryLightColor, // Changed to white
      elevation: 0,
      title: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          'Zoeken',
          style: TextStyle(
              fontWeight: FontWeight.w700, color: AppColors.whiteColor),
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(
            Icons
                .arrow_back_ios_new_rounded, // Simplified the back arrow for clarity
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
