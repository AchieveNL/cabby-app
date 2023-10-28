import 'package:cabby/config/theme.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/vehicle_service.dart';
import 'package:cabby/views/widgets/skeletons/VehicleCardSkeleton.dart';
import 'package:cabby/views/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';

class PopularVehicles extends StatefulWidget {
  const PopularVehicles({super.key});

  @override
  _PopularVehiclesState createState() => _PopularVehiclesState();
}

class _PopularVehiclesState extends State<PopularVehicles> {
  late Future<List<Vehicle>> vehiclesFuture;

  @override
  void initState() {
    super.initState();
    vehiclesFuture = VehicleService().getPopularVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Vehicle>>(
      future: vehiclesFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Vehicle>> snapshot) {
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            // Always showing the title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Cars',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View all cars',
                    style: TextStyle(
                      color: AppColors.primaryLightColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            // Conditional content
            if (snapshot.connectionState == ConnectionState.waiting)
              ...List.generate(
                5,
                (index) => const VehicleCardSkeleton(),
              )
            else if (snapshot.hasError)
              Text('Error: ${snapshot.error}')
            else
              ...snapshot.data!.map((vehicle) => VehicleCard(vehicle: vehicle))
          ],
        );
      },
    );
  }
}
