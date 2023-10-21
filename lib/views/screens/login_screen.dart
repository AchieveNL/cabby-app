import 'package:cabby/config/theme.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/utils/methods.dart';
import 'package:cabby/views/screens/forget_password_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:cabby/views/widgets/loader.dart';
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
  bool visibleButton = true;
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
                'Login',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your account credentials to sign in to your cabby account',
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
        _getLabel('Email Address'),
        SizedBox(height: screenSize.height * 0.02),
        _buildEmailField(),
        SizedBox(height: screenSize.height * 0.030),
        _getLabel('Password'),
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
                'Forgot Password?',
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
        visibleButton
            ? PrimaryButton(
                width: screenSize.width * 0.9,
                height: 50,
                btnText: 'Login',
                onPressed: onSubmit,
              )
            : const Loader(),
        SizedBox(height: screenSize.height * 0.03),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed("/register"),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Don\'t have an account?'),
              SizedBox(width: 10),
              Text(
                'Sign up now',
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
      decoration:
          DecorationInputs.textBoxInputDecoration(label: 'Email Address'),
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
          label: 'Password',
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

  void onSubmit() {}
}
