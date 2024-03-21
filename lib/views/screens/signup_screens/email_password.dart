import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/signup.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:flutter/material.dart';

enum EmailValidationState { Idle, Loading, Exists, DoesntExist }

class EmailPassword extends StatefulWidget {
  final Function(SignupEmailPassword) dataCallback;
  final SignupEmailPassword emailPasswordData;
  final Function({required String title, required bool isDisabled}) btnCallback;

  const EmailPassword({
    super.key,
    required this.dataCallback,
    required this.btnCallback,
    required this.emailPasswordData,
  });

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
  bool emailExists = false;
  bool containsSpecialCharacter = false;

  FocusNode emailFocusNode = FocusNode();
  ValueNotifier<EmailValidationState> emailValidationNotifier =
      ValueNotifier(EmailValidationState.Idle);

  final _formKey = GlobalKey<FormState>();

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

    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        _checkIfEmailExists(emailController.text);
      }
    });
  }

  Future<void> _checkIfEmailExists(String email) async {
    logger("checking if email exists");
    setState(() {
      emailExists = true;
    });
    emailValidationNotifier.value = EmailValidationState.Loading;
    try {
      Map<String, dynamic> checkEmail = await UserService().emailExits(email);
      setState(() {
        emailExists = true;
      });
      if (checkEmail['status'] == "success") {
        if (checkEmail['payload']) {
          emailValidationNotifier.value = EmailValidationState.Exists;
        } else {
          setState(() {
            emailExists = false;
          });
          emailValidationNotifier.value = EmailValidationState.DoesntExist;
        }
      }
      updateData();
    } catch (e) {
      logger(e.toString());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailFocusNode.dispose();
    emailValidationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(
            screenSize,
            'E-mailadres',
            emailController,
            _validateEmail,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildInputField(
            screenSize,
            'Wachtwoord',
            passwordController,
            _validatePassword,
            true,
          ),
          SizedBox(height: screenSize.height * 0.02),
          _buildPasswordCriteria(),
          SizedBox(height: screenSize.height * 0.02),
          _buildInputField(
            screenSize,
            'Bevestig wachtwoord',
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
            null &&
        !emailExists) {
      widget.btnCallback(title: "Volgende", isDisabled: false);
    } else {
      widget.btnCallback(title: "Volgende", isDisabled: true);
    }
    widget.dataCallback(data);
    _updatePasswordCriteria(passwordController.text);
  }

  Widget _buildInputField(Size screenSize, String label,
      TextEditingController controller, Function(String?) validator,
      [bool isPassword = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getLabel(label),
        SizedBox(height: screenSize.height * 0.02),
        label == 'E-mailadres'
            ? ValueListenableBuilder<EmailValidationState>(
                valueListenable: emailValidationNotifier,
                builder: (context, state, child) {
                  Widget? suffixIcon;
                  String? errorMessage;
                  if (state == EmailValidationState.Loading) {
                    suffixIcon = SizedBox(
                      width: 16,
                      height: 16,
                      child: Transform.scale(
                        scale: 0.5,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  } else if (state == EmailValidationState.DoesntExist) {
                    suffixIcon = const Icon(Icons.check, color: Colors.green);
                  } else if (state == EmailValidationState.Exists) {
                    suffixIcon = const Icon(Icons.error, color: Colors.red);
                    errorMessage = 'E-mail bestaat al';
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        focusNode: emailFocusNode,
                        controller: controller,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: isPassword
                            ? TextInputType.visiblePassword
                            : TextInputType.emailAddress,
                        validator: (value) {
                          return errorMessage ?? validator(value);
                        },
                        obscureText: isPassword &&
                            (label == 'Wachtwoord'
                                ? !showPassword
                                : !showConfirmPassword),
                        style: const TextStyle(
                            color: AppColors.blackColor, fontSize: 16),
                        decoration: isPassword
                            ? _buildPasswordDecoration(label)
                            : DecorationInputs.textBoxInputDecoration(
                                label: label, suffixIcon: suffixIcon),
                      ),
                    ],
                  );
                },
              )
            : TextFormField(
                controller: controller,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: isPassword
                    ? TextInputType.visiblePassword
                    : TextInputType.text,
                validator: validator as String? Function(String?),
                obscureText: isPassword &&
                    (label == 'Wachtwoord'
                        ? !showPassword
                        : !showConfirmPassword),
                style:
                    const TextStyle(color: AppColors.blackColor, fontSize: 16),
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
              label == 'Wachtwoord'
                  ? showPassword = !showPassword
                  : showConfirmPassword = !showConfirmPassword;
            });
          },
          icon: Icon(
            label == 'Wachtwoord' && showPassword ||
                    label == 'Bevestig wachtwoord' && showConfirmPassword
                ? Icons.visibility
                : Icons.visibility_off,
            color: AppColors.blackColor,
          ),
        ));
  }

  InputDecoration _buildDefaultDecoration(String label) {
    return DecorationInputs.textBoxInputDecoration(
      label: label,
      suffixIcon: ValueListenableBuilder<EmailValidationState>(
          valueListenable: emailValidationNotifier,
          builder: (context, state, child) {
            if (state == EmailValidationState.Loading) {
              return const CircularProgressIndicator(); // loading spinner
            } else if (state == EmailValidationState.DoesntExist) {
              return const Icon(Icons.check,
                  color: Colors.green); // green check mark
            } else if (state == EmailValidationState.Exists) {
              return const Icon(Icons.error, color: Colors.red); // error icon
            }
            return Container(); // just an empty container for default state
          }),
    );
  }

  Widget _buildPasswordCriteria() {
    return Column(
      children: [
        _passwordCriteriaRow(characterLength, 'Minimale lengte van 8 tekens'),
        _passwordCriteriaRow(containsUpperAndLowerCase,
            'Bestaat uit hoofdletters en kleine letters'),
        _passwordCriteriaRow(containsNumber, 'Bestaat uit cijfers'),
        _passwordCriteriaRow(
          containsSpecialCharacter,
          'Bevat een speciaal karakter',
        ),
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
            Text('Heb je al een account?'),
            SizedBox(width: 10),
            Text(
              'Inloggen',
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
    if (value!.isEmpty) {
      return 'Wachtwoord is vereist';
    }
    if (value.length < 8) {
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

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'E-mail is vereist';
    }
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Gelieve een geldig e-mailadres in te geven';
    }
    return null;
  }

  void _updatePasswordCriteria(String password) {
    setState(() {
      characterLength = password.length >= 8;
      containsUpperAndLowerCase = password.contains(RegExp(r'[A-Z]')) &&
          password.contains(RegExp(r'[a-z]'));
      containsNumber = password.contains(RegExp(r'[0-9]'));
      containsSpecialCharacter = password.contains(RegExp(r'[!@#\$&*~]'));
    });
  }
}
