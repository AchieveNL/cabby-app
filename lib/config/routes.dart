import 'package:cabby/views/screens/home_screen.dart';
import 'package:cabby/views/screens/login_screen.dart';
import 'package:cabby/views/screens/onboarding_screen.dart';
import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:cabby/views/screens/splash_screen.dart';

final routes = {
  '/': (context) => const SplashScreen(),
  '/onboarding': (context) => const OnBoardingScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const SignupScreen(),
  '/home': (context) => const HomeScreen(),
};
