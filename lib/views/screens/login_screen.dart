import 'package:cabby/config/theme.dart';
import 'package:cabby/models/user.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:cabby/utils/methods.dart';
import 'package:cabby/views/screens/forget_password_screen.dart';
import 'package:cabby/views/screens/home_screen.dart';
import 'package:cabby/views/screens/signup_screens/email_password.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/decoration.dart';
import 'package:cabby/views/widgets/loader.dart';
import 'package:cabby/views/widgets/welcome_message.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserService userService = UserService();
  bool visibleButton = true;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    final email = TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: validateEmail,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: AppColors.blackColor, fontSize: 16),
        decoration: DecorationInputs.textBoxInputDecoration(
          label: 'Email Address',
        ));

    final password = TextFormField(
        controller: passwordController,
        validator: validatePasswordLength,
        obscureText: !showPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(
          color: AppColors.blackColor,
          fontSize: 16,
        ),
        decoration: DecorationInputs.textBoxInputDecorationWithSuffixIcon(
            label: 'Password',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: showPassword
                  ? const Icon(
                      Icons.visibility,
                      color: AppColors.blackColor,
                    )
                  : const Icon(
                      Icons.visibility_off,
                      color: AppColors.blackColor,
                    ),
            )));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: DecorationBoxes.decorationBackground(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenSize.height * 0.1,
              ),
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Enter your account credentials to sign in to your cabby account',
                      style:
                          TextStyle(color: AppColors.whiteColor, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.02,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenSize.height * 0.85,
                    padding: const EdgeInsets.all(20),
                    decoration:
                        DecorationBoxes.decorationRoundBottomContainer(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: screenSize.height * 0.01,
                              ),
                              getLabel('Email Address'),
                              SizedBox(
                                height: screenSize.height * 0.01,
                              ),
                              email,
                              SizedBox(
                                height: screenSize.height * 0.015,
                              ),
                              getLabel('Password'),
                              SizedBox(
                                height: screenSize.height * 0.01,
                              ),
                              password,
                              SizedBox(
                                height: screenSize.height * 0.02,
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgetPasswordScreen(),
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
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              visibleButton
                                  ? PrimaryButton(
                                      width: screenSize.width * 0.9,
                                      height: 50,
                                      btnText: 'Login',
                                      onPressed: onSubmit)
                                  : const Loader(),
                              SizedBox(
                                height: screenSize.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Don\'t have an account?'),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed("/register");
                                    },
                                    child: const Text('Sign up now',
                                        style: TextStyle(
                                          fontFamily: "SF Cartoonist Hand",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryColor,
                                        )),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onSubmit() async {
  FocusScope.of(context).requestFocus(FocusNode());
  setState(() {
    visibleButton = false;
  });
  final result = await userService.login(
    emailController.text.trim(),
    passwordController.text.trim(),
  );

  if (result['status'] == 'success') {
    UserModel user = result['user'];

    Provider.of<UserProvider>(context, listen: false).setUser(user);

    if (user.status == UserStatus.BLOCKED) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WelcomeMessageWidget(
            isUserBlocked: true,
            msg: 'Your account has been blocked. Please contact the admin for more details.',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else if (user.status == UserStatus.PENDING) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WelcomeMessageWidget(
            isUserBlocked: true,
            msg: 'Your account is still pending approval.',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else if (user.status == UserStatus.REJECTED) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const WelcomeMessageWidget(
            isUserBlocked: true,
            msg: 'Your account has been rejected. Please contact the admin for more details.',
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  } else {
    Fluttertoast.showToast(
      msg: result['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    setState(() {
      visibleButton = true;
    });
  }
}
}
