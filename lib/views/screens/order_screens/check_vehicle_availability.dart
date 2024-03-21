// ignore_for_file: use_build_context_synchronously
import 'package:cabby/config/formatters.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/order.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/order_service.dart';
import 'package:cabby/views/screens/order_screens/order_vehicle.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:cabby/views/screens/order_screens/widgets/availability_slots.dart';
import 'package:cabby/views/screens/order_screens/widgets/date_range_picker.dart';
import 'package:cabby/views/screens/order_screens/widgets/date_time_picker_button.dart';
import 'package:cabby/views/screens/order_screens/widgets/vehicle_card.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:flutter/material.dart';

class CheckVehicleAvailability extends StatefulWidget {
  final Vehicle vehicle;

  const CheckVehicleAvailability({super.key, required this.vehicle});

  @override
  _CheckVehicleAvailabilityState createState() =>
      _CheckVehicleAvailabilityState();
}

class _CheckVehicleAvailabilityState extends State<CheckVehicleAvailability> {
  VehicleAvailability? _availability;
  bool _isLoading = true;
  bool _isAvailable = false;
  double? _totalPrice;

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _fetchAvailability();
  }

  void _fetchAvailability() async {
    OrdersService service = OrdersService();
    try {
      _availability = await service.fetchVehicleAvailability(widget.vehicle.id);
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      logger("Error fetching vehicle availability: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(
        context: context,
        title: "${widget.vehicle.companyName} ${widget.vehicle.model}",
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
                buildVehicleCard(
                  vehicle: widget.vehicle,
                ),
                const SizedBox(
                  height: 30,
                ),
                buildDateTimePickerButton(
                  title: 'Selecteer de huurperiode',
                  startDate: _startDate,
                  endDate: _endDate,
                  onTap: _showDateRangePicker,
                ),
                const SizedBox(
                  height: 30,
                ),
                _availability != null
                    ? buildAvailabilityList(
                        availability: _availability!, isLoading: _isLoading)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildActionView(),
    );
  }

  void _showDateRangePicker() async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (pickedDateRange != null) {
      final TimeOfDay? startTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (startTime != null) {
        final DateTime startDateTime = DateTime(
          pickedDateRange.start.year,
          pickedDateRange.start.month,
          pickedDateRange.start.day,
          startTime.hour,
          startTime.minute,
        );

        final TimeOfDay? endTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (endTime != null) {
          final DateTime endDateTime = DateTime(
            pickedDateRange.end.year,
            pickedDateRange.end.month,
            pickedDateRange.end.day,
            endTime.hour,
            endTime.minute,
          );

          setState(() {
            _startDate = startDateTime;
            _endDate = endDateTime;
          });

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              title: Text('Beschikbaarheid controleren'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Wacht alsjeblieft terwijl we de beschikbaarheid controleren ...',
                  ),
                ],
              ),
            ),
          );

          try {
            logger("Checking availability for vehicle ${widget.vehicle.id}");
            Map<String, dynamic> payload = await OrdersService()
                .checkVehicleAvailabilityForTimeslot(
                    widget.vehicle.id, _startDate!, _endDate!);
            bool isAvailable = payload['isAvailable'] as bool;
            if (isAvailable) {
              setState(() {
                _isAvailable = true;
                _totalPrice = payload['totalRentPrice']?.toDouble();
              });
              logger('Vehicle is available for the selected timeslot.');
            } else {
              setState(() {
                _isAvailable = false;
                _totalPrice = payload['totalRentPrice']?.toDouble();
              });
              logger('Vehicle is not available for the selected timeslot.');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Dit voertuig is niet beschikbaar op de geselecteerde tijden."),
                ),
              );
            }
          } finally {
            Navigator.pop(context);
          }
        }
      }
    }
  }

  Widget _buildActionView() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
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
                euroFormat.format(_totalPrice ?? widget.vehicle.pricePerDay),
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
            onPressed: _orderVehicle,
            btnText: "Reserveren",
            width: size.width * 0.5,
            isDisabled: !_isAvailable,
          ),
        ],
      ),
    );
  }

  void _orderVehicle() {
    if (_isAvailable) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => OrderVehicle(
          vehicle: widget.vehicle,
          startDate: _startDate!,
          endDate: _endDate!,
          totalPrice: _totalPrice!,
        ),
      );
      Navigator.push(context, route);
    }
  }
}
