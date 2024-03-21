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

  List<Widget> bookedPeriodWidgets =
      availability.bookedPeriods.map((BookedPeriod period) {
    return ListTile(
      title: const Text(
        "Al gereserveerde periodes",
        style: TextStyle(
          fontSize: 15,
        ),
      ),
      subtitle: Text(
          'Van: ${formatDate(period.from.toString())} \nTot: ${formatDate(period.to.toString())}'),
    );
  }).toList();

  return Column(children: bookedPeriodWidgets);
}

String formatDate(String inputDate) {
  DateTime parsedDate = DateTime.parse(inputDate);
  return DateFormat('dd MMMM yyyy, HH:mm', 'nl_NL').format(parsedDate);
}
