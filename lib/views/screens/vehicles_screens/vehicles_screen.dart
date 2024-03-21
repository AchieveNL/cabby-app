import 'package:cabby/config/theme.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/vehicle_service.dart';
import 'package:cabby/views/widgets/app_bar.dart';
import 'package:cabby/views/widgets/skeletons/VehicleCardSkeleton.dart';
import 'package:cabby/views/widgets/vehicle_card.dart';
import 'package:flutter/material.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  late Future<List<Vehicle>> vehiclesFuture;

  @override
  void initState() {
    super.initState();
    vehiclesFuture = VehicleService().getPopularVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWithBack(
        context: context,
        title: "Alle auto's",
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
          child: FutureBuilder<List<Vehicle>>(
            future: vehiclesFuture,
            builder:
                (BuildContext context, AsyncSnapshot<List<Vehicle>> snapshot) {
              Widget content;
              if (snapshot.connectionState == ConnectionState.waiting) {
                content = ListView.builder(
                  itemCount: 5, // for example, 5 skeletons
                  itemBuilder: (_, index) => const VehicleCardSkeleton(),
                );
              } else if (snapshot.hasError) {
                content = Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                content = ListView(
                  children: snapshot.data!
                      .map((vehicle) => VehicleCard(vehicle: vehicle))
                      .toList(),
                );
              } else {
                content = const Center(child: Text('No vehicles available'));
              }

              return Column(
                children: <Widget>[
                  Expanded(child: content),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
