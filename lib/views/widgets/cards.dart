import 'package:cabby/config/theme.dart';
import 'package:cabby/views/screens/report_damages/vehicle_damages_reports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildDamageReportsCard(BuildContext context, String id) {
  return GestureDetector(
    onTap: () {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => VehicleDamageReports(vehicleId: id),
      );
      Navigator.push(context, route);
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Bekijk alle schaderapporten",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.primaryColor,
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.primaryColor,
            )
          ]),
    ),
  );
}
