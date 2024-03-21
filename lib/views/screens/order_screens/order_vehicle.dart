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
import 'package:flutter/material.dart';

class OrderVehicle extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final double totalPrice;
  final Vehicle vehicle;

  const OrderVehicle({
    super.key,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
  });

  @override
  _OrderVehicleState createState() => _OrderVehicleState();
}

class _OrderVehicleState extends State<OrderVehicle> {
  bool isCreatingOrder = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(
        context: context,
        title:
            'Reserveren ${widget.vehicle.companyName} ${widget.vehicle.model}',
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
                  title: "Huurduur",
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  textTitle: const Text(
                    'Huurduur',
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
                " / totaal",
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
            btnText: "Afrekenen",
            width: size.width * 0.5,
            isLoading: isCreatingOrder,
            isDisabled: isCreatingOrder,
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
          content: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.warning_rounded, color: Colors.red, size: 64),
                SizedBox(height: 20),
                Text(
                  'Reserveringslimiet bereikt',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Het spijt ons, maar het is niet mogelijk om meer dan twee voertuigen tegelijkertijd te reserveren.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
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
      setState(() {
        isCreatingOrder = true;
      });
      final ordersService = OrdersService();
      final result = await ordersService.createOrder(
        vehicleId: widget.vehicle.id,
        rentalStartDate: widget.startDate,
        rentalEndDate: widget.endDate,
      );
      if (result["error"] != null) {
        logger("Error creating order: ${result["error"]}");
        // ignore: use_build_context_synchronously
        _showOrderLimitDialog(context);
        return;
      }
      final checkoutUrl = result['checkoutUrl'];

      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebviewScreen(
            url: checkoutUrl,
            navigationDelegate: orderPaymentRedirect(context: context),
            title: "Bestelbetaling",
          ),
        ),
      );
    } catch (error) {
      logger("Error creating order: $error");
    } finally {
      setState(() {
        isCreatingOrder = false;
      });
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
              child: Text('We vinden het jammer.. :(',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'U kunt niet meer dan 2 voertuigen tegelijkertijd bestellen.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              width: screenSize.width * 0.7, // Adjust width as needed
              height: 50,
              btnText: 'OK',
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
