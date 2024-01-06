import 'package:cabby/config/formatters.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:flutter/material.dart';

buildVehicleCard({required Vehicle vehicle}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      border: Border.all(
        color: Colors.grey.shade300,
        width: .6,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                vehicle.images[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${vehicle.companyName} ${vehicle.model}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${euroFormat.format(vehicle.pricePerDay ?? 0)} /dag',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
