import 'dart:io';

import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/signup_screens/driver_license.dart';
import 'package:cabby/views/screens/signup_screens/email_password.dart';
import 'package:cabby/views/screens/signup_screens/kawi_screen.dart';
import 'package:cabby/views/screens/signup_screens/kvk_screen.dart';
import 'package:cabby/views/screens/signup_screens/permit_details.dart';
import 'package:cabby/views/screens/signup_screens/profile_details.dart';
import 'package:cabby/views/screens/signup_screens/rental_policy_screen.dart';
import 'package:cabby/views/screens/signup_screens/signature_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

class SignupData {
  // For EmailPassword widget
  String? email;
  String? password;
  String? confirmPassword;

  // For ProfileDetails widget
  String? name;
  String? phone;
  String? zip;
  String? street;
  String? location;
  DateTime? dob;
  String? city;

  // For DriverLicenceScreen widget
  File? driverLicenseFront;
  File? driverLicenseBack;

  // For PermitDetails widget
  dynamic taxiPermitFile;

  // For KvkScreen widget
  dynamic kvkFile;

  // For KawiScreen widget
  dynamic kawiFile;

  // For Signature widget
  File? signatureImage;
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  SignupData signupData = SignupData();
  String nextBtnTitle = "Next";
  bool isButtonDisabled = true; // Button is disabled by default

  final List<String> stepTitles = [
    "Login access",
    "Profile",
    "Driver's License",
    "Taxi permission",
    "KVK",
    "Kiwa taxi vergunning",
    "Rent policy",
    "Pay deposit",
  ];

  List<Widget> get stepWidgets => [
        EmailPassword(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
        ProfileDetails(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
        DriverLicenceScreen(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
        PermitDetails(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
        KvkScreen(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
        KawiScreen(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
        RentalPolicy(
          dataCallback: updateSignupData,
          btnCallback: updateButton,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
          decoration: DecorationBoxes.decorationBackground(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.1),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Register',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Enter your account credentials to sign up',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildStepIndicator(),
                  ],
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Expanded(
                child: Container(
                  height: screenSize.height * 0.85,
                  decoration: DecorationBoxes.decorationRoundBottomContainer(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: stepWidgets[_currentStep],
                            ),
                          ),
                        ),
                      ),
                      PrimaryButton(
                        width: screenSize.width * 0.9,
                        height: 50,
                        // isLoading: true,
                        // isDisabled: true,
                        btnText: nextBtnTitle,
                        onPressed: onNext,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStepIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stepTitles.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Opacity(
              opacity: _currentStep == index ? 1.0 : 0.5,
              child: Text(
                stepTitles[index],
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: _currentStep == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void updateSignupData(SignupData data) {
    setState(() {
      signupData = data;
    });
  }

  void updateButton({required String title, required bool isDisabled}) {
    setState(() {
      nextBtnTitle = title;
      isButtonDisabled = isDisabled;
    });
  }

  void onNext() {
    // ignore: unrelated_type_equality_checks
    if (stepTitles[_currentStep] == "Rent policy") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignatureScreen(
            dataCallback: updateSignupData,
            btnCallback: updateButton,
          ),
        ),
      );
    }
    if (_currentStep < stepWidgets.length - 1) {
      setState(() {
        _currentStep++;
        isButtonDisabled = true; // Disable the button for the next step
      });
    }
    // Handle final submission or navigation if you've reached the last step...
  }
}
