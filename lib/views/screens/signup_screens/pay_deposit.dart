import 'package:flutter/material.dart';

class PayDeposit extends StatefulWidget {
  final Function({required String title, required bool isDisabled}) btnCallback;

  const PayDeposit({
    super.key,
    required this.btnCallback,
  });

  @override
  State<PayDeposit> createState() => _PayDepositState();
}

class _PayDepositState extends State<PayDeposit> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      widget.btnCallback(title: "Nu betalen", isDisabled: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Form(
      child: Column(
        children: [
          _buildHeaderRow("Aanbetaling"),
          SizedBox(height: screenSize.height * 0.05),
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
              "Klaar om je huurauto te reserveren? Vergeet niet dat een aanbetaling vereist is bij het ophalen om je reservering te garanderen. Deze aanbetaling zorgt ervoor dat Cabby eventuele schade of extra vergoedingen kan dekken tijdens je huurperiode.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Row _buildHeaderRow(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF0A0A1C),
          ),
        ),
        const Text(" *",
            style: TextStyle(fontSize: 14, color: Color(0xFFD92037))),
      ],
    );
  }
}
