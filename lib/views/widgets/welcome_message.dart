import 'package:cabby/config/theme.dart';
import 'package:cabby/services/user_service.dart';
import 'package:cabby/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeMessageWidget extends StatefulWidget {
  final bool isUserBlocked;
  final String msg;

  const WelcomeMessageWidget(
      {super.key, this.isUserBlocked = false, required this.msg});

  @override
  State<WelcomeMessageWidget> createState() => _WelcomeMessageWidgetState();
}

class _WelcomeMessageWidgetState extends State<WelcomeMessageWidget> {
  UserService userService = UserService();
  bool _changeUI = false;

  onClickSignOutBtn() {
    // userService.(context);
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isUserBlocked) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _changeUI = true;
      });
    }
  }

  Widget _buildTitleText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xFF1D252D)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubText(String text, Color color) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
      ),
      body: Center(
        child: Container(
          width: size.width * .8,
          height: size.height,
          margin: const EdgeInsets.only(top: 50),
          child: _changeUI ? _buildBlockedUI() : _buildSuccessUI(),
        ),
      ),
    );
  }

  Widget _buildBlockedUI() {
    return Column(
      children: [
        SvgPicture.asset('assets/account-verified.svg'),
        const SizedBox(height: 20),
        _buildTitleText('Uw gegevens worden geverifieerd'),
        const SizedBox(height: 15),
        _buildSubText(
          widget.msg,
          AppColors.notSelectedGreyColor,
        ),
        const Spacer(),
        _buildSignOutButton(),
        const SizedBox(height: 30)
      ],
    );
  }

  Widget _buildSuccessUI() {
    return Column(
      children: [
        SvgPicture.asset('assets/succes.svg'),
        const SizedBox(height: 20),
        _buildTitleText('Yeah!'),
        const SizedBox(height: 15),
        _buildSubText(
            'Uw account is succesvol aangemaakt', const Color(0xFF4D545C)),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onClickSignOutBtn,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            width: 1.0,
            color: AppColors.primaryColor,
          ),
          fixedSize: const Size.fromHeight(50),
        ),
        child: const Text(
          'Afmelden',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: AppColors.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
