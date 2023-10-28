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
              _createOrderProccedToPayment(context);
            },
            btnText: "Proceed to Payment",
            width: size.width * 0.5,
          ),
        ],
      ),
    );
  }

  void _createOrderProccedToPayment(BuildContext context) async {
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
      // Handle error, perhaps show an error message to the user
      logger(error);
    }
  }
}
