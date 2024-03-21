import 'package:cabby/config/formatters.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/views/screens/order_screens/check_vehicle_availability.dart';
import 'package:cabby/views/widgets/buttons/buttons.dart';
import 'package:cabby/views/widgets/cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  _VehicleDetailScreenState createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
              children: [
                _buildImageSlider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildName(),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _buildCompanyInfo(),
                const SizedBox(
                  height: 30,
                ),
                _buildDetailContainers(),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _buildRentInfo(),
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor =
        const Color.fromARGB(255, 220, 255, 214); // rgba(220, 255, 214, 1)
    Color textColor =
        const Color.fromARGB(255, 91, 188, 75); // rgba(91, 188, 75, 1)

    String text = 'Beschikbaar';
    logger("vehicle availability: ${widget.vehicle.availability}");
    if (widget.vehicle.availability?.toUpperCase() != 'AVAILABLE') {
      badgeColor =
          const Color.fromARGB(255, 255, 212, 212); // rgba(255, 212, 212, 1)
      textColor =
          const Color.fromARGB(255, 217, 32, 55); // rgba(217, 32, 55, 1)
      text = widget.vehicle.unavailabilityReason ?? 'Unavailable';
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: badgeColor,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildRentInfo() {
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
                euroFormat.format(widget.vehicle.pricePerDay),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.blackColor,
                ),
              ),
              const Text(
                " / dag",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
          PrimaryButton(
            onPressed: _rentVehicle,
            btnText: "Reserveren",
            width: size.width * 0.5,
          ),
        ],
      ),
    );
  }

  void _rentVehicle() {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => CheckVehicleAvailability(
        vehicle: widget.vehicle,
      ),
    );
    Navigator.push(context, route);
  }

  Widget _buildCompanyInfo() {
    return Row(
      children: [
        if (widget.vehicle.logo != null && widget.vehicle.logo!.isNotEmpty)
          Image.network(
            widget.vehicle.logo!,
            height: 24,
            width: 24,
            fit: BoxFit.cover,
          ),
        const SizedBox(width: 10),
        Text(
          widget.vehicle.companyName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    return Row(
      children: [
        Text(
          widget.vehicle.model,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.blackColor,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider() {
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
        items: widget.vehicle.images.map((image) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(image, fit: BoxFit.cover),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDetailContainers() {
    Size size = MediaQuery.of(context).size;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: (size.width / 2 - 15) / 80,
      children: [
        if (widget.vehicle.category != null)
          _detailContainer(
            'Type',
            Icons.directions_car,
            widget.vehicle.category!,
          ),
        _detailContainer(
          'Bouwjaar',
          Icons.date_range,
          widget.vehicle.manufactureYear,
        ),
        _detailContainer(
          'Min. huurperiode',
          Icons.hourglass_empty,
          widget.vehicle.rentalDuration,
        ),
        _detailContainer(
          'Motor',
          Icons.electric_moped,
          widget.vehicle.engineType,
        ),
        _detailContainer(
          'Zitplaatsen',
          Icons.event_seat,
          widget.vehicle.seatingCapacity,
        ),
        _detailContainer(
          'Batterij',
          Icons.battery_full,
          widget.vehicle.batteryCapacity,
        ),
        _detailContainer(
          'Kenmerken',
          Icons.star,
          widget.vehicle.uniqueFeature,
        ),
      ],
    );
  }

  Widget _detailContainer(String title, IconData icon, String value) {
    return Container(
      height: 50,
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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryLightColor,
      elevation: 0,
      title: Text(
        widget.vehicle.model,
        style: const TextStyle(
          color: AppColors.whiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          CupertinoIcons.back,
          color: AppColors.whiteColor,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
