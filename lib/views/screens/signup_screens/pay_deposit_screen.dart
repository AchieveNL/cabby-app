import 'package:cabby/config/utils.dart';
import 'package:cabby/services/payment_service.dart';
import 'package:cabby/views/screens/webview_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

class PayDepositScreen extends StatefulWidget {
  const PayDepositScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PayDepositScreen> createState() => _PayDepositScreenState();
}

class _PayDepositScreenState extends State<PayDepositScreen> {
  bool isButtonLoading = false;

  void _initiatePayment() async {
    setState(() {
      isButtonLoading = true;
    });

    final url = await PaymentService().createRegistrationPayment();

    if (url != null) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewScreen(
            url: url,
            navigationDelegate: depositPaymentRedirect(context),
            title: "Pay deposit",
          ),
        ),
      );
    } else {
      logger("Failed to get payment URL");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/pay_deposit.png',
                      width: 128,
                      height: 128,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    const Text(
                      "Pay deposit",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Ready to reserve your rental car? Don't forget that a deposit will be required at pickup to secure your rental. This deposit ensures that the rental company can cover any damages or additional fees incurred during your rental period",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            PrimaryButton(
              width: screenSize.width * 0.9,
              height: 50,
              isLoading: isButtonLoading,
              onPressed: () {
                _initiatePayment();
              },
              btnText: "Pay Deposit",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
