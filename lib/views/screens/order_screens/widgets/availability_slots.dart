import 'package:cabby/config/theme.dart';
import 'package:cabby/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildAvailabilityList({
  required VehicleAvailability availability,
  required bool isLoading,
}) {
  if (isLoading) {
    return const CircularProgressIndicator();
  }

  List<Widget> availabilityList = [];
  availability.availability.forEach((date, timeSlots) {
    List<Widget> slots = [];
    bool allSlotsAvailable = true; // Start by assuming all slots are available

    timeSlots.forEach((time, slotStatuses) {
      slotStatuses.forEach((slot, isAvailable) {
        // Check if any slot is unavailable
        if (!isAvailable) {
          allSlotsAvailable = false;
        }

        List<String> timeRange = slot.split('-');
        Color bgColor = isAvailable
            ? AppColors.greyColor
            : const Color.fromARGB(255, 255, 212, 212);
        slots.add(
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'from',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    timeRange[0].trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      fontSize: 13,
                    ),
                  ),
                  const Text(
                    'to',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    timeRange[1].trim(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.blackColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });

    Color dotColor = allSlotsAvailable
        ? const Color.fromARGB(255, 220, 255, 214)
        : const Color.fromARGB(255, 255, 212, 212);

    availabilityList.add(
      ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatDate(date),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Icon(
              Icons.circle,
              color: dotColor,
              size: 12.0,
            ),
          ],
        ),
        children: [
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: slots,
            ),
          )
        ],
      ),
    );
  });

  return Column(children: availabilityList);
}

String formatDate(String inputDate) {
  DateTime parsedDate = DateTime.parse(inputDate);
  return "${parsedDate.day} ${DateFormat('MMMM').format(parsedDate)}";
}
