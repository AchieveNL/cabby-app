import 'package:cabby/config/theme.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/screens/edit_password.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:cabby/views/widgets/version.dart';
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
              ? const Center(child: Text('Gebruikersprofiel niet beschikbaar!'))
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
                                btnText: 'Verander wachtwoord',
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
                                btnText: 'Uitloggen',
                              ),
                              SizedBox(height: screenSize.height * 0.04),
                              DangerButton(
                                width: screenSize.width * 0.9,
                                prefixIcon: const Icon(
                                  CupertinoIcons.delete,
                                  color: AppColors.redColor,
                                ),
                                height: 50,
                                onPressed: () {
                                  _showDeleteAccountDialog();
                                },
                                btnText: 'Account deactiveren',
                              ),
                              const Spacer(),
                              const Text(
                                "Cabby rentals",
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              AppVersion(),
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
                'Hoi $name',
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bevestig deactivering'),
          content: const Text(
              'Weet je zeker dat je je account wilt deactiveren? Deze actie kan niet ongedaan worden gemaakt.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuleren',
                  style: TextStyle(color: AppColors.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Verwijderen',
                  style: TextStyle(color: AppColors.redColor)),
              onPressed: () {
                // Call the function to delete the account
                AuthService(context).deleteAccount();
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
