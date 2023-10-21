import 'package:cabby/config/theme.dart';
import 'package:cabby/utils/methods.dart';
import 'package:cabby/views/screens/otp_verification_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:cabby/views/widgets/loader.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool visibleButton = true;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Container(
          decoration: DecorationBoxes.decorationBackground(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(screenSize),
              _buildResetForm(screenSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Size screenSize) {
    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.1),
        const Padding(
          padding: EdgeInsets.only(left: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset Password',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your email address to receive password reset instructions.',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }

  Widget _buildResetForm(Size screenSize) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: screenSize.height * 0.85,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
          decoration: DecorationBoxes.decorationRoundBottomContainer(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildEmailField(),
                _buildBottomSection(screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator:
          validateEmail, // Assuming you have this function from the previous code
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
      decoration:
          DecorationInputs.textBoxInputDecoration(label: 'Email Address'),
    );
  }

  Widget _buildBottomSection(Size screenSize) {
    return Column(
      children: [
        visibleButton
            ? PrimaryButton(
                width: screenSize.width * 0.9,
                height: 50,
                btnText: 'Send Code',
                onPressed: onSendResetLink,
              )
            : const Loader(),
        SizedBox(height: screenSize.height * 0.02),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Back to Login',
            style: TextStyle(
              fontFamily: "SF Cartoonist Hand",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void onSendResetLink() {
    // Here, you will handle the reset password link sending logic.
    // For now, it's empty.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OTPVerificationScreen(),
      ),
    );
  }
}

