import 'package:cabby/config/theme.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/views/screens/create_new_password_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void onVerifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final response = await UserService().verifyOtp(
        widget.email,
        otpController.text,
      );

      setState(() {
        isLoading = false;
      });

      if (response['status'] == 'success') {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateNewPasswordScreen(email: widget.email),
          ),
        );
      } else {
        showToast(response['message']);
      }
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
              _buildOTPForm(screenSize),
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
                'Controleer OTP',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Voer de 4-cijferige code in die naar je e-mail is verzonden.',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }

  Widget _buildOTPForm(Size screenSize) {
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
                _buildOTPField(),
                _buildBottomSection(screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField() {
    return TextFormField(
      controller: otpController,
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.length != 4) return 'Voer een 4-cijferige code in';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 4,
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 24),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'OTP'),
    );
  }

  Widget _buildBottomSection(Size screenSize) {
    return Column(
      children: [
        PrimaryButton(
          width: screenSize.width * 0.9,
          height: 50,
          btnText: 'Controleer OTP',
          isLoading: isLoading,
          onPressed: onVerifyOTP,
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
