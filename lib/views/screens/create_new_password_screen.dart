import 'package:cabby/config/theme.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final String email;
  const CreateNewPasswordScreen({super.key, required this.email});

  @override
  _CreateNewPasswordScreenState createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool characterLength = false;
  bool containsUpperAndLowerCase = false;
  bool containsNumber = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(updateData);
    confirmPasswordController.addListener(updateData);
  }

  void updateData() {
    _validatePassword(passwordController.text);
    _validateConfirmPassword(
        confirmPasswordController.text, passwordController.text);
  }

  void onSubmit() async {
    if (_validatePassword(passwordController.text) == null &&
        _validateConfirmPassword(
                confirmPasswordController.text, passwordController.text) ==
            null) {
      try {
        setState(() {
          isLoading = true;
        });
        var response = await UserService().resetPassword(
            widget.email, passwordController.text); // Use the API
        if (response['status'] == 'success') {
          _showSuccessDialog();
          setState(() {
            isLoading = false;
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message'] ?? 'An error occurred.'),
          ));
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    Size screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.green, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Center(
              child: Text('Yeah',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Your password has been successfully changed',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              width: screenSize.width * 0.7, // Adjust width as needed
              height: 50,
              btnText: 'Go to Login',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/login");
              },
            ),
          ],
        ),
      ),
    );
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
              _buildNewPasswordForm(screenSize),
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
                'Create New Password',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Enter your new password and confirm it.',
                style: TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
      ],
    );
  }

  Widget _buildNewPasswordForm(Size screenSize) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: screenSize.height * 0.85,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
          decoration: DecorationBoxes.decorationRoundBottomContainer(),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _buildInputField(
                      screenSize,
                      'New Password',
                      passwordController,
                      _validatePassword,
                      true,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildPasswordCriteria(),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildInputField(
                      screenSize,
                      'Confirm Password',
                      confirmPasswordController,
                      (val) => _validateConfirmPassword(
                          val, passwordController.text),
                      true,
                    )
                  ],
                ),
                PrimaryButton(
                  width: screenSize.width * 0.9,
                  height: 50,
                  isLoading: isLoading,
                  btnText: 'Set Password',
                  onPressed: onSubmit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
              (label == 'New Password' ? !showPassword : !showConfirmPassword),
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
              label == 'New Password'
                  ? showPassword = !showPassword
                  : showConfirmPassword = !showConfirmPassword;
            });
          },
          icon: Icon(
            label == 'New Password' && showPassword ||
                    label == 'Confirm Password' && showConfirmPassword
                ? Icons.visibility
                : Icons.visibility_off,
            color: AppColors.blackColor,
          ),
        ));
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

  InputDecoration _buildDefaultDecoration(String label) {
    return DecorationInputs.textBoxInputDecoration(label: label);
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

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
