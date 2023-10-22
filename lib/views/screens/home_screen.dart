import 'package:cabby/config/theme.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.userProfile;

    return Scaffold(
      // ignore: unnecessary_null_comparison
      body: user == null
          ? const Center(child: Text('User profile not available!'))
          : Container(
              decoration: DecorationBoxes.decorationBackground(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(screenSize, user.fullName),
                  Expanded(child: _buildContentWithButton(screenSize, context)),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(Size screenSize, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $userName!',
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Welcome back.',
            style: TextStyle(
              color: AppColors.whiteColor.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWithButton(Size screenSize, BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
      decoration: DecorationBoxes.decorationRoundBottomContainer(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Column(
              children: [
                const Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: AppColors.primaryColor,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Coming Soon",
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "We're working hard to bring this feature to you.",
                    style: TextStyle(
                      color: AppColors.primaryColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SecondaryButton(
              btnText: 'Sign Out',
              onPressed: () {
                AuthService(context).signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
