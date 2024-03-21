// ignore_for_file: use_build_context_synchronously

import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/user.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/utils/methods.dart';
import 'package:cabby/views/screens/forget_password_screen.dart';
import 'package:cabby/views/screens/status_screens/status_router_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserService userService = UserService();
  bool isLoading = false;
  bool showPassword = false;

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
              _buildLoginForm(screenSize),
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
                'Inloggen',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Voer je accountgegevens in om je aan te melden bij je Cabby-account.',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }

  Widget _buildLoginForm(Size screenSize) {
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
                _buildEmailAndPasswordFields(screenSize),
                _buildBottomSection(screenSize),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailAndPasswordFields(Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getLabel('E-mailadres'),
        SizedBox(height: screenSize.height * 0.02),
        _buildEmailField(),
        SizedBox(height: screenSize.height * 0.030),
        _getLabel('Wachtwoord'),
        SizedBox(height: screenSize.height * 0.02),
        _buildPasswordField(),
        SizedBox(height: screenSize.height * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPasswordScreen(),
                    ));
              },
              child: const Text(
                'Wachtwoord vergeten?',
                style: TextStyle(
                  fontFamily: "SF Cartoonist Hand",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildBottomSection(Size screenSize) {
    return Column(
      children: [
        PrimaryButton(
          width: screenSize.width * 0.9,
          height: 50,
          btnText: 'Inloggen',
          isLoading: isLoading,
          onPressed: onSubmit,
        ),
        SizedBox(height: screenSize.height * 0.03),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed("/register"),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Heb je geen account?'),
              SizedBox(width: 10),
              Text(
                'Meld je nu aan',
                style: TextStyle(
                  fontFamily: "SF Cartoonist Hand",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
      decoration: DecorationInputs.textBoxInputDecoration(label: 'E-mailadres'),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      validator: validatePasswordLength,
      obscureText: !showPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
      decoration: DecorationInputs.textBoxInputDecorationWithSuffixIcon(
          label: 'Wachtwoord',
          suffixIcon: IconButton(
            onPressed: _toggleShowPassword,
            icon: showPassword
                ? const Icon(Icons.visibility, color: AppColors.blackColor)
                : const Icon(Icons.visibility_off, color: AppColors.blackColor),
          )),
    );
  }

  Widget _getLabel(String label) {
    return Text(
      label,
      style: const TextStyle(color: AppColors.blackColor, fontSize: 14),
    );
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await userService.login(
          emailController.text,
          passwordController.text,
        );

        logger(response);

        if (response['status'] == 'success') {
          UserModel user = response['user'];
          AuthService authService = AuthService(context);

          await authService.initializeUser(user);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StatusRouterScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (response['status'] == 'error') {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        logger("Error during login: $e");
      }
    }
  }
}
