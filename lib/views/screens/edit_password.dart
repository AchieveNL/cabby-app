import 'package:cabby/config/theme.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({
    super.key,
  });

  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
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

        if (Provider.of<UserProvider>(context, listen: false).user == null) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Er is een fout opgetreden.Probeer het opnieuw.'),
            ),
          );
        }
        var response = await UserService().resetPassword(
          Provider.of<UserProvider>(context, listen: false).user!.email,
          passwordController.text,
        ); // Use the API
        if (response['status'] == 'success') {
          _showSuccessDialog();
          setState(() {
            isLoading = false;
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message'] ?? 'Er is een fout opgetreden.'),
          ));
        }
      } catch (error) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Er is een fout opgetreden.Probeer het opnieuw.')),
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
              child: Text('Yeah!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Uw wachtwoord is succesvol gewijzigd',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              width: screenSize.width * 0.7, // Adjust width as needed
              height: 50,
              btnText: 'Ga naar login',
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
                'Maak een nieuw wachtwoord',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              Text(
                'Voer je nieuwe wachtwoord in en bevestig deze.',
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
                      'nieuw paswoord',
                      passwordController,
                      _validatePassword,
                      true,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildPasswordCriteria(),
                    SizedBox(height: screenSize.height * 0.02),
                    _buildInputField(
                      screenSize,
                      'bevestig wachtwoord',
                      confirmPasswordController,
                      (val) => _validateConfirmPassword(
                          val, passwordController.text),
                      true,
                    )
                  ],
                ),
                Column(
                  children: [
                    PrimaryButton(
                      width: screenSize.width * 0.9,
                      height: 50,
                      isLoading: isLoading,
                      btnText: 'Verander wachtwoord',
                      onPressed: onSubmit,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    SecondaryButton(
                      width: screenSize.width * 0.9,
                      height: 50,
                      btnText: 'Annuleren',
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
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
              (label == 'nieuw paswoord'
                  ? !showPassword
                  : !showConfirmPassword),
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
              label == 'nieuw paswoord'
                  ? showPassword = !showPassword
                  : showConfirmPassword = !showConfirmPassword;
            });
          },
          icon: Icon(
            label == 'nieuw paswoord' && showPassword ||
                    label == 'bevestig wachtwoord' && showConfirmPassword
                ? Icons.visibility
                : Icons.visibility_off,
            color: AppColors.blackColor,
          ),
        ));
  }

  Widget _buildPasswordCriteria() {
    return Column(
      children: [
        _passwordCriteriaRow(characterLength, 'Minimale lengte van 8 tekens'),
        _passwordCriteriaRow(containsUpperAndLowerCase,
            'Bestaat uit hoofdletters en kleine letters'),
        _passwordCriteriaRow(containsNumber, 'Bestaat uit cijfers'),
      ],
    );
  }

  Widget _passwordCriteriaRow(bool criteria, String text) {
    return Row(
      children: [
        Icon(Icons.check, color: criteria ? Colors.lightGreen : Colors.grey),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: TextStyle(color: criteria ? Colors.lightGreen : Colors.grey),
          ),
        ),
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
      return 'Minimale lengte moet 8 tekens zijn';
    }
    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    if (!passValid.hasMatch(value)) {
      return "Wachtwoord moet hoofdletter, kleine letter, nummer en speciaal teken bevatten";
    }
    return null;
  }

  String? _validateConfirmPassword(String? value, String password) {
    if (value != password) {
      return 'Bevestig het wachtwoord moet hetzelfde zijn als wachtwoord';
    }
    return null;
  }

  void _dismissKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
