// Import necessary packages
import 'package:cabby/config/theme.dart';
import 'package:cabby/models/order.dart';
import 'package:cabby/services/order_service.dart';
import 'package:cabby/views/screens/report_damages/damage_reports.dart';
import 'package:flutter/material.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CarControlWidget extends StatefulWidget {
  final OrderDetails orderDetails;
  final Function refetchOrderDetails;

  const CarControlWidget({
    super.key,
    required this.orderDetails,
    required this.refetchOrderDetails,
  });

  @override
  State<CarControlWidget> createState() => _CarControlWidgetState();
}

class _CarControlWidgetState extends State<CarControlWidget> {
  bool unlockLoading = false;
  bool lockLoading = false;
  void onLockPress() async {
    try {
      setState(() {
        lockLoading = true;
      });
      await OrdersService().lockVehicleOrder(widget.orderDetails.order.id);
      widget.refetchOrderDetails();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Succesvol vergrendeld."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vergrendeling mislukt."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        lockLoading = false;
      });
    }
  }

  void onUnlockPress() async {
    try {
      setState(() {
        unlockLoading = true;
      });
      await OrdersService().unlockVehicleOrder(widget.orderDetails.order.id);
      widget.refetchOrderDetails();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Succesvol ontgrendelt."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ontgrendeling mislukt"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        unlockLoading = false;
      });
    }
  }

  void onReportDamage() {}
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    DateTime now = DateTime.now();
    return widget.orderDetails.order.status == "CONFIRMED" &&
            now.isAfter(
              DateTime.parse(widget.orderDetails.order.rentalStartDate),
            )
        ? Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                const Text(
                  "De auto is momenteel:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.orderDetails.isVehicleUnlocked
                      ? "Ontgrendelt 🔓"
                      : "Vergendeld 🔒",
                  style: TextStyle(
                    fontSize: 17,
                    color: widget.orderDetails.isVehicleUnlocked
                        ? AppColors.greenColor
                        : AppColors.redColor,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(
                  height: 1,
                  color: AppColors.greyColor,
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  btnText: "Ontgrendel de auto",
                  onPressed: onUnlockPress,
                  width: screenSize.width * 0.9,
                  height: 50,
                  isDisabled: unlockLoading,
                  isLoading: unlockLoading,
                  prefixIcon: SvgPicture.asset("assets/svg/key.svg",
                      width: 20, height: 20),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  btnText: "Vergrendel de auto",
                  onPressed: onLockPress,
                  width: screenSize.width * 0.9,
                  height: 50,
                  isLoading: lockLoading,
                  prefixIcon: const Icon(
                    Icons.lock_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(
                  height: 1,
                  color: AppColors.greyColor,
                ),
                const SizedBox(height: 20),
                SecondaryButton(
                  btnText: "Schade rapporteren",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DamageReportScreen(
                        vehicleId: widget.orderDetails.vehicle.id,
                      ),
                    ),
                  ),
                  width: screenSize.width * 0.9,
                  height: 50,
                  isLoading: lockLoading,
                  prefixIcon: const Icon(
                    Icons.flag_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          )
        : const SizedBox(
            height: 0,
          );
  }
}
