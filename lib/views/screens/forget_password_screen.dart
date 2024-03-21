import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/utils/methods.dart';
import 'package:cabby/views/screens/otp_verification_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void onSendResetLink() async {
    String email = emailController.text;
    logger('Sending reset link for email: $email'); // Log here

    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      logger('Form is valid, requesting reset password'); // Log here

      final response = await UserService().requestResetPassword(email);
      logger(
          'Reset password response received: ${response.toString()}'); // Log here

      setState(() {
        isLoading = false;
      });

      if (response['status'] == 'success') {
        logger(
            'Reset password request successful, navigating to OTPVerificationScreen'); // Log here
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              email: email,
            ),
          ),
        );
      } else {
        logger(
            'Reset password request failed: ${response['message']}'); // Log here
        showToast(response['message']);
      }
    } else {
      logger('Form validation failed'); // Log here
    }
  }

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
                'Reset wachtwoord',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Voer je e-mailadres in om instructies te ontvangen om je wachtwoord te resetten.',
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
      decoration: DecorationInputs.textBoxInputDecoration(label: 'E-mailadres'),
    );
  }

  Widget _buildBottomSection(Size screenSize) {
    return Column(
      children: [
        PrimaryButton(
          width: screenSize.width * 0.9,
          height: 50,
          btnText: 'Code verzenden',
          isLoading: isLoading, // Reflect the state of isLoading in the button
          onPressed: onSendResetLink,
        ),
        SizedBox(height: screenSize.height * 0.02),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Terug naar Inloggen',
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

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
