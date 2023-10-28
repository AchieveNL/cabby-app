import 'package:cabby/views/screens/bottom_nav_screen.dart';
import 'package:cabby/views/screens/login_screen.dart';
import 'package:cabby/views/screens/onboarding_screen.dart';
import 'package:cabby/views/screens/payment_redirect_screen.dart';
import 'package:cabby/views/screens/signup_screens/pay_deposit_screen.dart';
import 'package:cabby/views/screens/signup_screens/signup_screen.dart';
import 'package:cabby/views/screens/status_screens/blocked_screen.dart';
import 'package:cabby/views/screens/status_screens/rejected_screen.dart';
import 'package:cabby/views/screens/status_screens/status_router_screen.dart';
import 'package:cabby/views/screens/status_screens/verification.dart';
import 'package:cabby/views/screens/splash_screen.dart';
import 'package:cabby/views/screens/vehicles_screens/vehicles_screen.dart';

final routes = {
  '/': (context) => const SplashScreen(),
  '/onboarding': (context) => const OnBoardingScreen(),
  '/status': (context) => const StatusRouterScreen(),
  '/verification': (context) => const VerificationScreen(),
  '/rejected': (context) => const RejectedScreen(),
  '/blocked': (context) => const BlockedScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const SignupScreen(),
  '/payment-redirect': (context) => const PaymentRedirectScreen(),
  '/pay-deposit': (context) => const PayDepositScreen(),
  '/home': (context) => const BottomNavScreen(initialIndex: 0),
  '/messages': (context) => const BottomNavScreen(initialIndex: 1),
  '/myRentals': (context) => const BottomNavScreen(initialIndex: 2),
  '/profile': (context) => const BottomNavScreen(initialIndex: 3),
  '/vehicle': (context) => const VehiclesScreen(),
};
