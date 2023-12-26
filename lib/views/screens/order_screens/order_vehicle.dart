import 'package:cabby/config/formatters.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/order_service.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:cabby/views/screens/order_screens/widgets/date_time_picker_button.dart';
import 'package:cabby/views/screens/order_screens/widgets/location_card.dart';
import 'package:cabby/views/screens/order_screens/widgets/terms_and_conditions.dart';
import 'package:cabby/views/screens/order_screens/widgets/vehicle_card.dart';
import 'package:cabby/views/screens/webview_screen.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderVehicle extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final Vehicle vehicle;

  const OrderVehicle({
    Key? key,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _OrderVehicleState createState() => _OrderVehicleState();
}

class _OrderVehicleState extends State<OrderVehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(
        context: context,
        title: 'Reserve ${widget.vehicle.companyName} ${widget.vehicle.model}',
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.primaryLightColor,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(
            bottom: 90,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildVehicleCard(
                  vehicle: widget.vehicle,
                ),
                const SizedBox(height: 30),
                buildDateTimePickerButton(
                  onTap: () {},
                  title: "Rent duration",
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  textTitle: const Text(
                    'Rent duration',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const LocationCard(),
                const SizedBox(height: 30),
                const TermsAndConditions(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _actionBtn(),
    );
  }

  Widget _actionBtn() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 100,
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                euroFormat.format(widget.totalPrice),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.blackColor,
                ),
              ),
              const Text(
                " / total",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          PrimaryButton(
            onPressed: () {
              _createOrderProceedToPayment(context);
            },
            btnText: "Proceed to Payment",
            width: size.width * 0.5,
          ),
        ],
      ),
    );
  }

  void _showOrderLimitDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Order Limit Reached'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SvgPicture.asset('assets/images/attention.png'), // Replace with your SVG asset
              const SizedBox(height: 20),
              const Text('We are sorry, but you cannot order more than 2 vehicles at the same time.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}


  void _createOrderProceedToPayment(BuildContext context) async {
  try {
    final ordersService = OrdersService();
    final result = await ordersService.createOrder(
      vehicleId: widget.vehicle.id,
      rentalStartDate: widget.startDate,
      rentalEndDate: widget.endDate,
    );
    final checkoutUrl = result['checkoutUrl'];

    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebviewScreen(
          url: checkoutUrl,
          navigationDelegate: orderPaymentRedirect(context: context),
          title: "Order payment",
        ),
      ),
    );
  } catch (error) {
    logger(error);

    if (error is DioError) {
      // Check if the error is specifically about the order limit
      if (error.response?.data?.contains("You can have only 2 active or pending orders at max") == true) {
        // ignore: use_build_context_synchronously
        _showOrderLimitDialog(context);
      } else if (error.response?.statusCode == 404) {
        // Handle 404 error
        // Show an appropriate message to the user
      } else {
        // Handle other types of DioErrors
      }
    } else {
      // Handle non-DioErrors
    }
  }
}


  void _showCustomDialog(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.red, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.red, size: 64),
            const SizedBox(height: 16),
            const Center(
              child: Text('We are sorry.. :(',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'You cannot order more than 2 vehicles at the same time.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              width: screenSize.width * 0.7, // Adjust width as needed
              height: 50,
              btnText: 'Ok',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/home");
              },
            ),
          ],
        ),
      ),
    );
  }
}
