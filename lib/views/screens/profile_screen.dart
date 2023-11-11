import 'package:cabby/config/theme.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/screens/edit_password.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.userProfile;
          return user == null
              ? const Center(child: Text('User profile not available!'))
              : Container(
                  decoration: DecorationBoxes.decorationBackground(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(screenSize, user.fullName),
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
                          child: Column(
                            children: [
                              SecondaryButton(
                                width: screenSize.width * 0.9,
                                prefixIcon: const Icon(
                                  CupertinoIcons.pen,
                                  color: AppColors.primaryColor,
                                ),
                                height: 50,
                                onPressed: () {
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditPasswordScreen(),
                                    ),
                                  );
                                },
                                btnText: 'Change Password',
                              ),
                              SizedBox(height: screenSize.height * 0.04),
                              PrimaryButton(
                                width: screenSize.width * 0.9,
                                prefixIcon: SvgPicture.asset(
                                  'assets/svg/logout.svg',
                                ),
                                height: 50,
                                onPressed: () {
                                  AuthService(context).signOut();
                                },
                                btnText: 'Logout',
                              ),
                              SizedBox(height: screenSize.height * 0.04),
                              DangerButton(
                                width: screenSize.width * 0.9,
                                prefixIcon: const Icon(
                                  CupertinoIcons.delete,
                                  color: AppColors.redColor,
                                ),
                                height: 50,
                                onPressed: () {},
                                btnText: 'Desactivate Account',
                              ),
                              const Spacer(),
                              Text(
                                "Cabby rentals",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _buildHeader(Size screenSize, String name) {
    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.1),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $name',
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }
}
