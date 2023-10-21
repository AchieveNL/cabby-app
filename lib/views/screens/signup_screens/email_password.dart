import 'package:cabby/config/theme.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

class EmailPassword extends StatefulWidget {
  final Function(SignupEmailPassword) dataCallback;
  final SignupEmailPassword emailPasswordData;
  final Function({required String title, required bool isDisabled}) btnCallback;

  const EmailPassword(
      {
    Key? key,
    required this.dataCallback,
    required this.btnCallback,
    required this.emailPasswordData,
  })
      : super(key: key);

  @override
  State<EmailPassword> createState() => _EmailPasswordState();
}

class _EmailPasswordState extends State<EmailPassword> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  bool characterLength = false;
  bool containsUpperAndLowerCase = false;
  bool containsNumber = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void initState() {
    super.initState();

    emailController =
        TextEditingController(text: widget.emailPasswordData.email)
          ..addListener(updateData);
    passwordController =
        TextEditingController(text: widget.emailPasswordData.password)
          ..addListener(updateData);
    confirmPasswordController =
        TextEditingController(text: widget.emailPasswordData.confirmPassword)
          ..addListener(updateData);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            screenSize,
            'Email Address',
            emailController,
            _validateEmail,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildInputField(screenSize, 'Password', passwordController,
            _validatePassword,
            true,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildPasswordCriteria(),
          SizedBox(height: screenSize.height * 0.02),
          _buildInputField(
              screenSize,
              'Confirm password',
              confirmPasswordController,
              (val) => _validateConfirmPassword(val, passwordController.text),
            true,
          ),
          SizedBox(height: screenSize.height * 0.04),
          _buildFooterLinks(screenSize),
        ],
      ),
    );
  }

  void updateData() {
    SignupEmailPassword data = widget.emailPasswordData
      ..email = emailController.text
      ..password = passwordController.text
      ..confirmPassword = confirmPasswordController.text;

    if (_validateEmail(emailController.text) == null &&
        _validatePassword(passwordController.text) == null &&
        _validateConfirmPassword(
                confirmPasswordController.text, passwordController.text) ==
            null) {
      widget.btnCallback(title: "Next", isDisabled: false);
    } else {
      widget.btnCallback(title: "Next", isDisabled: true);
    }
    widget.dataCallback(data);
  }

  Widget _buildInputField(Size screenSize, String label,
      TextEditingController controller, Function(String?) validator,
      [bool isPassword = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getLabel(label),
        SizedBox(height: screenSize.height * 0.02),
        TextFormField(
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          keyboardType: isPassword
              ? TextInputType.visiblePassword
              : TextInputType.emailAddress,
          validator: validator as String? Function(String?),
          obscureText: isPassword &&
              (label == 'Password' ? !showPassword : !showConfirmPassword),
          style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
          decoration: isPassword
              ? _buildPasswordDecoration(label)
              : _buildDefaultDecoration(label),
        ),
      ],
    );
  }

  InputDecoration _buildPasswordDecoration(String label) {
    return DecorationInputs.textBoxInputDecorationWithSuffixIcon(
        label: label,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              label == 'Password'
                  ? showPassword = !showPassword
                  : showConfirmPassword = !showConfirmPassword;
            });
          },
          icon: Icon(
            label == 'Password' && showPassword ||
                    label == 'Confirm password' && showConfirmPassword
                ? Icons.visibility
                : Icons.visibility_off,
            color: AppColors.blackColor,
          ),
        ));
  }

  InputDecoration _buildDefaultDecoration(String label) {
    return DecorationInputs.textBoxInputDecoration(label: label);
  }

  Widget _buildPasswordCriteria() {
    return Column(
      children: [
        _passwordCriteriaRow(characterLength, 'Minimum length of 8 characters'),
        _passwordCriteriaRow(containsUpperAndLowerCase,
            'Consists of uppercase and lowercase letters'),
        _passwordCriteriaRow(containsNumber, 'Consists of numbers'),
      ],
    );
  }

  Widget _passwordCriteriaRow(bool criteria, String text) {
    return Row(
      children: [
        Icon(Icons.check, color: criteria ? Colors.lightGreen : Colors.grey),
        const SizedBox(width: 5),
        Text(text,
            style:
                TextStyle(color: criteria ? Colors.lightGreen : Colors.grey)),
      ],
    );
  }

  Widget _buildFooterLinks(Size screenSize) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed("/login");
      },
      child: Padding(
      padding: EdgeInsets.only(
          top: screenSize.height * 0.01, bottom: screenSize.height * 0.02),
        child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Text('Have an account?'),
            SizedBox(width: 10),
            Text(
              'Login',
                style: TextStyle(
                    fontFamily: "SF Cartoonist Hand",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor),
            ),
        ],
      ),
      ),
    );
  }

  Widget _getLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: AppColors.blackColor,
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return 'Minimum length must be 8 characters';
    }
    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!passValid.hasMatch(value)) {
      return "Password should contain Capital letter, Small letter, Number & Special character";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return 'Confirm Password must be same as Password';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
