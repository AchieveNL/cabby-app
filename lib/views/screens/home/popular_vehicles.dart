import 'package:cabby/config/theme.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/auth_service.dart';
import 'package:cabby/services/vehicle_service.dart';
import 'package:cabby/views/screens/vehicles_screens/vehicles_screen.dart';
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
        if (snapshot.hasError) {
          AuthService(context).signOut();
        }
        return ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Populaire auto's",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VehiclesScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Bekijk alles',
                    style: TextStyle(
                      color: AppColors.primaryLightColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (snapshot.connectionState == ConnectionState.waiting)
              ...List.generate(
                5,
                (index) => const VehicleCardSkeleton(),
              )
            else if (snapshot.hasError)
              const Center(
                child: Text('Something went wrong!'),
              )
            else
              ...snapshot.data!.map((vehicle) => VehicleCard(vehicle: vehicle))
          ],
        );
      },
    );
  }
}
