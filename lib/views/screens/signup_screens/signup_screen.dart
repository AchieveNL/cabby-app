import 'dart:io';
import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/licence.dart';
import 'package:cabby/models/permit.dart';
import 'package:cabby/models/profile.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/models/user.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/services/licence_service.dart';
import 'package:cabby/services/payment_service.dart';
import 'package:cabby/services/permit_service.dart';
import 'package:cabby/services/profile_service.dart';
import 'package:cabby/services/third_party_service.dart';
import 'package:cabby/services/upload_service.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/views/screens/signup_screens/driver_license.dart';
import 'package:cabby/views/screens/signup_screens/email_password.dart';
import 'package:cabby/views/screens/signup_screens/kiwa_screen.dart';
import 'package:cabby/views/screens/signup_screens/kvk_screen.dart';
import 'package:cabby/views/screens/signup_screens/pay_deposit.dart';
import 'package:cabby/views/screens/signup_screens/permit_details.dart';
import 'package:cabby/views/screens/signup_screens/profile_details.dart';
import 'package:cabby/views/screens/signup_screens/rental_policy_screen.dart';
import 'package:cabby/views/screens/signup_screens/signature_screen.dart';
import 'package:cabby/views/screens/webview_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:cabby/views/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  UploadService uploadService = UploadService();
  ProfileService profileService = ProfileService();
  LicenceService licenceService = LicenceService();
  PermitService permitService = PermitService();
  PaymentService paymentService = PaymentService();
  UserService userService = UserService();

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
    "Inloggegevens",
    "Profiel",
    "Rijbewijs",
    "Taxivergunning",
    "KVK",
    "KIWA taxivergunning",
    "Huurovereenkomst",
    "Aanbetaling",
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
        KiwaScreen(
          kawiData: kawiData,
          dataCallback: (data) => setState(() => kawiData = data),
          btnCallback: updateButton,
        ),
        RentalPolicy(
          signatureData: signatureData, // Assuming RentalPolicy needs it
          btnCallback: updateButton,
        ),
        PayDeposit(
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
                      'Registreren',
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    const Text(
                      'Voer je accountgegevens in om aan te melden',
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
                        isDisabled: isButtonDisabled,
                        btnText: nextBtnTitle,
                        onPressed: !isButtonDisabled ? onNext : () {},
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

  void onNext() async {
    if (_shouldNavigateToSignatureScreen()) {
      _navigateToSignatureScreen();
    } else if (nextBtnTitle == "Account aanmaken") {
      await _handleCreateAccount();
    } else if (nextBtnTitle == "Nu betalen") {
      _initiatePayment();
    } else if (_shouldIncrementStep()) {
      _incrementStep();
    }
  }

  bool _shouldNavigateToSignatureScreen() {
    return stepTitles[_currentStep] == "Huurovereenkomst" &&
        nextBtnTitle != "Account aanmaken";
  }

  void _navigateToSignatureScreen() {
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

  Future<void> _handleCreateAccount() async {
    setState(() {
      isButtonLoading = true;
      isButtonDisabled = true;
    });

    try {
      // ignore: use_build_context_synchronously
      ToastUtil.showToast(context, "Je account maken...");
      logger("Creating user...");
      await _createUser(data: emailPasswordData);
      logger("User created successfully!");

      logger("Creating profile...");
      await _createProfile(
          data: profileData, signature: signatureData.signature!);
      logger("Profile created successfully!");

      logger("Creating license...");
      await _createLicence(data: driverLicenceData);
      logger("License created successfully!");

      logger("Creating permit...");
      await _createPermit(
        kiwa: kawiData.kawiFile!,
        kvk: kvkData.kvkFile!,
        taxiPermitExpiry: permitDetailsData.taxiPermitExpiry!,
        taxiPermitFile: permitDetailsData.taxiPermitFile!,
      );
      logger("Permit created successfully!");

      final response = await userService.login(
        emailPasswordData.email!,
        emailPasswordData.password!,
      );

      logger(response);

      if (response['status'] == 'success') {
        UserModel user = response['user'];
        // ignore: use_build_context_synchronously
        AuthService authService = AuthService(context);

        await authService.initializeUser(user);
      }
      // ignore: use_build_context_synchronously
      ToastUtil.showToast(context, "Je account is aangemaakt.");
      _incrementStep();
      logger("Verifying user info...");
      await verifyUserInfo();
      logger("User info verified successfully!");
    } catch (e) {
      logger("Error in handleCreateAccount: $e");
    } finally {
      setState(() {
        isButtonLoading = false;
        isButtonDisabled = false;
      });
    }
  }

  void _initiatePayment() async {
    setState(() {
      isButtonLoading = true;
    });

    final url = await PaymentService().createRegistrationPayment();

    if (url != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewScreen(
            url: url,
            navigationDelegate: depositPaymentRedirect(context),
            title: "Aanbetaling",
          ),
        ),
      );
    } else {
      logger("Failed to get payment URL");
    }
  }

  bool _shouldIncrementStep() {
    return _currentStep < stepWidgets.length - 1;
  }

  void _incrementStep() {
    setState(() {
      _currentStep++;
      isButtonDisabled = true;
    });
    scrollToCurrentStep();
  }

  Future<void> _createUser({required SignupEmailPassword data}) async {
    await userService.signup(data.email!, data.password!);
  }

  Future<void> verifyUserInfo() async {
    await ThirdPartyService().verifyUserInfo();
  }

  Future<void> _createProfile(
      {required SignupProfile data, required String signature}) async {
    String firstName = data.firstName!;
    String lastName = data.lastName!;
    String fullName = "$firstName $lastName";

    final userProfile = UserProfile(
      city: data.city as String,
      fullAddress: data.street as String,
      fullName: fullName,
      lastName: lastName,
      firstName: firstName,
      phoneNumber: data.phone as String,
      zip: data.zip as String,
      signature: signature,
      dateOfBirth: DateFormat('dd/MM/yyyy', 'nl_NL')
          .format(DateTime.parse(data.dob!.toIso8601String())),
    );

    await ProfileService().createUserProfile(userProfile);
  }

  Future<void> _createLicence({required SignupDriverLicence data}) async {
    logger('Initiating license creation...'); // Log here

    final driverLicenseFrontUrl =
        await uploadService.uploadFile(data.driverLicenseFront as File);
    final driverLicenseBackUrl =
        await uploadService.uploadFile(data.driverLicenseBack as File);

    logger(
        'Front License URL: $driverLicenseFrontUrl, Back License URL: $driverLicenseBackUrl'); // Log here

    if (driverLicenseFrontUrl != null && driverLicenseBackUrl != null) {
      final driverLicenseRequest = DriverLicenseRequest(
        driverLicenseBack: driverLicenseBackUrl,
        driverLicenseFront: driverLicenseFrontUrl,
        driverLicenseExpiry: data.expiryDate as String,
        bsnNumber: data.bsnNumber as String,
      );

      await licenceService.createDriverLicense(driverLicenseRequest);
    }
  }

  Future<void> _createPermit({
    required File taxiPermitFile,
    required File kiwa,
    required File kvk,
    required String taxiPermitExpiry,
  }) async {
    logger('Initiating permit creation...'); // Log here

    String? kiwaDocumentUrl = await uploadService.uploadFile(kiwa);
    String? kvkDocumentUrl = await uploadService.uploadFile(kvk);
    String? taxiPermitPictureUrl =
        await uploadService.uploadFile(taxiPermitFile);

    logger(
        'Kiwa URL: $kiwaDocumentUrl, Kvk URL: $kvkDocumentUrl, Taxi Permit URL: $taxiPermitPictureUrl'); // Log here

    final permitRequest = PermitRequest(
      kiwaDocument: kiwaDocumentUrl,
      kvkDocument: kvkDocumentUrl,
      taxiPermitExpiry: taxiPermitExpiry,
      taxiPermitPicture: taxiPermitPictureUrl,
    );

    await permitService.createPermit(permitRequest);
  }
}
