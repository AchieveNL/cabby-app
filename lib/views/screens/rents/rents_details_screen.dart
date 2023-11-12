import 'package:cabby/config/formatters.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/order.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/order_service.dart';
import 'package:cabby/services/payment_service.dart';
import 'package:cabby/views/screens/report_damages/damage_reports.dart';
import 'package:cabby/views/screens/order_screens/widgets/date_time_picker_button.dart';
import 'package:cabby/views/screens/pdf_viewer_screen.dart';
import 'package:cabby/views/screens/webview_screen.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/cards.dart';
import 'package:cabby/views/widgets/rents_details_screen_skeleton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RentsDetailsScreen extends StatefulWidget {
  final String orderId;
  const RentsDetailsScreen({super.key, required this.orderId});

  @override
  State<RentsDetailsScreen> createState() => _RentsDetailsScreenState();
}

class _RentsDetailsScreenState extends State<RentsDetailsScreen> {
  late Future<OrderDetails> orderDetailsFuture;

  bool canCancelOrder(String rentalStartDateStr) {
    DateTime rentalStartDate = DateTime.parse(rentalStartDateStr);
    DateTime now = DateTime.now();
    Duration difference = rentalStartDate.difference(now);
    return difference.inHours > 24;
  }

  @override
  void initState() {
    super.initState();
    orderDetailsFuture = OrdersService().fetchOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<OrderDetails>(
      future: orderDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingSkeleton();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData) {
          return const Text("No data available");
        } else {
          OrderDetails orderDetails = snapshot.data!;
          bool canCancel = canCancelOrder(orderDetails.order.rentalStartDate);

          return Scaffold(
            appBar: buildAppBarWithBack(
              context: context,
              title:
                  "${orderDetails.vehicle.companyName} ${orderDetails.vehicle.model}",
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildImageSlider(
                        vehicle: orderDetails.vehicle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildStatusBadge(orderDetails.orderMessage),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildName(name: orderDetails.vehicle.model),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildCompanyInfo(
                        vehicle: orderDetails.vehicle,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildDetailContainers(
                        vehicle: orderDetails.vehicle,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      _buildOrderDetails(
                        orderDetails: orderDetails,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildDamageReportsCard(context, orderDetails.vehicle.id),
                      const SizedBox(
                        height: 30,
                      ),
                      DangerButton(
                        btnText: "Cancel order",
                        onPressed: () async {
                          if (canCancel) {
                            bool success = await OrdersService()
                                .cancelOrder(orderDetails.order.id);
                            if (success) {
                              _showSuccessDialog();
                            }
                          }
                        },
                        isDisabled: !canCancel,
                        width: size.width * 0.95,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: _buildActionView(
              orderDetails: orderDetails,
            ),
          );
        }
      },
    );
  }

  void _showSuccessDialog() {
    Size screenSize = MediaQuery.of(context).size;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.green, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/success.png',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text('Yeah',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Your request to cancel has been submitted. The refund can take up to 2-5 workdays. After the refund has been completed, we will let you know.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              width: screenSize.width * 0.7, // Adjust width as needed
              height: 50,
              btnText: 'Go to home',
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/home");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails({required OrderDetails orderDetails}) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const PDFViewerScreen(
                          title: "Invoice",
                          url: "",
                        );
                      },
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Invoice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    SvgPicture.asset(
                      "assets/svg/invoice.svg",
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          buildDateTimePickerContent(
            startDate: DateTime.parse(orderDetails.order.rentalStartDate),
            endDate: DateTime.parse(orderDetails.order.rentalEndDate),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total price",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    euroFormat.format(
                      double.parse(orderDetails.order.totalAmount),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContainers({required Vehicle vehicle}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (vehicle.category != null)
            _detailContainer(
              'Type',
              Icons.directions_car,
              vehicle.category!,
            ),
          _detailContainer(
            'Year',
            Icons.date_range,
            vehicle.manufactureYear,
          ),
          _detailContainer(
            'Duration',
            Icons.hourglass_empty,
            vehicle.rentalDuration,
          ),
          _detailContainer(
            'Engine',
            Icons.electric_moped,
            vehicle.engineType,
          ),
          _detailContainer(
            'Seats',
            Icons.event_seat,
            vehicle.seatingCapacity,
          ),
          _detailContainer(
            'Battery',
            Icons.battery_full,
            vehicle.batteryCapacity,
          ),
          _detailContainer(
            'Feature',
            Icons.star,
            vehicle.uniqueFeature,
          ),
        ]
            .map((widget) =>
                Padding(padding: const EdgeInsets.all(5), child: widget))
            .toList(),
      ),
    );
  }

  Widget _detailContainer(String title, IconData icon, String value) {
    return Container(
      height: 70,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.greyColor,
      ),
      padding: const EdgeInsets.all(5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo({required Vehicle vehicle}) {
    return Row(
      children: [
        if (vehicle.logo != null && vehicle.logo!.isNotEmpty)
          Image.network(
            vehicle.logo!,
            height: 24,
            width: 24,
            fit: BoxFit.cover,
          ),
        const SizedBox(width: 10),
        Text(
          vehicle.companyName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String orderMessage) {
    logger(orderMessage);
    Color? badgeColor;
    Color? textColor;

    if (orderMessage.contains("Prepare!")) {
      badgeColor = const Color.fromARGB(255, 212, 230, 241);
      textColor = const Color.fromARGB(255, 52, 152, 219);
    } else if (orderMessage.contains("ready to use")) {
      badgeColor = const Color.fromARGB(255, 220, 255, 214);
      textColor = const Color.fromARGB(255, 91, 188, 75);
    } else if (orderMessage.contains("Thank you for renting with us")) {
      badgeColor = const Color.fromARGB(255, 255, 212, 212);
      textColor = const Color.fromARGB(255, 217, 32, 55);
    } else {
      badgeColor = Colors.grey[300];
      textColor = Colors.grey[600];
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: badgeColor,
      ),
      child: Text(
        orderMessage,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildName({required String name}) {
    return Row(
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider({required Vehicle vehicle}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      height: 240,
      child: CarouselSlider(
        options: CarouselOptions(
          height: 240,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
          enableInfiniteScroll: false,
          aspectRatio: 16 / 9,
          autoPlay: false,
          onPageChanged: (index, reason) {
            setState(() {
              // To update page indicator if you have one
            });
          },
        ),
        items: vehicle.images.map((image) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(image, fit: BoxFit.cover),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionView({required OrderDetails orderDetails}) {
    logger("is vehicle unlocked: ${orderDetails.isVehicleUnlocked}");
    Size size = MediaQuery.of(context).size;
    DateTime now = DateTime.now();

    Widget createActionButton(String text, VoidCallback onPressed,
        {double width = 0.5, SvgPicture? prefixIcon, bool isDisabled = false}) {
      return PrimaryButton(
        onPressed: onPressed,
        btnText: text,
        width: size.width * width,
        isDisabled: isDisabled,
        prefixIcon: prefixIcon,
      );
    }

    Widget? determineActionButton() {
      String status = orderDetails.order.status.toLowerCase();
      bool isRentalPeriodActive =
          now.isAfter(DateTime.parse(orderDetails.order.rentalStartDate)) &&
              now.isBefore(DateTime.parse(orderDetails.order.rentalEndDate));

      // Check if the vehicle is unlocked and the order is confirmed
      if (status == "confirmed" &&
          !isRentalPeriodActive &&
          !orderDetails.isVehicleUnlocked) {
        return createActionButton(
          "Unlock",
          () {
            OrdersService().unlockVehicleOrder(orderDetails.order.id);
            orderDetailsFuture =
                OrdersService().fetchOrderDetails(widget.orderId);
          }, // Add unlock logic here
          width: 0.3,
          prefixIcon:
              SvgPicture.asset("assets/svg/key.svg", width: 20, height: 20),
          isDisabled: true,
        );
      }
      if (status == "confirmed" && orderDetails.isVehicleUnlocked) {
        return createActionButton(
          "Report Damages",
          () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DamageReportScreen(vehicleId: orderDetails.vehicle.id)),
          ),
          width: 0.5,
        );
      }

      // Check if the order is in the rental period and confirmed
      if (status == "confirmed" && isRentalPeriodActive) {
        return createActionButton(
          "Unlock",
          () {
            OrdersService().unlockVehicleOrder(orderDetails.order.id);
            orderDetailsFuture =
                OrdersService().fetchOrderDetails(widget.orderId);
          }, // Add unlock logic here
          width: 0.3,
          prefixIcon:
              SvgPicture.asset("assets/svg/key.svg", width: 20, height: 20),
        );
      }

      // Check if the rental period has ended
      if (now.isAfter(DateTime.parse(orderDetails.order.rentalEndDate))) {
        return createActionButton(
          "Finish",
          () {
            OrdersService().completeOrder(orderDetails.order.id);
            orderDetailsFuture =
                OrdersService().fetchOrderDetails(widget.orderId);
            OrdersService().lockVehicleOrder(orderDetails.order.id);
          },
          width: 0.3,
        );
      }

      // Handle completed order
      if (status == "completed") {
        return createActionButton(
          "Report Damages",
          () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DamageReportScreen(vehicleId: orderDetails.vehicle.id)),
          ),
          width: 0.5,
        );
      }

      // For other statuses like 'canceled' or 'rejected'
      return const SizedBox();
    }

    Widget actionButton = determineActionButton() ?? const SizedBox();

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(color: AppColors.whiteColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                euroFormat.format(double.parse(orderDetails.order.totalAmount)),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.blackColor),
              ),
              const Text(" / total",
                  style: TextStyle(fontSize: 14, color: AppColors.blackColor)),
            ],
          ),
          actionButton, // Display the appropriate button
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return const Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: RentsDetailsScreenSkeleton(),
        ),
      ],
    );
  }

  void orderProccedToPayment(BuildContext context, String orderId) async {
    try {
      final checkoutUrl = await PaymentService().createOrderPaymentUrl(orderId);

      if (checkoutUrl != null) {
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
      }
    } catch (error) {
      // Handle error, perhaps show an error message to the user
      logger(error);
    }
  }
}
