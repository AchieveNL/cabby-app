import 'package:cabby/config/theme.dart';
import 'package:cabby/models/signup.dart';
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;

  SignupEmailPassword emailPasswordData = SignupEmailPassword();
  SignupProfile profileData = SignupProfile();
  SignupDriverLicence driverLicenceData = SignupDriverLicence();
  SignupPermitDetails permitDetailsData = SignupPermitDetails();
  SignupKvk kvkData = SignupKvk();
  SignupKawi kawiData = SignupKawi();
  SignupSignature signatureData = SignupSignature();

  String nextBtnTitle = "Next";

  bool isButtonLoading = false;
  bool isButtonDisabled = true;
  bool showNextBtn = true;

  late ScrollController stepIndicatorController;

  @override
  void initState() {
    super.initState();
    stepIndicatorController = ScrollController();
  }

  @override
  void dispose() {
    stepIndicatorController.dispose();
    super.dispose();
  }

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
          emailPasswordData: emailPasswordData,
          dataCallback: (data) => setState(() => emailPasswordData = data),
          btnCallback: updateButton,
        ),
        ProfileDetails(
          profileData: profileData,
          dataCallback: (data) => setState(() => profileData = data),
          btnCallback: updateButton,
        ),
        DriverLicenceScreen(
          driverLicenceData: driverLicenceData,
          dataCallback: (data) => setState(() => driverLicenceData = data),
          btnCallback: updateButton,
        ),
        PermitDetails(
          permitDetailsData: permitDetailsData,
          dataCallback: (data) => setState(() => permitDetailsData = data),
          btnCallback: updateButton,
        ),
        KvkScreen(
          kvkData: kvkData,
          dataCallback: (data) => setState(() => kvkData = data),
          btnCallback: updateButton,
        ),
        KawiScreen(
          kawiData: kawiData,
          dataCallback: (data) => setState(() => kawiData = data),
          btnCallback: updateButton,
        ),
        RentalPolicy(
          signatureData: signatureData, // Assuming RentalPolicy needs it
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
                    SizedBox(height: screenSize.height * 0.02),
                    const Text(
                      'Enter your account credentials to sign up',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
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
                        isLoading: isButtonLoading,
                        // isDisabled: isButtonDisabled,
                        btnText: nextBtnTitle,
                        onPressed: onNext,
                      ),
                      SizedBox(height: screenSize.height * 0.02),
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
      controller: stepIndicatorController,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(stepTitles.length, (index) {
          return InkWell(
            onTap: () => gotoStep(index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Opacity(
                opacity: _currentStep == index ? 1.0 : 0.5,
                child: Row(
                  children: [
                    Text(
                      stepTitles[index],
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: _currentStep == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "·",
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  void gotoStep(int step) {
    if (step < stepWidgets.length && step < _currentStep) {
      setState(() {
        _currentStep = step;
        isButtonDisabled = true;
      });
      scrollToCurrentStep();
    }
  }

  void scrollToCurrentStep() {
    final screenWidth = MediaQuery.of(context).size.width;
    final estimatedStepWidth = screenWidth / 4;
    final offset = (_currentStep * estimatedStepWidth) -
        (screenWidth / 2) +
        (estimatedStepWidth / 2);

    stepIndicatorController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
            onSignatureComplete: (signatureUrl) {
              setState(() {
                signatureData = SignupSignature()..signature = signatureUrl;
              });
            },
          ),
        ),
      );
    }
    if (_currentStep < stepWidgets.length - 1) {
      setState(() {
        _currentStep++;
        isButtonDisabled = true;
      });

      scrollToCurrentStep();
    }
    // Handle final submission or navigation if you've reached the last step...
  }
}
