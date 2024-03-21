import 'package:cabby/config/utils.dart';
import 'package:cabby/services/payment_service.dart';
import 'package:cabby/views/screens/webview_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

class PayDepositScreen extends StatefulWidget {
  const PayDepositScreen({
    super.key,
  });

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
            title: "Aanbetaling",
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
                      "Aanbetaling",
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
                        "Klaar om je huurauto te reserveren? Vergeet niet dat een aanbetaling vereist is bij het ophalen om je reservering te beveiligen. Deze aanbetaling zorgt ervoor dat het verhuurbedrijf eventuele schade of extra vergoedingen kan dekken tijdens je huurperiode",
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
              btnText: "Aanbetaling",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
