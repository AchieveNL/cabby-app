import 'package:cabby/views/screens/signup_screens/confirmation_screen.dart';
import 'package:cabby/views/screens/signup_screens/order_confirmation_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void logger(dynamic message) {
  if (kDebugMode) {
    print(message);
  }
}

class Utils {
  static String formatDateTime(String isoDateString) {
    DateTime dateTime = DateTime.parse(isoDateString);
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} on ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

NavigationDelegate depositPaymentRedirect(BuildContext context) {
  return NavigationDelegate(
    onNavigationRequest: (NavigationRequest request) {
      if (request.url.startsWith("cabby://registration-payment-completed")) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConfirmationScreen(),
          ),
        );
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
  );
}

NavigationDelegate orderPaymentRedirect(
    {required BuildContext context, required}) {
  return NavigationDelegate(
    onNavigationRequest: (NavigationRequest request) {
      if (request.url.startsWith("cabby://order-payment-completed")) {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrderConfirmationScreen(),
          ),
        );
        return NavigationDecision.prevent;
      }
      return NavigationDecision.navigate;
    },
  );
}
